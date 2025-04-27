program ej6;
type
    prenda = record
        codigo,stock: integer;
        descripcion,colores,tipo: String[20];
        precio:real;
    end;

    archPrendas = file of prenda;    

    procedure actualizarMaestro( var mae, det: archPrendas);
    var
    prendaMae,prendaDet: prenda;
    found: boolean;
    begin
      reset(mae);
      reset(det);
      while not(eof(det)) do begin
        read(det,prendaDet);
        found:= false;
        // LEO PRENDA DEL DETALLE, LA BUSCO EN EL MAESTRO
        while (not eof(mae)) and (not found) do begin
          read(mae,prendaMae);
          if (prendaMae.codigo = prendaDet.codigo) then begin
            // SI ENCONTRE LA PRENDA, MODIFICO STOCK CON -1 Y LA REESCRIBO
            found:= true;
            prendaMae.stock:= -1;
            seek(mae,FilePos(mae) - 1);
            write(mae,prendaMae);
          end;
        end;
        // LEO EL SIGUIENTE EN EL DETALLE HASTA QUE TERMINE
      end;
      close(det);
      close(mae);
    end;

    procedure efectivizarBajas(var mae: archPrendas ; name: String);
    var
    prendaMae: prenda;
    nuevoArch: archPrendas;
    begin
      Assign(nuevoArch, 'nuevo.dat');
      Rewrite(nuevoArch);
      reset(mae);
      while (not eof(mae)) do begin
        read(mae,prendaMae);
        // SOLO ESCRIBO EN EL NUEVO LAS QUE TIENEN STOCK POSITIVO
        // LAS OTRAS SE SALTEAN
        if (prendaMae.stock >= 0) then
          write(nuevoArch,prendaMae);
      end;

      close(mae);
      close(nuevoArch);
      // LE ASIGNO AL NUEVO ARCHIVO EL NOMBRE DEL MAESTRO
      Rename(nuevoArch,name);
    end;
var
maestro,detalle: archPrendas;
name: String;
begin
    writeln('Ingrese nombre del archivo a crear'); readln(name);
    Assign(maestro,name);
    Assign(detalle,'detalle.dat');
    // FALTARIA CREARLOS Y CARGARLOS
    actualizarMaestro(maestro,detalle);
    efectivizarBajas(maestro,name);
end.