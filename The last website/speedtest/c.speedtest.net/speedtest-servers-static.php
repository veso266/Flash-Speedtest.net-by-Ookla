<?php
header('Content-type: text/xml');
$xml = file_get_contents('servers.xml');
echo $xml;
?>