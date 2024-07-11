library Project1;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  ComCtrls,
  Forms;  

{$R *.RES}

const
  C_FNAME = 'result.txt';
  F_FNAME = 'facts.txt';

var
  tfOut: TextFile;
  ffOut: TextFile;

procedure function1(obj: Pointer; obj2: Pointer); cdecl;
var view: TListView;
    items: TListItems;
    count: Integer;
    item: TListItem;
    i: Integer;
    s: Pchar;
begin
    AssignFile(tfOut, C_FNAME);
    rewrite(tfOut);
    AssignFile(ffOut, F_FNAME);
    rewrite(ffOut);

    view := TListView(obj);
    items := view.Items;
    count := items.Count;


    for i := 0 to count-1 do
    begin
        item := items[i];
        s := item.SubItems.GetText();
        write(tfOut, s);
        if i <> count-1 then
        begin
                writeln(tfOut, '=');
        end;
    end;

    view := TListView(obj2);
    items := view.Items;
    count := items.Count;
    for i := 0 to count-1 do
    begin
        item := items[i];
        s := item.SubItems.GetText();
        write(ffOut, s);
        if i <> count-1 then
        begin
                writeln(ffOut, '=');
        end;
    end;


    CloseFile(tfOut);
    CloseFile(ffOut);
end;


exports
    function1;
end.


