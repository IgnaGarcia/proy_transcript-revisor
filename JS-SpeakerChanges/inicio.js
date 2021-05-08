//Listar las revisiones para manipularlas
window.addEventListener("load", () => {

    document.getElementById("input").addEventListener("change", cargarTexto)
})

let descargar = () => {
    let content = document.getElementById("root")
    let element = document.createElement('a')
    element.href = 'data:application/txt,' + encodeURIComponent(content.innerText)
    element.download = document.getElementById("input").files[0].name.split('.')[0] + ".txt"
    element.click();
}

let readFile = file => {
    return new Promise((resolve, reject) => {
        const reader = new FileReader()

        reader.onload = res => resolve(res.target.result)
        reader.onerror = err => reject(err)

        reader.readAsText(file, "UTF-8")
    })
}

let cargarTexto = (e) => {
    let file = e.target.files[0]
    let root = document.getElementById("root")

    if (file) readFile(file).then(json => {
        json = JSON.parse(json)

        json.forEach( (p, i) => {
            let parrafo = document.createElement("P")

            let p0 = document.createElement("p")
            p0.append("Parrafo " + i + ": ")
            p0.className = "red"
            parrafo.append(p0)

            let speakerP = document.createElement("p")

            let actualSpeaker = p.words[0].speaker
            let speakerChanges = 0

            speakerP.append("Speaker " +actualSpeaker + ": ")
            p.words.forEach( w => {
                if (w.speaker != actualSpeaker) {
                    parrafo.append(speakerP)
                    speakerChanges++
                    actualSpeaker = w.speaker

                    speakerP = document.createElement("p")
                    speakerP.append("Speaker " + actualSpeaker + ": ")
                }
                
                speakerP.append(w.word + " ")
            })
            parrafo.append(speakerP)
            root.append(parrafo)

            let extras = document.createElement("div")
            let p1 = document.createElement("p")
            p1.append("Cambios de Hablante = " + speakerChanges)
            extras.append(p1)

            if(i+1 < json.length) {
                let p2 = document.createElement("p")
                p2.append("Diferencia con prox = " + (json[i+1].from - p.to).toFixed(2) + 'segs')
                extras.append(p2)
                to = p.to
            }

            root.append(extras)
        })
    })
}