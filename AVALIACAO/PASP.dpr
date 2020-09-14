program PASP;

{------------------------------------------------------------------------------}
{                              AVALIACAO SOFTPLAN                              }
{                                                                              }
{  //// APLICACAO PARA DOWNLOAD DE ARQUIVOS DA WEB ////                        }
{                                                                              }
{  Abordagem simplificada, usando apenas recursos da infraestruta XE ou        }
{  Libs de dominio publico. Nenhuma otimizacao foi elaborada, devido a         }
{  celeridade necessaria a entrega.                                            }
{                                                                              }
{ Developed by: R Cabral                                                       }
{ Contact: ronbral@gmail.com                                                   }
{ Last Rev: 14.09.20   Inicio: 13.09.20                                        }
{------------------------------------------------------------------------------}


uses
  Vcl.Forms,
  // Libs auxiliares - Dominio Público
  // Créditos:
  // Camada Indy: HtmlViewer: PBear / HtmlViewer Team
  // Animaçoes:   PicShow : Kambiz R. Khojasteh
  UrlConId10 in 'LibsAux\UrlConId10.pas',
  LogFormUnit in 'LibsAux\LogFormUnit.pas',
  HtmlGlobals in 'LibsAux\HtmlGlobals.pas',
  UrlConn in 'LibsAux\UrlConn.pas',
  URLSubs in 'LibsAux\URLSubs.pas',
  PicShow in 'LibsAux\PicShow.pas',
  PSEffect in 'LibsAux\PSEffect.pas',
  //PSAP
  fAvaliacaoSP in 'fAvaliacaoSP.pas' {fDownloadURL},
  dmRecursosBase in 'dmRecursosBase.pas' {dmRecsBase: TDataModule},
  fMensagemDlg in 'fMensagemDlg.pas' {FMsgDlg},
  fDownloadHist in 'fDownloadHist.pas' {FDownHist};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmRecsBase, dmRecsBase);
  Application.CreateForm(TfDownloadURL, fDownloadURL);
  Application.Run;
end.
