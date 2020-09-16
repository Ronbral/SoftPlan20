unit fAvaliacaoSP;

{------------------------------------------------------------------------------}
{                              AVALIACAO SOFTPLAN                              }
{                                                                              }
{  PROJETO: Simples Aplicacao para Downloads de arquivos da Web ************** }
{                                                                              }
{  //// FORM PRINCIPAL / SOLICITACAO DA URL PARA DOWNLOAD  ////                }
{                                                                              }
{ Developed by: R Cabral                                                       }
{ Contact: ronbral@gmail.com                                                   }
{ 13-14/Set/2020                                                               }
{------------------------------------------------------------------------------}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  System.Threading,
  Vcl.StdCtrls, UrlConId10, UrlConn, URLSubs, Vcl.ComCtrls;

const
  db_SQLite = 'SP_AVALIACAO.DB';
  tm_Margem = #13#10#13#10;

  wm_Progress = wm_User;
  wm_DoIt     = wm_User+111;
  wm_LoadURL  = wm_User+124;
  wm_DownLoad = wm_User+125;

  // u.f - Formulario de Autorização
  http_Username = '';
  http_Password = '';
  http_BasicAuthentication = True;




type

  TfDownloadURL = class(TForm)
    pn1: TPanel;
    im1: TImage;
    pnUrl: TPanel;
    pn2: TPanel;
    lb1: TLabel;
    edURL: TEdit;
    lb2: TLabel;
    btCancelar: TButton;
    btExecDown: TButton;
    lb4: TLabel;
    btDwHist: TButton;
    btStatus: TButton;
    ProgressBarDown: TProgressBar;
    lb5: TLabel;
    lb6: TLabel;
    lTaxa: TLabel;
    lDuracao: TLabel;
    lb3: TLabel;
    procedure FormResize(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btExecDownClick(Sender: TObject);
    procedure btDwHistClick(Sender: TObject);
    //---
    function ConnectorsGetAuthorization(Connection: ThtConnection; TryRealm: Boolean): Boolean;
    procedure btStatusClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FTask: ITask;
    FHttpConnector: ThtIndyHttpConnector;
    FStartTick,
    FUpdatedTick: Cardinal;
    FConnection: ThtConnection;
    FAppClose: Boolean;
    DW_URL: string;
    DW_CANCELAR: Boolean;
    DW_INICIO,
    DW_FIM: TDateTime;
    DW_TAXA: Boolean;
    DW_PERC_MX,
    DW_PERC_AT: Int64;
    RC_APP_ID : Integer;

    procedure TaskFinished;
    procedure DocData(Sender: TObject); //Notificações GUI
    procedure DocBegin(Sender: TObject);
  public
    { Public declarations }
  end;

var
  fDownloadURL: TfDownloadURL;

implementation

{$R *.dfm}

Uses
   HtmlGlobals,
   System.SyncObjs,
   LogFormUnit,
   dmRecursosBase,
   fDownloadHist,
   fMensagemDlg;



procedure TfDownloadURL.btCancelarClick(Sender: TObject);
begin
  if Assigned(FTask) then
//     if TFMsgDlg.Execute('Atenção!'+tm_Margem+
//                         'Existe um download em andamento, deseja interrompe-lo?', 5, 'Sim, Não') = 2 then //2=Sim
        begin
          DW_CANCELAR := true;
          DW_URL := '';
          btCancelar.Enabled := false;
          btStatus.Enabled := false;
          btExecDown.Enabled := true;
          edURL.Clear;
        end;
end;

procedure TfDownloadURL.btExecDownClick(Sender: TObject);
const mg_erro1 = 'Atenção!'+tm_Margem+
                 'Já Existe um Download em andamento. Por favor aguarde a '+
                 'conclusão para iniciar outro download.';
      mg_erro2 = 'Atenção!'+tm_Margem+
                 'O Link informado para o Download não parece correto ou não é suportado '+
                 '(Tipos: zip, db, dat, tar, pdf, doc, xls, rar).  '+
                 'Use uma URL completa, com protocolo e caminho adicionados';

var Protocol, Ext: string;


begin
  if Assigned(FTask) then
     begin
       TFMsgDlg.Execute(mg_erro1, 5, 'Ok');
       Exit;
     end;
  DW_URL := trim(edURL.Text);
  if length(DW_URL) > 15 then // http://p/f.db
     begin
       Protocol := GetProtocol(DW_URL);
       Ext := Lowercase(GetURLExtension(DW_URL));
       if Pos('http', Protocol) = 1 then
          begin //Tipos suportados
             if (Ext = 'zip') or (Ext = 'db') or (Ext = 'dat') or (Ext = 'tar') or
                (Ext = 'pdf') or (Ext = 'doc') or (Ext = 'xls') or (Ext = 'rar') then
                begin
                  btExecDown.Enabled := false;
                  btCancelar.Enabled := true;
                  btStatus.Enabled := true;
                  DW_CANCELAR := false; // <---
                  //--- Task PPL
                  FTask := TTask.Create(
                    procedure
                    var
                      URL, Msg, NomeArquivo: String;
                      FDownLoad: ThtUrlDoc;
                      Connections: ThtConnectionManager;
                    begin
                      try
                        TThread.Synchronize(TThread.Current,
                          procedure
                          begin
                            URL := fDownloadURL.DW_URL;
                            Connections := dmRecsBase.ConexaoWeb;
                          end);
                        NomeArquivo := GetURLFilenameAndExt(URL);

                        if NomeArquivo > '' then
                           begin
                             FDownLoad := ThtUrlDoc.Create;
                             try
                               try
                                  FDownLoad.Url := URL;
                                  FConnection := Connections.CreateConnection(GetProtocol(URL));
                                  FConnection.OnDocData := DocData;
                                  FConnection.OnDocBegin := DocBegin;
                                  if Not fDownloadURL.DW_CANCELAR then
                                     FConnection.LoadDoc(FDownLoad);     {download it}
                                  if Not fDownloadURL.DW_CANCELAR then
                                     begin
                                       // u.f - Tratar nomes inválidos <---
                                       FDownLoad.SaveToFile(NomeArquivo);
                                     end;
                                except
                                  on E: Exception do
                                    begin
                                      SetLength(Msg, 0);
                                      if FConnection <> nil then
                                         Msg := FConnection.ReasonPhrase;
                                      if Length(Msg) + Length(E.Message) > 0 then
                                         Msg := Msg + ' ';
                                      Msg := Msg + E.Message;
                                      // u.f - Adicionar erro ao Log
                                    end;
                                end;
                             finally
                               FDownLoad.Free;
                             end;
                           end;
                      finally
                         TThread.Queue(nil, TaskFinished);
                      end;
                    end
                  );
                  if (Not fDownloadURL.DW_CANCELAR) then
                     begin
                       DW_INICIO := now;
                       FTask.Start;
                     end;
                  //--- Task
                end
             else TFMsgDlg.Execute(mg_erro2, 5, 'Ok');
          end
       else TFMsgDlg.Execute(mg_erro2, 5, 'Ok');
     end
  else TFMsgDlg.Execute(mg_erro2, 5, 'Ok');
end;


procedure TfDownloadURL.TaskFinished;
begin
  FTask := Nil;
  if Not FAppClose then // Download Abortado?
     begin
       DW_FIM := Now;
       btCancelar.Enabled := false;
       btStatus.Enabled := false;
       edURL.Clear;
       ProgressBarDown.Max := 0;
       ProgressBarDown.Position := 0;
       lDuracao.Caption := '';
       lTaxa.Caption := '';
       //--- Histórico de Downloads
       if (Not fDownloadURL.DW_CANCELAR) and (DW_URL > '') and dmRecsBase.FDConnectionSQLite.Connected and (RC_APP_ID > 0) then
           with dmRecsBase.FDQuery do
              begin
                SQL.Text := 'insert into LOGDOWNLOAD(CODIGO, URL, DATAINICIO, DATAFIM) '+
                            'values( (select COALESCE(max(CODIGO),0)+1 from LOGDOWNLOAD), '+ // CODIGO Incremental
                            QuotedStr(DW_URL)+', '+ // URL
                            'date('+QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', DW_INICIO))+'), '+ // SQLite usa AAAA-MM-DD HH: MM: SS
                            'date('+QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', DW_FIM))+') )';
                ExecSQL;
                Close;
              end;
       btExecDown.Enabled := true;
     end;
