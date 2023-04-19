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

Program tp3ej6;

Const 
  valor_alto = 9999;

Type 
  prenda = Record
    cod_prenda: integer;
    descripcion: string;
    color:string;
    tipo_prenda: string;
    stock: integer;
    precio: integer;
  End;
  
  archivo = file of prenda;
  detalle = file of integer;

procedure leer(var a:archivo; var p :prenda);
begin
    if (not eof(a)) then
        read(a,p)
    else
        p.cod_prenda:= valor_alto;
end; 

procedure actualizar (var a:archivo ; var d:detalle);
    procedure baja(var a:archivo; cod: integer);
    var
        cabecera, aux: prenda;
    begin
        reset(a);
        if not eof (a) then read(a,cabecera);
        leer(a,aux);
        while ((aux.cod_prenda<>valor_alto) and (aux.cod_prenda<>cod)) do 
            leer(a,aux);
        if (aux.cod_prenda<>valor_alto) then begin


///////////////FALTA TERMINAR EL MODUILO DE CREACION Y EL DE BAJA> >?>>>>>>>>>>
        end;
        
    end;


var
    cod: Integer;
begin
    reset(d);
    while not eof(d) do begin
        read(d,cod);
        baja(a,cod);
    end;
    close(d);
    WriteLn('***Actualizacion realizada con exito***');
end;

procedure crearArchivos(var a : archivo; var d :detalle);
var
    t: Text;
    aux: prenda;
    num: integer;
begin
    assign(t,'tp3ej6_mae.txt');
    reset(t);
    Rewrite(a);
    while not eof(t) do begin  
        readln(t,aux.cod_prenda,aux.descripcion);
        ReadLn(t, aux.stock,aux.color);
        readl(t,aux.precio,aux.tipo_prenda);
        write(a,aux);
    end;
    close(a);
    close(t);
    assign(t,'tp3ej6_det.txt');
    reset(t);
    Rewrite(d);
    while not eof (t) do begin
        readln(t,num);
        write(d,num);  
    end;
    close(t);
    close(d);
end;

var
    a: archivo;
    d:detalle;
begin
    Assign(a,'tp3ej6_mae');
    Assign(d,'tp3ej6_det');
    crearArchivos(a,d);
    actualizar(a,d);
end.
