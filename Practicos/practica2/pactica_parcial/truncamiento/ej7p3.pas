{Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}

program ej7p3;

const
    valor_alto = 9999;

type
    ave = record
        codigo:integer;
        nombre:string;
        familia:string;
        descripcion:string;
        zona:string;
    end;
    archivo = File of ave;

procedure leer(var a:archivo;var reg:ave);
begin
    if(not eof(a))then
        read(a,reg)
    else 
        reg:=valor_alto;
end;

procedure eliminar(var a:archivo);

    procedure buscarYmarcar(var mae:archivo ; buscado:integer ; var pude:boolean);
    var
        A:ave;
        posEliminado:integer;
    begin
        reset(mae);
        leer(mae, A);
        pude:= false;
        while(not eof(mae)) and (A.cod <> buscado) do 
            leer(mae, A);
        if (A.cod = buscado) then begin
            A.codigo:= A.codigo * -1;
            posEliminado:= filePos(mae)-1;
            seek(mae, posEliminado);
            write(mae, A);
            pude:= true;
        end;
        close(mae);
    end;

var
    aux:ave;
    cod:integer;
    pude:Boolean;
begin
    writeln('Ingrese el codigo de ave a eliminar');
    readln(cod);
    while (cod <> 50000) do begin
        buscarYmarcar(mae, cod, pude);
        if (pude) then
            writeln('Eliminacion del cod ', cod, ' fue exitosa')
        else
            writeln('El codigo buscado no se encuentra');
        writeln('Ingrese el codigo de ave a eliminar');
        readln(cod);
    end;
end;

procedure compactar(var a:archivo);
var
    A:ave;
    posEliminado:integer;
begin
    reset(a);
    while(not eof(a)) do begin
        read(a, A);
        if (A.codigo < 0) then begin
            posEliminado:= filepos(a)-1;
            seek(a, fileSize(a)-1);
            read(a,A);
            seek(a,FileSize(a)-1);
            Truncate(a);
            seek(a,posEliminado);
            write(a,A);
            seek(a, filepos(a)-1);
        end;
    end;
    close(a);
end;

var
    a:archivo;
begin
    assign(a,'archivo');
    eliminar(a);
    compactar(a);
end.