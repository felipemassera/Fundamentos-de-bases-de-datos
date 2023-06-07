{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.}

program ej6;
type
    prenda = record
      cod_prenda:integer;
      descripcion: string;
      colores: string;
      tipo_prenda: string;
      stock:integer;
      precio_unitario :integer;
    end;
    maestro = file of prenda;
    detalle = file of integer;

procedure bajaLogica(var a:maestro; var d:detalle);
var
  aux : prenda;
  cod : integer;
begin
  assign(a,'maestro.dat');
  reset(d);
  while (not eof(d)) do begin
    read(d,cod);
    reset(a);
    while((not eof(a))and(aux.cod_prenda<>cod))do read(a,aux);
    if (aux.cod_prenda = cod) then begin
        aux.stock:= -1;
        Seek(a,FilePos(a)-1);
        write(a,aux);
    end;
  end;
  close(a);
  close(d);
end;

procedure compactar(var a: maestro ; var b:maestro);
  procedure renombrar( var a:maestro);
  begin
    Erase(a);
    Rename(b, 'maestro.dat');
  end;
var
  aux : prenda;
begin
  reset(a);
  rewrite(b);
  while (not eof(a)) do begin
    read(a,aux);
    if (aux.stock >= 0) then 
      write(b,aux);
  end;
  close(a);
  close(b);
  renombrar(a,b);
end;

var
   m, b: maestro;
begin
  bajaLogica(m);
  compactar(m,b);
end.