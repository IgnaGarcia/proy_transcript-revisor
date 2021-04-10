let crearRevision = () => {
    //Obtener los inputs
    let inputTitulo = document.getElementById("inputTitulo")
    let inputTexto = document.getElementById("inputTexto").files[0]
    let inputAudio = document.getElementById("inputAudio").files[0]
    
    console.log(inputTitulo.value)

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
    let content = await readFile(file)
    let json = clearJSON(content)

    return json
}

let clearJSON = (json) => {
    let paragraphs = []
    let keywords = []
    json.results.forEach(el => {
        paragraphs.push(el.alternatives)
        keywords.push(el.keywords_result)
    })
    let speakers = json.speaker_labels

    /*
    {[
        {
            paragraph: "texto del parrafo",
            from: tiempo de primera palabra,
            to: tiempo de ultima palabra,
            speaker: 0/1/2 etiqueta de hablante segun primera palabra
            words:[
                {
                    word: "texto",
                    from: tiempo de inicio,
                    to: tiempo de fin,
                    confidence: grado de seguridad,
                    isKeyword: true/false
                }
            ]
        }
    ]}
    */
}