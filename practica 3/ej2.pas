program ej2;
const
    marca = '@';

var
    nombres: array[1..10] of String;
    apellidos: array[1..10] of String;
    asisNum: integer;  

type
    asistente = record
        numero,dni,telefono: integer;
        nombre,apellido,email: String[30];
    end;

    archAsist = file of asistente;

    procedure leerAsistente(var a: asistente);
    begin
      asisNum := asisNum + 1;
      a.numero:= asisNum;
      a.nombre:= nombres[Random(10) + 1];
      a.apellido := apellidos[Random(10) + 1];
      a.email := a.apellido + '@gmail.com';
      a.dni := Random(2000001) + 43000000;
      a.telefono:= Random(999999) + 1000000;
    end;

    procedure cargarDatosRandom ();
    begin
        asisNum:= 990;
        nombres[1] := 'Agustin'; nombres[2] := 'Giane';
        nombres[3] := 'Pepe'; nombres[4] := 'Santi';
        nombres[5] := 'Panchito'; nombres[6] := 'Juli';
        nombres[7] := 'Laureano'; nombres[8] := 'Valentino';
        nombres[9] := 'Jorge'; nombres[10] := 'Phi';

        apellidos[1] := 'Gonzalez'; apellidos[2] := 'Lopez';
        apellidos[3] := 'Rodriguez'; apellidos[4] := 'Bertone';
        apellidos[5] := 'Messi'; apellidos[6] := 'Gutierrez';
        apellidos[7] := 'Medina'; apellidos[8] := 'Perez';
        apellidos[9] := 'Ronaldo'; apellidos[10] := 'Alvarez';   
    end;

    procedure cargarArchivo ( var arch : archAsist);
    var
    asis: asistente;
    aux: integer;
    begin
      Rewrite(arch);
      // ACTIVO RANDOMIZE PARA GENERAR ASISTENTES RANDOM
      Randomize;
      aux:= 1;
      while (aux <> 0) do begin
        leerAsistente(asis);
        write(arch,asis);
        writeln('Ingrese 0 para terminar carga, 1 para seguir');
        readln(aux);
      end;
      close(arch);
    end;

    procedure eliminar1000(var arch: archAsist);
    var
    asis: asistente;
    begin
      reset(arch);
      while (not eof(arch)) do begin
        read(arch,asis);
        // SI ENCUENTRO UNO CON NRO MENOR A 1000 LE AGREGO MARCA Y LO ESCRIBO DENUEVO
        if (asis.numero < 1000) then begin
          asis.nombre:= marca + asis.nombre;
        end;
        seek(arch,FilePos(arch) - 1);
        write(arch,asis);
      end;

      close(arch);
    end;

    procedure printAsistentes( var arch: archAsist);
    var
    asis: asistente;
    begin
    reset(arch);
    writeln('--- LISTADO DE ASISTENTES ---');
    while not eof(arch) do begin
        read(arch, asis);
        if (Pos(marca, asis.nombre) = 0) then
        begin
        writeln('Numero: ', asis.numero);
        writeln('Nombre: ', asis.nombre);
        writeln('Apellido: ', asis.apellido);
        writeln('Email: ', asis.email);
        writeln('DNI: ', asis.dni);
        writeln('Telefono: ', asis.telefono);
        writeln('------------------------------');
        end;
    end;
    close(arch);
    end;
var
arch: archAsist;
begin
  cargarDatosRandom();
  assign(arch,'archivoAsistentes.txt');
  cargarArchivo(arch);
  eliminar1000(arch);
  printAsistentes(arch);
end.