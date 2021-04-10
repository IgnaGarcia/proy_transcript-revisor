let crearRevision = () => {
    //Obtener los inputs
    let inputTitulo = document.getElementById("inputTitulo")
    let inputTexto = document.getElementById("inputTexto").files[0]
    let inputAudio = document.getElementById("inputAudio").files[0]

    //Leer el JSON para guardarlo
    let json = 0
    if (inputTexto) json = fileToJSON(inputTexto)

    //Guardar el audio
    let audio = new Audio()
    audio.src = window.URL.createObjectURL(inputAudio)
}

let readFile = (file) => {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();

        reader.onload = res => resolve(res.target.result)
        reader.onerror = err => reject(err)

        reader.readAsText(file, "UTF-8");
    })
}

let fileToJSON = async (file) => {
    let json = 0
    readFile(file).
        then(result => {
            json = clearJSON(JSON.parse(result))
        })

    return json
}

let wordFactory = (word, from, to, confidence) => {
    let obj = {
        word: word,
        from: from,
        to: to,
        confidence: confidence,
        isKeyword: false
    }
    
    return obj
}

let paragraphFactory = (paragraph, from) => {
    let obj = {
        paragraph: paragraph,
        from: from,
        to: -1,
        speaker: -1,
        words: []
    }

    return obj
}

let clearJSON = (json) => {
    let wordCount = 0
    let cleared = []
    
    json.results.forEach(result => {
        let paragraph = paragraphFactory(result.alternatives[0].transcript, result.alternatives[0].timestamps[0][1])

        result.alternatives[0].timestamps.forEach((word, i) => {
            let nWord = wordFactory(word[0], word[1], word[2], result.alternatives[0].word_confidence[i][1])

            if(Object.keys(result.keywords_result).indexOf(word[0]) != -1){
                let index = Object.keys(result.keywords_result).indexOf(word[0])
                let keyword = Object.values(result.keywords_result)[index]
                if(keyword[0].start_time == word[1]) nWord.isKeyword = true
            }

            if((paragraph.speaker == -1) && (paragraph.from <= json.speaker_labels[wordCount].from)){
                paragraph.speaker = json.speaker_labels[wordCount].speaker
            }
            wordCount += 1
            
            paragraph.to = word[2]
            paragraph.words.push(nWord)
        })

        cleared.push(paragraph)
    })
    
    return cleared
}