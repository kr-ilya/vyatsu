unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, EditBtn, DBCtrls, Grids, Buttons, ExtCtrls, RTTIGrids;

type
  rec = record
      id: longint;
      tittle: string[100];
      description: string[255];
      size: integer;
      cost: integer;
      feedback: 1..5;
  end;

  ft = file of rec;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    UpDown1: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure toggleButtons(val: boolean);
    procedure ClearTable;
  private

  public

  end;

var
  Form1: TForm1;
  page: longint = 1;
  perPage: longint = 11;
  maxpage: longint;
  sortfile: string;
  pizzaFile: ft;
  pizza: rec;

implementation
uses sorting, generator, checking;
{$R *.lfm}

{ TForm1 }

// Сгенерировать
procedure TForm1.Button1Click(Sender: TObject);
begin
     generate(Form1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    sort(Form1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     check(Form1);
end;



procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var
  n: longint;
  fs: longint;
begin
    if opened then
    begin
      AssignFile(pizzaFile, sortfile);
      reset(pizzaFile);

      fs := FileSize(pizzaFile);

      maxpage := fs div perPage;
      if fs mod perPage <> 0 then inc(maxpage);

       case Button of
        btNext:
          begin
               if page + 1 <= maxpage then
                  inc(page)
               else
               begin
                 CloseFile(pizzaFile);
                 exit;
               end;
          end;
        btPrev:
          begin
               if page - 1 >= 1 then
                  dec(page)
               else
               begin
                 CloseFile(pizzaFile);
                 exit;
               end;
          end;
       end;

       Form1.StaticText2.Caption := inttostr(page) + '/' + inttostr(maxpage);
       seek(pizzaFile, (page-1)*perPage);

       Form1.ClearTable;
       n := 0;
       while (n < perPage) and ((page-1)*perPage+n < fs) do
       begin
           read(pizzaFile,pizza);
           Form1.StringGrid1.Cells[0, n+1] :=  inttostr(pizza.id);
           Form1.StringGrid1.Cells[1, n+1] :=  pizza.tittle;
           Form1.StringGrid1.Cells[2, n+1] :=  pizza.description;
           Form1.StringGrid1.Cells[3, n+1] :=  inttostr(pizza.size);
           Form1.StringGrid1.Cells[4, n+1] :=  inttostr(pizza.cost);
           Form1.StringGrid1.Cells[5, n+1] :=  inttostr(pizza.feedback);
           Form1.StringGrid1.update;
           inc(n);
       end;

      CloseFile(pizzaFile);
    end;
end;


procedure TForm1.toggleButtons(val: boolean);
begin
    Form1.Button1.Enabled := val;
    Form1.Button2.Enabled := val;
    Form1.Button3.Enabled := val;
    Form1.UpDown1.Enabled := val;
    Form1.Button1.Update();
    Form1.Button2.Update();
    Form1.Button3.Update();
    Form1.UpDown1.Update();
end;

procedure TForm1.ClearTable;
var i: integer;
begin
with StringGrid1 do
  for i:=1 to RowCount-1 do
    Rows[i].Clear;
end;


end.

