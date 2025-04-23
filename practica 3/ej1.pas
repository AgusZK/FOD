program ej1;

const valorAlto = '9999';
type
    empleado = record
        codigo: String[4];
        nombre: String;
        monto: real;
    end;

    detalle = file of empleado;
 
    procedure leer (var det: detalle ; var data: empleado);
    begin
      if (not eof(det)) then
        read(det,data)
      else
        data.codigo := valorAlto;
    end;

    procedure bajaEmpleado(var mer: detalle ; code: string);
    var
    emp,ult: empleado;
    posUlt, posBorrar: integer;
    find: boolean;
    begin
        reset(mer);
        find := false;
        posBorrar:= -1;
        // ME GUARDO AL POSICION DEL ULTIMO
        posUlt:= fileSize(mer) - 1;
        // BUSCO EL ARCHIVO A BORRAR
        while (not eof(mer)) and (not find) do begin
          read(mer,emp);
          if (emp.codigo = code) then begin
            posBorrar:= filePos(mer) - 1;
            find := true;
          end;
        end;
        if (find) then begin
          // SI SALGO LO ENCONTRE, LEO EL REGISTRO DE LA ULITMA POS (ULT) 
          seek(mer,posUlt);
          read(mer,ult);
          // LO ESCRIBO EN LA POSICION DONDE ENCONTRO EL ARCHIVO A BORRAR
          seek(mer,posBorrar);
          write(mer, ult);
          // VUELVO AL FINAL Y TRUNCO
          seek(mer,posUlt);
          Truncate(mer);
        end
        else
            writeln('El codigo ingresado no fue encontrado');

        close(mer);    
    end;
var
mer,det: detalle;
code: String;
data,aux: empleado;    
begin

  Assign(mer,'archivoFinal.dat');
  Assign(det,'archivoDetalle.dat');
  // CREO MERGE Y ABRO EL DETALLE
  rewrite(mer);
  reset(det);
  leer(det,data);
  while (data.codigo <> valorAlto) do begin
    // ME COPIO EL EMPLEADO, INICIALIZO EN 0 EL MONTO TOTAL
    aux:= data;
    aux.monto:= 0;
    while (aux.codigo = data.codigo) do begin
        aux.monto := aux.monto + data.monto;
        leer(det,data);
    end;
    // CUANDO TERMINO DE PROCESAR LOS DEL MISMO CODIGO LO ESCRIBO
    write(mer,aux);
  end;
  Close(det);
  Close(mer);

  // EJERCICIO 1 PRACTICA 3, LO ANTERIOR ES COPYPASTE DE P2EJ1
  writeln('INGRESE COD DE EMPLEADO PARA BORRARLO DEL ARCHIVO ');
  readln(code);
  bajaEmpleado(mer, code);
end.