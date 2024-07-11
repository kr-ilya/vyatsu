unit generator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Unit1, Math;

type
  pt = array[0..200] of string[100];

var
   ptittle: TextFile;
   ptittles: pt;
   gd: longint;
   lp, pp: integer;
   opened: boolean = False;

   //Генерация данных
procedure generate(Form1: TForm1);

implementation

var
   lorem: string = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Etiam dignissim diam quis enim lobortis scelerisque fermentum dui faucibus. Dapibus ultrices in iaculis nunc sed augue lacus';
   i, id, n, fs: longint;

procedure generate(Form1:TForm1);
begin
    if Form1.SaveDialog1.Execute() then
    begin
      Assignfile(pizzaFile, Form1.SaveDialog1.FileName);
      AssignFile(ptittle, 'ptittle.txt');
      rewrite(pizzaFile);
      opened := True;
      try
      reset(ptittle);
      except
         on eInOutError do
         begin
              ShowMessage('Файл ptittle.txt не найден!');
              CloseFile(pizzaFile);
              exit;
         end
         else
         begin
            ShowMessage('Не удалось открыть файл ptittle.txt');
            CloseFile(pizzaFile);
            exit;
         end;
      end;

      i := 0;
      while not eof(ptittle) do
      begin
         readln(ptittle, ptittles[i]);
         inc(i);
      end;
      CloseFile(ptittle);
      randomize;
      id := 0;

      gd := 3500000;
      n := 0;
      Form1.toggleButtons(False);
      Form1.ClearTable;
      Form1.Statusbar1.SimpleText := 'Идет генерация данных - 0%';
      while FileSize(pizzaFile) < gd do
      begin
           pizza.id := id;
           pizza.tittle := ptittles[randomrange(0, i)];
           pizza.description := lorem;
           pizza.size := randomrange(20, 150);
           pizza.cost := randomrange(50, 100000);
           pizza.feedback := randomrange(1, 5);
           inc(id);
           write(pizzaFile,pizza);


           fs := FileSize(pizzaFile);

           if (n < perPage) and (n < fs)  then
           begin
                Form1.StringGrid1.Cells[0, n+1] :=  inttostr(pizza.id);
                Form1.StringGrid1.Cells[1, n+1] :=  pizza.tittle;
                Form1.StringGrid1.Cells[2, n+1] :=  pizza.description;
                Form1.StringGrid1.Cells[3, n+1] :=  inttostr(pizza.size);
                Form1.StringGrid1.Cells[4, n+1] :=  inttostr(pizza.cost);
                Form1.StringGrid1.Cells[5, n+1] :=  inttostr(pizza.feedback);
                Form1.StringGrid1.update;
                inc(n);
           end;

           pp := round((FileSize(pizzaFile)/gd)*100);
           Form1.Statusbar1.SimpleText := 'Идет генерация данных - ' + inttostr(pp) + '%';
           if (pp mod 5 = 0) AND (lp <> pp) then
           begin
                Form1.Statusbar1.Update;
                lp := pp;
           end;
      end;
      sortfile := Form1.SaveDialog1.FileName;
      CloseFile(pizzaFile);

      maxpage := fs div perPage;
      if fs mod perPage <> 0 then inc(maxpage);

      Form1.toggleButtons(True);
      page := 1;
      Form1.StaticText2.Caption := '1/' + inttostr(maxpage);
      Form1.Statusbar1.SimpleText := 'Генерация данных завершена';
    end;
end;

end.

