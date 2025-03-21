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
    procedure cargarArchivo( var r: registro);
    var
    emp: empleados;
    begin
        rewrite(r);
        writeln('ingrese apellido');
        readln(emp.apellido);
        while (emp.apellido <> 'fin') do begin
            writeln('ingrese nombre');
            readln(emp.nombre);
            writeln('ingrese edad');
            readln(emp.edad);
            writeln('ingrese dni');
            readln(emp.dni);
            write(r,emp);
            writeln('ingrese apellido');
            readln(emp.apellido);
        end;
        close(r);
    end;

    procedure printDatos (e : empleados);
    begin
      writeln('nro: ', e.nro , 'apellido: ', e.apellido , 'nombre: ' , e.nombre , 'edad: ' , e.edad , 'dni: ', e.dni );
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
    end;

    procedure printTodos ( var r: registro);
    var
    emp: empleados;
    begin
      reset(r);
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
      writeln('Empleados mayores a 70: ');
      while (not eof (r)) do begin
        read(r,emp);
        if (emp.edad > 70) then
          printDatos(emp);
      end;
    end;
var
r: registro;
name: string;
begin
    writeln('ingrese nombre de archivo');
    readln(name);
    assign(r,name);
    cargarArchivo(r);
    printFiltrado(r);
    printTodos(r);
    print70(r);
end.