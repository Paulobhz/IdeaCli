unit uFrmBase;

interface

uses
  uDm,
  uFancyDialog,

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
  TFrmBase = class(TForm)
    TabControl: TTabControl;
    TabLista: TTabItem;
    TabItem: TTabItem;
    lytBusca: TLayout;
    rctBusca: TRectangle;
    edt_busca: TEdit;
    img_busca: TImage;
    lv_itens: TListView;
    tctToolBarLista: TRectangle;
    lbl_Nome: TLabel;
    img_Add: TImage;
    img_voltar: TImage;
    ActionList: TActionList;
    ActItem: TChangeTabAction;
    ActLista: TChangeTabAction;
    rctToolBarItem: TRectangle;
    lbl_Nome_Item: TLabel;
    img_salvar: TImage;
    img_voltar_lista: TImage;
    procedure img_voltarClick(Sender: TObject);
    procedure img_AddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmBase: TFrmBase;

implementation

uses
  uFrmMenu;

{$R *.fmx}

procedure TFrmBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FrmBase.DisposeOf;
    FrmBase := nil;
end;

procedure TFrmBase.FormShow(Sender: TObject);
begin
    TabControl.ActiveTab := TabLista;

end;

procedure TFrmBase.img_AddClick(Sender: TObject);
begin
    ActItem.Execute;
end;

procedure TFrmBase.img_voltarClick(Sender: TObject);
begin
    Close;
end;

end.
