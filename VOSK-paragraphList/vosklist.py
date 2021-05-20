'''
Usage: 
    python voskplist.py -i <input_file> -o <output_file> [-c] [-d <break_paragraph>]
'''
import json
import sys, getopt            

def cleanList(jsonDictonary, writer, dif):
    lastEnd = 0
    for w in jsonDictonary['result']:    
        word = w['word']
        if (w['start'] - lastEnd) < dif:
            writer.write(f'{word} ')
        else:
            if lastEnd != 0:
                writer.write(f'\n\n{word} ')
            else:
                writer.write(f'{word} ')
        lastEnd = w['end']

def simpleList(jsonDictonary, writer, dif):
    lastEnd = 0
    i=0
    for w in jsonDictonary['result']:    
        word = w['word']
        if (w['start'] - lastEnd) < dif:
            writer.write(f'{word} ')
        else:
            if lastEnd != 0:
                writer.write(f"\n\nDiferencia con prox = {round(w['start'] - lastEnd, 2)}segs")
                writer.write(f'\n\nParrafo {i}:\n\t{word} ')
            else:
                writer.write(f'Parrafo {i}:\n\t{word} ')

        lastEnd = w['end']       
        i += 1

def main(ifile, ofile, c, dif):

    reader = open(ifile, 'r')
    jsonDictonary = json.loads(reader.read())
    reader.close()

    writer = open(ofile, 'w')
    if c:
        cleanList(jsonDictonary, writer, dif)
    else:
        simpleList(jsonDictonary, writer, dif)
    writer.close()
    

if __name__ == "__main__":
    argv = sys.argv[1:]

    short_options = "i:o:cd:"
    long_options = ["input_file=", "output_file=", "clean", "dif"]

    inputfile = ''
    outputfile = ''
    clean = False
    dif = 0.8

    try:
        opts, args = getopt.getopt(argv, short_options, long_options)
    except getopt.GetoptError:
        print('\nERROR- usar python voskplist.py -i <input_file> -o <output_file> [-c] [-d <break_paragraph>]')
        sys.exit(2)

    for opt, arg in opts:
        if opt in ("-i", "--input_file"):
            inputfile = arg
        elif opt in ("-o", "--output_file"):
            outputfile = arg
        elif opt in("-c", "--clean"):
            clean = True
        elif opt in("-d", "--dif"):
            dif = float(arg)
    
    if inputfile == '':
        print('\nERROR-La direccion del input es requerida.\nDeclarala en el llamado con -i o --input_file')
        sys.exit(2)
    if outputfile == '':
        print('\nINFO-No se especifica direccion del output, se guardara junto al ejetubale\n')
        outputfile = "./plist.txt"

    main(inputfile, outputfile, clean, dif)