end;

procedure TfDownloadURL.btDwHistClick(Sender: TObject);
var FDwHist: TFDownHist;

begin //Exibe lista de Downloads efetuados com sucesso
  FDwHist := TFDownHist.Create(nil);
  with FDwHist do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfDownloadURL.btStatusClick(Sender: TObject);
var p: Double;

begin //160 (25/100)
  DW_TAXA := true;
  Sleep(100);
  if (dw_perc_at < 1) or (dw_perc_mx < 1) then Exit;  //Download incipiente

  p := (dw_perc_at*100) div dw_perc_mx;
  TFMsgDlg.Execute('Download em Andamento!'+tm_Margem+
                   tm_Margem+
                   'Seu download está com '+IntToStr(trunc(p))+'% concluído.', 3, 'Ok');
end;

procedure TfDownloadURL.DocBegin(Sender: TObject);
begin
  FStartTick := GetTickCount;
end;

procedure TfDownloadURL.DocData(Sender: TObject);

function SizeToStr(Size: Int64): String;
type
    TBinaryPrefix = (None, Ki, Mi, Gi, Ti, Pi, Ei, Zi, Yi);
const
    CBinaryPrefix: array[TBinaryPrefix] of String = ('', 'Ki', 'Mi', 'Gi', 'Ti', 'Pi', 'Ei', 'Zi', 'Yi');
