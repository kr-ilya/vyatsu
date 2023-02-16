unit fullness;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, defSets, math;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    SpinEdit7: TSpinEdit;
    SpinEdit8: TSpinEdit;
    SpinEdit9: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure setCounts();
    procedure SpinEdit1KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit2KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit3KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit4KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit5KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit6KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit7KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit8KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit9KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  Form3: TForm3;

implementation
uses Unit1;
{$R *.lfm}

{ TForm3 }

// Отмена
procedure TForm3.Button1Click(Sender: TObject);
begin
  self.Hide();
end;
// Применить
procedure TForm3.Button2Click(Sender: TObject);
begin
  setCounts;

  Form1.ReDraw;
end;

// Ок
procedure TForm3.Button3Click(Sender: TObject);
begin
  setCounts;

  Form1.ReDraw;
  self.Hide();
end;

// Случайно
procedure TForm3.Button4Click(Sender: TObject);
begin
     SpinEdit1.Value := RandomRange(0, 5);
     SpinEdit2.Value := RandomRange(0, 5);
     SpinEdit3.Value := RandomRange(0, 5);
     SpinEdit4.Value := RandomRange(0, 5);
     SpinEdit5.Value := RandomRange(0, 5);
     SpinEdit6.Value := RandomRange(0, 5);
     SpinEdit7.Value := RandomRange(0, 5);
     SpinEdit8.Value := RandomRange(0, 5);
     SpinEdit9.Value := RandomRange(0, 5);
end;

procedure TForm3.FormHide(Sender: TObject);
begin
  Form1.Enabled := True;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
     SpinEdit1.Value := itemsCounts[0];
     SpinEdit2.Value := itemsCounts[1];
     SpinEdit3.Value := itemsCounts[2];
     SpinEdit4.Value := itemsCounts[3];
     SpinEdit5.Value := itemsCounts[4];
     SpinEdit6.Value := itemsCounts[5];
     SpinEdit7.Value := itemsCounts[6];
     SpinEdit8.Value := itemsCounts[7];
     SpinEdit9.Value := itemsCounts[8];

     Form1.Enabled := False;

end;

procedure TForm3.setCounts();
begin
  boxsList[0].itemsCount := SpinEdit1.Value;
  boxsList[1].itemsCount := SpinEdit2.Value;
  boxsList[2].itemsCount := SpinEdit3.Value;
  boxsList[3].itemsCount := SpinEdit4.Value;
  boxsList[4].itemsCount := SpinEdit5.Value;
  boxsList[5].itemsCount := SpinEdit6.Value;
  boxsList[6].itemsCount := SpinEdit7.Value;
  boxsList[7].itemsCount := SpinEdit8.Value;
  boxsList[8].itemsCount := SpinEdit9.Value;

  itemsCounts[0] := SpinEdit1.Value;
  itemsCounts[1] := SpinEdit2.Value;
  itemsCounts[2] := SpinEdit3.Value;
  itemsCounts[3] := SpinEdit4.Value;
  itemsCounts[4] := SpinEdit5.Value;
  itemsCounts[5] := SpinEdit6.Value;
  itemsCounts[6] := SpinEdit7.Value;
  itemsCounts[7] := SpinEdit8.Value;
  itemsCounts[8] := SpinEdit9.Value;

   Form1.set_custom_settings;
end;

procedure TForm3.SpinEdit1KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;

procedure TForm3.SpinEdit2Change(Sender: TObject);
begin

end;

procedure TForm3.SpinEdit2KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;

procedure TForm3.SpinEdit3KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;

procedure TForm3.SpinEdit4KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;

procedure TForm3.SpinEdit5KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;

procedure TForm3.SpinEdit6KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;

procedure TForm3.SpinEdit7KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;


procedure TForm3.SpinEdit8KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;

procedure TForm3.SpinEdit9KeyPress(Sender: TObject; var Key: char);
begin
  key := #0;
end;


procedure TForm3.SpinEdit9MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;


end.

