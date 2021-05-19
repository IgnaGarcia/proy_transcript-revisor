# SpeechToTextVOSK
Transcripcion de voz a texto con la biblioteca VOSK y modelos del lenguaje/acusticos en español


## 1- Instalar Python 64bits y marcar "Agregarl a PATH"  
	
https://www.python.org/downloads/

	Corroborar en consola: python -V


## 2- Instalar dependencias de VOSK:

python -m pip install cffi
pip3 install vosk

	Corroborar en consola: pip show vosk


## 3-Ejecutar desde cmd con el comando:
	
	py ./transciptor.py ARCHIVO

 reemplazancho ARCHIVO por el nombre del archivo y su extension