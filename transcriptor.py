import json
from os.path import join, dirname
from ibm_watson import SpeechToTextV1
from ibm_watson.websocket import RecognizeCallback, AudioSource
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator
import time


class MyRecognizeCallback(RecognizeCallback):
    def __init__(self):
        RecognizeCallback.__init__(self)

    def on_data(self, data):
        jsonDictonary = data  # Guardar el resultado como Dictionary
        # Convertir el resultado a un JSON Indentado para facil lectura
        jsonText = json.dumps(jsonDictonary, indent=2)

        print("\n\nGuardando resultado...")

        # Archivo para todo el resultado (Timestamps, Keywords, ETC)
        f = open("salida/data.json", "w")
        f.write(jsonText)  # Guardar el JSON Indentado
        f.close()

        # Archivo solo para las posibles transcripciones
        f = open("salida/transcripcion.txt", "w")
        i = 0

        for x in jsonDictonary['results']:
            f.write(x['alternatives'][0]['transcript'])
        f.close()

        print("\n\nPeticion exitosa! revisar en la carpeta raiz del repositorio")

    def on_error(self, error):
        print('\n\nError : {}'.format(error))

    def on_inactivity_timeout(self, error):
        print('\n\nInactividad en el audio : {}'.format(error))


tinicial = time.time()

# Inserte la key aqui
_key = 'IlPmRpIn1M-Twblnj0KF-J6N1e-nnhvxGhCEFGsebKDo'

# Inserte la url de su clave aqui
_url = 'https://api.us-south.speech-to-text.watson.cloud.ibm.com/instances/62725879-72ad-4e7b-a9bd-5597be5f13ec'

authenticator = IAMAuthenticator(_key)
speech_to_text = SpeechToTextV1(authenticator=authenticator)

speech_to_text.set_service_url(_url)
speech_to_text.set_disable_ssl_verification(True)

myRecognizeCallback = MyRecognizeCallback()

opcion = int(input(
    "Seleccione el tipo de archivo: \n\t1-mp3 \n\t2-flac \n\t3-ogg \n\t4-wav \n: "))
if opcion == 1:
    audioType = 'audio/'+'mp3'
    tipo = 'mp3'
elif opcion == 2:
    audioType = 'audio/'+'flac'
    tipo = 'flac'
elif opcion == 3:
    audioType = 'audio/'+'ogg'
    tipo = 'ogg'
elif opcion == 4:
    audioType = 'audio/'+'wav'
    tipo = 'wav'
else:
    audioType = 'audio/'+'mp3'
    tipo = 'mp3'

claves = input("Ingrese las palabras clave separadas por un - (guion)\n: ")
keywords = claves.split('-')

with open('audio.'+tipo, 'rb') as audio_file:
    audio_source = AudioSource(audio_file)

    print("\n\nCargando datos...")
    speech_to_text.recognize_using_websocket(
        audio=audio_source,
        content_type=audioType,
        recognize_callback=myRecognizeCallback,
        model='es-ES_BroadbandModel',
        keywords=keywords,
        keywords_threshold=0.8,
        inactivity_timeout=180,
        smart_formatting=True,
        speaker_labels= True,
        timestamps=True,
        word_confidence= True,
        max_alternatives=1)

tfinal = time.time()
difftime = tfinal - tinicial
print("La funcion tardo: ", difftime, "segs")

input('\n\n>>>>Presione ENTER para salir')
