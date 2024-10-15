function getWeather(url) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function () {
        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

        } else if (doc.readyState == XMLHttpRequest.DONE) {
            let parsed
            try {
                parsed = JSON.parse(doc.responseText)
                weather = parsed
            } catch (e) {
              console.log("getWeather error:", JSON.stringify(e))
            }
        }
    }
    doc.open("GET", url);
    doc.send();
}