
program tp3ej4ej5;
const
    valor_alto=9999;
type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;
    tArchFlores = file of reg_flor;

procedure leer(var a:tArchFlores; var f: reg_flor);
begin
  if (not eof (a))then 
    read(a,f)
  else
    f.codigo:= valor_alto;
end;

{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descripta anteriormente}
procedure agregarFlor(var a: tArchFlores; nombre: string; codigo: integer);
var
    f,aux: reg_flor;
    pos: integer;
begin
    reset(a);
    f.nombre:=nombre;
    f.codigo:=codigo;
    read(a,aux);
    if (aux.codigo = 0) then begin
        seek(a, FileSize(a));
        Write(a,f);
    end else begin
        pos:= aux.codigo * -1;
        seek(a, pos);
        read(a,aux);
        seek(a,FilePos(a)-1);
        write(a,f);
        seek(a,0);
        write(a,aux);
    end;
    close(a);
    WriteLn('***Flor agregada con exito!***');
end;

{Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente}
Procedure eliminarFlor (Var a: tArchFlores; flor:reg_flor);
var
    cabecera,aux : reg_flor;
    swap :integer;
begin
    reset(a);
    leer(a,cabecera);
    aux := cabecera;
    while ((aux.codigo <> valor_alto) and (aux.codigo<>flor.codigo))do leer(a,aux);
    if (aux.codigo<>valor_alto) then begin
        swap := (FilePos(a)-1) * -1;
        seek(a,filepos(a)-1);
        write(a,cabecera);
        cabecera.codigo:= swap;
        seek(a,0);
        write(a,cabecera);
        WriteLn('*** Flor eliminada ***')
    end else WriteLn('XXX Codigo de flor no encontrada XXX');
    close(a);
end;

procedure listarArchivo(var a:tArchFlores);
var
    aux:reg_flor;
begin
    reset(a);
    while not eof(a) do begin
        read(a,aux);
        if (aux.codigo>0) then 
            WriteLn('Codigo: ',aux.codigo,', Nombre Flor: ', aux.nombre);
    end;
    close(a);
    WriteLn('### Fin Listar Archivo ###');
end;

procedure crearArchivo(var a : tArchFlores);
    procedure leerFlor(var f:reg_flor);
    begin
        write('Codigo : ');
        ReadLn(f.codigo);
        if f.codigo<>9999 then begin
            Write('Nombre : ');
            ReadLn(f.nombre);
        end;
    end;
var
    aux: reg_flor;
begin
    Rewrite(a);
    aux.codigo:=0;
    aux.nombre:= ' ';
    write(a,aux);
    leerFlor(aux);
    while (aux.codigo<>9999) do begin
        Write(a,aux);
        leerFlor(aux);
    end;
    close(a);
    WriteLn('### Archivo creado con exito ###');
end;

Procedure menu(Var a:tArchFlores);
    Procedure listaMenu();
    Begin
        WriteLn('*************************************');
        WriteLn('Que accion desea realizar?');
        WriteLn('1- Crear Archivo Maestro');
        WriteLn('2- Agregar Flor');
        WriteLn('3- Eliminar Flor');
        WriteLn('4- Mostrar Archivo');
        WriteLn('5- Salir');
        WriteLn('*************************************');
    End;
Var 
  aux:reg_flor;
  opcion,codigo: Integer;
  nombre: string;
Begin
  Repeat
    listaMenu();
    readln(opcion);
    Case opcion Of 
      1 : crearArchivo(a);
      2 : begin 
            Write('ingrese el nombre de la flor: ');
            ReadLn(nombre);
            Write('Ingresar el codigo: ');
            ReadLn(codigo);
            agregarFlor(a,nombre,codigo);
          end;
      3 : begin
            WriteLn('Ingresar el codigo de la flor a eliminar');
            read(aux.codigo);
            eliminarFlor(a,aux);
          End;
      4 : listarArchivo(a);
      5 : WriteLn('Saliste!');
      Else WriteLn('Opcion incorrecta!');
    End;
  Until opcion=5;
End;

var
    a: tArchFlores;
begin
    assign(a,'tp3ej4ej5');
    menu(a);
end.