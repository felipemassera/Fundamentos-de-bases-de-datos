{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program bajas2;
const
    valorAlto =9999;
type
    asistente = record
        nro : integer;
        apellidoYnombre: string;
        email:string;
        tel: integer;
        dni:integer;
    end;
    archivo = file of asistente;

procedure crearArchivo(var a :archivo);
    procedure leerAsistente(var a : asistente);
    begin
      writeln('("0" salimos) NRO: ');
      readLn(a.nro);
      if (a<>0) then begin
        writeln('Apellido y Nombre: ');
        readLn(a.apellidoYnombre);
        writeln('Email: ');
        readLn(a.email);
        writeln('TEL: ');
        readLn(a.tel);
        writeln('DNI: ');
        readLn(a.dni);
      end;
    end;
var
    aux:asistente;
begin
    Rewrite(a);
    leerAsistente(aux);
    while (aux.nro<>0) do begin
        write(a,aux);
        leerAsistente(aux);
    end;
    close(a);
end;

procedure baja(var a:archivo);
var
    aux:asistente
begin
  reset(a);
  while (not eof(a))do begin
    read(a,aux);
    if (aux.nro<1000) then begin
        aux.apellidoYnombre[1]:= '#';
        seek(a,FilePos(a)-1);
        Write(a,aux);
    end;
  end;
  close(a);
end;

var
    a:archivo;
begin
  assign(a,'archivo');
  crearArchivo(a);
  baja(a);
end.