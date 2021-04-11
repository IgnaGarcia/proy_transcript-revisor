//Constructor de Revision
let revisionFactory = (titulo, audio, texto) => {
    //timestamp
    let date = new Date(Date.now())
    let strDate = date.getFullYear()+"/"+date.getMonth()+"/"+date.getUTCDate()+" "+date.getHours()+':'+date.getMinutes()
    
    let obj = {
        titulo: titulo,
        audio: audio,
        texto: texto,
        fecha: strDate
    }

    return obj
}

//Captar los datos ingresados, manipularlos y guardarlos
let crearRevision = async () => {
    //Obtener los inputs
    let inputTitulo = document.getElementById("inputTitulo")
    let inputTexto = document.getElementById("inputTexto").files[0]
    let inputAudio = document.getElementById("inputAudio").files[0]

    //Leer el JSON para guardarlo
    let json = 0
    if (inputTexto) json = await fileToJSON(inputTexto)

    //Guardar el audio
    let audio = new Audio()
    audio.src = window.URL.createObjectURL(inputAudio)

    //Crear Revision
    let revision = revisionFactory(inputTitulo, audio, json)
}

//Promise Wraper para manager de la DB
let promiseReq = req => {
    return new Promise((resolve, reject) => {
        req.onsuccess = () => resolve(req.result);
        req.onerror = () => reject(req.error);
    });
}

//Manager de la DB del browser
let indexedDBManager = async () => {
    // Abrimos la DB
    let openRequest = indexedDB.open('testDB', 1);
    openRequest.onupgradeneeded = (e) => {
        let db = e.target.result;
        db.createObjectStore("doc", { keyPath: "id", autoIncrement: true });
        console.log("created indexed DB")
    };

    return promiseReq(openRequest).then(db => {
        let obj = {db: db}
        obj.transaction= obj.db.transaction("doc", "readwrite")
        obj.store= obj.transaction.objectStore("doc")
        obj.add= (item) => promiseReq(obj.store.add(item))
        obj.get= (key) => promiseReq(obj.store.get(key))
        obj.delete= (key) => promiseReq(obj.store.delete(key))
        obj.put= (item) => promiseReq(obj.store.put(item))
        obj.getAll= () => promiseReq(obj.store.getAll())
        return obj
    })
}

//Promesa de lectura completa del archivo
let readFile = (file) => {
    return new Promise((resolve, reject) => {
        const reader = new FileReader()

        reader.onload = res => resolve(res.target.result)
        reader.onerror = err => reject(err)

        reader.readAsText(file, "UTF-8")
    })
}

//Leer el archivo, convertirlo a JSON y pasarlo a limpio
let fileToJSON = async (file) => {
    let result = await readFile(file)
    return await clearJSON(JSON.parse(result))
}

//Constructor de Palabras
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

//Constructor de Parrafos
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

//Limpieza de JSON de entrada
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