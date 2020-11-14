# SpeechToTextVOSK
Transcripcion de voz a texto con la biblioteca VOSK y modelos del lenguaje/acusticos en español


## 1- Instalar Python 64bits y marcar "Agregarl a PATH"  
	
https://www.python.org/downloads/

	Corroborar en consola: python -V


## 2- Instalar dependencias de VOSK:

pip3 install vosk

	Corroborar en consola: pip show vosk


## 3-Descargar ffmpeg para convertir archivos de audio

https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-2020-11-11-git-89429cf2f2-essentials_build.7z

### 3.1 Descomprimir y renombrar por "ffmpeg"
### 3.2 Mover a carpeta familiar. Ej: C:\ProgramFiles
### 3.3 Agregar al Path 
3.3.1 Configuracion Avanzada del Sistema
3.3.2 Variables de Entorno
3.3.3 Variables de Sistema = "Path"
3.3.4 Editar
3.3.5 Agregar la ruta donde se guardo la carpeta ffmpeg concatenando \bin
3.3.6 Aceptar...

	Corroborar en consola: ffmpeg -version


## 4-Ejecutar desde cmd con el comando:
	
	py ./transciptor.py ARCHIVO

 reemplazancho ARCHIVO por el nombre del archivo y su extension
