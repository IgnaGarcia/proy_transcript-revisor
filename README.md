# SpeechToTextIBM
Programa en Python que consuma API de IBM Watson para la transcripcion de archivos

- **Instalar Python y marcar "Agregarl a PATH"**
https://www.python.org/downloads/

- **Instalar dependencias PIPENV y levantar entorno virtual, por cmd ejecutar**
```
pip install pipenv

pipenv install
```

- **Crearse una cuenta en**
https://cloud.ibm.com/

    y obtener una KEY y URL para el servicio
    https://cloud.ibm.com/catalog/services/speech-to-text

- **Ejecutar**
```
pipenv run python transcriptor.py INPUT_DIR OUTPUT_DIR
```
---
# Guia de uso para pipenv
- **Agregar dependencias** 
```
pipenv install {PAQUETE}
```
- **Si agregas nuevas dependencias no te olvides de plasmarlas en el .lock**
```
pipenv lock 
```
- **Si queres borrar el entorno virtual**
```
pipenv --rm
```