unit uFrmCliente;

interface

uses
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
  System.Variants,

  uFancyDialog;

type
  TFrmCliente = class(TFrmBase)
    Layout1: TLayout;
    edt_cod: TEdit;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    Label2: TLabel;
    Rectangle2: TRectangle;
    edt_nome: TEdit;
    Layout4: TLayout;
    Label3: TLabel;
    Rectangle3: TRectangle;
    edt_Obs: TEdit;
    Layout5: TLayout;
    Label4: TLabel;
    Rectangle4: TRectangle;
    edt_valor: TEdit;
    Layout6: TLayout;
    lbl_cidade: TLabel;
    Rectangle5: TRectangle;
    edt_cid: TEdit;
    Layout7: TLayout;
    Label6: TLabel;
    Rectangle6: TRectangle;
    edt_Endereco: TEdit;
    Layout8: TLayout;
    Label7: TLabel;
    Rectangle7: TRectangle;
    edt_email: TEdit;
    Layout9: TLayout;
    Label8: TLabel;
    Rectangle8: TRectangle;
    edt_Fone: TEdit;
    Layout10: TLayout;
    Label9: TLabel;
    Rectangle9: TRectangle;
    edt_CNPJCPF: TEdit;
    img_excluir: TImage;
    procedure FormShow(Sender: TObject);
    procedure img_voltar_listaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_buscaClick(Sender: TObject);
    procedure lv_itensPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure lv_itensItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormCreate(Sender: TObject);
    procedure img_AddClick(Sender: TObject);
    procedure img_salvarClick(Sender: TObject);
    procedure img_excluirClick(Sender: TObject);
  private
    cod_Cli, modo : string;
    fancy : TFancyDialog;
    procedure AddCliente(cod_cliente, nome, endereco, cidade, fone: string);
    procedure ListarCliente(busca: string; ind_clear: boolean; delay: integer=0);
    procedure ClickDelete(Sender: TObject);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCliente: TFrmCliente;

implementation

uses
  uDm, uFrmMenu;

{$R *.fmx}

procedure TFrmCliente.AddCliente(cod_cliente, nome, endereco, cidade, fone: string);
var
    item : TListViewItem;
    txt : TListItemText;
begin
    try
        item           := lv_itens.Items.Add;
        item.TagString := cod_cliente;

        with item do
        begin
            // Nome...
            txt      := TListItemText(Objects.FindDrawable('TxtNome'));
            txt.Text := nome;

            // Endereco...
            txt      := TListItemText(Objects.FindDrawable('TxtEndereco'));
            txt.Text := endereco + ' - ' + cidade;

            // Fone...
            txt      := TListItemText(Objects.FindDrawable('TxtFone'));
            txt.Text := fone;
        end;
    except on ex:exception do
        showmessage('Erro ao inserir cliente na lista: ' + ex.Message);
    end;
end;


procedure TFrmCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    fancy.DisposeOf;

    FrmCliente := nil;
end;

procedure TFrmCliente.FormCreate(Sender: TObject);
begin
  inherited;
  fancy := TFancyDialog.Create(FrmCliente);

end;

procedure TFrmCliente.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
    inherited;
    if Key = vkReturn then
     begin
         Key := vkTab;
         KeyDown(Key, KeyChar, Shift);
     end;
end;

procedure TFrmCliente.FormShow(Sender: TObject);
begin
  inherited;
  ListarCliente('',True);
end;

procedure TFrmCliente.img_AddClick(Sender: TObject);
begin

    if NOT FrmMenu.VerificaPermissao('CLI','I') then
    begin
        fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
        Exit;
    end;
    cod_Cli            := '';
    modo               := 'I';
    edt_cod.Text       := '';
    edt_Obs.Text       := '';
    edt_cid.Text       := '';
    edt_nome.Text      := '';
    edt_Fone.Text      := '';
    edt_email.Text     := '';
    edt_CNPJCPF.Text   := '';
    edt_Endereco.Text  := '';
    edt_valor.Text     := '0,00';
    lbl_Nome_Item.Text := 'NOVO CLIENTE';
    inherited;

    edt_nome.SetFocus;

end;

