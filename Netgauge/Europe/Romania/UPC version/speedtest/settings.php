<?php
header('Content-type: text/xml');
$xml = file_get_contents('settings.xml');
$xml = str_replace("%CLIENT_IP%", $_SERVER['REMOTE_ADDR'], $xml);
echo $xml;
?>
