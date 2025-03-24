program ej3;
type
    empleados = record
        nro: integer;
        apellido: string;
        nombre: string;
        edad: integer;
        dni: integer;
    end;

    registro = file of empleados;

    procedure leer( var emp: empleados);
    begin
      writeln('Ingrese apellido (fin para no registrarlo)');
      readln(emp.apellido);   
      writeln('Ingrese nombre');
      readln(emp.nombre);
      writeln('Ingrese edad');
      readln(emp.edad);
      writeln('Ingrese dni');
      readln(emp.dni);
      writeln('Ingrese nro de empleado');
      readln(emp.nro);
    end;

    procedure cargarArchivo( var r: registro);
    var
    emp: empleados;
    begin
        rewrite(r);
        leer(emp);
        while (emp.apellido <> 'fin') do begin
            write(r,emp);
            leer(emp);
        end;
        close(r);
    end;

    procedure printDatos (e : empleados);
    begin
      writeln(' apellido: ', e.apellido , ' nombre: ' , e.nombre , ' edad: ' , e.edad , ' dni: ', e.dni , ' nro: ', e.nro );
    end;

    procedure printFiltrado ( var r: registro );
    var
    emp: empleados;
    tag: string;
    begin
      writeln('Ingrese nombre/apellido para filtrar');
      readln(tag);
      reset(r);
      writeln;
      writeln('Empleados filtrados: ');
      while (not eof(r)) do begin
        read(r,emp);
        if (emp.apellido = tag) or (emp.nombre = tag) then 
            printDatos(emp)
      end;
      close(r);
    end;

    procedure printTodos ( var r: registro);
    var
    emp: empleados;
    begin
      reset(r);
      writeln;
      writeln('Todos los empleados: ');
      while (not eof(r)) do begin
        read(r,emp);
        printDatos(emp);
      end;
      close(r);
    end;

    procedure print70 (var r: registro);
    var
    emp: empleados;
    begin
      reset(r);
      writeln;
      writeln('Empleados mayores a 70: ');
      while (not eof (r)) do begin
        read(r,emp);
        if (emp.edad > 70) then
          printDatos(emp);
      end;
      close(r);
    end;

    procedure agregarEmpleados( var r: registro);
    var
    emp,emp2: empleados;
    find: boolean;
    begin
      // EMP: EMP DE TECLADO , EMP2: EMP DENTRO DEL ARCHIVO
      reset(r);
      leer(emp);
      while (emp.apellido <> 'fin') do begin
        seek (r,0);
        find:= false;
        while (not eof(r)) and (not find) do begin
          read(r,emp2);
          if (emp.nro = emp2.nro) then
            find:= true;
        end;
        if (find) then
          writeln('El empleado ya esta registrado')
        else begin
          seek(r,fileSize(r)); 
          write(r,emp);
        end;
        leer(emp);
       end;
       close(r);
    end;
    
    procedure modificarEdad ( var r: registro);
    var
    emp: empleados;
    num: integer;
    find: boolean;
    begin
      writeln('Ingrese numero de empleado a modificar edad');
      readln(num);
      reset(r);
      find:= false;
      while (not eof(r)) and (not find) do begin
        read (r, emp);
        if (emp.nro = num) then
          find := true;
      end;
      if (find) then begin
        seek (r, filePos(r) - 1); // ABRO EL ARCHIVO Y RETROCEDO 1, DONDE ME QUEDE
        writeln('Ingrese nueva edad');
        readln(emp.edad);
        writeln('El empleado de numero: ' , emp.nro , ' ha sido modificado y su nueva edad es: ' , emp.edad);
      end
      else
        writeln('El nro de empleado no esta registrado');
      close(r);  
    end;

    procedure exportarContenido( var r: registro);
    var
    emp: empleados;
    txt: Text;
    begin
      assign(txt, 'todos_empleados.txt');
      rewrite(txt);
      reset(r);
      while (not eof(r)) do begin
        read(r,emp);
        write(txt, emp.nro, ' ' , emp.apellido, ' ', emp.nombre , ' ', emp.edad, ' ' , emp.dni);
      end;
      close(txt);
      close(r);
    end;

    procedure exportarDniEn00 ( var r: registro);
    var
    emp: empleados;
    txt: Text;
    begin
      assign(txt, 'faltaDNIEmpleado.txt');
      rewrite(txt);
      reset(r);
      while (not eof(r)) do begin
        read (r,emp);
        if(emp.dni = 00) then
          Write(txt, emp.nro, ' ', emp.apellido, ' ', emp.nombre , ' ', emp.edad, ' ', emp.dni);
        close(txt);
        close(r);
      end;
    end;
var
r: registro;
name: string;
option: byte;
begin
  repeat
    // MENU DE OPCIONES, 0 CORTA EL PROGRAMA ENTERO
    writeLn('0) Fin del programa');
    writeLn('1) Crear archivo ');
    writeLn('2) Mostrar empleados por nombre/apellido seleccionado');
    writeLn('3) Mostrar todos los empleados');
    writeLn('4) Mostrar empleados mayores de 70 años');
    writeLn('5) Agregar un empleado al archivo');
    writeLn('6) Modificar edad de empleado por numero');
    writeLn('7) Exportar el contenido del archivo a un txt');
    writeLn('8) Exportar empleados con DNI 00 a un txt');
    writeln;    
    writeln('Ingrese el numero de operacion a ejecutar');
    readln(option);

    if (option <> 0) then begin
      writeln('Ingrese nombre de archivo a crear o buscar en caso de ya creado');
      readln(name);
      assign(r,name);
    end;

    case option of
      // EJ 3
      1: cargarArchivo(r);
      2: printFiltrado(r);
      3: printTodos(r);
      4: print70(r);
      // EJ 4
      5: agregarEmpleados(r);
      6: modificarEdad(r);
      7: exportarContenido(r);
      8: exportarDniEn00(r);
    end;
  until (option = 0);
end.