program Ej1;

type
enteros = file of integer;

procedure printEnteros(var arc: enteros);
var
num,cant: integer;
prom: real;
begin
  reset(arc);
  cant:= 0;
  prom:= 0;
  while (not eof(arc)) do begin
    read(arc,num);
    if (num < 1500) then begin
      cant:= cant + 1;
      prom:= prom + num;
    end;
  end;
    writeln('cantidad menor a 1500: ', cant);
    writeln('promedio: ', prom/cant:0:3);
end;

var
ent: enteros;
name: string;
num: integer;

begin
    writeln('ingrese nombre del archivo');
    readln(name);
    assign(ent,name);
    rewrite(ent);
    writeln('ingrese num');
    readln(num);
    while (num <> 30000) do begin
        write(ent,num);
        writeln('ingrese numero');
		    readln(num);
    end;
    close(ent);

    printEnteros(ent);
end.