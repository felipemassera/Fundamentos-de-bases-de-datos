
{ 1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y
permita
incorporar datos al archivo. Los números son ingresados desde teclado. El
nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese  número 30000, que no debe incorporarse al archivo.}

Program p1ej1;

Type 
  archivo = file Of integer;

Procedure leerInts(Var arch : archivo);

Var 
  aux: Integer;
Begin
  write('ingrese un numero (salimos con 30k)');
  read(aux);
  While (aux <> 30000) Do
    Begin
      write(arch, aux);
      read(aux);
    End;
End;

Var 
  arch: archivo;
  nombre: String;
Begin
  write('ingresar el nombre del archivo: ');
  read(nombre);
  assign(arch, nombre);
  rewrite(arch);
  leerInts(arch);
  close(arch);
End.
