{15. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua,# viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización se debe proceder de la siguiente manera:
1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
2. Idem para viviendas con agua, gas y entrega de sanitarios.
3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}

program tp2ej15;
const
  valor_alto= 999;
  df= 2;
  //df= 10;
type
    rMae = record
        codPcia: integer;
        codLoc: integer;
        nombreLoc: string;
        //nombreProv: string;
        sLuz: integer;
        sGas: integer;
        chapa: integer;
        sAgua: integer;
        sSanitarios: integer;
    end;
    rDet = record
        codPcia: integer;
        codLoc: integer;
        cLuz: integer;
        construidas: integer;  //a las de chapa se le resta contruidas
        cAgua: integer;
        cGas: integer;
        sanitarios: integer;
    END;
    maestro = file of rMae;
    detalle = file of rDet;
    vector = array [1..df] of detalle;
    vectorReg = array [1..df] of rDet;

procedure leer(var det: detalle; var regD: rDet);
begin
    if (not eof (det)) then
        read(det, regD)
    else begin
        regD.codPcia:= valor_alto;
        regD.codLoc:= valor_alto;
    end;
end;

procedure actualizarMaestro(var m  : maestro; vec: vector);
    procedure minimo(var vec: vector;var vecR:vectorReg;var min: rDet );
    var
        pos,i:integer;
    begin
        min.codPcia:= valor_alto;
        min.codLoc:= valor_alto;
        for i:=1 to df do begin
            if (vecR[i].codPcia < min.codPcia) or ((vecR[i].codPcia = min.codPcia) and (vecR[i].codLoc < min.codLoc)) then
            begin
                min:= vecR[i];
                pos:= i;
            end;
        end;
        if min.codPcia <> valor_alto then leer(vec[pos], vecR[pos]);
    end;

var
    auxM: rMae;
    min: rDet;
    i: integer;
    vecReg: vectorReg;
begin
    reset(m);
    for i:=1 to df do begin
        reset(vec[i]);
        leer(vec[i],vecReg[i]);
    end;
    minimo(vec,vecReg, min);
    while min.codPcia<>valor_alto do begin
        read(m,auxM);
        while (auxM.codPcia<>min.codPcia) or (auxM.codLoc<>min.codLoc) do read(m,auxM);
        While (auxM.codPcia = min.codPcia) and (auxM.codLoc = min.codLoc) Do begin
            auxM.sLuz:= auxM.sLuz - min.cLuz;
            auxM.sGas:= auxM.sGas - min.cGas;
            auxM.chapa:= auxM.chapa - min.construidas;
            auxM.sAgua:= auxM.sAgua - min.cAgua;
            auxM.sSanitarios:= auxM.sSanitarios - min.sanitarios;
            minimo(vec,vecReg, min); 
        end;    
        seek(m, filePos(m)-1);
        write(m,auxM);
    end;
    close(m);
    for i:=1 to df do close(vec[i]);
end;
procedure asignar(var m:maestro; var vec: vector);
var
    istring: string;
    i: Integer;
begin
    for i:= 1 to df do begin
        str(i, istring);
        assign(vec[i],'detalle'+istring+'.dat');
    end;
    assign(m,'maestro.dat');
    WriteLn('fin de asignacion');
end;

 procedure vermae(var m:maestro);
 var
   aux: rMae;
  begin
    reset(m);
    while not eof(m) do begin
        read(m,aux);
        writeln('codPcia: ',aux.codPcia, ' codLoc: ',aux.codLoc);
        WriteLn('sLuz: ',aux.sLuz,' s Gas: ',aux.sGas ,' chapa: ',aux.chapa);
        WriteLn(' sanitarios: ',aux.sSanitarios,' s/agua: ',aux.sAgua);
    end;
  end; 
 
var
    m: maestro;
    vec: vector; 
begin
    asignar(m,vec);
    vermae(m);
    WriteLn('Fin ver Maestro s/modificar');
    actualizarMaestro(m,vec);
    vermae(m);
    WriteLn('Fin ver Maestro modificado');
end.