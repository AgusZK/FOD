program ej4lisInv;
// LISTA INVERTIDA
type
    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;

    archivo = file of reg_flor;

procedure alta(var arch: archivo; flor : reg_flor);
var
    cabecera: reg_flor
begin
  Reset(arch);
  read(arch,cabecera);

  if (cabecera.codigo >= 0) then begin
    seek(arch,FileSize(arch));
    Write(arch,f);
  end
  else begin
    // SI EN CABECERA HAY UN NEGATIVO, VOY A LA POS MULTIPLICANDO POR -1 Y ME LEO ESE REGISTRO
    seek(arch, (cabecera.codigo * -1) - 1);
    read(arch,cabecera);
    // VUELVO 1 Y ESCRIBO EL REGISTRO NUEVO REUTILIZANDO ESAPCIO
    seek(arch,FilePos(arch) - 1);
    write(arch,f);
    // VUELVO AL PRINCIPIO Y ESCRIBO EL REGISTRO 
    seek(arch,0);
    write(arch,cabecera);
  end;
  Close(arch);
end;

procedure baja( var arch: archivo; cod: integer);
var
    cabecera,busqueda: reg_flor;
    find: boolean;
begin
  Reset(arch);
  find:= false;
  busqueda.codigo:= -1;
  read(arch,cabecera);
  while (not eof(arch) and (not found)) do begin
    read(arch,busqueda);
    if (busqueda.codigo = cod) then
      find:= true;
  end;
  // SI ENCONTRE EL CODIGO A BORRAR
  if (find) then
    // VOY A LA POS Y ESCRIBO EL CABECERA VIEJO
    seek(arch,FilePos(arch) - 1);
    write(arch,cabecera);
    // ME COPIO LA POSICION DEL ARCHIVO BORRADO Y LA MULTIPLICO POR -1
    cabecera.codigo:= FilePos(arch) * -1;
    // VUELVO AL PRINICIPIO Y ESCRIBO NUEVO CABECERA CON POS DE BORRADO ACTUALIZADA
    seek(arch,0);
    write(arch,cabecera);
end;

begin
  
end.