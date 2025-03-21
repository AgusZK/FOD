program Ej1;

type
enteros = file of integer;

var
ent: enteros;
name: string;
num: integer;
begin
    writeln('ingrese nombre del archivo');
    readln(name);
    assign(ent,name);
    rewrite(ent);
    writeln('ingrese numero');
    readln(num);
    while (num <> 3000) do begin
        write(ent,num);
        writeln('ingrese numero');
		readln(num);
    end;
end.