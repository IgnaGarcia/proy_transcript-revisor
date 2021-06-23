from vosk import Model, KaldiRecognizer, SetLogLevel
import sys
import os
import wave
import json
import subprocess
import math
import time

tinicial = time.time()

SetLogLevel(-1)
if not os.path.exists("model"):
    print("Please download the model from https://alphacephei.com/vosk/models and unpack as 'model' in the current folder.")
    exit(1)

sample_rate = 16000
print("Cargando modelos...")
model = Model("model")
rec = KaldiRecognizer(model, sample_rate)

print("Convirtiendo el archivo de entrada...")
process = subprocess.Popen(['./ffmpeg/bin/ffmpeg', '-loglevel', 'quiet', '-i',
                            sys.argv[1], '-ar', str(sample_rate),
                            '-ac', '1', '-f', 's16le', '-'], stdout=subprocess.PIPE)

print("Comenzando a transcribir...")
while True:
    data = process.stdout.read(4000)
    if len(data) == 0:
        break
    if rec.AcceptWaveform(data):
        pass
    else:
        pass

print("Guardando la transcripcion...")
res = json.loads(rec.FinalResult())

# arch = open("resultado.txt", "w")
# arch.write(res['text'])
# for x in res:
#     sMinutes = math.floor(x[0][0][0]/60)
#     sSeconds = round(res['result'][0]['start'] - sMinutes * 60)
#     sSeconds = sSeconds if sSeconds > 9 else "0"+str(sSeconds)

#     eMinutes = math.floor(
#         res[x]['result'][len(res[x]['result'])-1]['end']/60)
#     eSeconds = round(res[x]['result'][len(res[x]['result'])-1]
#                      ['end'] - eMinutes * 60)
#     eSeconds = eSeconds if eSeconds > 9 else "0"+str(eSeconds)

#     arch.write("{}:{} - {}:{} :\n\t{}\n\n".format(sMinutes,
#                                                   sSeconds, eMinutes, eSeconds, res[x]['text']))

# arch.close()

arch = open("data.json", "w")
arch.write(json.dumps(res, indent=2))
arch.close()

print("Proceso finalizado, revise en el directorio de la app el archivo resultado.txt")

tfinal = time.time()
difftime = tfinal - tinicial
print("La funcion tardo: ", difftime, "segs")
