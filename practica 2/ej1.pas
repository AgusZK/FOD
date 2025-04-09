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
var
mer,det: detalle;
name: String;
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
end.