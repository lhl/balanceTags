<?
require('timing.inc');
?>



<? $text = join('',file("test.txt")); ?>

<? 
/* Yowza
     ereg time: 5.774313s
     preg time: 1.059208s
*/
?>

<? ss_timing_start("preg"); for($i=0;$i<1000;$i++) echo pregf($text); ss_timing_stop("preg"); ?>

<? ss_timing_start("ereg"); for($i=0;$i<1000;$i++) eregf($text); ss_timing_stop("ereg"); ?>



<p>ereg time: <?= ss_timing_current("ereg") ?>s<br>
preg time: <?= ss_timing_current("preg") ?>s</p>

<?
function eregf($text) {
 	while (ereg("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",$text,$regex)) {
    $text = substr($text,strpos($text,$regex[0]) + strlen($regex[0]));
  }
}    

function pregf($text) {
 	while (preg_match("/<(\/?\w*)\s*([^>]*)>/",$text,$regex)) {
    $text = substr($text,strpos($text,$regex[0]) + strlen($regex[0]));
  }
}    

?>
