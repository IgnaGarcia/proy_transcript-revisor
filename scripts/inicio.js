window.addEventListener("load", () => {
    let text = "Lorem ipsum dolor sit amet consectetur adipisicing elit. Iure, velit, quas quod, soluta quae impedit ut vel doloribus natus a dolorem repellendus laboriosam explicabo sint eligendi odit aperiam unde molestiae.";

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
    doc.save('sample-document.pdf');
})