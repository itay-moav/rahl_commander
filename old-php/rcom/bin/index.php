<?php
$home_path = str_replace('/index.php','',$_SERVER['SCRIPT_NAME']);
$command = explode('/',explode('?',str_replace($home_path . '/','',$_SERVER['REQUEST_URI']))[0])[0];
$command_line = false;
echo "Command: <b>{$command}</b>";
echo '<pre>';
require_once '../application/bootstrap.php';
