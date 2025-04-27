program ej4;
type
    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;

    tArchFlores = file of reg_flor;

    procedure agregarFlor (var arch: tArchFlores ; nombre: string; codigo:integer);
    var
    f,cabecera: reg_flor;
    begin
      reset(arch);
      read(arch,cabecera);
      f.nombre:= nombre;
      f.codigo:= codigo;
      // ME FIJO SI NO HAY 0 EN LA CABECERA, SINO LO AGERGO AL FINAL
      if (cabecera.codigo <> 0) then begin
        // VOY AL REGISTRO, MULTIPLICANDO POR -1 Y RESTANDO 1, ME LEO LO QUE VA A IR EN CABCERA
        seek(arch, (cabecera.codigo * -1) - 1);
        read(arch,cabecera);
        // VUELVO UNO PARA ATRAS Y ESCRIBO LA NUEVA FLOR
        seek(arch, FilePos(arch) - 1);
        write(arch,f); 
        // VUELVO AL PRINCIPIO Y ESCRIBO EL CABECERA QUE LEI
        seek(arch,0);
        write(arch,cabecera);
      end
      else
        seek(arch,FileSize(arch));
        Write(arch,f);

      Close(arch);
    end;

    procedure listarArchivo(var arch: tArchFlores);
    var
    f: reg_flor;
    begin
    Reset(arch);
    while (not eof(arch)) do begin
        Read(arch, f);
        // SALTEO LAS ELIMINADAS (CODIGO NEGATIVO)
        if (f.codigo > 0) then
            WriteLn('codigo: ', f.codigo, ' nombre: ', f.nombre);
        end;

    Close(arch);
    end;

    // ADICIONAL DEL EJERCICIO 5

    procedure eliminarFlor (var arch: tArchFlores; flor:reg_flor);
    var
    f, cabecera: reg_flor;
    found: boolean;
    begin
        Reset(arch);
        found := false;
        read(arch, cabecera);
        while (not eof(arch)) and (not found) do
        begin
            read(arch, f);
            if (f.codigo = flor.codigo) then
            found := true;
        end;

        if (found) then
        begin
            seek(arch, FilePos(arch) - 1);
            write(arch, cabecera);
            cabecera.codigo := FilePos(arch) * -1;
            seek(arch, 0);
            write(arch, cabecera);
        end
        else
            writeln('Flor no encontrada');

        Close(arch);
    end;


    procedure crearArchivo(var arch: tArchFlores);
    var
        cabecera: reg_flor;
        begin
        assign(arch, 'flores.dat');
        rewrite(arch);
        cabecera.codigo := 0;
        cabecera.nombre := '';
        write(arch, cabecera);
        close(arch);
    end;
    
var
arch: tArchFlores;
flor: reg_flor;
begin
  assign(arch, 'flores.dat');
  crearArchivo(arch);

  agregarFlor(arch, 'Rosa', 1);
  agregarFlor(arch, 'Tulipan', 2);
  agregarFlor(arch, 'Girasol', 3);
  writeln('Listado de agregadas');
  listarArchivo(arch);

  flor.codigo := 2;
  eliminarFlor(arch, flor);
  writeln;  
  writeln('Listado con eliminado');
  listarArchivo(arch);
end.