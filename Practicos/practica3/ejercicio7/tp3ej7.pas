{7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. 

Realice un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros.

 Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 5000}

program tp3ej7;
const 
    valor_alto= 5000;
type
    aves = record
        cod:Integer;
        nombre: string;
        familia: string;
        descipcion: string;
        zona: string;
    end;
    archivo = file of aves;

Procedure leer(Var a:archivo; Var p :aves);
Begin
  If (Not eof(a)) Then
    read(a,p)
  Else
    p.cod := valor_alto;
End;

procedure compactar(var a:archivo);
Var 
    aux: aves;
    pos:integer;
begin
    reset(a);
    leer(a,aux);
    while (aux.cod<>valor_alto) do begin
        if (aux.nombre[1]='@') then begin
            pos:= filepos(a)-1;
            seek(a, FileSize(a)-1);
            read(a,aux);
            seek(a, FileSize(a)-1);
            truncate(a);
            seek(a,pos);
            write(a,aux);
            seek(a,filePos(a)-1);
        end;
        leer(a,aux);
    end;
    close(a);
    WriteLn('***FIN COMPACTAR MAESTRO***');
end;

procedure procesar(var a :archivo);
    procedure eliminarLogica(var a : archivo; cod : integer);
    var
        aux:aves;
    begin
        reset(a);
        leer(a,aux);
        while ((aux.cod<>valor_alto)and(aux.cod<>cod)) do leer(a,aux);
        if ((aux.cod = cod) and (aux.nombre[1]<>'@'))then begin
            aux.nombre:= '@'+aux.nombre;
            WriteLn('eliminar', aux.nombre[1]);
            seek(a,FilePos(a)-1);
            Write(a,aux);
        end else WriteLn('Codigo de ave no encontrada');
        close(a);
    end; 
var
    cod_usuario: integer;
begin
    writeln('Ingrese el codigo del ave a eliminar');
    readln(cod_usuario);
    while (cod_usuario<>valor_alto) do begin
            eliminarLogica(a,cod_usuario);
        writeln('Ingrese el codigo del ave a eliminar');
        readln(cod_usuario);
    end;
    WriteLn('***FIN DE ELIMINAR AVES***')
end;

Procedure listarArchivo(Var a:archivo);
Var 
  aux: aves;
Begin
  reset(a);
  While Not eof(a) Do
    Begin
      read(a,aux);
      WriteLn('Codigo: ',aux.cod,', Descripcion: ', aux.descipcion,' Nombre: ', aux.nombre);
    End;
  close(a);
  WriteLn('### Fin Listar Archivo ###');
End;

var
    a:archivo;
begin
    assign(a, 'tp3ej7');
    listarArchivo(a);
    procesar(a);
    listarArchivo(a);
    compactar(a);
    listarArchivo(a);
end.