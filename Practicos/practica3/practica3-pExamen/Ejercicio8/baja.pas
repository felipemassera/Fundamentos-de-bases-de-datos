{Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. 
(El control deunicidad lo debe realizar utilizando el módulo anterior). 
En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”.}

program baja;
type
  distro = record
    nombre : string;
    ano_lanzamiento : Integer;
    kernel : integer;
    nDesarrolladores : integer;
    descripcion : string;
  end;
  archivo = file of distro;

{ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.}
function existeDistribucion(var a: archivo; nombre:String) : boolean;
var
  aux : distro;
begin
  reset(a);
  while ((not eof (a)) and (aux.nombre <> nombre)) do read(a,aux);
  close(a);
  existeDistribucion:= (aux.nombre = nombre);
end;

{AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. 
(El control deunicidad lo debe realizar utilizando el módulo anterior). 
En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.}

procedure AltaDistribucion(var a: archivo);
  procedure terminarDistro(var aux:distro);
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
  aux,cabecera : distro;
begin
  WriteLn('Ingrese el nombre de la distribucion');
  read(aux.nombre);
  if (not existeDistribucion(a,aux.nombre)) then begin
    terminarDistro(aux);
    reset(a);
    read(a,cabecera);
    if (cabecera.nDesarrolladores < 0) then begin
      seek(a, (cabecera.nDesarrolladores*-1));
      read(a,cabecera);
      seek(a, FilePos(a)-1);
      write(a,aux);
      seek(a,0); //me muevo a la cabecera
      write(a,cabecera);
    end else begin
      seek(a, FileSize(a));
      write(a,aux);
    end;
  end else write('La distribucion ya existe');
  close(a);  
end;


{BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”}
procedure bajaDistribucion(var a:archivo);
var
  aux, cabecera : distro; nombre:string;
begin
  WriteLn('Ingrese el nombre de la distro a eliminar: ');
  read (nombre);
  if (existeDistribucion(a,nombre)) then begin
    reset(a);
    read(a,cabecera);
    while (aux.nombre <> nombre) do read(a,aux);
    aux.nDesarrolladores := FilePos(a)-1 * -1;
    seek(a, FilePos(a)-1);
    write(a,cabecera);
    seek(a,0);
    write(a,aux);
    close(a);
  end else WriteLn('Distribucion no existente ');
end;
