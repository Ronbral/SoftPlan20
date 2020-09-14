unit fMensagemDlg;

{------------------------------------------------------------------------------}
{                              AVALIACAO SOFTPLAN                              }
{                                                                              }
{  PROJETO: Aplicação para Downloads de arquivos da WEB ********************** }
{                                                                              }
{  //// SIMPLES EXIBICAO DE MENSAGENS / DIALOGOS  ////                         }
{                                                                              }
{ Developed by: R Cabral                                                       }
{ Contact: ronbral@gmail.com                                                   }
{ Set/2020                                                                     }
{------------------------------------------------------------------------------}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.WideStrUtils,
  PicShow, Vcl.Imaging.pngimage;


type
  TFMsgDlg = class(TForm)
    pnImg: TPanel;
    pnMsg: TPanel;
    pnBts: TPanel;
    pnOk: TPanel;
    btOk: TButton;
    pnSim: TPanel;
    btSim: TButton;
    pnNao: TPanel;
    btNao: TButton;
    lbMsg: TLabel;
    pnArea: TPanel;
    PicShow: TPicShow;
    im1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btOpcaoClick(Sender: TObject);
  private
    { Private declarations }
    MD_RESULT : Integer;
  public
    { Public declarations }
    class function Execute(const Mensagem: string; Icone: Word; Opcoes: String='OK'): Integer;
    function ShowMsg(const Mensagem: string; Icone: Word; Opcoes: String='OK'): Integer;
    procedure Wm_NCHitTest(var msg: TMessage); message wm_NCHitTest;
  end;

var
  FMsgDlg: TFMsgDlg;

implementation

{$R *.dfm}

Uses dmRecursosBase;

{ MD_RESULT: 0 = Nenhuma opcao selecionada (... ALT+F4)
             1 = OK
             2 = SIM
             3 = NAO
 Icones:   0 = Alerta - Sininho
           1 = Executar - Raio
           2 = Erro
           3 = Download
           4 = Ok
           5 = Alerta

}

class function TFMsgDlg.Execute(const Mensagem: string; Icone: Word; Opcoes: String='OK'): Integer;
begin
  if FMsgDlg = nil then
     FMsgDlg := TFMsgDlg.Create(Application);
  RESULT := FMsgDlg.ShowMsg(Mensagem, Icone, Opcoes);
end;

function TFMsgDlg.ShowMsg(const Mensagem: string; Icone: Word; Opcoes: String='OK'): Integer;
var md_opcoes: String;
          Bmp: TBitmap;

begin
  md_opcoes := trim(UTF8UpperCase(Opcoes));
  if md_opcoes='' then md_opcoes := 'OK';
  with FMsgDlg do
    begin
      lbMsg.Caption :=  Mensagem;
      //Exibe opções
      pnOk.Visible  := (Pos('OK', md_opcoes) > 0);
      pnNao.Visible := (Pos('NÃO', md_opcoes) > 0);
      pnSim.Visible := (Pos('SIM', md_opcoes) > 0);
      //Exibe Icon
      Bmp := TBitmap.Create;
      try
        if (Icone < 0) or (Icone > 5) then dmRecsBase.ImageListJPG.GetBitmap(0{Alerta}, Bmp)
        else dmRecsBase.ImageListJPG.GetBitmap(Icone, Bmp);
        PicShow.Picture.Bitmap.Assign(Bmp);
        Randomize;
        PicShow.Style := TShowStyle(Random(High(TShowStyle))+1);
        PicShow.Execute;
      finally
        Bmp.Free;
      end;
      md_result := 0;
    end;
  ShowModal;
  RESULT := MD_RESULT;
end;

procedure TFMsgDlg.btOpcaoClick(Sender: TObject);
begin
  MD_RESULT := TButton(sender).Tag;
  Close;
end;

procedure TFMsgDlg.FormCreate(Sender: TObject);
begin
  pnOk.Visible := false;
  pnSim.Visible := false;
  pnNao.Visible := false;
  lbMsg.Caption := '';
  MD_RESULT := 0;
end;

procedure TFMsgDlg.Wm_NCHitTest(var msg: TMessage);
begin // Habilita deslocamento da janela
  if GetAsyncKeyState(VK_LBUTTON) < 0 Then
     Msg.Result := HTCAPTION
  else Msg.Result := HTCLIENT;
end;

end.
