function showTime(){
    var date = new Date();
    var h = date.getHours();
    var m = date.getMinutes();
    var s = date.getSeconds();
    var ms = date.getMilliseconds();
    var timer = 1000;

    if(h == 0){
        h = 12;
    }

    h = (h < 10) ? "0" + h : h;
    m = (m < 10) ? "0" + m : m;
    s = (s < 10) ? "0" + s : s;

    document.getElementById("hour").innerText = h;
    document.getElementById("min").innerText = m;
    document.getElementById("sec").innerText = s;

    // Trying to do something clever here to ensure we update the time roughly within
    // 100ms within the turn of the second
    if (ms < 900) {
        timer = 1000 - ms - 100;
    }
    else {
        timer = 100;
    }

    setTimeout(showTime, timer);
}

showTime();
