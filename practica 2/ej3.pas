program ej3;

const
    valorAlto = 'ZZZZZZ';
type
    provicia = record
        nombre: String[20];
        alfabetizados,encuestados: integer;
    end;

    censo = record
        nombre: String[20];
        codigo,alfabetizados,encuestados: integer;
    end;

    maestro = file of provicia;
    detalle = file of censo;

    procedure leer (var det: detalle ; var reg: censo);
    begin
      if (not eof(det)) then
        read(det,reg)
      else 
        reg.nombre:= valorAlto;
    end;

    procedure minimo(var det1,det2: detalle ; var regd1,regd2,min: censo);
    begin
      if (regd1.nombre < regd2.nombre) then begin
        min:= regd1;
        leer(det1,regd1);
      end
      else begin
        min:= regd2;
        leer(det2,regd2);         
      end;
    end;

    procedure actualizar(var mae : maestro; var det1,det2: detalle);
    var
    regm, auxM: provicia;
    regd1,regd2,min: censo;
    begin
        // ABRO Y LEO LOS 3
        reset(mae);
        reset(det1);
        reset(det2);      
        read(mae,regm);
        leer(det1,regd1);
        leer(det2,regd2);
        // DEVUELVE EN MIN EL REGISTRO MAS CHICO DE LOS DETALLE
        minimo(det1,det2,regd1,regd2,min);
        // INICIALIZO CONTADORES DE AUX
        while (min.nombre <> valorAlto) do begin
          auxM.nombre := min.nombre;
          auxM.alfabetizados:= 0;
          auxM.encuestados:= 0;
          // PROCESO TODOS LOS MINIMOS CON EL MISMO NOMBRE
          while (auxM.nombre = min.nombre) do begin
            auxM.alfabetizados:= auxM.alfabetizados + min.alfabetizados;
            auxM.encuestados:= auxM.encuestados + min.encuestados;
            minimo(det1,det2,regd1,regd2,min);
          end;

          // BUSCO EL REGISTRO EN EL MAESTRO PARA ACTUALIZARLO
          while (regM.nombre <> auxM.nombre) do begin
            read(mae,regM);
          end;
          // SI SALGO LO ENCONTRO, ACTUALIZO Y ESCRIBO
          regM.alfabetizados:= auxM.alfabetizados;
          regM.encuestados:= auxM.alfabetizados;
          seek(mae,filepos(mae) - 1);
          write(mae,regm);
          
          minimo(det1,det2,regd1,regd2,min);
        end;
        close(mae);
        close(det1);
        close(det2);
    end;
var
mae: maestro;
det1,det2: detalle; 
begin
  Assign(mae, 'archMaestro.dat');
  Assign(det1,'archDetalle1.dat');
  Assign(det2, 'archDetalle2.dat');
  actualizar(mae,det1,det2);
end.