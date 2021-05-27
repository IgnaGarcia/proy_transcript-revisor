'''
Usage: 
    python cleanJson.py -i <input_file> -o <output_file> [-d <break_paragraph>] [--ibm]
'''
import json
import sys, getopt

def wordFactory(word, desde, to, confidence, speaker):
    return {
        'word': word,
        'from': desde,
        'to': to,
        'confidence': confidence,
        'speaker': speaker
    }


def paragraphFactory(desde):
    return { 
        'from': desde, 
        'to': -1, 
        'words': []
    }


def cleanVosk(data, dif):
    lastEnd = 0
    cleared = []

    for w in data['result']:   
        if lastEnd == 0:
            paragraph = paragraphFactory(w['start'])
        elif (w['start'] - lastEnd) > dif:
            paragraph['words'][-1]['word'] +=  "."
            cleared.append(paragraph)
            paragraph = paragraphFactory(w['start'])

        word = wordFactory(w['word'], w['start'], w['end'], w['conf'], 0)  

        paragraph['words'].append(word)
        paragraph['to'] = w['end']

        lastEnd = w['end']

    cleared.append(paragraph)
    return cleared


def cleanIbm(data, dif):
    wordCount = 0
    lastEnd = 0
    cleared = []

    for result in data['results']:
        i = 0

        for w in result['alternatives'][0]['timestamps']:
            if lastEnd == 0:
                paragraph = paragraphFactory(w[1])
            elif (w[1] - lastEnd) > dif:
                paragraph['words'][-1]['word'] += "."
                cleared.append(paragraph)
                paragraph = paragraphFactory(w[1])
            
            word = wordFactory(w[0], w[1], w[2], result['alternatives'][0]['word_confidence'][i][1], data['speaker_labels'][wordCount]['speaker'])            
    
            paragraph['words'].append(word)
            paragraph['to'] = w[2]
            
            wordCount += 1
            i += 1  
            lastEnd = w[2]
            
    cleared.append(paragraph)
    return cleared


def errorMessage(opt):
    if opt == 1:
        print('\nERROR- usar python cleanJson.py -i <input_file> -o <output_file> [-d <break_paragraph>] [--ibm]')
    elif opt == 2:
        print('\nERROR-La direccion del input es requerida.\nDeclarala en el llamado con -i o --input_file')

    sys.exit(2)


def main(ifile, ofile, dif, ibm):
    reader = open(ifile, 'r')
    jsonDictonary = json.loads(reader.read())
    reader.close()

    writer = open(ofile, 'w')
    if ibm:
        res = cleanIbm(jsonDictonary, dif)
    else:
        res = cleanVosk(jsonDictonary, dif)

    writer.write(json.dumps(res, indent=2))
    writer.close()


if __name__ == "__main__":
    argv = sys.argv[1:]

    short_options = "i:o:d:"
    long_options = ["input_file=", "output_file=", "dif", "ibm"]

    inputfile = ''
    outputfile = ''
    dif = 0.8
    ibm = False

    try:
        opts, args = getopt.getopt(argv, short_options, long_options)
    except getopt.GetoptError:
        errorMessage(1)

    for opt, arg in opts:
        if opt in ("-i", "--input_file"):
            inputfile = arg
        elif opt in ("-o", "--output_file"):
            outputfile = arg
        elif opt in("-d", "--dif"):
            dif = float(arg)
        elif opt == "--ibm":
            ibm = True
    
    if inputfile == '':
        errorMessage(2)
    if outputfile == '':
        print('\nINFO-No se especifica direccion del output, se guardara junto al ejetubale\n')
        outputfile = "./clean.json"

    main(inputfile, outputfile, dif, ibm)