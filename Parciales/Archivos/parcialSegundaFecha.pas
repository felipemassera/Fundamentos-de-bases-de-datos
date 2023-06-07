{Suponga que cuenta con un archivo con información acerca de las ventas de diferentes eventos de un teatro de la ciudad de  La Plata.
Dicho archivo tiene la siguiente estructura: nombreEvento, fechaFuncion , SectorFuncion(General, platea, etc),  y cantidadEntradasVendidas por sector.
Además se conoce que la información del archivo está ordenada primero por nombreEvento y luego por fechaFuncion.
Escriba un programa (Programa principal, estructuras y módulos) que dado el archivo descripto, realice  un informe por pantalla con el siguiente formato:

CANTIDAD DE ENTRADAS VENDIDAS  POR FUNCIÓN Y POR EVENTO

NOMBRE Evento 1
Fecha función 1
Sector 1                                 Cantidad Vendida
Sector N                                 Cantidad Vendida
-----------
            Cantidad Total de Entradas Vendidas por función 1
Fecha función N
Sector 1                                 Cantidad Vendida
Sector N                                 Cantidad Vendida
-----------
            Cantidad Total de Entradas Vendidas por función N 
-----------
Cantidad total Vendida por evento 1
……...
……...
……..
NOMBRE Evento N
Fecha función 1
Sector 1                                 Cantidad Vendida
Sector N                                 Cantidad Vendida
-----------
            Cantidad Total de Entradas Vendidas por función 1
Fecha función N
Sector 1                                 Cantidad Vendida
Sector N                                 Cantidad Vendida
-----------
            Cantidad Total de Entradas Vendidas por función N 
-----------
Cantidad total Vendida por evento N}


program parcialSegundaFecha;
const 
    valor_alto = 'ZZZZZZ';
type
    reg= record
        nombreEvento: string;
        fechaFuncion: string;
        SectorFuncion: string;
        cantidadEntradasVendidas: integer;
    end;
    arch =  file of reg;
 

procedure leer(var a:arch; var r : reg);
begin
    if (not eof (a)) then
        read(a,aux)
    else
        r.nombreEvento:= valor_alto;     
end;


procedure asignar (var archi: arch);
begin
    assign(archi, 'archivoVentas.bin');
end;


procedure listar(var a : arch);
var
    aux, act: reg;
    totFecha, totEvento :Integer;
begin
    reset(a);
    leer(a,aux);
    while (aux.nombreEvento<>valor_alto) do begin
        act.nombreEvento := aux.nombreEvento;
        totEvento:= 0;
        writeln('NOMBRE EVENTO: ', act.nombreEvento);
        while (act.nombreEvento = aux.nombreEvento) do begin
            totFecha:= 0;
            act.fechaFuncion:= aux.fechaFuncion;
            writeln('FECHA FUNCION: ', act.fechaFuncion);
            while ((act.nombreEvento = aux.nombreEvento) and (act.fechaFuncion = aux.fechaFuncion)) do begin
                act.cantidadEntradasVendidas:= aux.cantidadEntradasVendidas;
                act.SectorFuncion:= aux.SectorFuncion;
                totFecha := totFecha + act;
                Writeln('Sector: ', act.SectorFuncion, ' Cantidad Vendida: ', act.cantidadEntradasVendidas);
                leer(a, aux);
            end;
            totEvento:= totEvento + totFecha;
            writeln('Cantidad Total de Entradas Vendidas por función: ', totFecha);
        end;
        writeln('Cantidad total Vendida por evento: ', totEvento);
    end;
    close(a);    
end;

var
    a: arch;
begin
    asignar(a);
    listar(a);
end.