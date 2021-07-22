import json
import time
import sys
import pathlib

from os.path import join, dirname
from ibm_watson import SpeechToTextV1
from ibm_watson.websocket import RecognizeCallback, AudioSource
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator

class MyRecognizeCallback(RecognizeCallback):
    def __init__(self):
        RecognizeCallback.__init__(self)

    def on_data(self, data):
        output_dir = sys.argv[2]
        jsonDictonary = data  # Guardar el resultado como Dictionary
        # Convertir el resultado a un JSON Indentado para facil lectura
        jsonText = json.dumps(jsonDictonary, indent=2)

        print(f"\nGuardando resultado en: {output_dir}")

        # Archivo para todo el resultado (Timestamps, Keywords, ETC)
        f = open(f"{pathlib.Path(output_dir)}/data.json", "w")
        f.write(jsonText) 
        f.close()

        print(f"\nPeticion exitosa! revisar en {output_dir}")

    def on_error(self, error):
        print(f'\nError : {error}')

    def on_inactivity_timeout(self, error):
        print(f'\nInactividad en el audio : {error}')

def main():
    # Inserte la key aqui
    _key = sys.argv[3]
    # Inserte la url de su clave aqui
    _url = sys.argv[4]

    input_dir = sys.argv[1]

    authenticator = IAMAuthenticator(_key)
    speech_to_text = SpeechToTextV1(authenticator=authenticator)

    speech_to_text.set_service_url(_url)
    speech_to_text.set_disable_ssl_verification(True)

    myRecognizeCallback = MyRecognizeCallback()

    with open(pathlib.Path(sys.argv[1]), 'rb') as audio_file:
        audio_source = AudioSource(audio_file)

        print(f"\nCargando datos\t\taudio path: {input_dir}")
        speech_to_text.recognize_using_websocket(
            audio = audio_source,
            content_type = 'audio/' + pathlib.Path(sys.argv[1]).suffix[1:],
            recognize_callback = myRecognizeCallback,
            model = 'es-ES_BroadbandModel',
            inactivity_timeout = 180,
            smart_formatting = True,
            speaker_labels = True,
            timestamps = True,
            word_confidence = True,
            max_alternatives = 1)

if __name__ == "__main__":
    tinicial = time.time()
    main()    
    tfinal = time.time()
    difftime = tfinal - tinicial

    print("\nLa funcion tardo: ", difftime, "segs")
    input('\n>>>>Presione ENTER para salir')
