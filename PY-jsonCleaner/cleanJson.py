import json
import sys

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

def cleanJson(data):
    wordCount = 0
    cleared = []

    for result in data['results']:
        paragraph = paragraphFactory(result['alternatives'][0]['timestamps'][0][1])
        i = 0

        for word in result['alternatives'][0]['timestamps']:
            if(len(result['alternatives'][0]['timestamps']) -1 == i):
                word[0] = word[0]+"."
            
            nWord = wordFactory(word[0], word[1], word[2], result['alternatives'][0]['word_confidence'][i][1], data['speaker_labels'][wordCount]['speaker'])            
            
            paragraph['to'] = word[2]
            paragraph['words'].append(nWord)
            
            wordCount += 1
            i += 1  
        cleared.append(paragraph)
    return cleared

if __name__ == "__main__":
    input_dir = sys.argv[1]
    output_name = sys.argv[2]
    try:
        f = open(f'{input_dir}', 'r')
        jsonDictonary = json.loads(f.read())
        f.close()

        f = open(f"./{output_name}.json", "w")
        f.write(json.dumps(cleanJson(jsonDictonary), indent=2)) 
        f.close()

        print("Limpieza finalizada correctamente")
    except:
        print("ERROR")
