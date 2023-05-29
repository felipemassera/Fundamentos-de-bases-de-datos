{7. Se cuenta con un archivo que almacena información sobre especies de aves en
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

program baja_logica_compactar;
type
	aves = record
  	codigo:integer;
		nombre_especie : string;
		familia_ave: string;
		descripcion: string;
		zona_geografica: string;
	end;
	archivo = file of aves;

procedure bajaLogica(var a:archivo);
var
  aux : aves;
begin
	writeln('ingrese el cod de la ave para dar de baja.');
	readln(cod);
	reset(a);
	while ((not eof(a))and(aux.codigo<>cod)) do read(a,aux);
	if(aux.codigo = cod) then begin
		aux.nombre_especie[1]:= '@';
		seek(a, FilePos(a)-1);
		write(a,aux);
	end;
	close(a);
end;

procedure compactar(var a:archivo ; var b:archivo);
var
  aux:aves;
begin
  reset(a);
  while (not eof (a)) do begin //////////////////////////SEGUIRLA
	read(a,aux);
	if(aux.nombre_especie[1]= '@') then begin
	  pos:= FilePos(a)-1;
	  seek

	  
	end;
  end;
end;

var
  a:archivo;
begin
	assign(a,'aves');
	bajaLogica(a);
	compactar(a);
end.