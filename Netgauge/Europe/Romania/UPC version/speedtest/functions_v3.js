function toJava(jsmethod,args) {
 var e = document.getElementById('VoipApplet');
 e.fromJS(jsmethod,args);
}

function fromJava(jsmethod,args) {
 setTimeout("flashCall(\'" + jsmethod + "\', \'" + args + "\')", 100);
}

function flashCall(jsmethod, args) {
 var e = document.getElementById('flashtest');
 e.fromJS(jsmethod, args);
}

function test_completed(array) {
        download_rate = Math.round((array.download/8)*10)/10;
        upload_rate = Math.round((array.upload/8)*10)/10;
        var curdate = new Date();
        var speed = document.getElementById('speed');
        if (speed) {
                if (array.latency) {
                        if (array.jitter > -1) {
                                if (array.packetloss < 100) {
                                        speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + array.download + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + array.upload + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "Latency: <strong>" + array.latency + "</strong> ms<br/>" + "Jitter: <strong>" + array.jitter + "</strong> ms<br/>" + "Packet Loss: <strong>" + array.packetloss + "</strong>%";
                                } else {
                                        speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + array.download + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + array.upload + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "Latency: <strong>" + array.latency + "</strong> ms<br/>" + "Jitter: <strong>" + array.jitter + "</strong> ms";
                                }
                        } else {
                                speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + array.download + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + array.upload + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "Latency: <strong>" + array.latency + "</strong> ms";
                        }
                } else {
                        speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + array.download + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + array.upload + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)";
                }

                speed.innerHTML = speed.innerHTML + "<br/>" + curdate.toLocaleString() + "<br/>";
        }
	var abovebefore = document.getElementById('abovebefore');
	if (abovebefore) {
		abovebefore.style.display = "none";
	}
	var belowbefore = document.getElementById('belowbefore');
	if (belowbefore) {
		belowbefore.style.display = "none";
	}
	var aboveafter = document.getElementById('aboveafter');
	if (aboveafter) {
		aboveafter.style.display = "block";
	}
	var belowafter = document.getElementById('belowafter');
	if (belowafter) {
		belowafter.style.display = "block";
	}
}
