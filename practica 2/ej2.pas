program ej2;
const
    valorAlto = '9999';
type
    producto = record
        codigo: String[4];
        nombre: String;
        precio: real;
        stockA: integer;
        stockM: integer;
    end;

    ventas = record
        codigo: String[4];
        cantV: integer;
    end;

    maestro = file of producto;
    detalle = file of ventas;

    procedure leerMaestro( var auxM: producto);
    begin
      writeln('Ingrese codigo de producto (valorAlto para fin)'); readln(auxM.codigo);
      writeln('Ingrese nombre comercial '); readln(auxM.nombre);
      Writeln('Ingrese precio de venta '); readln(auxM.precio);
      writeln('Ingrese stock actual '); readln(auxM.stockA);
      writeln('Ingrese stock minimo'); readln(auxM.stockM);
    end;

    procedure leerDetalle (var auxD: ventas);
    begin
      writeLn('Ingrese codigo de venta (valorAlto para fin)'); readln(auxD.codigo);
      writeln('Ingrese cantidad de ventas'); readln(auxD.cantV);
    end;

    procedure leer (var det: detalle ; var data: ventas);
    begin
      if (not eof(det)) then
        read(det,data)
      else
        data.codigo:= valorAlto;
    end;

    procedure crearMaestro(var mae: maestro);
    var
      auxM: producto;
    begin
      rewrite(mae);
      leerMaestro(auxM);
      while(auxM.codigo <> valorAlto) do begin
        write(mae,auxM);
        leerMaestro(auxM);
      end;
      close(mae);
    end;

    procedure crearDetalle(var det: detalle);
    var
      auxD: ventas;
    begin
        rewrite(det);
        leerDetalle(auxD);
        while (auxD.codigo <> valorAlto) do begin
            write(det,auxD);
            leerDetalle(auxD);
        end;
        close(det);
    end;

    procedure listarMinimo(var mae : maestro);
    var
    auxM: producto;
    txt: Text;
    begin
      Assign(txt,'stock_minimo.txt');
      rewrite(txt);
      reset(mae);
      while (not eof(mae)) do begin
          read(mae,auxM);
          if (auxM.stockA < auxM.stockM) then
            Write(txt,auxM.codigo,' ', auxM.nombre, ' ', auxM.precio, ' ', auxM.stockA, ' ', auxM.stockM);
      end;
      close(txt);
      close(mae);
    end;
var
mae: maestro;
det: detalle;
auxM: producto;
auxD: ventas;
name: String;
begin
  Assign(mae,'archivoMaestro.dat');
  writeln('Ingrese nombre del detalle'); readln(name);
  Assign(det,name);
  // CREO MAESTRO Y CREO DETALLE
  crearMaestro(mae);
  crearDetalle(det);
  // PROCESO
  reset(mae); reset(det);
  leer(det,auxD);
  while (auxD.codigo <> valorAlto) do begin
    read(mae,auxM);
    // BUSCO EL MATCH DEL CODIGO EN EL MAESTRO
    while (auxM.codigo <> auxD.codigo) do begin
        read(mae,auxM);
    end;
    // SALGO DEL WHILE, ENCONTRE EL CODIGO Y PROCESO TODOS
    while (auxM.codigo = auxD.codigo) do begin
        auxM.stockA:= auxM.stockA - auxD.cantV;
        leer(det,auxD);
    end;
    // VUELVO A UBICARME EN EL MAESTRO EN 1 POSICION ATRAS Y REESCRIBO ACTUALIZADO
    // LEO OTRO ARCHIVO DEL DETALLE
    seek (mae, filepos(mae) - 1);
    write(mae,auxM);

    leer(det,auxD);
  end;
  close(mae);
  close(det);
  // CREO TXT CON LA CONDICION
  listarMinimo(mae);
end.