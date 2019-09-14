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


//This function is called when the entire test is complete
//NetGauge passes the results of the test to the function as a JSON array
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


//this is where we determine if the user's download speed was as fast as they expected

//downMbps is the download speed in Mbps, rounded to the nearest hundredth
        var downMbps = Math.round(array.download/10)/100;
//expDown is the value of the Expected download speed user input 
        var expDown = document.getElementById("targetDown").value;
//afterDiv is the html div directly above the flash container        
        var afterDiv = document.getElementById("aboveafter");
        
 //Begining of if statement
 //"if the download speed is less than the expected value, provide a link to customer support"   
  
        if(downMbps < expDown){       
        
                afterDiv.innerHTML = "Your download rate of " +downMbps + " Mbps was slower than the expected rate of " + expDown +" Mbps. <br/>Click <a href='http://d.pr/GFDw' target='_blank'>here</a> to be connected with a support representative.";
        } 
 //"otherwise, if the download speed is higher than expected, provide a link to upgrade service"             
        else if (downMbps > expDown){
            
                afterDiv.innerHTML = "Your download rate of " +downMbps + " Mbps was better than expected! <br/>Need an even faster connection? Click <a href='http://d.pr/q826' target='_blank'>here</a> to upgrade your service.";
        }
        
 //end of if statement       
}



//This function is called every time a test component completes. 
//When NetGauge calls the function, it passes the name of the completed test
//in the variable testval
function test_component_complete(testval){
        var statDiv = document.getElementById("status");
        statDiv.innerHTML = "Current status: " + testval + " test completed successfully."
}

