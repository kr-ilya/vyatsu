unit checking;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unit1;

procedure check(Form1: TForm1);

implementation


function comparator(rec1,rec2:rec):boolean;
begin
  if rec1.size>rec2.size then comparator:=true
  else if rec1.size<rec2.size then comparator:=false
  else if rec1.cost>rec2.cost then comparator:=true
  else if rec1.cost<rec2.cost then comparator:=false
  else comparator:=false;
end;


procedure check(Form1: TForm1);
var
  rec1, rec2: rec;
  i:longint;
begin
     Form1.Statusbar1.SimpleText := 'Выберите проверяемый файл';
     if Form1.OpenDialog2.Execute then
     begin
          Form1.toggleButtons(False);
          AssignFile(pizzaFile, Form1.OpenDialog2.FileName);
          Reset(pizzaFile);
          read(pizzaFile, rec1);
          Form1.Statusbar1.SimpleText := 'Проверка...';
          Form1.Statusbar1.Update;
          for i:=2 to filesize(pizzaFile) do
          begin
            read(pizzaFile, rec2);
            if comparator(rec1,rec2)=true then
            begin
              Form1.Statusbar1.SimpleText := 'Файл не отсортирован';
              Form1.toggleButtons(True);
              CloseFile(pizzaFile);
              exit;
            end
            else rec1:=rec2;
          end;
          Form1.Statusbar1.SimpleText := 'Файл отсортирован';
          Form1.toggleButtons(True);
          CloseFile(pizzaFile);
     end;
end;

end.

