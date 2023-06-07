{Dada la siguiente estructura:
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descripta anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}

program alta_tablaInvertida_listar;
type
    reg_flor = record
      nombre: String[45];
      codigo:integer;
    end;
    tArchFlores = file of reg_flor;

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
  cabecera,f:reg_flor; pos:integer;
begin
  f.codigo:= codigo;
  f.nombre:= nombre;
  reset(a);
  read(a,cabecera);
  if (cabecera.codigo < 0) then begin
    pos:= cabecera.codigo*-1;
    seek(a,pos);
    read(a,cabecera);
    seek(a,pos);
    write(a,f);
    seek(a,0);
    write(a,cabecera);
  end else begin
    seek(a,FileSize(a));
    write(a,f);
  end;
  close(a);
  WriteLn('***Flor agregada con exito!***');
end;

procedure listarArchivo(var a: tArchFlores);
var
  aux:reg_flor;
  txt: text;
begin
  Assign(txt,'reporte.txt');
  reset(a);
  rewrite(txt);
  while (not eof(a)) do begin
    read(a,aux);
    if (aux.codigo>0) then
      writeln(txt,aux.codigo, ' ', aux.nombre);
  end;
  close(a);
  close(txt);
  WriteLn('### Fin Listar Archivo ###');
end;