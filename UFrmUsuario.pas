unit UFrmUsuario;

interface

uses
  uFancyDialog,
  uFrmBase,

  FMX.ActnList,
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.ListView,
  FMX.ListView.Adapters.Base,
  FMX.ListView.Appearances,
  FMX.ListView.Types,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.Types,

  System.Actions,
  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants;

type
  TFrmUsuario = class(TFrmBase)
    procedure img_voltar_listaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure img_buscaClick(Sender: TObject);
  private
    cod_Usr, modo : string;
    fancy : TFancyDialog;
    procedure AddUsuario(cod_usuario, nome, login, administrador: string);
    procedure ListarUsuario(busca: string; ind_clear: boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUsuario: TFrmUsuario;

implementation

uses
  uFrmMenu, uDm;

{$R *.fmx}

procedure TFrmUsuario.AddUsuario(cod_usuario, nome, login, administrador: string);
var
    item : TListViewItem;
    txt : TListItemText;
begin
    try
        item           := lv_itens.Items.Add;
        item.TagString := cod_usuario;

        with item do
        begin
            // Nome...
            txt      := TListItemText(Objects.FindDrawable('TxtNome'));
            txt.Text := nome;

            // Login...
            txt      := TListItemText(Objects.FindDrawable('TxtLogin'));
            txt.Text := login;

            // Administrador...
            txt      := TListItemText(Objects.FindDrawable('TxtFone'));
            if administrador = 'S' then txt.Text := 'Administrador' else txt.Text := '';
        end;
    except on ex:exception do
        showmessage('Erro ao inserir usuário na lista: ' + ex.Message);
    end;
end;

procedure TFrmUsuario.ListarUsuario(busca: string; ind_clear: boolean);
begin
    dm.qry_usuario.Active := false;
    dm.qry_usuario.SQL.Clear;
    dm.qry_usuario.SQL.Add('SELECT U.* ');
    dm.qry_usuario.SQL.Add('FROM TAB_USUARIO U');

    // Filtro...
    if busca <> '' then
    begin
        dm.qry_usuario.SQL.Add('WHERE U.NOME LIKE ''%'' || :BUSCA || ''%'' ');
        dm.qry_usuario.ParamByName('BUSCA').Value := busca;
    end;

    dm.qry_usuario.SQL.Add('ORDER BY NOME');

    dm.qry_usuario.Active := true;

    // Limpar listagem...
    if ind_clear then
        lv_itens.Items.Clear;

    lv_itens.BeginUpdate;

    while NOT dm.qry_usuario.Eof do
    begin
            AddUsuario(dm.qry_usuario.FieldByName('COD_USUARIO').AsString,
                       dm.qry_usuario.FieldByName('NOME').AsString,
                       dm.qry_usuario.FieldByName('LOGIN').AsString,
                       dm.qry_usuario.FieldByName('ADMINISTRADOR').AsString);

        dm.qry_usuario.Next;
    end;

    lv_itens.EndUpdate;

end;



procedure TFrmUsuario.FormShow(Sender: TObject);
begin
    inherited;
    ListarUsuario('',True);
end;

procedure TFrmUsuario.img_buscaClick(Sender: TObject);
begin
  inherited;
  ListarUsuario(edt_busca.text,True);
end;

procedure TFrmUsuario.img_voltar_listaClick(Sender: TObject);
begin
  ActLista.Execute;
end;

end.
