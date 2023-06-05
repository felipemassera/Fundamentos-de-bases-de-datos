{ Una compañía aérea dispone de un archivo maestro donde guarda información sobre
sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez
}

program Merge;
const 
    df = 2 ;
    valorAlto = 'zzzz';
type
    vuelo = record
        destino:string;
        fecha: integer;
        horaSalida: integer;
        cantAsientos: integer;
    end;
    archivo = file of vuelo;
    arrDetalles = array [1..df] of archivo;
    arrRegistros = array [1..df] of vuelo;

    lista = ^nodo;
    nodo = record
        dato:vuelo;
        sig:lista;
    end;

procedure agregarAdelante(var L:lista ; V:vuelo);
var
    nuevo:lista;
begin
    new(nuevo);
    nuevo^.dato:= V;
    nuevo^.sig:= L;
    L:= nuevo;
end;

procedure leer(var a:archivo ; var reg:vuelo);
begin
    if (not eof(a)) then
        read(a, reg)
    else
        reg.destino:= valor_alto;
end;

procedure asignar(var mae:archivo ; var v_det:arrDetalles ; var v_reg:arrRegistros);
var
    i:integer;
    iString:string;
begin
    assign(mae, 'maestro.bin');
    reset(mae);
    for i:=1 to df do begin
        str(i, iString);
        assign(v_det[i], 'detalle'+iString+'.bin');
        reset(v_det[i]);
        leer(v_det[i], v_reg[i]);
    end;
end;


procedure merge(var mae:archivo ; var v_det:arrDetalles ; v_reg:arrRegistros ; var L:lista);

    
    procedure minimo(var v_det:arrDetalles ; var v_reg:arrRegistros ; var min:vuelo);
    var
        i, pos:integer;
    begin
        min.destino:= valor_alto;
        min.fecha:= 9999;
        min.horaSalida:= 9999;
        for i:=1 to df do begin
            if (min.destino > v_reg[i].destino) or ((min.destino = v_reg[i].destino) and (min.fecha > v_reg[i].fecha))
                        or ((min.destino = v_reg[i].destino)and(min.fecha = v_reg[i].fecha)and(min.horaSalida > v_reg[i].horaSalida)) then begin
                min:= v_reg[i];
                pos:= i;
            end;
        if (min.destino <> valor_alto) then
            leer(v_det[pos], v_reg[pos]);
    end;

var
    min, regMae:vuelo;
    asientos_min:integer;
begin
    writeln('Ingrese el numero minimo de asientos para los vuelos que desea listar');
    read(asientos_min);
    L:= nil;
    leer(mae, regMae);
    minimo(v_det, v_reg, min);
    while(min.destino <> valor_alto) do begin
        while(regMae.destino <> min.destino) or (regMae.fecha <> min.fecha) or (regMae.horaSalido <> regMae.horaSalida) do begin
            if (regM.cantAsientos < asientos_min) then
                agregarAdelante(L, regMae);
            leer(mae, regMae);
        end;
        while (regMae.destino = min.destino) and (regMae.fecha = min.fecha) and (regMae.horaSalido = regMae.horaSalida) do begin
            regM.asientos:= regM.cantAsientos - min.cantAsientos;
            minimo(v_det, v_reg, min);
        end;
        seek(mae, filePos(mae)-1);
        write(mae, regMae);
    end;
    
    while(not eof(mae)) do begin
        read(mae, regM);
        if (regM.cantAsientos < asientos_min) then
            agregarAdelante(L, regM);
    end;
end;

VAR
    mae:archivo;
    v_det:arrDetalles;
    v_reg:arrRegistros;
    i:integer;
BEGIN
    asignar(mae, v_det, v_reg);
    merge(mae, v_det, v_reg);
    for i:=1 to df do
        close(v_det[i])
    close(mae);
END;