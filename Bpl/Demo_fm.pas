unit Demo_fm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SideBar, ComCtrls, StdCtrls, MkRangeSlider;

type
  TfmDemo = class(TForm)
    SideBar1: TSideBar;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    HorizRS: TmkRangeSlider;
    RadioGroup2: TRadioGroup;
    Panel2: TPanel;
    ComboBox1: TComboBox;
    procedure RadioGroup2Click(Sender: TObject);
    procedure HorizRSGetRullerLength(Sender: TObject; var Value: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDemo: TfmDemo;


const
  ColorDlClick = $00A66EA;
  ColorClick = $0080FFFF;
  ColorIdle = clGray;

implementation



{$R *.dfm}

procedure TfmDemo.RadioGroup2Click(Sender: TObject);
begin
  case RadioGroup2.ItemIndex of
    0 : begin   //forward
      HorizRS.ColorLow := ColorIdle;
      HorizRS.ColorMid := ColorClick;
      HorizRS.ColorHi  := ColorDlClick;
    end;

    1 : begin   //central
      HorizRS.ColorLow := ColorClick;       
      HorizRS.ColorMid := ColorIdle;
      HorizRS.ColorHi  := ColorDlClick;
    end;

  {  2 : begin   //backward
      HorizRS.ColorLow := ColorDlClick;
      HorizRS.ColorMid := ColorClick;
      HorizRS.ColorHi  := ColorIdle;
    end; }
  end;
  HorizRS.Invalidate;
end;

procedure TfmDemo.HorizRSGetRullerLength(Sender: TObject;
  var Value: Integer);
begin
   Value := 300;
end;

end.
