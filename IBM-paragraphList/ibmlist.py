'''
Usage: 
    python ibmlist.py -i <input_file> -o <output_file> [-c] [-s]
'''
import json
import sys, getopt

def speakersList(jsonDictonary, writer):
    i=0
    for p in jsonDictonary:
        parrafo = f'Parrafo {i}: '

        actualSpeaker = p['words'][0]['speaker']
        speakerP = f"\n\tSpeaker {actualSpeaker}: "
        speakerChanges = 0

        for w in p['words']:
            if (w['speaker'] != actualSpeaker):
                parrafo += speakerP
                speakerChanges += 1
                actualSpeaker = w['speaker']
                speakerP = f"\n\tSpeaker {actualSpeaker}: "

            word= w['word']
            speakerP += f'{word} '
    
        parrafo += speakerP
        writer.write(parrafo)

        writer.write(f"\nCambios de Hablante = {speakerChanges}")

        if(i+1 < len(jsonDictonary)):
            writer.write(f"\nDiferencia con prox = {round(jsonDictonary[i+1]['from'] - p['to'], 2)}segs\n\n")        

        i += 1

def cleanList(jsonDictonary, writer):
    i = True
    for p in jsonDictonary:
        if i:
            parrafo = ""
            i = False
        else:
            parrafo = "\n\n"

        for w in p['words']:
            word= w['word']
            parrafo += f'{word} '

        writer.write(parrafo)       
         

def simpleList(jsonDictonary, writer):
    i=0
    for p in jsonDictonary:
        speaker = p['words'][0]['speaker']
        parrafo = f'Parrafo {i} - Speaker {speaker}:  '

        speakerP = "\n\t"

        for w in p['words']:
            word= w['word']
            speakerP += f'{word} '
    
        parrafo += speakerP
        writer.write(parrafo)

        if(i+1 < len(jsonDictonary)):
            writer.write(f"\nDiferencia con prox = {round(jsonDictonary[i+1]['from'] - p['to'], 2)}segs\n\n")        

        i += 1

def main(ifile, ofile, s, c):

    reader = open(ifile, 'r')
    jsonDictonary = json.loads(reader.read())
    reader.close()

    writer = open(ofile, 'w')
    if c:
        cleanList(jsonDictonary, writer)
    elif s:
        speakersList(jsonDictonary, writer)
    else:
        simpleList(jsonDictonary, writer)
    writer.close()
    

if __name__ == "__main__":
    argv = sys.argv[1:]

    short_options = "i:o:sc"
    long_options = ["input_file=", "output_file=", "speaker", "clean"]

    inputfile = ''
    outputfile = ''
    speaker = False
    clean = False

    try:
        opts, args = getopt.getopt(argv, short_options, long_options)
    except getopt.GetoptError:
        print('\nERROR- usar python ibmlist.py -i <input_file> -o <output_file> [-c] [-s]')
        sys.exit(2)

    for opt, arg in opts:
        if opt in ("-i", "--input_file"):
            inputfile = arg
        elif opt in ("-o", "--output_file"):
            outputfile = arg
        elif opt in ("-s", "--speaker"):
            speaker = True
        elif opt in ("-c", "--clean"):
            clean = True
    
    if inputfile == '':
        print('\nERROR-La direccion del input es requerida.\nDeclarala en el llamado con -i o --input_file')
        sys.exit(2)
    if outputfile == '':
        print('\nINFO-No se especifica direccion del output, se guardara junto al ejetubale\n')
        outputfile = "./plist.txt"

    main(inputfile, outputfile, speaker, clean)