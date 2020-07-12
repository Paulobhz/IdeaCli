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
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Fancy : TFancyDialog;
    procedure AddPerfil(cod_perfil, nome, Situacao: string);
    procedure ListarPerfil(busca: string; ind_clear: boolean );
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



end.
