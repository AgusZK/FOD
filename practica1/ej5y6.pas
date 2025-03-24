program ej5y6;
type
celular = record
    codigo: integer;
    nombre: string;
    descripcion: string;
    marca: string;
    precio: real;
    stockMin: integer;
    stockDis: integer;
end;

celulares = file of celular;

procedure printCelular( cel: celular);
begin
  writeln('Codigo: ' , cel.codigo);
  writeln('Nombre: ' , cel.nombre);
  writeln('Descripcion: ', cel.descripcion);
  writeln('Marca: ', cel.marca);
  writeln('Precio: ', cel.precio);
  writeln('Stock Minimo: ', cel.stockMin);
  writeln('Stock Disponible: ', cel.stockDis);
end;

procedure leerCelular ( var c: celular);
begin
  writeln('Ingrese codigo de celular, -1 para terminar');
  readln(c.codigo);
  if (c.codigo <> -1) then begin
    writeln('Ingrese nombre '); readln(c.nombre);
    writeln('Ingrese descripcion '); readln(c.descripcion);
    writeln('Ingrese marca '); readln(c.marca);
    writeln('Ingrese precio '); readln(c.precio);
    writeln('Ingrese stock minimo '); readln(c.stockMin);
    writeln('Ingrese stock disponibl '); readln(c.stockDis);
  end;
end;

procedure crearArchivo( var cel: celulares);
var
c: celular;
txt: Text;
begin
  assign(txt, 'celulares.txt');
  reset(txt);
  rewrite(cel);

  // CODIGO PRECIO MARCA
  // STOCK DIS, STOCK MIN, DESCR
  // NOMBRE
  while (not eof(cel)) do begin
    readln(txt, c.codigo, c.precio, c.marca);
    readln(txt, c.stockDis, c.stockMin, c.descripcion);
    readln(txt,c.nombre);

    write(cel,c);
  end;
  close(txt);
  close(cel);
end;

procedure printStockMenorQueMin (var cel: celulares);
var
c: celular;
begin
  reset(cel);
  while (not eof(cel)) do begin
    read(cel,c);
    if (c.stockDis < c.stockMin) then
      printCelular(c);
  end;
end;

procedure printDescripcion ( var cel: celulares);
var
c: celular;
tag: string;
begin
  writeln('Ingrese descripcion a buscar '); readln(tag);
  while (not eof(cel)) do begin
    read(cel,c);
    if (c.descripcion = tag) then
      printCelular(c)
    else
        writeln('Celular no encontrado');
  end;
end;

procedure exportarArchivo( var cel: celulares);
var
c: celular;
txt: Text;
begin
    assign(txt, 'celulares.txt');
    rewrite(txt);
    reset(cel);
    while (not eof(cel)) do begin
        read(cel,c);
        writeln(txt , c.codigo , c.precio , c.marca);
        writeln(txt, c.stockDis , c.stockMin, c.descripcion);
        writeln(txt, c.nombre);
    end;
    close(txt);
    close(cel);
end;

procedure agregarCelulares ( var cel: celulares);
var
c: celular;
begin
  reset(cel);
  leerCelular(c);
  seek(cel,FilePos(cel));
  while (c.codigo <> -1) do begin
    write(cel,c);
    leerCelular(c);
  end;
end;

procedure modificarStock ( var cel: celulares);
var
c: celular;
name: string;
find: boolean;
begin
  writeln('Ingrese nombre de celular a modificar STOCK'); readln(name);
  find:= false;
  while (not eof (cel)) do begin
    read(cel,c);
    if (c.nombre = name) then
        find:= true
  end;
  if (find) then begin
    writeln('Ingrese el STOCK modificado'); readln(c.stockDis);
    write(cel,c);
  end
  else
    writeln('El celular ingresado no se encuentra en el archivo: ');
end;

procedure exportarSinStock ( var cel: celulares);
var
c: celular;
txt: Text;
begin
  assign(txt, 'SinStock.txt');
  rewrite(txt);
  reset(cel);
  while (not eof(cel)) do begin
    read(cel,c);
    if (c.stockDis = 0) then begin
        writeln(txt , c.codigo , c.precio , c.marca);
        writeln(txt, c.stockDis , c.stockMin, c.descripcion);
        writeln(txt, c.nombre);
    end;
  end;
  close(txt);
  close(cel);
end;

var
cel: celulares;
option: byte;
name: string;
begin
    repeat
        writeLn('0) Fin del programa');
        writeLn('1) Crear archivo de celulares ');
        writeLn('2) Imprimir celulares con stock menor al stock minimo ');
        writeLn('3) Imprimir celulares con descripcion ingresada ');
        writeLn('4) Exportar informacion a archivo de texto ');
        writeLn('5) Agregar un celular al archivo ');
        writeLn('6) Modificar stock de un celular dado ');
        writeLn('7) Exportar celulares sin stock ');                  
        writeln;
        writeln('Ingrese el numero de operacion a ejecutar');
        readln(option);

        if (option <> 0) then begin
        writeln('Ingrese nombre de archivo');
        readln(name);
        assign(cel,name);
        end;

        case option of
            // EJ 5
            1: crearArchivo(cel);
            2: printStockMenorQueMin(cel);
            3: printDescripcion(cel);
            4: exportarArchivo(cel);
            // EJ 6
            5: agregarCelulares(cel);
            6: modificarStock(cel);
            7: exportarSinStock(cel);
        end;
    until (option = 0);
end.