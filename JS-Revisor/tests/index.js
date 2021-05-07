let promiseReq = req => {
    return new Promise((resolve, reject) => {
        req.onsuccess = () => resolve(req.result);
        req.onerror = () => reject(req.error);
    });
}

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

window.addEventListener("load", async () => {
    let managerIDB = await indexedDBManager()
    console.log(managerIDB)
    //managerIDB.add({"qcy": 20}).then((e) => console.log(e))
    managerIDB.get(2).then(e => {
        console.log(e)
        e.qcy = "algo"
        managerIDB.put(e).then(e => console.log(e))
    })
    managerIDB.getAll().then(e => console.log(e))
    managerIDB.delete(3).then(e => console.log(e))


    /*let text = "Lorem ipsum dolor sit amet consectetur adipisicing elit. Iure, velit, quas quod, soluta quae impedit ut vel doloribus natus a dolorem repellendus laboriosam explicabo sint eligendi odit aperiam unde molestiae.";

    let root = document.getElementById("root");
    root.setAttribute("contenteditable", "true")

    //appender del texto
    for(let i=0; i<10; i++){
        let paragraph = document.createElement("div");
        let wordList = text.split(" ");
        wordList.forEach( el => {
            let word = document.createElement("span")
            word.classList.add("word");
            word.append(el+" ")
            paragraph.append(word)
        })

        root.append(paragraph)
    }

    //reproducir audio desde un file
    document.getElementById("audioInput").addEventListener("change", (event) => {
        var files = event.target.files;

        let audio = new Audio()
        audio.src = window.URL.createObjectURL(files[0]);

        //audio.play();

        let audioElement = document.getElementById("audio")
        audioElement.setAttribute("src", audio.src)
        audioElement.play();
    });
  
    //generar y descargar pdf
    let doc = new jsPDF();
    doc.fromHTML(root, 15, 15, {
        'width': 170
    });

    // Save the PDF
    doc.save('sample-document.pdf');*/
})