procedure TFrmCliente.img_buscaClick(Sender: TObject);
begin
    inherited;
    ListarCliente(edt_busca.Text,True);
end;

procedure TFrmCliente.ClickDelete(Sender: TObject);
begin
    try
        dm.qry_cliente.Active := false;
        dm.qry_cliente.SQL.Clear;
        dm.qry_cliente.SQL.Add('DELETE FROM TAB_CLIENTE');
        dm.qry_cliente.SQL.Add('WHERE COD_CLIENTE = :COD_CLIENTE');
        dm.qry_cliente.ParamByName('COD_CLIENTE').Value := cod_Cli;
        dm.qry_cliente.ExecSQL;

    except on ex:exception do
    begin
        showmessage('Erro ao excluir cliente: ' + ex.Message);
        exit;
    end;
    end;

    ListarCliente(edt_busca.Text, true, 0);
    ActLista.Execute;
end;

procedure TFrmCliente.img_excluirClick(Sender: TObject);
begin
    if NOT FrmMenu.VerificaPermissao('CLI','D') then
    begin
        fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
        Exit;
    end;

    fancy.Show(TIconDialog.Question, 'Confirmação', 'Deseja excluir o cliente?',
               'Sim', ClickDelete, 'Não');
end;

procedure TFrmCliente.img_salvarClick(Sender: TObject);
var
    valor : string;
begin
    try
        dm.qry_cliente.Active := false;
        dm.qry_cliente.SQL.Clear;

        if Modo = 'I' then
        begin
            dm.qry_cliente.SQL.Add('INSERT INTO TAB_CLIENTE(CNPJ_CPF, NOME, FONE, EMAIL, ENDERECO, ');
            dm.qry_cliente.SQL.Add('CIDADE, OBS, VALOR_LIMITE)');
            dm.qry_cliente.SQL.Add('VALUES(:CNPJ_CPF, :NOME, :FONE, :EMAIL, :ENDERECO, ');
            dm.qry_cliente.SQL.Add(':CIDADE, :OBS, :VALOR_LIMITE )');
        end
        else
        begin
            dm.qry_cliente.SQL.Add('UPDATE TAB_CLIENTE SET CNPJ_CPF=:CNPJ_CPF, NOME=:NOME, FONE=:FONE, ');
            dm.qry_cliente.SQL.Add('EMAIL=:EMAIL, ENDERECO=:ENDERECO, CIDADE=:CIDADE, OBS=:OBS, VALOR_LIMITE=:VALOR_LIMITE ');
            dm.qry_cliente.SQL.Add('WHERE COD_CLIENTE = :COD_CLIENTE');

            dm.qry_cliente.ParamByName('COD_CLIENTE').Value := cod_cli;
        end;

        // 8.500,00
        valor := StringReplace(edt_valor.Text, '.', '', [rfReplaceAll]); // 8500,00
        valor := StringReplace(valor, ',', '', [rfReplaceAll]); // 850000


        dm.qry_cliente.ParamByName('CNPJ_CPF').Value := edt_CNPJCPF.Text;
        dm.qry_cliente.ParamByName('NOME').Value := edt_nome.Text;
        dm.qry_cliente.ParamByName('FONE').Value := edt_Fone.Text;
        dm.qry_cliente.ParamByName('EMAIL').Value := edt_email.Text;
        dm.qry_cliente.ParamByName('ENDERECO').Value := edt_Endereco.Text;
        dm.qry_cliente.ParamByName('CIDADE').Value := edt_cid.Text;
        dm.qry_cliente.ParamByName('OBS').Value := edt_Obs.Text;
        dm.qry_cliente.ParamByName('VALOR_LIMITE').Value := valor.ToDouble / 100;

        dm.qry_cliente.ExecSQL;

    except on ex:exception do
    begin
        showmessage('Erro ao cadastrar cliente: ' + ex.Message);
        exit;
    end;
    end;

    ListarCliente(edt_busca.Text, true, 600);
    ActLista.Execute

end;

procedure TFrmCliente.img_voltar_listaClick(Sender: TObject);
begin
    ActLista.Execute;
end;

