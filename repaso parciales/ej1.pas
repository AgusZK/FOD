program ej1;
// MERGE-CREAR MAESTRO
const
    valorAlto= '9999';
    cantArchivos = 5;
type
    corredor = record
        DNI,apellido,nombre: String[20];
        kmsTotal,carrerasGanadas: integer;
    end;

    carrera = record
        DNI,apellido,nombre: String[20];
        kms, gano: integer;
    end;

    maestro = file of corredor;
    detalle = file of carrera;
    // ARC_DET = NOMBRES , ARC_DATOS: REGISTROS
    arc_det = array[1..cantArchivos] of detalle;
    arc_datos = array [1..cantArchivos] of carrera;

procedure minimo (var detalles: arc_det; var data: arc_datos; var min: carrera);
var
    i,pos: integer;
begin
    pos:= 1;
    for i:= 1 to cantArchivos do begin
      if (data[i].DNI < data[pos].DNI) then
        pos:= i; 
    end;
    // ACTUALIZO EL MINIMO, LEO OTRO
    min := data[pos];
    leer(detalles[pos],data[pos]);
end;

procedure generarMaestro( var mae: maestro; var det : arc_det);
var
 i: integer;
 regM: corredor;
 regD,min: carrera;
 data: arc_datos;
begin
  // CREO MAESTRO, ABRO DETALLES
  Rewrite(mae);
  for i:= 1 to cantArchivos do begin
    reset(det[i]);
    leer(det[i],data[i]);
  end;
  // BUSCO MINIMO
  minimo(det,data,min);
  while (min.DNI <> valorAlto) do begin    
    regM.kmsTotal:= 0;
    regM.carrerasGanadas:= 0;
    // ME GUARDO DNI ACTUAL, PROCESO TODOS LOS DE ESE DNI
    regD.DNI := min.DNI;
    while (regD.DNI = min.DNI) do begin
      regM.DNI:= regD.DNI;
      regM.nombre:= regD.nombre;
      regM.apellido:= regD.apellido;
      regM.kmsTotal:= regM.kmsTotal + regD.kms;
      if (regD.gano = 1) then
        regM.carrerasGanadas:= regM.carrerasGanadas + 1;

      minimo(det,data,min);
    end;
    // SI SALGO TERMINE DE PROCESAR EL CORREDOR, LO ESCRIBO EN EL MAESTRO
    write(mae,regM);
  end;

  close(mae);
  for i:= 1 to cantArchivos do begin
    close(det[i]);
  end;
end;

var
mae: maestro;
det: arc_det;
datos: arc_datos;
begin
  Assign(mae, 'maestro.dat');
  Assign(det[1], 'detalle1.dat');
  Assign(det[2], 'detalle2.dat');
  Assign(det[3], 'detalle3.dat');
  Assign(det[4], 'detalle4.dat');
  Assign(det[5], 'detalle5.dat');
  // FALTARIA LLENAR EL DE REGISTROS

  generarMaestro(mae, det); 
end.