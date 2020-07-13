unit uDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs;

type
  TDm = class(TDataModule)
    Conn: TFDConnection;
    qry_cliente: TFDQuery;
    qry_geral: TFDQuery;
    qry_usuario: TFDQuery;
    qry_perfil: TFDQuery;
    qry_perfil_opcao: TFDQuery;
    qry_perfis: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDm.DataModuleCreate(Sender: TObject);
begin
    with conn do
    begin
        Params.Values['DriverID'] := 'SQLite';

        {$IFDEF IOS}
        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'IdeaCli.db');
        {$ENDIF}

        {$IFDEF ANDROID}
        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'IdeaCli.db');
        {$ENDIF}

        {$IFDEF MSWINDOWS}
        Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\DB\pedidos.db';
        //Params.Values['Database'] := 'D:\Projetos\IdeaCli\BD\IdeaCli.db';
        {$ENDIF}

        try
            Connected := true;
        except on e:exception do
            raise Exception.Create('Erro de conexão com o banco de dados: ' + e.Message);
        end;
    end;

end;

end.