procedure TFrmCliente.ListarCliente(busca: string; ind_clear: boolean; delay : integer=0);
begin
    if lv_itens.TagString = '1' then
        exit;

    lv_itens.TagString := '1'; // Em processamento...

    if ind_clear then
        lv_itens.Tag := 0;

    TThread.CreateAnonymousThread(procedure
    begin
        sleep(delay);

        dm.qry_cliente.Active := false;
        dm.qry_cliente.SQL.Clear;
        dm.qry_cliente.SQL.Add('SELECT C.* ');
        dm.qry_cliente.SQL.Add('FROM TAB_CLIENTE C');

        // Filtro...
        if busca <> '' then
        begin
            dm.qry_cliente.SQL.Add('WHERE C.NOME LIKE ''%'' || :BUSCA || ''%'' ');
            dm.qry_cliente.ParamByName('BUSCA').Value := busca;
        end;

        dm.qry_cliente.SQL.Add('ORDER BY NOME');
        dm.qry_cliente.SQL.Add('LIMIT :PAGINA, :QTD_REG');
        dm.qry_cliente.ParamByName('PAGINA').Value := lv_itens.Tag * 15;
        dm.qry_cliente.ParamByName('QTD_REG').Value := 15;
        dm.qry_cliente.Active := true;

        // Limpar listagem...
        if ind_clear then
            lv_itens.Items.Clear;

        lv_itens.Tag := lv_itens.Tag + 1;
        lv_itens.BeginUpdate;

        while NOT dm.qry_cliente.Eof do
        begin
            TThread.Synchronize(nil, procedure
            begin
                AddCliente(dm.qry_cliente.FieldByName('COD_CLIENTE').AsString,
                           dm.qry_cliente.FieldByName('NOME').AsString,
                           dm.qry_cliente.FieldByName('ENDERECO').AsString,
                           dm.qry_cliente.FieldByName('CIDADE').AsString,
                           dm.qry_cliente.FieldByName('FONE').AsString);
            end);

            dm.qry_cliente.Next;
        end;

        lv_itens.EndUpdate;
        lv_itens.TagString := ''; // Processamento terminou...

    end).Start;
end;


procedure TFrmCliente.lv_itensItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    try
        //Testar permissão de Alteração
        if NOT FrmMenu.VerificaPermissao('CLI','A') then
        begin
            fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
            Exit;
        end;
        cod_cli := AItem.TagString;
        modo := 'A';
        img_excluir.Visible := true;

        // Buscar dados do produto na base...
        dm.qry_geral.Active := false;
        dm.qry_geral.SQL.Clear;
        dm.qry_geral.SQL.Add('SELECT * FROM TAB_CLIENTE WHERE COD_CLIENTE=:COD_CLIENTE');
        dm.qry_geral.ParamByName('COD_CLIENTE').Value := cod_cli;
        dm.qry_geral.Active := true;

        edt_cod.Text       := dm.qry_geral.FieldByName('COD_CLIENTE').AsString;
        edt_Obs.Text       := dm.qry_geral.FieldByName('OBS').AsString;
        edt_cid.Text       := dm.qry_geral.FieldByName('CIDADE').AsString;
        edt_nome.Text      := dm.qry_geral.FieldByName('NOME').AsString;
        edt_Fone.Text      := dm.qry_geral.FieldByName('FONE').AsString;
        edt_email.Text     := dm.qry_geral.FieldByName('EMAIL').AsString;
        edt_CNPJCPF.Text   := dm.qry_geral.FieldByName('CNPJ_CPF').AsString;
        edt_Endereco.Text  := dm.qry_geral.FieldByName('ENDERECO').AsString;
        edt_valor.Text     := FormatFloat('#,##0.00', dm.qry_geral.FieldByName('VALOR_LIMITE').AsFloat);

        lbl_Nome_Item.Text := 'CLIENTE: '+ edt_nome.Text;

        edt_nome.SetFocus;

        ActItem.Execute;

    except on ex:exception do
        showmessage('Erro ao carregar dados do cliente: ' + ex.Message);
    end;

end;

procedure TFrmCliente.lv_itensPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
    if lv_itens.Items.Count >= 0 then
      begin
          if lv_itens.GetItemRect(lv_itens.Items.Count - 5).Bottom <= lv_itens.Height then
              ListarCliente(edt_busca.Text, false, 0);
      end;

end;

end.
