program ej6;

const
    valorAlto = '9999';
    cantArchivos = 10;
type
    dataMaestro = record
        localidad,cepa: string[4];
        nombre: string[10];
        casosActivos,casosNuevos,recuperados,fallecidos: integer;
    end;

    municipio = record
        localidad,cepa: string[4];
        nomLocalidad,nomcEPA: string[20];
        casosActivos,casosNuevos,recuperados,fallecidos: integer;
    end;

    maestro = file of dataMaestro;
    detalle = file of municipio;

    // ARC DETALLE = NOMBRES, ARC DATA = REGISTRO DEL ARCHIVO 
    arc_detalle = array [1..cantArchivos] of detalle;
    arc_data = array [1..cantArchivos] of municipio;

    procedure leer (var det: detalle ; var reg: municipio);
    begin
        if (not eof(det)) then
          read(det,reg)
        else 
          reg.localidad:= valorAlto;
    end;

    // LEE DEL ARRAY DE LOS REGISTROS DE DETALLES Y DEVUELVE EL REGISTRO MAS CHICO
    procedure minimo(var detalles: arc_detalle ; var data: arc_data ; var min: municipio);
    var
    i,pos: integer;
    begin
      pos:= 1;
      for i:= 1 to cantArchivos do begin
        // CHECKEO SI EN i HAY LOCALIDAD Y CEPA CON MENOR CODIGO QUE EN POS
        if (data[i].localidad < data[pos].localidad) or ((data[i].localidad = data[pos].localidad) and (data[i].cepa < data[pos].cepa)) then
          pos:= i;
        end;

        // ACTUALIZO EL MINIMO Y LEO OTRO
        min:= data[pos];
        leer(detalles[i],data[i]);
    end;

    procedure actMaestro (var mae: maestro ; var detalles : arc_detalle);
    var
    i: integer;
    regm: dataMaestro;
    regD,min: municipio;
    data: arc_data;
    begin
        // ABRO MAESTRO Y ABRO TODOS LOS DETALLES DEL ARRAY
        Reset(mae);
        for i:= 1 to cantArchivos do begin
          reset(detalles[i]);
          // LEO DETALLE CON SU PARALELO QUE TIENE SU REGISTRO
          // LOS DATOS ESTAN 1 - 1
          leer(detalles[i], data[i]);
        end;
        read(mae,regm);
        minimo(detalles,data,min);
        while(min.localidad <> valorAlto) do begin
          regD.localidad:= min.localidad;
          regD.cepa:= min.cepa;
          // PROCESO TODOS LOS QUE TIENEN MISMA LOCALIDAD Y CEPA
          while (regD.localidad = min.localidad) and (regD.cepa = min.cepa) do begin
            regD.fallecidos:= regD.fallecidos + min.fallecidos;
            regD.recuperados:= regD.recuperados + min.recuperados;
            regD.casosActivos:= regD.casosActivos + min.casosActivos;
            regD.casosNuevos:= regD.casosNuevos + min.casosNuevos;

            minimo(detalles,data,min);
          end;
          // SI SALGO TERMINE DE PROCESAR, BUSCO EN EL MAESTRO Y LO ACTUALIZO
          while (regm.localidad <> regD.localidad) and (regm.cepa <> regD.cepa) do begin
            read(mae,regm);
          end;
          regm.fallecidos:= regM.fallecidos + regD.fallecidos;
          regm.recuperados:= regm.recuperados + regD.recuperados;
          regm.casosActivos:= regD.casosActivos;
          regm.casosNuevos:= regm.casosNuevos;
          seek(mae,filepos(mae)-1);
          write(mae,regm);
        end;
        close(mae);
        for i:= 1 to cantArchivos do begin
          close(detalles[i]);
        end;   
    end;
var
mae: maestro;
detalles: arc_detalle;
i: integer;
s: string;
begin
  Assign(mae, 'maestroMunicipios.dat');
  // ME CREO EL ARRAY DE DETALLES CON LOS NOMBRES DE LOS ARCHIVOS
  for i:= 1 to cantArchivos do
  // EL STR TE GUARDA EL ENTERO EN de i en s PARA CONCATENAR, SINO TIRA ERROR (EN LA DIAPOSITIVA ESTA MENCIONADO PERO NO EXPLICADO)
    Str(i,s);
    Assign(detalles[i], 'detalle' + s + '.dat');
  actMaestro(mae,detalles);
end.