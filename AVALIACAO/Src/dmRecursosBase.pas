unit dmRecursosBase;

{------------------------------------------------------------------------------}
{                              AVALIACAO SOFTPLAN                              }
{                                                                              }
{  PROJETO: Aplicacao para Downloads de arquivos da WEB ********************** }
{                                                                              }
{  //// DATAMODULE / RECURSOS COMUNS  ////                                     }
{                                                                              }
{ Developed by: R Cabral                                                       }
{ Contact: ronbral@gmail.com                                                   }
{ Set/2020                                                                     }
{------------------------------------------------------------------------------}

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.ImageList, Vcl.ImgList,
  Vcl.Controls, UrlConn;

type
  TdmRecsBase = class(TDataModule)
    FDConnectionSQLite: TFDConnection;
    FDQuery: TFDQuery;
    ConexaoWeb: ThtConnectionManager;
    ImageListJPG: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmRecsBase: TdmRecsBase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
