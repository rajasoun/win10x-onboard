#Requires -Version 5 

function success($msg) {  write-host "     >  $msg" -f darkgreen }
function info($msg) {   write-host "     >  $msg" -f cyan }
function warn($msg) {  write-host "     >  $msg" -f yellow }
function abort($msg, [int] $exit_code=1) { write-host "     >  $msg" -f red; exit $exit_code }
function error($msg) { write-host "ERROR      >  $msg" -f darkred }