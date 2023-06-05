program parcial2018;

const
    valor_alto = 9999;
type
    registro = record
        anio:integer;
        mes:integer;
        dia:integer;
        id: integer;
        tAcceso: integer;    
    end;
    maestro = file of registro;
    //orden anio,mes,dia e id

procedure leer (var mae:maestro ; var dato:registro);
begin
    if(NOT eof(mae)) then
        read(mae, dato)
    else
        dato.anio:= valor_alto;
end;

procedure procesar(var mae:maestro);
var
    anio_buscado:integer;
    reg:registro;
    actual:registro;
    total_dia,total_mes,total_anio:integer;
begin
    WriteLn('Ingresar anio a buscar:');
    readln(anio_buscado);
    leer(mae,reg);
    while (reg.anio <> valor_alto) and (reg.anio <> anio_buscado)do 
        leer(mae,reg);
    if (reg.anio = anio_buscado) then  begin
        total_anio:=0;
        writeln('Anio ',anio_buscado);
        while(reg.anio=anio_buscado)do begin
            actual.mes:=reg.mes;
            total_mes:=0;
            writeln('   Mes ',actual.mes);
            while (reg.anio = anio_buscado) and (reg.mes = actual.mes) do begin
                actual.dia:=reg.dia;
                total_dia:=0;
                writeln('       Dia ', actual.dia);
                while (reg.anio = anio_buscado) and (reg.mes = actual.mes) and (reg.dia = actual.dia)do begin
                    actual.id:=reg.id;
                    actual.tAcceso:=0;
                    while (reg.anio = anio_buscado) and (reg.mes = actual.mes) and (reg.dia = actual.dia) and (reg.id = actual.id)do begin
                        actual.tAcceso:= actual.tAcceso + reg.tAcceso;
                        leer(mae, reg);
                    end;
                    writeln('           idUsuario ',actual.id,', Tiempo Total de acceso en el dia ',actual.dia,' mes ',actual.mes,': ',actual.tAcceso);
                    total_dia:= total_dia + actual.tAcceso;
                end;
                writeln('       Tiempo total acceso dia ',actual.dia,' mes ',actual.mes,': ',total_dia);
                total_mes:= total_mes + total_dia;
            end;
            writeln('   Total tiempo de acceso mes ',actual.mes,': ',total_mes);
            total_anio:= total_anio + total_mes;
        end;
        writeln('Total tiempo de acceso anio: ',total_anio);
    end else WriteLn('anio no encontrado.');
end;

VAR
    mae:maestro;
BEGIN
    assign(mae, 'accesos.dat');
    reset(mae);
    procesar(mae);
    close(mae);
END.