var
    Sized: Int64;
    I: TBinaryPrefix;

begin
  I := None;
  repeat
    Sized := Size div 1024;
    if Sized < 10 then
       break;
    Inc(I);
    Size := Sized;
  until False;
  Result := IntToStr(Size) + ' ' + CBinaryPrefix[I];
end;

var
  ReceivedSize: Int64;
  ExpectedSize: Int64;
  Speed: Int64;
  Now: Cardinal;
  Elapsed: Cardinal;
  H, M, S: Integer;

begin
  if Not DW_CANCELAR then
     begin
       Now := GetTickCount;
       ReceivedSize := FConnection.ReceivedSize;
       ExpectedSize := FConnection.ExpectedSize;
       if DW_TAXA then
           begin
             DW_TAXA := false;
             DW_PERC_MX := ExpectedSize;
             DW_PERC_AT := ReceivedSize;
           end;
       if (FUpdatedTick + 100 < Now) or (ReceivedSize = ExpectedSize) then
           begin
             FUpdatedTick := Now;
             Elapsed := Now - FStartTick;
             if Elapsed > 0 then
                begin
                  if ReceivedSize < Int64(Elapsed) * 1000 then
                     Speed := ReceivedSize * 1000 div Elapsed
                  else
                     Speed := ReceivedSize div Elapsed * 1000;
                  lTaxa.Caption := SizeToStr(ReceivedSize) + 'B de ' + SizeToStr(ExpectedSize) + 'B (a ' + SizeToStr(Speed) + 'B/seg)';

                  ProgressBarDown.Max := ExpectedSize;
                  ProgressBarDown.Position := ReceivedSize;

                  if (ReceivedSize > 0) and (ExpectedSize > 0) then
                     begin
                       S := Round((ExpectedSize - ReceivedSize) / 1000 * Elapsed / ReceivedSize);
                       H := S div 3600;
                       S := S mod 3600;
                       M := S div 60;
                       S := S mod 60;
                       lDuracao.Caption := Format('%2.2d:%2.2d:%2.2d', [H, M, S]);
                       lDuracao.Update;
                     end;
                end;
           end;
     end
  else if Assigned(FTask) then
          begin //--- Cancela
            FConnection.Abort;
            if (DW_URL > '') then
                try
                  DW_URL := '';
                  FTask.Cancel;
                  //FTask.CheckCanceled;
                finally
                  edURL.Enabled := true;
                  btCancelar.Enabled := false;
                  btStatus.Enabled := false;
                  edURL.Clear;
                  btExecDown.Enabled := true;
                end;
          end;
end;

procedure TfDownloadURL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if dmRecsBase.FDConnectionSQLite.Connected and (RC_APP_ID > 0) then
     with dmRecsBase.FDQuery do
        begin
          SQL.Text := 'update tab_app_recursos '+
                      'set  '+
                      'tar_ultima_utilizacao=datetime(''now'',''localtime'') '+
                      'where  '+
                      'tar_app_id='+IntToStr(RC_APP_ID);
          ExecSQL;
          Close;
        end;
  dmRecsBase.FDConnectionSQLite.Close;
