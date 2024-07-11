program kover;
uses graph, wincrt, carpet;
var
key: char;

begin
init();
repeat
 key := readkey;
 case key of
 #43: zoomin; // +
 #45: zoomout; // -
 #49: stepup; // 1
 #48: stepdown; // 0
 #0: begin
 key := readkey;
    case key of
     #75: left; //left
     #77: right; //right
     #80: down; //down
     #72: up; //up
  end;
  end;
  end;
until key = #27;
closegraph;
end.