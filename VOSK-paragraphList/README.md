# USO:
python vosklist.py -i <input_file> -o <output_file> [-c] [-d]

**<input_file>** = direccion del archivo json a listar su contenido 
<output_file> = direccion y nombre del archivo txt de salida, por defecto es ./plist.txt
-c = indica que la salida sera solo texto, sin etiquetas, omitira el -s 
-d = numero que indica la diferencia minima en segs que debe haber para crear un nuevo parrafo, por defecto 0.8 