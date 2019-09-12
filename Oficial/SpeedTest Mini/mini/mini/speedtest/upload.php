<?php
// Copyright 2007 Ookla
// Calculates the size of an HTTP POST
$size = 500;
$request = isset($_REQUEST)?$_REQUEST:$HTTP_POST_VARS;
foreach ($request as $key => $value) {
   $size += (strlen($key) + strlen($value) + 3);
}
printf("size=%d",$size);
exit;
?>
