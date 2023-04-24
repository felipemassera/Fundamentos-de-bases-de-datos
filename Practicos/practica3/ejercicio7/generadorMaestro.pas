Program generadorMaestro;
Type 
  datoMaestro = Record
    cod: integer;
    nombre: string;
    familia: string;
    descripcion: string;
    zona: string;
  End;
Var 
  archivoTexto: text;
  archivoBinario: file Of datoMaestro;
  registro: datoMaestro;

Begin
  // Abrir archivo de texto en modo lectura
  assign(archivoTexto, 'tp3ej7.txt');
  reset(archivoTexto);

  // Crear archivo binario en modo escritura
  assign(archivoBinario, 'tp3ej7');
  rewrite(archivoBinario);

  // Leer datos del archivo de texto y escribirlos en el archivo binario
  While Not eof(archivoTexto) Do
    Begin
      // Leer datos del archivo de texto
      readln(archivoTexto, registro.cod,registro.nombre);
      readln(archivoTexto, registro.familia);
      readln(archivoTexto, registro.descripcion);
      readln(archivoTexto, registro.zona);

      // Escribir datos en el archivo binario
      write(archivoBinario, registro);
    End;

  // Cerrar archivos
  close(archivoTexto);
  close(archivoBinario);

  writeln('Datos convertidos a binario exitosamente.');
End.
