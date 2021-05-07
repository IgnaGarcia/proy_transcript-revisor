//Una vez que carga el DOM se agrega el texto
window.addEventListener("load", () => { 
    let root = document.getElementById("root")
    
    //Conectarse a la DB y obtener revision
    indexedDBManager().then(dbManager => {
        let urlParams = new URLSearchParams(window.location.search)
        let id = parseInt(urlParams.get('id'))

        dbManager.get(id).then(revisions => {
            cargarTexto(revisions.revision, root)
            cargarAudio(revisions.revision)
        })
    })

    document.getElementById("btnDescPDF").addEventListener("click", descargarPDF)
    document.getElementById("btnDescDOC").addEventListener("click", descargarDOC)
    document.getElementById("btnGuardar").addEventListener("click", guardarRevision)
})

// Sincronizar el texto con el audio a partir del current time
let sincroAudio = (audio) => {
    let words = Array.from(document.querySelectorAll("span[data-from]"))
    let actualWord = words[0]
    let from = actualWord.getAttribute("data-from")
    let to = actualWord.getAttribute("data-to")
    actualWord.setAttribute('data-current', 1)

    audio.addEventListener('timeupdate', e => {
        if(audio.currentTime > to || audio.currentTime < from) {
            let word = words.filter(el => (audio.currentTime >= el.getAttribute("data-from")) && (audio.currentTime <= el.getAttribute("data-to")))
            if(word[0]) {
                from = word[0].getAttribute("data-from")
                to = word[0].getAttribute("data-to")
                word[0].setAttribute('data-current', 1)
    
                actualWord.removeAttribute('data-current')
                actualWord = word[0]
            }
        }
    });
}

// Escucha si hay un salto en el audio
let jumpAudio = (audio) => {
    let root = document.getElementById("root")
    root.addEventListener('click', e => e.altKey ? audio.currentTime = e.target.getAttribute("data-from") : null)
}

//Agregar el Audio al HTML y controlarlo
let cargarAudio = (revision) => {
    let audio = new Audio()
    audio.src = window.URL.createObjectURL(revision.audio)

    let audioContainer = document.getElementById("audioContainer")
    audioContainer.append(audio)

    document.getElementById("retroceder").addEventListener("click", () => {
        if(audio.currentTime - 5 < 0) audio.currentTime = 0
        else audio.currentTime -= 5
    })
    document.getElementById("play").addEventListener("click", () => {
        if (audio.paused) audio.play()
        else audio.pause()
    })
    document.getElementById("avanzar").addEventListener("click", () => {
        if(audio.currentTime + 5 > audio.duration) audio.currentTime = audio.duration
        else audio.currentTime += 5
    })
    
    sincroAudio(audio)
    jumpAudio(audio)
}

//Guardar la Revision en IndexedDB
let guardarRevision = async() => {

}

//Descargar en formato DOC
let descargarDOC = () => {
    let content = document.getElementById("root")
    let element = document.createElement('a')
    element.href = 'data:application/vnd.ms-word;charset=utf-8,' + encodeURIComponent(content.innerText)
    element.download = "prueba.doc"
    element.click();
}

//Descargar en formato PDF
let descargarPDF = () => {
    let root = document.getElementById("root")
    
    //Generar y descargar pdf
    let doc = new jsPDF()
    doc.fromHTML(root, 15, 15, {
        'width': 170
    });

    doc.save('sample-document.pdf')
}

//Agregar el texto al DOM
let cargarTexto = (revision, root) => {
    revision.texto.forEach((element, index) => {
        let parrafo = document.createElement("div")
        parrafo.id = "p-"+index
        
        let speaker = document.createElement("div")
        speaker.id = "s-"+index
        speaker.contentEditable = false
        speaker.append("Speaker "+ element.speaker +": ")
        
        let timeStamp = document.createElement("span")
        timeStamp.append("["+element.from+" - "+element.to+"]")
        speaker.append(timeStamp)

        parrafo.append(speaker)

        let palabras = document.createElement("div")
        palabras.id = "w-"+index
        element.words.forEach((e, i) => {
            let palabra = document.createElement("span")
            palabra.id = "w-"+index+"-"+i
            palabra.className = palabra.className+" w"
            palabra.append(e.word+" ")

            palabra.setAttribute('data-from', e.from)
            palabra.setAttribute('data-to', e.to)

            if(e.confidence < .45) palabra.className = palabra.className+" lowConfidence"
            else if(e.confidence < .75) palabra.className = palabra.className+" mediumConfidence"

            palabras.append(palabra)
            palabra.addEventListener('keydown', e => console.log(e.target))
        })
        parrafo.append(palabras)

        root.append(parrafo);
    })
}

//Manager de la DB del browser
let indexedDBManager = async () => {
    
    //Promise Wraper para manager de la DB
    let promiseReq = req => {
        return new Promise((resolve, reject) => {
            req.onsuccess = () => resolve(req.result);
            req.onerror = () => reject(req.error);
        });
    }

    // Abrimos la DB
    let openRequest = indexedDB.open('Revisions', 1);
    openRequest.onupgradeneeded = (e) => {
        let db = e.target.result;
        db.createObjectStore("Revisions", { keyPath: "id", autoIncrement: true });
    };

    return promiseReq(openRequest).then(db => {
        let obj = {db: db}
        obj.promiseReq = promiseReq
        obj.transaction= obj.db.transaction("Revisions", "readwrite")
        obj.store= obj.transaction.objectStore("Revisions")
        obj.add= (item) => obj.promiseReq(obj.store.add(item))
        obj.get= (key) => obj.promiseReq(obj.store.get(key))
        obj.delete= (key) => obj.promiseReq(obj.store.delete(key))
        obj.put= (item) => obj.promiseReq(obj.store.put(item))
        obj.getAll= () => obj.promiseReq(obj.store.getAll())
        return obj
    })
}