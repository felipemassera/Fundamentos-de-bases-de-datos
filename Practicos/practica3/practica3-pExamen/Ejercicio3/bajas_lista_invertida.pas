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

program bajas_lista_invertida;
type
    novela = record
        cod: integer;
        genero: String;
        nombre:String;
        duracion:integer;
        director:string;
        precio: integer;
    end;
    archivo= file of novela;

procedure eliminarNovela(var a:archivo);
var
  aux,cabecera:novela; cod:integer;
begin
  reset(a);
  WriteLn('ingrese el cod de la novela a eliminar.');
  ReadLn(cod);
  read(a,cabecera);
  while ((not eof(a))and(aux.cod <> cod)) do read(a,aux);
  if (aux.cod = cod) then begin
    pos:= (FilePos(a)-1)*-1;
    seek(a, FilePos(a)-1);
    aux.cod:=cabecera.cod;
    Write(a,aux);
    cabecera.cod:= pos;
    seek(a, 0); //cabecera =0
    write(a,cabecera);
    WriteLn('Eliminacion hecha con exito');
  end else
    WriteLn('novela no encontrada.');
end;


procedure crearNovela(var n:novela; ok:boolean);
begin
  WriteLn('*************************************');  
  if ok then
    WriteLn('codigo novela: ');
    read(n.cod);
  if(n.cod>0)then begin
    WriteLn('genero:');
    read(n.genero);
    WriteLn('nombre:');
    read(n.nombre);
    WriteLn('duración:');
    read(n.duracion);
    WriteLn('director:');
    read(n.director);
    WriteLn('precio:');
    read(n.precio);
    if ok then write('creacion de novela! ')
    else write('modificacion de novela! ')
  end;
  if (n.cod<0) then
    writeln('Novela no creada!');
  WriteLn('*************************************');
end;

procedure modificarNovela(var a:archivo);
var
  n:novela; cod:integer;
begin
  reset(a);
  WriteLn('ingresar cod novela a modificar');
  read(cod);
  while((not eof(a))and(n.cod<>cod))do
    read(a,n);
  if(n.cod = cod) then begin
    crearNovela(n,false);
    seek(a,filepos(a)-1);
    write(a,n);
    WriteLn('***Modificacion realizada con exito***');
  end else 
    write('novela no encontrada.');
  close(a);
end;

procedure altaNovela(var a:archivo);
  	procedure agregarNovela(var a: archivo; pos :integer; n:novela);
  	//agrega novela aprovechando si hay espacios eliminados en el archivo
  	var
  	  aux1 : novela;
  	begin
  	  if(pos<0) then begin
  	    pos:= pos *-1;
  	    seek(a,pos);
  	    Read(a,aux1);
  	    Seek(a,pos);
  	    write(a,n);
  	    seek(a,0); //cabecera =0
  	    write(a,aux1);
  	  end
  	  else begin
  	    seek(a,filesize(a));
  	    write(a,aux);
  	  end;
  	end;
var
    aux:novela;
    pos:integer;
begin    
    reset(a);
    read(a,aux);
    pos:= aux.cod;
    crearNovela(aux,true);
    agregarNovela(a,pos,aux);
    close(a);
end;


procedure crearArchivo(var a: archivo);
var 
    aux: novela;
begin
    Rewrite(a);
    aux.cod:=0;
    Write(a,aux);
    crearNovela(aux,true);
    while (aux.cod>0)do begin
      write(a,aux);
      crearNovela(aux,true);
    end;
    WriteLn('Archivo creado con exito!');
    close(a);
end;

procedure listarArchivo(var a:archivo);
var
  aux:novela;
  txt:Text;
begin
  assign(txt,'novelas.txt');
  Rewrite(txt);
  reset(a);
  while (not eof(a)) do begin
    read(a,aux);
    writeln(txt,aux.cod,aux.duracion);
    WriteLn(txt,aux.genero);
    WriteLn(txt,aux.nombre);
    WriteLn(txt,aux.director);
  end;
  close(a);
  close(txt);
end;

procedure menu();
    procedure menuTxt();
    begin
      writeln('//////////////////-*MENU*-\\\\\\\\\\\\\\\\\\\\\\');
      writeln('1- CREAR archivo');
      writeln('2- ALTA novela');
      writeln('3- MODIFICAR novela');
      writeln('4- ELIMINAR novelA');
      writeln('5- LISTAR novelA');
      writeln('6- ELIMINAR novelA');
      writeln('************************************************');
    end;
var
    a:archivo;
    menu:integer;
    ok:boolean;
begin
    Assign(a,'archivo');
    repeat
        menuTxt();
        readln(menu);
        ok:=false;
        case menu of:
          1: crearArchivo(a);
          2: altaNovela(a);
          3: modificarNovela(a);
          4: eliminarNovela(a);
          5: listarArchivo(a);
         else ok:=true;
        end;
    until ok;
    close(a);
    WriteLn('SALISTE');
end;

begin
    menu();
end.