#Requires -Version 5 

function success($msg) {  write-host "     >  $msg" -f darkgreen }
function info($msg) {   write-host "     >  $msg" -f cyan }
function warn($msg) {  write-host "     >  $msg" -f yellow }