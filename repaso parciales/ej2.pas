program ej2;
// ACTUALIZAR MAESTRO
const
    valorAlto = 9999;
    cantArchivos = 3;
type
    productos = record
        codigo,barras,categoria,stockAct,stockMin: integer;
        nombre,descripcion: String[20];
    end;

    pedido = record
        codigo,cantPedida: integer;
        descripcion: String[20];
    end;

    maestro = file of productos;
    detalle = file of pedidos;

    arr_det = array [1..cantArchivos] of detalle;
    arr_datos = array[1..cantArchivos] of pedido;
procedure leer (var arch: detalle ; var p: pedido);
begin
  if (not eof(arch)) then 
    read(arch,p)
  else
    p.codigo := valorAlto;
end;  

procedure minimo (var detalles: arr_det; var datos: arr_datos ; var min: pedido);
var
    i,pos: integer;
begin
    pos:= 1;
    if (datos[i].codigo < datos[pos].codigo) then 
        pos:= i;

    // ACTUALIZO, LEO OTRO
    min := datos[pos];
    leer(detalles[pos],datos[pos]);    
end;

procedure actualizarMaestro (var mae: maestro; var detalles: arr_det);
var
    regM: productos;
    datos: arr_datos;
    regD,min: pedido;
    i: integer;  
begin
    // ABRO MAESTRO, ABRO Y LEO TODOS LOS DETALLES
    Reset(mae);
    for int:= 1 to cantArchivos do begin
      reset(detalles[i]);
      leer(detalles[i].datos[i]);
    end;
  
    read(mae,regM);
    minimo(detalles,datos,min);
    // LEO EL DETALLE, ME GUARDO EL CODIGO Y CORTE DE CONTROL
    while (min.codigo <> valorAlto) do begin
      regD.codigo := min.codigo;
      regD.cantPedida := 0;

      while (regD.codigo = min.codigo) do begin
        // SUMO CANTIDAD Y LEO OTRO
        regD.cantPedida:= regD.cantPedida + min.cantPedida;
        minimo(detalles,datos,min);
      end;
      // SI SALGO TERMINE DE PROCESAR LOS DEL MISMO CODIGO, LO BUSCO EN EL MAESTRO Y LO ESCRIBO
      while (regM.codigo <> regD.codigo) do begin
        read(mae,regM);
      end;
      // SI EL STOCK ALCANZA PARA LO PEDIDO, LO RESTO, SINO INFORMO QUE NO SE PUEDE
      if (regM.stockAct >= regD.cantPedida) then
        regM.stockAct := regM.stockAct - regD.cantPedida
      else begin
        WriteLn('El pedido para el producto: ', regD.codigo, 'No se pudo completar debido a falta de stock, faltaron: ', (regD.cantPedida - regM.stockAct), ' productos');
        regM.stockAct:= 0;
      end;
      
      // SI EL STOCK ALCANZO, PERO QUEDO POR DEBAJO DE LO MINIMO, INFORMO
      if (regM.stockAct < regM.stockMin) then
        Writeln('El producto: ', regM.codigo, ' quedo por debajo de su stock minimo. Categoria: ', regM.categoria);
      
      // ESCRIBO EN EL MAESTRO
      seek(mae,FilePos(mae) - 1);
      write(mae,regM);
    end;
    close(mae);
    for int:= 1 to cantArchivos do begin
      close(detalles[i]);
    end;
end;

var
    mae: maestro;
    detalles: arr_det;
begin
  actualizarMaestro(mae,detalles);
end.