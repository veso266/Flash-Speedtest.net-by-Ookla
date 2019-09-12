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

//function test_completed(array) {
function test_completed( download_speed, upload_speed, latency, jitter, packet_loss, server_id)
{
        download_rate = Math.round((download_speed/8)*10)/10;
        upload_rate = Math.round((upload_speed/8)*10)/10;
        var curdate = new Date();
        var speed = document.getElementById('speed');
        var hostname = window.location.hostname;
        var result_id = '';

        jQuery
                .post(
                        "/speedtestlog.php",
                        {
                                "download": download_speed,
                                "upload": upload_speed,
                                "latency": latency
                        },
                        function( data )
                        {
                                console.log( data );
                                result_id = data;
                                if (speed) {
                                        /*if (latency) {
                                                if (jitter > -1) {
                                                        if (packet_loss < 100) {
                                                                speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "Latency: <strong>" + latency + "</strong> ms<br/>" + "Jitter: <strong>" + jitter + "</strong> ms<br/>" + "Packet Loss: <strong>" + packet_loss + "</strong>%";
                                                        } else {
                                                                speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "Latency: <strong>" + latency + "</strong> ms<br/>" + "Jitter: <strong>" + jitter + "</strong> ms";
                                                        }
                                                } else {
                                                        speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "Latency: <strong>" + latency + "</strong> ms";
                                                }
                                        } else {
                                                speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)";
                                        }

                                        speed.innerHTML = speed.innerHTML + "<br/>" + curdate.toLocaleString() + "<br/>";*/
                                
                                        speed.innerHTML = "<div class='contain'> <div class='resultimage'> <img src='http://" + hostname + "/result/" + result_id + "/' /> </div> <div class='resulttextall'> <div class='resulttext'> Forum Link<br /><input type='text' value='[url=http://" + hostname + "/][img]http://" + hostname + "/result/" + result_id + "/[/img][/url]'> </div> <div class='resulttext'> Web Link<br /><input type='text' value='<a href=http://" + hostname + "/><img src=http://" + hostname + "/result/" + result_id + "/></a>'> </div> <div class='resulttext'> Direct Link<br /><input type='text' value='http://" + hostname + "/result/" + result_id + "/'> </div> </div> </div> </div>";
                                }
                                
                        }
                );




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