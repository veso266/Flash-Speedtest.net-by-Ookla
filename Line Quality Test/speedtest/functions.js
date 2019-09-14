function test_completed(download_speed, upload_speed, latency, jitter, packet_loss, server_id) {
	download_rate = Math.round((download_speed/8)*10)/10;
	upload_rate = Math.round((upload_speed/8)*10)/10;
	var curdate = new Date();
	var speed = document.getElementById('speed');
	if (speed) {
		if (latency) {
			if (jitter > -1) {
				if (packet_loss < 100) {
					speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "PING: <strong>" + latency + "</strong> ms<br/>" + curdate.toLocaleString() + "<img src=\"./log_result.php?d=" + download_speed + "&u=" + upload_speed + "&l=" + latency + "&j=" + jitter + "&pl=" + packet_loss + "&ss=SG2" + "\" width=1 height=1>";
				} else {
					speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "PING: <strong>" + latency + "</strong> ms<br/>" + curdate.toLocaleString() + "<img src=\"./log_result.php?d=" + download_speed + "&u=" + upload_speed + "&l=" + latency + "&j=" + jitter + "&ss=SG2" + "\" width=1 height=1>";
				}
			} else {
				speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate)<br/>" + "PING: <strong>" + latency + "</strong> ms<br/>" + curdate.toLocaleString() + "<img src=\"./log_result.php?d=" + download_speed + "&u=" + upload_speed + "&l=" + latency + "&ss=SG2" + "\" width=1 height=1>";
			}
		} else {
			speed.innerHTML = "<strong>Last Result:</strong><br/>" + "Download Speed: <strong>" + download_speed + "</strong> kbps (" + download_rate + " KB/sec transfer rate)<br/>" + "Upload Speed: <strong>" + upload_speed + "</strong> kbps (" + upload_rate + " KB/sec transfer rate) <br/>" + curdate.toLocaleString() + "<img src=\"./log_result.php?d=" + download_speed + "&u=" + upload_speed + "&ss=SG2" + "\" width=1 height=1>";
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
