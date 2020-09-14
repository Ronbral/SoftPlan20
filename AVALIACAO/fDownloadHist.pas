unit fDownloadHist;

{------------------------------------------------------------------------------}
{                              AVALIACAO SOFTPLAN                              }
{                                                                              }
{  PROJETO: Aplicação para Downloads de arquivos da WEB ********************** }
{                                                                              }
{  //// LISTA/HISTÓRICO DE DOWNLOADS  ////                                     }
{                                                                              }
{ Developed by: R Cabral                                                       }
{ Contact: ronbral@gmail.com                                                   }
{ 15/Set/2020                                                                     }
{------------------------------------------------------------------------------}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  dmRecursosBase, Data.DB, Vcl.Grids, Vcl.DBGrids;

const
  tm_Margem = #13#10#13#10;


type
  TFDownHist = class(TForm)
    lb1: TLabel;
    p1: TPanel;
    btSair: TButton;
    dbg: TDBGrid;
    ds_TbHist: TDataSource;
    pOpts: TPanel;
    procedure btSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Wm_NCHitTest(var msg: TMessage); message wm_NCHitTest;
  end;


implementation

{$R *.dfm}

Uses fMensagemDlg;


procedure TFDownHist.FormCreate(Sender: TObject);
begin
  with dmRecsBase.FDConnectionSQLite do
    if Connected then // Banco de Dados Disponivel?
       begin
         with dmRecsBase.FDQuery do
            begin
              Close;
              SQL.Text := 'select URL, DATAINICIO, DATAFIM  from LOGDOWNLOAD '+
                          'where  '+
                          'URL IS NOT NULL and '+
                          'DATAINICIO IS NOT NULL and '+
                          'DATAFIM IS NOT NULL '+
                          'Order by CODIGO Desc';
              Open;
              if RecordCount > 0 then
                 begin
                   ds_TbHist.DataSet := dmRecsBase.FDQuery;
                 end
               else TFMsgDlg.Execute('Atenção!'+tm_Margem+
                         'O Histórico de Downloads está vazio.', 3, 'Ok');
            end;
       end
    else TFMsgDlg.Execute('Atenção!'+tm_Margem+
                          'O recurso Histórico de Downloads estará insdisponível.', 2, 'Ok');
end;


procedure TFDownHist.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFDownHist.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmRecsBase.FDQuery.Close;
end;

procedure TFDownHist.Wm_NCHitTest(var msg: TMessage);
begin // Habilita deslocamento da janela
  if GetAsyncKeyState(VK_LBUTTON) < 0 Then
     Msg.Result := HTCAPTION
  else Msg.Result := HTCLIENT;
end;

end.
