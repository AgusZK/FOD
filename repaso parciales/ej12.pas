program ej12;
// BAJA FISICA Y LOGICA
const
    valorAlto = '9999';
type
    tienda = record
        cod_prend,descripcion,colores,tipo_prenda: String[20];
        stock,precio_unitario: integer;
    end;

    prenda = record
        cod_prenda: String[20];
    end;

    maestro = file of tienda;
    detalle = file of prenda;

procedure leer (var arch: detalle ; var p: prenda);
begin
    if(not eof(arch)) then 
        read(arch,p)
    else 
        p.cod_prenda:= valorAlto;
end;

procedure bajaMaestro(var mae: maestro; var det: detalle);
var
    regM,aux: tienda;
    regD,p: prenda;
    find: boolean;
    pos: integer;
begin
    // ABRO AMBOS ARCHIVOS
    Reset(mae);
    Reset(det);
    find: false;
    // LEO DEL MAESTRO EL REGISTRO, Y LEO DEL DETALLE UNA PRENDA
    read(mae,regM);
    leer(det,p);
    while (p.cod_prenda <> valorAlto) do begin
      regD.cod_prenda := p.cod_prenda;
      while (regM.cod_prend <> p.cod_prenda) and (not find) do begin
        read(mae,regM);
        if (regM.cod_prend = p.cod_prenda) then begin
          find:= true;
          pos:= FilePos(mae) - 1;
        end;
      end;
      if(find) then begin
        // LEO EL ARCHIVO, MODIFICO EL STOCK
        read(mae,regM);
        regM.stock:= -1;
        // VOY AL FINAL , ME GUARDO EL ULTIMO
        seek(mae,FileSize(mae) - 1);
        read(mae,aux);
        // ESCRIBO EL REG CON LA BAJA LOGICA HECHA
        write(mae,regM);
        // VUELVO A LA POS, ESCRIBO EL ULTIMO AHI Y TRUNCO EL ARCHIVO
        seek(mae,pos);
        write(mae,aux);
        Truncate(mae);
      end
      else begin
        writeln('LA PRENDA NO ESTA EN EL MAESTRO');
      // LEO EL SIGUIENTE DEL DETALLE  
      leer(det,p);
      end;
    close(mae);
    close(det);
    end;
end;

var
    mae: maestro;
    det: detalle;
begin
  Assign(mae, 'maestro.dat');
  Assign(det,'detalle.dat');
  bajaMaestro(mae,det);
end.