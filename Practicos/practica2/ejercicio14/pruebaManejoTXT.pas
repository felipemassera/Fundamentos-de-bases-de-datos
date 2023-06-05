program pruebaManejoTXT;
type
    reg = record
        dest: string;
        fecha: string;
        cant:integer;
        valor:integer;
    end;

procedure listar(var t:text);
var
  r:reg;
begin
    reset(t);
    while not eof(t) do begin
        readln(t,r.dest);
        Writeln(r.dest);
        readln(t,r.fecha);
        Writeln(r.fecha);
        readln(t,r.cant);
        Writeln(r.cant);
        readln(t,r.valor);
        Writeln(r.valor);
    end;
    close(t);
end;

var
    t : Text;
begin
  assign(t, 'detalle.txt');
  listar(t);
  reset(t);
  Writeln('preAPPEND');
  Append(t);
  listar(t);
end.