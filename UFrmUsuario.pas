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
  System.Variants, FMX.ListBox, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope;

type
  TFrmUsuario = class(TFrmBase)
    lytCod: TLayout;
    Label1: TLabel;
    Rectangle1: TRectangle;
    edt_cod: TEdit;
    Layout3: TLayout;
    Label2: TLabel;
    Rectangle2: TRectangle;
    edt_nome: TEdit;
    lytLogin: TLayout;
    Label3: TLabel;
    Rectangle3: TRectangle;
    edt_login: TEdit;
    Layout1: TLayout;
    Label4: TLabel;
    Rectangle4: TRectangle;
    edt_senha: TEdit;
    Layout2: TLayout;
    Label5: TLabel;
    Rectangle5: TRectangle;
    cbxPerfil: TComboBox;
    img_excluir: TImage;
    lytAdministrador: TLayout;
    Label6: TLabel;
    swt_adm: TSwitch;
    procedure img_voltar_listaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure img_buscaClick(Sender: TObject);
    procedure lv_itensItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_AddClick(Sender: TObject);
    procedure img_salvarClick(Sender: TObject);
    procedure img_excluirClick(Sender: TObject);
  private
    cod_Usr, modo : string;
    fancy : TFancyDialog;
    procedure AddUsuario(cod_usuario, nome, login, administrador: string; cod_perfil:Integer);
    procedure ListarUsuario(busca: string; ind_clear: boolean);
    procedure ClickDelete(Sender: TObject);
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

procedure TFrmUsuario.AddUsuario(cod_usuario, nome, login, administrador: string; cod_perfil:Integer);
var
    item : TListViewItem;
    txt : TListItemText;
begin
    try
        item           := lv_itens.Items.Add;
        item.TagString := cod_usuario;
        item.Tag       := cod_perfil;

        with item do
        begin
            // Nome...
            txt      := TListItemText(Objects.FindDrawable('TxtNome'));
            txt.Text := nome;

            // Login...
            txt      := TListItemText(Objects.FindDrawable('TxtLogin'));
            txt.Text := login;

            // Administrador...
            txt      := TListItemText(Objects.FindDrawable('TxtAdministrador'));
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
                       dm.qry_usuario.FieldByName('ADMINISTRADOR').AsString,
                       Dm.qry_usuario.FieldByName('COD_PERFIL').AsInteger);

        dm.qry_usuario.Next;
    end;

    lv_itens.EndUpdate;

end;



procedure TFrmUsuario.lv_itensItemClick(const Sender: TObject;
  const AItem: TListViewItem);
//var
//  aCodPerfil: Integer;
begin
    try
        //Testar permissão de Alteração
        if NOT FrmMenu.VerificaPermissao('USR','A') then
        begin
            fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
            Exit;
        end;
        cod_Usr    := AItem.TagString;
//        aCodPerfil := AItem.Tag;
        modo       := 'A';
        img_excluir.Visible := true;

        // Buscar dados do produto na base...
        dm.qry_usuario.Active := false;
        dm.qry_usuario.SQL.Clear;
        dm.qry_usuario.SQL.Add('SELECT * FROM TAB_USUARIO WHERE COD_USUARIO=:COD_USUARIO');
        dm.qry_usuario.ParamByName('COD_USUARIO').Value := cod_Usr;
        dm.qry_usuario.Active := true;

        edt_cod.Text       := dm.qry_usuario.FieldByName('COD_USUARIO').AsString;
        edt_login.Text     := dm.qry_usuario.FieldByName('LOGIN').AsString;
        edt_senha.Text     := dm.qry_usuario.FieldByName('SENHA').AsString;
        edt_nome.Text      := dm.qry_usuario.FieldByName('NOME').AsString;

        swt_adm.IsChecked := dm.qry_usuario.FieldByName('ADMINISTRADOR').AsString ='S';

        if not swt_adm.IsChecked then cbxPerfil.ItemIndex := AItem.Tag;
        lbl_Nome_Item.Text := 'Usuário';

        edt_nome.SetFocus;

        ActItem.Execute;

    except on ex:exception do
        showmessage('Erro ao carregar dados do usuário : ' + ex.Message);
    end;

end;

