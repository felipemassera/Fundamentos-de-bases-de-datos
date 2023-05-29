{Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
{Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente}


procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
  aux,cabecera: reg_flor; pos:integer;
begin
  reset(a);
  read(a,cabecera);
  while ((not eof(a))and(aux.codigo<>flor.codigo)) do read(a,aux);
  if aux.codigo=flor.codigo then begin
    pos:= (FilePos(a)-1)*-1;
    seek(a,FilePos(a)-1);
    write(a,cabecera);
    seek(a,0); //cabecera = 0
    cabecera.codigo:=pos;
    write(a,cabecera);
  end;
  close(a);
end;

begin
end.