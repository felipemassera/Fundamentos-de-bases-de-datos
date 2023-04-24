{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.

Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
}

program tp3ej8;
const
    valor_alto= 'ZZZZ';
type
    distros = record
        nombre: String;
        anio:integer;
        nKernel: integer;
        cantDevs: integer;
        desc: String;
    end;
    archivo = file of distros;

procedure leer(var a :archivo; var aux: distros);
begin
    if (not eof (a)) then
        read(a,aux)
    else
        aux.nombre:= valor_alto;
end;

//ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
//la distribución existe en el archivo o falso en caso contrario.
function existeDistribucion(var a:archivo; nombre: string):boolean;
var
    aux : distros;
begin
    reset(a);
    leer(a,aux);
    while (aux.nombre<>valor_alto)and(aux.nombre<>nombre) do leer(a,aux);
    close(a);
    existeDistribucion:=(aux.nombre=nombre)
end;

{AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.}
procedure altaDistribucion(var a:archivo);
    procedure terminarLeer(var aux: distros);
    begin
      WriteLn('Ingrese Anio de Distribucion: ');
      readln(aux.anio);
      WriteLn('Ingrese Numero de Kernel: ');
      readln(aux.nKernel);
      WriteLn('Ingrese Cantidad de desarrolladores: ');
      readln(aux.cantDevs);
      WriteLn('Ingrese Descripcion: ');
      readln(aux.desc);
    end;
var
    aux, encabezado:distros;
    pos:integer;
begin
    WriteLn('ingrese el nombre de la distribucion para dar alta');
    readln(aux.nombre);
    if(not existeDistribucion(a,aux.nombre)) then begin
        terminarLeer(aux);
        reset(a);
        leer(a,encabezado);
        if(encabezado.cantDevs = 0)then begin
            seek(a,FileSize(a));
            write(a,aux);
        end else begin
            pos:= (encabezado.cantDevs * -1);
            seek(a, pos);
            read(a,encabezado);
            seek(a, FilePos(a)-1);
            Write(a,aux);
            seek(a,0);
            write(a,encabezado);
        end;
        close(a);
        WriteLn('**** Dato dado de alta****');
    end else WriteLn('Ya existe la distribucion');
end;

{BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”.}
procedure bajaDistribucion(var a:archivo);
var
    pos:Integer;
    aux,encabezado: distros;
    n_teclado:string;
begin
    WriteLn('Ingrese el nombre de la distro que desea borrar');
    readln(n_teclado);
    WriteLn('RES: ',existeDistribucion(a,n_teclado));
    If (existeDistribucion(a,n_teclado)) then begin  
        reset(a);
        leer(a,encabezado);
        aux.nombre:=encabezado.nombre;
        while(aux.nombre<>n_teclado)do leer(a,aux);        
            pos:= (filepos(a)-1) *-1;
            seek(a, FilePos(a)-1);
            write(a,encabezado);
            encabezado.cantDevs:=pos;
            seek(a,0);
            Write(a,encabezado);
            WriteLn('***Baja con exito***');
        Close(a);
    end else WriteLn('XXX NO existe la distribucion que desea Borrar XXX');
end;

Procedure listarArchivo(Var a:archivo);
Var 
  aux: distros;
Begin
  reset(a);
  While Not eof(a) Do
    Begin
      read(a,aux);
      WriteLn('Nombre: ',aux.nombre,', NumKernel: ', aux.nKernel,' CantDevs: ',aux.cantDevs);
    End;
  close(a);
  WriteLn('### Fin Listar Archivo ###');
End;

Procedure crearArchivo(Var a : archivo);
Var 
  t: Text;
  aux: distros;
Begin
  assign(t,'tp3ej8.txt');
  reset(t);
  Rewrite(a);
  While Not eof(t) Do
    Begin
      readln(t,aux.nombre);
      ReadLn(t,aux.anio,aux.nKernel,aux.cantDevs,aux.desc);
      write(a,aux);
    End;
  close(a);
  close(t);
  writeln('*****Archivo creado con exito*****');
End;


Procedure menu(Var a:archivo);
Procedure listaMenu();
Begin
  WriteLn('*************************************');
  WriteLn('Que accion desea realizar?');
  WriteLn('1- Crear Archivo Maestro');
  WriteLn('2- Alta Distribucion');
  WriteLn('3- Baja Distribucion');
  WriteLn('4- Mostrar Archivo');
  WriteLn('5- Salir');
  WriteLn('*************************************');
End;

Var 
  aux: distros;
  opcion,codigo: Integer;
  nombre: string;
Begin
  Repeat
    listaMenu();
    readln(opcion);
    Case opcion Of 
      1 : crearArchivo(a);
      2 : altaDistribucion(a);
      3 : bajaDistribucion(a);
      4 : listarArchivo(a);
      5 : WriteLn('Saliste!');
      Else WriteLn('Opcion incorrecta!');
    End;
  Until opcion=5;
End;
var
    a:archivo;
begin
    Assign(a, 'tp3ej8');
    menu(a);
end.