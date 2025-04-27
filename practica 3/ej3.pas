program ej3;

type
    novela = record
        codigo,duracion: integer;
        genero,nombre,director: String;
        precio: real;
    end;

    archNovela = file of novela;

    procedure leerNovela( var n : novela);
    begin
      WriteLn('Ingrese codigo (0 para fin)'); readln(n.codigo);
      WriteLn('Ingrese director'); readln(n.director);
      WriteLn('Ingrese nombre de la novela'); readln(n.nombre);
      WriteLn('Ingrese genero'); readln(n.genero);
      n.precio := Random() * 300;
      n.duracion := Random(180) + 100;
    end;

    procedure crearArchivo( var arch: archNovela);
    var
    n: novela;
    begin
      Rewrite(arch);
      // USO LISTA INVERTIDA, PRIMER REGISTRO CON CODIGO = 0 Y LO ESCRIBO
      n.codigo := 0;
      Write(arch,n);
      // AHORA METO LOS DEMAS
      leerNovela(n);
      while (n.codigo <> 0) do begin
        Write(arch,n);
        leerNovela(n)
      end;
      Close(arch);
    end;

    procedure altaNovela ( var arch: archNovela);
    var
    n: novela;
    pos: integer;
    begin
      Reset(arch);
      // ABRO Y LEO CABECERA
      read(arch,n);
      if (n.codigo < 0) then begin
        // COMO DICE EL INCISO, SI ES NEGATIVO EL CODIGO TENGO QUE BUSCAR POS EN EL POSITIVO
        // MULTIPLICO POR -1 PARA OBTENER LA POS Y LE RESTO 1 PARA IR AL QUE CORRESPONDE
        pos:= (n.codigo * -1) - 1;
        // VOY AL REGISTRO CORRESPONDIENTE, LO COPIO Y LO PONGO EN LA CABECERA
        seek(arch,pos);
        read(arch,n);
        seek(arch,0);
        write(arch,n);
        // VUELVO A DONDE TENGO QUE ESCRIBIR EL ALTA
        seek(arch,pos);
      end
      else
        // SI NO ES NEGATIVO ME PONGO AL FINAL Y EN CUALQUIER CASO ESCRIBO
        seek(arch,fileSize(arch));

      // LEO Y ESCRIBO ALTA EN CUALQUIER CASO
      leerNovela(n);
      write(arch,n);
      close(arch);
    end;

    procedure modificarDatos ( var n : novela);
    begin
      writeln('Ingrese nueva duracion'); readln(n.duracion);
      writeln('Ingrese nuevo genero'); readln(n.genero);
      writeln('Ingrese nuevo nombre'); readln(n.nombre);
      writeln('Ingrese nuevo director'); readln(n.director);
      writeln('Ingrese nuevo precio'); readln(n.precio);
    end;

    procedure modificarNovela (var arch: archNovela);
    var
    n: novela;
    code: integer;
    found: boolean;
    begin
        writeln('Ingrese codigo para modificar novela'); readln(code);
        Reset(arch);
        found:= false;
        // LEO CABECERA PORQUE SI LO HAGO DESPUES PIERDO EL FILEPOS
        read(arch,cabecera);
        while (not eof(arch)) and (not found) do begin
            Read(arch,n);
            if (n.codigo = code) then
                found:= true;
        end;
        // SI LO ENCONTRE, MODIFICO SUS DATOS Y LO ESCRIBO EN EL REGISTRO ANTERIOR AL QUE QUEDE
        if(found) then begin
            modificarDatos(n);
            seek(arch,FilePos(arch) - 1);
            write(arch,n)
        end
        // SINO, EL CODIGO INGRESADO NO EXISTE
        else 
            Writeln('Codigo ingresado no registrado en novela');

        Close(arch);
    end;

    procedure bajaNovela( var arch: archNovela);
    var
    n,cabecera: novela;
    code: integer;
    found: boolean;
    begin
        writeln('Ingrese codigo para dar baja a la novela'); readln(code);
        Reset(arch);
        found:= false;
        while (not eof(arch)) and (not found) do begin
          read(arch,n);
          if (n.codigo = code) then
            found:= true;
        end;

        if (found) then begin
          // VOY AL REGISTRO, PONGO EL ANTIGUO REGISTRO CABECERA Y MODIFICO CODIGO DE CABECERA (EL QUE VOY A ESCRIBIR DESPUES) CON POS * -1
          seek(arch, FilePos(arch) - 1);
          Write(arch, cabecera);
          cabecera.codigo := FilePos(arch) * -1;
          // VUELVO AL PRINCIPIO Y ESCRIBO CABECERA CON CODIGO (POS DEL BORRADO) MODIFICADO
          seek(arch,0);
          write(arch,cabecera);
        end
        else
          writeln('Codigo de novela no encontrado');

        Close(arch);
    end;

    procedure mantenerArchivo (var arch: archNovela);
    var
    num: integer;
    begin
      // MUESTRO MENU PARA HACER ALTA, MODIFICACION O BAJA
      repeat
        WriteLn('0 Terminar programa');
        WriteLn('1 Agregar novela (alta)');
        WriteLn('2 Modificar novela (menos el codigo)');
        WriteLn('3 Eliminar novela (baja)');

        WriteLn('Ingrese num de operacion'); readln(num);

        case num of 
            1: altaNovela(arch);
            2: modificarNovela(arch);
            3: bajaNovela(arch);
        end;

      until num = 0   
    end;

    procedure exportarTxt ( var arch: archNovela);
    var
    n: novela;
    txt: Text;
    begin
      Assign(txt,'exportado.txt');
      Rewrite(txt);
      Reset(arch);
      while (not eof(arch)) do begin
        read(arch,n);
        writeln(txt, n.nombre, ' || ' , n.duracion , ' || ', n.director, ' || ' , n.genero , ' || ', n.precio, ' || ', n.codigo);
      end;

      close(txt);
      close(arch);
    end;

var
arch: archNovela;
name: String[20];
num: integer;
begin
  name:= '';
  // MUESTRO MENU DE OPCIONES, CON 0 CORTA
  repeat
    WriteLn('0 Terminar programa');
    WriteLn('1 Crear archivo');
    WriteLn('2 Mantenimiento (altas y bajas)');
    WriteLn('3 Exportar a txt');

    WriteLn('Ingrese num de operacion'); readln(num);
    if (num <> 0) then begin
      writeln('Ingrese nombre para crear archivo'); readln(name);
      Assign(arch,name);
    end;

    case num of 
        1: crearArchivo(arch);
        2: mantenerArchivo(arch);
        3: exportarTxt(arch);
    end;

  until num = 0
end.