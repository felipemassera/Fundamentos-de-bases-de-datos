{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program tp3ej2;
const
    valor_alto = 9999;
type
    asistente = record
        nro: integer;
        apellido : string;
        nombre: string;
        email: string;
        tel: integer;
        dni: integer;
    end;
    archivo = file of asistente;
procedure crearArchivo(var a : archivo);


var
    aux: asistente;
begin
    Rewrite(a);
    WriteLn('ingrese apellido');
    readln(aux.apellido);
    while (aux.apellido <> 'fin') do begin  
        WriteLn('ingrese nombre');
        readln(aux.nombre);
        WriteLn('ingrese email');
        readln(aux.email);
        WriteLn('ingrese NRO');
        readln(aux.nro);
        //WriteLn('ingrese telefono');
        aux.tel:= random(9999);
        //WriteLn('ingrese dni');
        aux.dni:= random(1001);
        write(a,aux);
        WriteLn('ingrese apellido');
        readln(aux.apellido);
    end;
    close(a);
end;
procedure eliminar(var a:archivo);
    procedure leer(var a: archivo;var aux : asistente);
    begin
        if (not eof (a))then
            read(a,aux)      
        else
            aux.nro := valor_alto;
    end;
var
    aux: asistente;
begin
    reset(a);
    leer(a,aux);
    while aux.nro <> valor_alto do begin
        if aux.nro < 1000 then begin
            aux.apellido:= '@'+aux.apellido;
            seek(a,FilePos(a)-1);
            Write(a,aux);
        end;
        leer(a,aux);
    end;
end;

procedure mostrarArchivo(var a:archivo);
var
    asist : asistente;
begin
    reset(a);
    while( not eof(a)) do
    begin
        read(a, asist);
        writeln('Nombre: ', asist.nombre, ' Apellido: ', asist.apellido, ' Numero: ', asist.nro);
    end;
    close(a);
end;

var
    a : archivo;
begin
    Assign(a, 'maestro');
    crearArchivo(a);
    mostrarArchivo(a);
    writeln('');
    eliminar(a);
    mostrarArchivo(a);
end.
