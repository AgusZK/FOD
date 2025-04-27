program ej8;
type
    distribucion = record
        nombre,descripcion: String[20];
        anio,kernel,desarrolladores: Integer;
    end;

    archDistribuciones = file of distribucion;

    function buscarDistribucion (var arch: archDistribuciones ; distName: String):integer;
    var
    dist: distribucion;
    found: boolean;
    begin
      Reset(arch);
      found:= false;
      while (not eof(arch)) and (not found) do begin
        read(arch,dist);
        if (dist.nombre = distName) then
          found:= true;
      end;
      // SI ENCUENTRO DEVUELVO LA POS, SI NO ENCUENTRO DEVUELVO -1
      if (found) then 
        buscarDistribucion := FilePos(arch) -1
      else
        buscarDistribucion := -1;

      Close(arch);
    end;

    procedure altaDistribucion( var arch: archDistribuciones ; regDist : distribucion);
    var
    cabecera: distribucion;
    begin
      reset(arch);
      read(arch,cabecera);
      if (buscarDistribucion(arch,regDist.nombre) <> -1) then begin
        writeln('Ya existe la distribucion');
        close(arch);
        exit;
      end;
      // SI NO HAY NEGATIVO, LO PONGO AL FINAL
      if (cabecera.desarrolladores >= 0) then begin
        seek(arch,FileSize(arch));
        write(arch,regDist);
      end
      // SI ES NEGATIVO HAY ESPACIO, ME COPIO EL CABECERA Y PONGO EN ESA POS EL REGISTRO DEL PARAMETRO
      // MODIFICO CABECERA AL FINAL
      else begin
        seek(arch, (cabecera.desarrolladores * -1) - 1);
        read(arch,cabecera);
        seek(arch,filePos(arch) - 1);
        write(arch,regDist);
        seek(arch,0);
        write(arch,cabecera);
      end;
      Close(arch);
    end;

    procedure bajaDistribucion(var arch: archDistribuciones ; name:String);
    var
    cabecera: distribucion;
    posBorrar : integer;
    begin
      reset(arch);
      read(arch,cabecera);
      posBorrar := buscarDistribucion(arch,name);
      if (posBorrar = -1) then
        writeln('Distribucion no existente')
      else begin
        // PONGO CABECERA VIEJA EN LA POS A BORRAR
        seek(arch,posBorrar);
        write(arch,cabecera);
        cabecera.desarrolladores := posBorrar * -1;
        // MODIFICO DESARROLLADORES PARA INDICAR LA POS BORRADA Y LA ESCRIBO EN CABECERA
        seek(arch,0);
        write(arch,cabecera);
      end;
      Close(arch);
    end;

    procedure inicializarArchivo(var arch: archDistribuciones);
    var
    dist: distribucion;
    begin
        rewrite(arch);
        dist.nombre := 'Ubuntu'; dist.descripcion := 'Ubuntu 20.04'; dist.anio := 2004; dist.kernel := 5; dist.desarrolladores := 10;
        write(arch, dist);
        close(arch);
    end;
var
    arch: archDistribuciones;
    dist1, dist2: distribucion;

begin
    assign(arch, 'distribuciones.dat');
    inicializarArchivo(arch);

    dist1.nombre := 'Debian'; dist1.descripcion := 'Debian 11'; dist1.anio := 2021; dist1.kernel := 5; dist1.desarrolladores := 10;
    altaDistribucion(arch, dist1);

    dist2.nombre := 'Fedora'; dist2.descripcion := 'Fedora 35'; dist2.anio := 2021; dist2.kernel := 5; dist2.desarrolladores := 20;
    altaDistribucion(arch, dist2);

    bajaDistribucion(arch, 'Debian');
end.