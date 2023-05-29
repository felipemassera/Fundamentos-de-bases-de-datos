{1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}

procedure bajas(var a: archivo; numLegajo:integer);
var
  aux: registro; pos:integer;
begin
  reset(a);
  leer(a,aux);
  while ((aux.legajo <> valorAlto)and(aux.legajo<>numLegajo)) do leer(a,aux);
  if aux.legajo=numLegajo then begin
    pos:= FilePos(a)-1;
    if (pos<>FileSize(a)-1) then begin
        seek(a, FileSize(a)-1);
        read(a,aux);
        seek(a,pos);
        write(a,aux);
        seek(a, FileSize(a)-1);
    end;
    Truncate(a);
    write('Archivo borrado con exito');
  end else WriteLn('no se encontro el dato');
end;
