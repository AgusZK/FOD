program ej5;

const
    valorAlto= 'ZZZZZ';

type
    servidor = record
        cod_usaurio: string[5];
        fecha: string;
        tiempo_total_de_sesiones_abiertas: integer;
    end;

    logs = record
        cod_usaurio: string[5];
        fecha: string;
        tiempo_sesion: integer;
    end;

    maestro = file of servidor;
    detalle = file of logs;

    procedure leer (var det: detalle ; var reg: logs);
    begin
        if (not eof(det)) then
          read(det,reg)
        else
          reg.cod_usaurio:= valorAlto
    end;

    procedure minimo (var det1,det2,det3,det4,det5: detalle ; var r1,r2,r3,r4,r5,min: logs);
    begin
      if (r1.cod_usaurio < r2.cod_usaurio) and (r1.cod_usaurio < r3.cod_usaurio) and (r1.cod_usaurio < r4.cod_usaurio) and (r1.cod_usaurio <r5.cod_usaurio) then begin
        min:= r1;
        leer(det1,r1);
      end
      else if (r2.cod_usaurio <r3.cod_usaurio) and (r2.cod_usaurio< r4.cod_usaurio) and (r2.cod_usaurio< r5.cod_usaurio) then begin
        min:= r2;
        leer (det2,r2);
      end
      else if (r3.cod_usaurio < r4.cod_usaurio) and (r3.cod_usaurio < r5.cod_usaurio) then begin
        min:= r3;
        leer(det3,r3);
      end
      else if (r4.cod_usaurio < r5.cod_usaurio) then begin
        min:= r4;
        leer(det4,r4);
      end
      else
        min:= r5;
        leer (det5,r5);
    end;

    procedure mergeTodo (var mae: maestro ; var det1,det2,det3,det4,det5: detalle);
    var
    regm,auxM: servidor;
    reg1,reg2,reg3,reg4,reg5,min: logs;
    begin
      reset(mae);
      reset(det1); reset(det2); reset(det3); reset(det4); reset(det5);
      minimo(det1,det2,det3,det4,det5,reg1,reg2,reg3,reg4,reg5,min);
      while (min.cod_usaurio <> valorAlto) do begin 
        auxM.fecha := min.fecha;
        auxM.cod_usaurio:= min.cod_usaurio;
        auxM.tiempo_total_de_sesiones_abiertas:= 0;
        // ACTUALIZO TOTAL DE SESIONES DEL MISMO USUARIO
        while (auxM.cod_usaurio = min.cod_usaurio) do begin
          auxM.tiempo_total_de_sesiones_abiertas:= auxM.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
          minimo(det1,det2,det3,det4,det5,reg1,reg2,reg3,reg4,reg5,min);
        end;
        // BUSCO EN EL MAESTRO Y LA ESCRIBO
        while (regm.cod_usaurio <> auxM.cod_usaurio) do begin
            read(mae,regm);
        end;
        regm.cod_usaurio:= auxM.cod_usaurio;
        regm.fecha:= auxM.fecha;
        regm.tiempo_total_de_sesiones_abiertas:= auxM.tiempo_total_de_sesiones_abiertas;
        seek(mae,filepos(mae) - 1);
        write(mae,regm);
        // BUSCO OTRO MINIMO HASTA QUE TERMINE
        minimo(det1,det2,det3,det4,det5,reg1,reg2,reg3,reg4,reg5,min);
      end;
      close(mae);
      close(det1); close(det2); close(det3); close(det4); close(det5);
    end;
var
  mae: maestro;
  det1,det2,det3,det4,det5: detalle;
begin
  assign(mae, 'var/log/servidor.dat');
  Assign(det1, 'pc1.dat'); Assign(det2, 'pc2.dat'); Assign(det3, 'pc3.dat') ; Assign(det4, 'pc4.dat') ; Assign(det5, 'pc5.dat');
  mergeTodo(mae,det1,det2,det3,det4,det5);
end.