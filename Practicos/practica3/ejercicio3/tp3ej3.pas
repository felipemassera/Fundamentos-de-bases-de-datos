{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}

program tp3ej3;
const   
    valor_alto = 9999;
type
    novela = record
        genero: string;
        nombre: string;
        director: string;
        cod:integer;
        dura: integer;
        precio: integer;
    end;
    archivo = file of novela;

procedure leer( var a: archivo; var aux : novela);
begin
    if not eof (a) then
        read(a,aux)
    else
        aux.cod:= valor_alto;
end;

procedure leerNovela(var aux:novela);
begin
    Write('Ingrese el codigo de novela: ');
    readln(aux.cod);
    if aux.cod<>9999 then begin
        Write('Ingrese nombre de la Novela: ');
        ReadLn(aux.nombre);
        Write('Ingrese genero de la Novela: ');
        ReadLn(aux.genero);
        Write('Ingrese director de la Novela: ');
        ReadLn(aux.director);
        aux.precio := random(100)+1;
        aux.dura := random(900);
    end;
end;

procedure crearArchivo(var a:archivo);
var
    aux: novela;
begin
    Rewrite(a);
    aux.cod:= 0;
    Write(a,aux);
    leerNovela(aux);
    while (aux.cod<>9999) do begin
        Write(a,aux);
        leerNovela(aux);
        
    end;
    WriteLn('Archivo creado con exito!');
    close(a);
end;

procedure altaNovela(var a:archivo);
var
    n,aux: novela;
    pos: integer;
begin
    leerNovela(n);
    reset(a);
    leer(a,aux);
    if aux.cod = 0 then begin
        seek(a, FileSize(a));
        Write(a,n);
    end 
    else begin
        pos:= aux.cod * -1;
        seek(a,pos);
        read(a,aux);
        seek(a,Filepos(a)-1);
        Write(a,n);
        seek(a,0);  //cabecera =0
        write(a,aux);
    end;
    WriteLn('Novela creado con exito!');
    close(a);
end;

procedure modificarNovela(var a:archivo);
var
    aux:novela;
    cod:Integer;
begin
    reset(a);
    WriteLn('Ingrese el codigo de la novela a modificar');
    readln(cod);
    leer(a,aux);
    while ((aux.cod<>valor_alto) and (aux.cod<>cod)) do
        leer(a,aux);
    if aux.cod = cod then begin
        WriteLn('*************************************');
        WriteLn('MODIFICACION : ');
        Write('Ingrese nombre de la Novela: ');
        ReadLn(aux.nombre);
        Write('Ingrese genero de la Novela: ');
        ReadLn(aux.genero);
        Write('Ingrese director de la Novela: ');
        ReadLn(aux.director);
        aux.precio := random(100)+1;
        WriteLn('*************************************');
        Seek(a, filepos(a)-1);
        write(a,aux);
        WriteLn('***Modificacion realizada con exito***');
    end else WriteLn('XXX Codigo de novela no encontrado XXX'); 
    close(a);
end;


procedure mostrarArchivo(var a:archivo);
var
    aux:novela;
begin
    reset(a);
    leer(a,aux);
    while aux.cod <> valor_alto do begin
        if aux.cod>=0 then 
            WriteLn('Codigo: ',aux.cod,' , Nombre: ',aux.nombre ,' , Director: ', aux.director, ' Genero: ', aux.genero)
        else WriteLn('Codigo: ',aux.cod);
        leer(a,aux);
    end;
    WriteLn('***Fin Archivo***');
    close(a);
end;

procedure eliminarNovela(var a:archivo);
var
    aux,cabecera:novela;
    swap,codEli:integer;
    ok: boolean;
begin
    reset(a);
    ok:=False;
    leer(a,cabecera);
    aux:=cabecera;
    WriteLn('ingrese el codigo de la novela que desea Eliminar: ');
    read(codEli);
    while ((aux.cod<>valor_alto) and (aux.cod<> codEli)) do begin
        leer(a,aux);
    end;
    if (aux.cod<>valor_alto)then
    begin
        swap:= (filepos(a)-1)*-1;
        seek(a,filepos(a)-1);
        Write(a,cabecera);
        cabecera.cod:= swap;
        seek(a,0);
        write(a,cabecera);
        ok:=true
    end else   WriteLn('El Codigo de novela no fue encontrado');
    if ok then WriteLn('Eliminacion hecha con exito');
    close(a)
end;

procedure listarTXT(var a :archivo);
Var 
    t : text;
    aux: novela;
begin
    assign(t,'novelas.txt');
    reset(a);
    Rewrite(t);
    read(a,aux);
    while not eof(a) do begin
        Write(t,'Codigo: ',aux.cod,' , Nombre: ',aux.nombre ,' , Director: ', aux.director, ' Genero: ', aux.genero);
        read(a,aux);
    end;
    WriteLn('***Fin listar novela***');
end;

procedure menu(var a:archivo);
    procedure listaMenu();
    begin
        WriteLn('*************************************');
        WriteLn('Que accion desea realizar?');
        WriteLn('1- Crear Archivo Maestro');
        WriteLn('2- Dar de altaNovela');
        WriteLn('3- Modificar novela');
        WriteLn('4- Eliminar novela');
        WriteLn('5- Mostrar Archivo');
        WriteLn('6- Listar novelas a TXT');
        WriteLn('7- Salir');
        WriteLn('*************************************');
    end;
var 
    opcion:Integer;
begin
repeat
    listaMenu();
    readln(opcion);
    case opcion of
        1 : crearArchivo(a);
        2 : altaNovela(a);
        3 : modificarNovela(a);
        4 : eliminarNovela(a);
        5 : mostrarArchivo(a);
        6 : listarTXT(a);
        7 : WriteLn('Saliste!');
        else WriteLn('Opcion incorrecta!');
        end;
until opcion=7;
end;

var
    a:archivo;
begin
    assign(a,'tp3ej3');
    menu(a);
end.
















