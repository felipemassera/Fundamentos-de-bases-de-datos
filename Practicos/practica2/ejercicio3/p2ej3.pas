
{ 3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}
Program p2ej3;
Const 
  valor_alto = 9999;
  sucu = 30;
Type 
  producto = Record
    cod : Integer;
    nombre: nombres;
    descripcion : String [50];
    stockDis : integer;
    stockMin : integer;
    precio : double;
  End;
  producto_detalle =record
    cod = Integer;
    cantVendida = integer;
  end;
  maestro = file of producto;
  detalle = file of producto_detalle;
  sucursales = array [1..sucu] of detalle;
  registros = array [1..sucu] of  producto_detalle;

procedure leer (var det : detalle; var aux : producto_detalle);
begin
  if not eof (det) then
    read(det, aux)
  else
    aux.cod:= valor_alto;
end;

procedure actualizarMaestro(Var mae: maestro; Var det: detalle );
var
  auxMae: producto;
  auxDet: producto_detalle;
begin
  assign(mae,'maestro');
  Assign(det,'detalle');
  reset(mae);
  reset(det);
  leer(det,auxDet);
  while auxDet.cod<>valor_alto do begin
    Read(mae, auxMae);
    While auxMae.cod <> auxDet.cod Do Read(mae, auxMae);
    while auxMae.cod = auxDet.cod do begin
      auxMae.stockDis = auxMae.stockDis - auxDet.cantVendida;
      leer(det,auxDet);
    end;
      seek(mae, FilePos(mae)-1);
      write(mae, auxMae);  
  end;
  Close(mae);
  Close(det);
end;

procedure descargoDiarios(var mae: maestro; suc : sucursales);
var
  i :integer;
begin
  for i:=0 to sucu do begin
    actualizarMaestro(mae,suc[i]);
  end;
end;

procedure cargoArray(var detDiarios:sucursales);
var
  aux : producto_detalle;
  det : detalle;
  arch : text;
begin
  assign(arch,'detalle.txt');
  assign(det,'detalle');
  Reset(Arch);
  Rewrite(det);
  while not eof (arch)do begin
    read(arch, aux.cod, aux.cantVendida);
    write(det,aux);
  end;
  //El array para la prueba contiene 30 listados =
  for i:=1 to suc do
    detDiarios[i]:= det;
  close(arch);
  close(det);
end;

procedure maximo (var archivo);
var

begin
  
end;


var
  arrayD : sucursales;
  arrayR: registros;
  min: producto_detalle;
  nombreFisico:String;
  i:integer;
Begin
  cargoArray(arrayD);

  for i:=1 to suc do
  begin
    Str(i, iString);
    assign(arrayD[i], 'detalle'+iString);
    rewrite(arrayD[i]);
    leer(arrayD[i], arrayR[i]);
  end;

  minimo(arrayD, arrayR, min);
End.
