
<?php
if(!isset($_POST['sub'])){
  echo '
  <h1>Generate real Ookla Speedtest results.</h1>
  <form action="" method="POST">
  <input type="number" placeholder="Download speed in mbps" name="down" step="0.01" style="width: 175px;"></input> mbps<br>
  <input type="number" placeholder="Upload speed in mbps" name="up" step="0.01" style="width: 175px;"></input> mbps<br>
  <input type="number" placeholder="Ping in ms" name="ping" style="width: 175px;"></input> ms<br>
  <button type="submit" value="Submit" name="sub" style="width: 175px;">Submit</button>
  ';
  die();
}
$down = $_POST['down'] * 1000;  // 999 = Mbps . 925 = décimal
$up = $_POST['up'] * 1000; // 999 = Mbps . 794 = décimal
$ping = $_POST['ping'];
$server = '3729';
$accuracy = 8;
$hash = md5("$ping-$up-$down-297aae72");
$headers = Array(
      'POST /api/api.php HTTP/1.1',
      'Host: www.speedtest.net',
      'User-Agent: DrWhat Speedtest',
      'Content-Type: application/x-www-form-urlencoded',
      'Origin: http://c.speedtest.net',
      'Referer: http://c.speedtest.net/flash/speedtest.swf',
      'Cookie: PLACE YOUR COOKIE HERE',
      'Connection: Close'
    );
    $post = "startmode=recommendedselect&promo=&upload=$up&accuracy=$accuracy&recommendedserverid=$server&serverid=$server&ping=$ping&hash=$hash&download=$down";
    //$post = urlencode($post);
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'http://www.speedtest.net/api/api.php');
    curl_setopt($ch, CURLOPT_ENCODING, "" );
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_FRESH_CONNECT, 1);
    $data = curl_exec($ch);
    foreach (explode('&', $data) as $chunk) {
      $param = explode("=", $chunk);
      if (urldecode($param[0])== "resultid"){
      print '<h1>Result generated</h1>
      <h3>DOWN: ' . $_POST['down'] . 'mbps, UP: ' . $_POST['up'] . 'mbps, PING: ' . $ping . '</h3>
      <a href="http://beta.speedtest.net/my-result/'.urldecode($param[1]) . '" target="_BLANK">' . 'http://beta.speedtest.net/my-result/'.urldecode($param[1]) . '</a> (Opens in new tab) <br>
      A script by <a href="https://jaydontaylor.com">Jaydon Taylor</a><br>
      <a href="" onclick="window.location.reload()">Click here to try another one!</a>

      ';
      }
    }
?>
