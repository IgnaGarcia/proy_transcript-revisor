import json
from os.path import join, dirname
from ibm_watson import SpeechToTextV1
from ibm_watson.websocket import RecognizeCallback, AudioSource
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator

#Inserte la key aqui
_key = ''

#Inserte la url de su clave aqui
_url = '' 

authenticator = IAMAuthenticator(_key)
speech_to_text = SpeechToTextV1(
    authenticator=authenticator
)

speech_to_text.set_service_url(_url)
speech_to_text.set_disable_ssl_verification(True)

class MyRecognizeCallback(RecognizeCallback):
    def __init__(self):
        RecognizeCallback.__init__(self)

    def on_data(self, data):
        jsonDictonary = data #Guardar el resultado como Dictionary
        jsonText= json.dumps(jsonDictonary, indent=2)  #Convertir el resultado a un JSON Indentado para facil lectura
        
        print("\n\nGuardando resultado...")
        
        f = open ("salida/data.txt", "w") #Archivo para todo el resultado (Timestamps, Alternatives, Keywords, ETC)
        f.write(jsonText) #Guardar el JSON Indentado
        f.close()
        
        f = open ("salida/transcripcion.txt", "w") #Archivo solo para las posibles transcripciones
        i=0
        
        for x in jsonDictonary['results']:  

            f.write("Resultado " + str(i+1) + " : ") #Resultado parcial numero i
            i=i+1
            f.write("Comienza en: " + str(x['alternatives'][0]['timestamps'][0][1])) #Segundo en el que comienza este resultado

            j=0 #Resetear J para contar cada posible resultado

            for y in x['alternatives']: #Recorrer las alternativas de transcrippcion

                f.write("\n-----------\n\tOpcion " + str(j+1) + " : \n") #Alternativa numero j
                f.write(y['transcript']) #Escribir la Alternatica

                j=j+1
            f.write("\n----------------------------------------------------------\n")

        f.close()

        print("\n\nPeticion exitosa! revisar en la carpeta raiz del repositorio") 
        input('\n\n>>>>Presione ENTER para salir') 

    def on_error(self, error):
        print('\n\nError : {}'.format(error))
        input('\n\n>>>>Presione ENTER para salir')

    def on_inactivity_timeout(self, error):
        print('\n\nInactividad en el audio : {}'.format(error))
        input('\n\n>>>>Presione ENTER para salir')

myRecognizeCallback = MyRecognizeCallback()

opcion= int(input ("Seleccione el tipo de archivo: \n\t1-mp3 \n\t2-flac \n\t3-ogg \n\t4-wav \n: "))
if opcion==1:
    audioType = 'audio/'+'mp3'
    tipo= 'mp3'
elif opcion==2:
    audioType = 'audio/'+'flac'
    tipo= 'flac'
elif opcion==3:
    audioType = 'audio/'+'ogg'
    tipo= 'ogg'
elif opcion==4:
    audioType = 'audio/'+'wav'
    tipo= 'wav'
else:
    audioType = 'audio/'+'mp3'
    tipo= 'mp3'

claves= input ("Ingrese las palabras clave separadas por un - (guion)\n: ")
keywords= claves.split('-')

with open('audio.'+tipo,'rb') as audio_file:
    audio_source = AudioSource(audio_file)

    print("\n\nCargando datos...")
    speech_to_text.recognize_using_websocket(
        audio= audio_source,
        content_type= audioType,
        recognize_callback= myRecognizeCallback,
        model= 'es-ES_BroadbandModel',
        keywords= keywords ,
        keywords_threshold=0.8,
        inactivity_timeout= 180,
        smart_formatting= True,
        timestamps= True,
        max_alternatives=3)