procedure TFrmUsuario.FormShow(Sender: TObject);
begin
    inherited;
    cbxPerfil.Items.Clear;
    Dm.qry_perfis.Active := False;
    Dm.qry_perfis.Active := True;
    while not Dm.qry_perfis.Eof do
    begin
        cbxPerfil.Items.AddObject(Dm.qry_perfis.FieldByName('NOME').AsString,TObject(Dm.qry_perfis.FieldByName('COD_PERFIL').AsInteger));
        Dm.qry_perfis.Next;
    end;

    ListarUsuario('',True);
end;

procedure TFrmUsuario.img_AddClick(Sender: TObject);
begin

    if NOT FrmMenu.VerificaPermissao('USR','I') then
    begin
        fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
        Exit;
    end;
    cod_Usr            := '';
    modo               := 'I';
    edt_cod.Text       := '';
    edt_nome.Text      := '';
    edt_login.Text     := '';
    edt_senha.Text     := '';
    swt_adm.IsChecked  := False;
    lbl_Nome_Item.Text := 'NOVO USUÁRIO';
    inherited;

    edt_nome.SetFocus;


end;

procedure TFrmUsuario.img_buscaClick(Sender: TObject);
begin
  inherited;
  ListarUsuario(edt_busca.text,True);
end;

procedure TFrmUsuario.ClickDelete(Sender: TObject);
begin
    try
        dm.qry_usuario.Active := false;
        dm.qry_usuario.SQL.Clear;
        dm.qry_usuario.SQL.Add('DELETE FROM TAB_USUARIO');
        dm.qry_usuario.SQL.Add('WHERE COD_USUARIO = :COD_USUARIO');
        dm.qry_usuario.ParamByName('COD_CLIENTE').Value := cod_Usr;
        dm.qry_usuario.ExecSQL;

    except on ex:exception do
    begin
        showmessage('Erro ao excluir Usuário: ' + ex.Message);
        exit;
    end;
    end;

    ListarUsuario(edt_busca.Text, true);
    ActLista.Execute;
end;


procedure TFrmUsuario.img_excluirClick(Sender: TObject);
begin
  inherited;
    if NOT FrmMenu.VerificaPermissao('USR','D') then
    begin
        fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
        Exit;
    end;

    fancy.Show(TIconDialog.Question, 'Confirmação', 'Deseja excluir o cliente?',
               'Sim', ClickDelete, 'Não');

end;

procedure TFrmUsuario.img_salvarClick(Sender: TObject);
begin
    try
        dm.qry_usuario.Active := false;
        dm.qry_usuario.SQL.Clear;

        if Modo = 'I' then
        begin
            dm.qry_usuario.SQL.Add('INSERT INTO TAB_USUARIO(LOGIN, SENHA, NOME, COD_PERFIL, ADMINISTRADOR) ');
            dm.qry_usuario.SQL.Add('VALUES(:LOGIN, :SENHA, :NOME, :COD_PERFIL, :ADMINISTRADOR)');
        end
        else
        begin
            dm.qry_usuario.SQL.Add('UPDATE TAB_USUARIO SET LOGIN=:LOGIN, SENHA=:SENHA, NOME=:NOME, COD_PERFIL=:COD_PERFIL, ADMINISTRADOR=:ADMINISTRADOR)');
            dm.qry_usuario.SQL.Add('WHERE COD_USUARIO = :COD_USUARIO');

            dm.qry_usuario.ParamByName('COD_USUARIO').Value := cod_Usr;
        end;


        dm.qry_usuario.ParamByName('NOME').Value       := edt_nome.Text;
        dm.qry_usuario.ParamByName('LOGIN').Value      := edt_login.Text;
        dm.qry_usuario.ParamByName('SENHA').Value      := edt_senha.Text;
        dm.qry_usuario.ParamByName('COD_PERFIL').Value := cbxPerfil.ItemIndex;
        if swt_adm.IsChecked then
            dm.qry_usuario.ParamByName('ADMINISTRADOR').Value := 'S'
        else
            dm.qry_usuario.ParamByName('ADMINISTRADOR').Value := 'N';

        dm.qry_usuario.ExecSQL;

    except on ex:exception do
    begin
        showmessage('Erro ao cadastrar Usuário: ' + ex.Message);
        exit;
    end;
    end;

    ListarUsuario(edt_busca.Text, true);
    ActLista.Execute

end;

procedure TFrmUsuario.img_voltar_listaClick(Sender: TObject);
begin
  ActLista.Execute;
end;

end.
