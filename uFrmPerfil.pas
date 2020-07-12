unit uFrmPerfil;

interface

uses
  uDm,
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
  TFrmPerfil = class(TFrmBase)
    lytCod: TLayout;
    Label1: TLabel;
    Rectangle1: TRectangle;
    edt_cod: TEdit;
    lytNome: TLayout;
    Label2: TLabel;
    Rectangle2: TRectangle;
    edt_nome: TEdit;
    lytSituacao: TLayout;
    Label3: TLabel;
    swt_Situacao: TSwitch;
    Layout1: TLayout;
    Label4: TLabel;
    rctOptCli: TRectangle;
    lbl_OptCli: TLabel;
    rctOptPer: TRectangle;
    lbl_OptPer: TLabel;
    rctOptUsr: TRectangle;
    lbl_OptUsr: TLabel;
    img_excluir: TImage;
    TabOpcao: TTabItem;
    Rectangle3: TRectangle;
    lbl_nome_opcao: TLabel;
    img_Opcao_Ok: TImage;
    img_voltar_item: TImage;
    ActOpcao: TChangeTabAction;
    lytConsulta: TLayout;
    Label6: TLabel;
    swtConsulta: TSwitch;
    lytInclusao: TLayout;
    Label7: TLabel;
    swtInclusao: TSwitch;
    lytAlteracao: TLayout;
    Label8: TLabel;
    swtAlteracao: TSwitch;
    lytExclusao: TLayout;
    Label9: TLabel;
    swtExclusão: TSwitch;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_itensItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_voltar_itemClick(Sender: TObject);
    procedure img_Opcao_OkClick(Sender: TObject);
    procedure rctOptCliClick(Sender: TObject);
    procedure img_salvarClick(Sender: TObject);
    procedure rctOptUsrClick(Sender: TObject);
    procedure rctOptPerClick(Sender: TObject);
    procedure img_voltar_listaClick(Sender: TObject);
    procedure img_AddClick(Sender: TObject);
    procedure img_buscaClick(Sender: TObject);
  private
    Fancy : TFancyDialog;
    Cod_Per, Modo, Opc_Edit : string;
    procedure AddPerfil(cod_perfil, nome, Situacao: string);
    procedure ListarPerfil(busca: string; ind_clear: boolean );
    procedure EditarOpcao(aPermiss: string);
    function MontaPerm(aOpcao: string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPerfil: TFrmPerfil;

implementation

uses
  uFrmMenu;

{$R *.fmx}

procedure TFrmPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Fancy.DisposeOf;
end;

procedure TFrmPerfil.FormCreate(Sender: TObject);
begin
  inherited;
  fancy := TFancyDialog.Create(FrmPerfil);
end;


procedure TFrmPerfil.FormShow(Sender: TObject);
begin
  inherited;
  ListarPerfil('',false);
end;

procedure TFrmPerfil.img_Opcao_OkClick(Sender: TObject);
var
  OpcaoCorrente : string;
begin
    //Tratar Opcao;
    OpcaoCorrente := '';
    if swtConsulta.IsChecked  then OpcaoCorrente := OpcaoCorrente + 'C';
    if swtInclusao.IsChecked  then OpcaoCorrente := OpcaoCorrente + 'I';
    if swtAlteracao.IsChecked then OpcaoCorrente := OpcaoCorrente + 'A';
    if swtExclusão.IsChecked  then OpcaoCorrente := OpcaoCorrente + 'D';
    if Opc_Edit = 'CLI' then
    begin
        rctOptCli.TagString := OpcaoCorrente;
        lbl_OptCli.Text     :='Cad. de Clientes: '+ MontaPerm(rctOptCli.TagString);
    end;
    if Opc_Edit = 'USR' then
    begin
        rctOptUsr.TagString := OpcaoCorrente;
        lbl_OptUsr.Text     :='Cad. de Usuários: ' + MontaPerm(rctOptUsr.TagString);
    end;
    if Opc_Edit = 'PER' then
    begin
        rctOptPer.TagString := OpcaoCorrente;
        lbl_OptPer.Text     :='Cad. de Perfis: '+ MontaPerm(rctOptPer.TagString);
    end;

    ActItem.Execute;

end;

procedure TFrmPerfil.img_AddClick(Sender: TObject);
begin
    if NOT FrmMenu.VerificaPermissao('PER','I') then
    begin
        fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
        Exit;
    end;
    Cod_Per                := '';
    modo                   := 'I';
    edt_cod.Text           := '';
    edt_nome.Text          := '';
    swt_Situacao.IsChecked := True;

    rctOptCli.TagString    := '';
    rctOptUsr.TagString    := '';
    rctOptPer.TagString    := '';
    rctOptCli.Tag          := 0;
    rctOptUsr.Tag          := 0;
    rctOptPer.Tag          := 0;

    lbl_OptCli.Text        :='Cad. de Clientes: SEM PERMISSÕES!';
    lbl_OptUsr.Text        :='Cad. de Usuários: SEM PERMISSÕES!';
    lbl_OptPer.Text        :='Cad. de Perfis:   SEM PERMISSÕES!';


    lbl_Nome_Item.Text     := 'NOVO PERFIL';

    inherited;

    edt_nome.SetFocus;

end;

procedure TFrmPerfil.img_buscaClick(Sender: TObject);
begin
  inherited;
  ListarPerfil(edt_busca.Text,True);
end;

procedure TFrmPerfil.img_salvarClick(Sender: TObject);
var
  I, aCod_PerOp : Integer;
  aOpcao, aPermissao : string;
begin
    try //try do Perfil
        dm.qry_perfil.Active := false;
        dm.qry_perfil.SQL.Clear;

        if Modo = 'I' then
        begin
            dm.qry_perfil.SQL.Add('INSERT INTO TAB_PERFIL(NOME, SITUACAO) ');
            dm.qry_perfil.SQL.Add('VALUES(:NOME, :SITUACAO) ');
        end
        else
        begin
            dm.qry_perfil.SQL.Add('UPDATE TAB_PERFIL SET CNOME=:NOME, SITUACAO=:SITUACAO ');
            dm.qry_perfil.SQL.Add('WHERE COD_PERFIL =:COD_PERFIL');

            dm.qry_perfil.ParamByName('COD_PERFIL').Value := Cod_Per;
        end;

        dm.qry_perfil.ParamByName('NOME').Value := edt_nome.Text;
        if swt_Situacao.IsChecked then
            dm.qry_perfil.ParamByName('SITUACAO').Value := 'A'
        else
            dm.qry_perfil.ParamByName('SITUACAO').Value := 'I';

        dm.qry_perfil.ExecSQL;

        if Modo = 'I' then
        begin
            dm.qry_geral.Active := False;
            dm.qry_geral.SQL.Clear;
            dm.qry_geral.SQL.Add('SELECT IFNULL(MAX(COD_PERFIL), 0) AS COD_PERFIL FROM TAB_PERFIL');
            dm.qry_geral.Active := True;

            Cod_Per := dm.qry_geral.FieldByName('COD_PERFIL').AsString;
        end;
    except on ex:exception do
    begin
        showmessage('Erro ao cadastrar Perfil: ' + ex.Message);
        exit;
    end;
    end;

    try //try das opcoes
        for I := 1 to 3 do
        begin
            if I=1 then
            begin
              aOpcao     := 'CLI';
              aPermissao := rctOptCli.TagString;
              aCod_PerOp := rctOptCli.Tag;
            end;

            if I=2 then
            begin
              aOpcao     := 'USR';
              aPermissao := rctOptUsr.TagString;
              aCod_PerOp := rctOptUsr.Tag;
            end;

            if I=3 then
            begin
              aOpcao     := 'PER';
              aPermissao := rctOptPer.TagString;
              aCod_PerOp := rctOptPer.Tag;
            end;

            dm.qry_perfil_opcao.Active := false;
            dm.qry_perfil_opcao.SQL.Clear;

            if Modo = 'I' then
            begin
                dm.qry_perfil_opcao.SQL.Add('INSERT INTO TAB_PERFIL_OPCAO(COD_PERFIL, COD_OPCAO, COD_PERMISSAO) ');
                dm.qry_perfil_opcao.SQL.Add('VALUES(:COD_PERFIL, :COD_OPCAO, :COD_PERMISSAO) ');
            end
            else
            begin
                dm.qry_perfil_opcao.SQL.Add('UPDATE TAB_PERFIL SET COD_PERFIL=:COD_PERFIL, COD_OPCAO=:COD_OPCAO, COD_PERMISSAO=:COD_PERMISSAO');
                dm.qry_perfil_opcao.SQL.Add('WHERE COD_PERFIL_OP = :COD_PERFIL_OP');

                dm.qry_perfil_opcao.ParamByName('COD_PERFIL_OP').Value := aCod_PerOp;
            end;

            dm.qry_perfil_opcao.ParamByName('COD_PERFIL').Value    := Cod_Per;
            dm.qry_perfil_opcao.ParamByName('COD_OPCAO').Value     := aOpcao;
            dm.qry_perfil_opcao.ParamByName('COD_PERMISSAO').Value := aPermissao;

            dm.qry_perfil_opcao.ExecSQL;
        end;

    except on ex:exception do
    begin
        showmessage('Erro ao cadastrar Perfil: ' + ex.Message);
        exit;
    end;

    end;

    ListarPerfil(edt_busca.Text, true);
    ActLista.Execute


end;

procedure TFrmPerfil.img_voltar_itemClick(Sender: TObject);
begin
    Opc_Edit :='';
    ActItem.Execute;
end;

procedure TFrmPerfil.img_voltar_listaClick(Sender: TObject);
begin
    ActLista.Execute;
end;

procedure TFrmPerfil.AddPerfil(cod_perfil, nome, Situacao: string);
var
    item : TListViewItem;
    txt : TListItemText;
begin
    try
        item           := lv_itens.Items.Add;
        item.TagString := cod_perfil;

        with item do
        begin
            // Nome...
            txt      := TListItemText(Objects.FindDrawable('TxtNome'));
            txt.Text := nome;

            // Endereco...
            txt      := TListItemText(Objects.FindDrawable('TxtSituacao'));
            if Situacao = 'A' then
            begin
              txt.Text := 'Perfil Ativo';
              txt.TextColor := $FF7796CB;

            end else
            begin
              txt.Text := 'Perfil Desativado';
              txt.TextColor := $FFd1d2f9;
            end;

        end;
    except on ex:exception do
        showmessage('Erro ao inserir perfil na lista: ' + ex.Message);
    end;
end;


procedure TFrmPerfil.ListarPerfil(busca: string; ind_clear: boolean );
begin
      dm.qry_perfil.Active := false;
      dm.qry_perfil.SQL.Clear;
      dm.qry_perfil.SQL.Add('SELECT P.* ');
      dm.qry_perfil.SQL.Add('FROM TAB_PERFIL P');

      // Filtro...
      if busca <> '' then
      begin
          dm.qry_perfil.SQL.Add('WHERE P.NOME LIKE ''%'' || :BUSCA || ''%'' ');
          dm.qry_perfil.ParamByName('BUSCA').Value := busca;
      end;

      dm.qry_perfil.SQL.Add('ORDER BY NOME');

      dm.qry_perfil.Active := true;

      // Limpar listagem...
      if ind_clear then
          lv_itens.Items.Clear;

      lv_itens.BeginUpdate;

      while NOT dm.qry_perfil.Eof do
      begin
          AddPerfil(dm.qry_perfil.FieldByName('COD_PERFIL').AsString,
                    dm.qry_perfil.FieldByName('NOME').AsString,
                    dm.qry_perfil.FieldByName('SITUACAO').AsString
                     );

          dm.qry_perfil.Next;
      end;

      lv_itens.EndUpdate;

end;

function TFrmPerfil.MontaPerm(aOpcao : string): string;
begin
    Result := '';
    if Pos('C',aOpcao)>0 then Result := Result+' Consulta,';
    if Pos('I',aOpcao)>0 then Result := Result+' Inclusão,';
    if Pos('A',aOpcao)>0 then Result := Result+' Alteração,';
    if Pos('D',aOpcao)>0 then Result := Result+' Exclusão';
    if Result='' then
        Result := 'SEM PERMISSÕES!'
    else
        if Result[Length(Result)-1]=',' then Result := Copy(Result,0,Length(Result)-1);

end;

procedure TFrmPerfil.lv_itensItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    try
        //Testar permissão de Alteração
        if NOT FrmMenu.VerificaPermissao('PER','A') then
        begin
            fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
            Exit;
        end;
        Cod_Per := AItem.TagString;
        modo := 'A';
        img_excluir.Visible := true;

        // Buscar dados do produto na base...
        dm.qry_geral.Active := false;
        dm.qry_geral.SQL.Clear;
        dm.qry_geral.SQL.Add('SELECT * FROM TAB_PERFIL WHERE COD_PERFIL=:COD_PERFIL');
        dm.qry_geral.ParamByName('COD_PERFIL').Value := Cod_Per;
        dm.qry_geral.Active := true;

        edt_cod.Text       := dm.qry_geral.FieldByName('COD_PERFIL').AsString;
        edt_nome.Text      := dm.qry_geral.FieldByName('NOME').AsString;
        swt_Situacao.IsChecked := dm.qry_geral.FieldByName('SITUACAO').AsString='A' ;

        Dm.qry_perfil_opcao.Active := False;
        dm.qry_perfil_opcao.SQL.Clear;
        dm.qry_perfil_opcao.SQL.Add('SELECT * FROM TAB_PERFIL_OPCAO WHERE COD_PERFIL=:COD_PERFIL');
        dm.qry_perfil_opcao.ParamByName('COD_PERFIL').Value := Cod_Per;
        dm.qry_perfil_opcao.Active := true;

        While not Dm.qry_perfil_opcao.Eof do
        begin
          if Dm.qry_perfil_opcao.FieldByName('COD_OPCAO').AsString='CLI' then
          begin
              rctOptCli.TagString := Dm.qry_perfil_opcao.FieldByName('COD_PERMISSAO').AsString;
              rctOptCli.Tag       := Dm.qry_perfil_opcao.FieldByName('COD_PERFIL_Op').AsInteger;
              lbl_OptCli.Text     :='Cad. de Clientes: '+ MontaPerm(rctOptCli.TagString);
          end;

          if Dm.qry_perfil_opcao.FieldByName('COD_OPCAO').AsString='USR' then
          begin
              rctOptUsr.TagString := Dm.qry_perfil_opcao.FieldByName('COD_PERMISSAO').AsString;
              rctOptUsr.Tag       := Dm.qry_perfil_opcao.FieldByName('COD_PERFIL_Op').AsInteger;
              lbl_OptUsr.Text     :='Cad. de Usuários: ' + MontaPerm(rctOptUsr.TagString);
          end;

          if Dm.qry_perfil_opcao.FieldByName('COD_OPCAO').AsString='PER' then
          begin
              rctOptPer.TagString := Dm.qry_perfil_opcao.FieldByName('COD_PERMISSAO').AsString;
              rctOptPer.Tag       := Dm.qry_perfil_opcao.FieldByName('COD_PERFIL_Op').AsInteger;
              lbl_OptPer.Text     :='Cad. de Perfis: '+ MontaPerm(rctOptPer.TagString);
          end;

          Dm.qry_perfil_opcao.Next;
        end;

        lbl_Nome_Item.Text := 'CLIENTE: '+ edt_nome.Text;

        edt_nome.SetFocus;

        ActItem.Execute;

    except on ex:exception do
        showmessage('Erro ao carregar dados do cliente: ' + ex.Message);
    end;


end;

procedure TFrmPerfil.EditarOpcao(aPermiss: string);
begin
    swtConsulta.IsChecked  := (Pos('C',aPermiss)>0);
    swtInclusao.IsChecked  := (Pos('I',aPermiss)>0);
    swtAlteracao.IsChecked := (Pos('A',aPermiss)>0);
    swtExclusão.IsChecked  := (Pos('D',aPermiss)>0);
end;

procedure TFrmPerfil.rctOptCliClick(Sender: TObject);
begin
   Opc_Edit       := 'CLI';
   lbl_nome_opcao.Text := 'Cad. Clientes';
   EditarOpcao(TRectangle(Sender).TagString);
   ActOpcao.Execute;
end;

procedure TFrmPerfil.rctOptPerClick(Sender: TObject);
begin
   Opc_Edit       := 'PER';
   lbl_nome_opcao.Text := 'Perfis';
   EditarOpcao(TRectangle(Sender).TagString);
   ActOpcao.Execute;

end;

procedure TFrmPerfil.rctOptUsrClick(Sender: TObject);
begin
   Opc_Edit       := 'USR';
   lbl_nome_opcao.Text := 'Cad. Usuários';
   EditarOpcao(TRectangle(Sender).TagString);
   ActOpcao.Execute;
end;

end.
