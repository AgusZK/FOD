program ej10;
const
    valorAlto = 9999;
type
    venta = record
        categoria,marca,modelo,cantV: integer;
    end;

    archivo = file of venta;

procedure leer (var arch: archivo ; var v: venta);
begin
  if (not eof(arch)) then
    read(arch,v)
  else
    v.categoria := valorAlto;
end;

procedure reporteVentas(var arch: archivo ; var txt: Text);
var
    v,aux: venta;
    total_categoria, total_marca, total_modelo: integer;
begin
    Reset(arch);
    Rewrite(txt);
    // LEO DEL ARCHIVO Y PROCESO
    leer(arch,v);
    while (v.categoria <> valorAlto) do begin
      // GUARDO CATEGORIA ACTUAL INICIALIZO CONTADOR DE CATEGORIA
      aux.categoria := v.categoria;
      total_categoria:= 0;
      // CORTE DE CONTROL PARA CATEGORIA, INICIALIZO CONTADOR DE MARCA
      while (aux.categoria = v.categoria) do begin
        // GUARDO MARCA ACTUAL
        aux.marca := v.marca;
        total_marca := 0;
        // CORTE DE CONTROL PARA CATEGORIA Y MARCA, INICIALIZO CONTADOR DE MODELO
        while (aux.categoria = v.categoria) and (aux.marca = v.marca) do begin
            aux.modelo:= v.modelo;
            total_modelo:= 0;

            // SI EL QUE LEO TIENE MISMA CATEGORIA, MARCA Y MODELO, SUMO CANT VENTAS Y LEO EL SIGUIENTE
            while (aux.categoria = v.categoria) and (aux.marca = v.marca) and (aux.modelo = v.modelo) do begin
              total_modelo := total_modelo + v.cantV;
              leer(arch,v)
            end;

            // SI SALGO YA NO ESTOY EN EL MISMO MODELO, ESCRIBO 
            Writeln(txt, '        ', aux.modelo, ': ', total_modelo);
            total_marca:= total_marca + total_modelo;
        end;
        // SI SALGO YA NO ESTOY EN LA MISMA MARCA, ESCRIBO
        Writeln(txt, '    ', aux.marca, ': ' , total_marca);
        total_categoria:= total_categoria + total_marca;
      end;
    // SI SAGO YA NO ESTOY EN LA MISMA CATEGORIA, ESCRIBO
    Writeln(txt, '    ', aux.categoria, ': ', total_categoria);
    end;

    Close(arch);
    Close(txt);
end;

var
txt: Text;
v: venta;
arch : archivo;
begin
  Assign(arch, 'archivoVentas.dat');
  Assign(txt, 'datos.txt');
  Rewrite(arch);

  v.categoria := 1; v.marca := 10; v.modelo := 100; v.cantV := 20;
  Write(arch, v);
  v.modelo := 101; v.cantV := 25;
  Write(arch, v);
    
  v.marca := 10; v.modelo := 102; v.cantV := 15;
  Write(arch, v);
    
  v.categoria := 2; v.marca := 20; v.modelo := 200; v.cantV := 30;
  Write(arch, v);
  v.modelo := 201; v.cantV := 18;
  Write(arch, v);

  v.marca := 20; v.modelo := 202; v.cantV := 22;
  Write(arch, v);

  v.categoria := 3; v.marca := 30; v.modelo := 300; v.cantV := 50;
  Write(arch, v);
  v.modelo := 301; v.cantV := 45;
  Write(arch, v);
  v.categoria := valorAlto;
  Write(arch, v);
  Close(arch);
  
  reporteVentas(arch,txt); 
end.