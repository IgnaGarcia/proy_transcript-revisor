//Una vez que carga el DOM se agrega el texto
window.addEventListener("load", async () => { 
    let root = document.getElementById("root");
    root.setAttribute("contenteditable", "true");

    //Conectarse a la DB y obtener revision
    let dbManager = await indexedDBManager()
    
    let urlParams = new URLSearchParams(window.location.search);
    let id = parseInt(urlParams.get('id'))
    
    dbManager.get(id).then(revisions => {
        revisions.revision.texto.forEach(el => {
            let parrafo= document.createElement("div");
            parrafo.append("Speaker" + el.speaker + ": " + el.paragraph + "." + " ")
            root.append(parrafo);
        })
    })
})

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