end;

procedure TfDownloadURL.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(FTask) then
     if TFMsgDlg.Execute('Atenção!'+tm_Margem+
                         'Existe um download em andamento, deseja interrompe-lo?', 5, 'Sim, Não') = 2 then //2=Sim
        begin
          DW_CANCELAR := true; //--- Ativa Cancelamento da Task
          FAppClose := true;
          //Sleep(500);
        end
     else CanClose := false;
end;

procedure TfDownloadURL.FormCreate(Sender: TObject);
var db, path: String;
     e: Integer;

begin
  btCancelar.Enabled := false;
  btStatus.Enabled := false;
  ProgressBarDown.Min := 0;
  ProgressBarDown.Max := 0;
  ProgressBarDown.Position := 0;
  // u.f - Log do Serviço Http
  LogForm := TLogForm.Create(Self, 100, 100, 600, 400);
  // VGA viewport
  self.Width  := 800;
  self.Height := 600;
  // Conecta ao Db
  path := ExtractFilePath(ParamStr(0));
  db := path+db_SQLite;
  if Not FileExists(db) then
     TFMsgDlg.Execute('Atenção!'+tm_Margem+
                      'O Arquivo de Histórico de Downloads('+db_SQLite+') não foi encontrado na pasta '+
                      ExtractFilePath(ParamStr(0))+'. '+tm_Margem+
                      'O recurso Histórico de Downloads está insdisponível.', 2, 'Ok');
  //SSL
  e := 0;
  if Not FileExists(path+'libeay32.dll') then inc(e);
  if Not FileExists(path+'ssleay32.dll') then inc(e);
  if e > 0 then
     TFMsgDlg.Execute('Atenção!'+tm_Margem+
                      'Suporte ao protocolo HTTPS não disponível. Arquivos DLL necessários estão ausentes ('+
                      'libeay32.dll / ssleay32.dll).', 5, 'Ok');
  with dmRecsBase.FDConnectionSQLite do
    begin
      Close;
      RC_APP_ID := 0;
      lb4.Caption := 'Historico de Downloads nao disponivel!';
      if FileExists(db) then
         begin
           with Params do
             begin
               Clear;
               Add('DriverID=SQLite');
               Add('Database='+db);
             end;
           Open;
           // Banco de Dados Disponivel
           if Connected then
              with dmRecsBase.FDQuery do
                begin
                  SQL.Text := 'select tar_app_id, tar_ultima_utilizacao from tab_app_recursos '+
                              'where  '+
                              'tar_app_id > 0';
                  Open;
                  if RecordCount > 0 then
                     begin
                       lb4.Caption := 'Ultima utilizacao: '+FieldByName('tar_ultima_utilizacao').AsString;
                       RC_APP_ID := FieldByName('tar_app_id').AsInteger;
                     end;
                  Close;
                end;
         end
     //else Error
    end;
  // Adaptador Http Indy
  FHttpConnector := ThtIndyHttpConnector.Create(Self);
  FHttpConnector.ConnectionManager := dmRecsBase.ConexaoWeb;
  FHttpConnector.OnGetAuthorization := ConnectorsGetAuthorization;
  // u.f
  FHttpConnector.ProxyPort := '80';
  edURL.Clear;
  DW_URL := '';
  FTask := nil;
  FAppClose := false;
end;

function TfDownloadURL.ConnectorsGetAuthorization(Connection: ThtConnection; TryRealm: Boolean): Boolean;
begin // u.f - Exibir solicitação de Autenticação <---
  Connection.Username := http_Username;
  Connection.Password := http_Password;
  Connection.BasicAuthentication := http_BasicAuthentication;
  RESULT := true; // u.f - mrOk
end;


procedure TfDownloadURL.FormResize(Sender: TObject);
var h, w: Integer;

begin 
  // Centraliza Painel de Downloaf
  w := ((self.Width-pnUrl.Width) div 2);
  if w <> pnUrl.Left then
     pnUrl.Left := w;
  h := ((self.Height-pnUrl.Height) div 2);
  if h <> pnUrl.Top then
     pnUrl.Top := h;
end;


end.
