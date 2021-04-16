//Una vez que carga el DOM se agrega el texto
window.addEventListener("load", () => { 
    let root = document.getElementById("root");
    cargarTexto(root)
    cargarAudio()

    document.getElementById("btnDescPDF").addEventListener("click", descargarPDF)
    document.getElementById("btnDescDOC").addEventListener("click", descargarDOC)
    document.getElementById("btnGuardar").addEventListener("click", guardarRevision)
})

let cargarAudio = async() => {
    //Conectarse a la DB y obtener revision
    let dbManager = await indexedDBManager()
        
    let urlParams = new URLSearchParams(window.location.search);
    let id = parseInt(urlParams.get('id'))

    dbManager.get(id).then(revisions => {
        let audio = new Audio()
        audio.src = window.URL.createObjectURL(revisions.revision.audio);
        
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
    })
}

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
let cargarTexto = async(root) => {
    //Conectarse a la DB y obtener revision
    let dbManager = await indexedDBManager()
        
    let urlParams = new URLSearchParams(window.location.search);
    let id = parseInt(urlParams.get('id'))

    dbManager.get(id).then(revisions => {
        revisions.revision.texto.forEach(el => {
            let parrafo= document.createElement("div");
            parrafo.append("Speaker" + el.speaker + ": " + el.paragraph)
            root.append(parrafo);
        })
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