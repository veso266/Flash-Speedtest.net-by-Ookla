function test_completed(download_speed, upload_speed, latency, server_id) {
	download_rate = Math.round((download_speed/8)*10)/10;
	upload_rate = Math.round((upload_speed/8)*10)/10;
	var curdate = new Date();
	var speed = document.getElementById('speed');
	if (speed) {
		if (latency) {
			speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "Latency: <strong>" + latency + "</strong> ms<br/>" + curdate.toLocaleString();
		} else {
			speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + curdate.toLocaleString();
		}
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

function test_started(test_count, server_id) {
	var teststarted = document.getElementById('teststarted');
	if (teststarted) {
		teststarted.style.display = "block";
	}
}
