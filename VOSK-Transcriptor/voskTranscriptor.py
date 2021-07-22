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

arch = open("data.json", "w")
arch.write(json.dumps(res, indent=2))
arch.close()

print("Proceso finalizado, revise en el directorio de la app el archivo resultado.txt")

tfinal = time.time()
difftime = tfinal - tinicial
print("La funcion tardo: ", difftime, "segs")