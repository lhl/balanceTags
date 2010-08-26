<?
require('timing.inc');

/* No HTML should:
   . Strip Tags
   . Convert New Lines to <br>
   . Convert Tabs to spaces
   . ? Convert extra spaces to &nbsp;
   . Convert www. and http://, ftp://, etc to urls all (://?)
   
   
   
   nl2br(ereg_replace(" ", " &nbsp;", htmlentities($stringoftext)));
*/

?>

<? // Used for Stripping
$text = join('',file("test.txt")); 
?>

<? // 0.0258 Complete Tag Stripping
$i = 0;

ss_timing_start();
for($i;$i<1000;$i++) {
  $cleaned = strip_tags($text); 
}
ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>Total Stripping Time (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>

<? // 0.0164 Convert CRLF to <BR> nl2br
$i = 0;

ss_timing_start();
for($i;$i<1000;$i++) {
  $cleaned = nl2br($text); 
}
ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>nl2br (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>

<? // 0.4208 Convert CRLF to <BR> preg_replace
$i = 0;

ss_timing_start();
for($i;$i<1000;$i++) {
  $cleaned = preg_replace("/(\015\012)|(\015)|(\012)/","&nbsp;<br />", $text);
}
ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>preg_replace (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>

<? // 0.6582 Convert CRLF to <BR> ereg_replace
$i = 0;

ss_timing_start();
for($i;$i<1000;$i++) {
  $cleaned = ereg_replace("/(\015\012)|(\015)|(\012)/","&nbsp;<br />", $text);
}
ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>ereg_replace (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>

<? // 0.0348 Convert CRLF to <BR> str_replace (only windows)
$i = 0;

ss_timing_start();
for($i;$i<1000;$i++) {
  $cleaned = str_replace("\015\012","<br />", $text);
  //$cleaned = str_replace("\015","<br />", $text);
  //$cleaned = str_replace("\012","<br />", $text);
}
ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>str_replace CRLF (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>

<? // 0.0843 Convert CRLF to <BR> str_replace (all)
$i = 0;

ss_timing_start();
for($i;$i<1000;$i++) {
  $cleaned = str_replace("\015\012","<br />", $text);
  $cleaned = str_replace("\015","<br />", $cleaned);
  $cleaned = str_replace("\012","<br />", $cleaned);
}
ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>str_replace ALL (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>

<? // 0.0777 Convert CRLF to <BR> str_replace (all array)
$i = 0;

ss_timing_start();
for($i;$i<1000;$i++) {
  $cleaned = str_replace(array("\015\012", "\015", "\012"), array("<br />", "<br />", "<br />"), $text);
}
ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>str_replace ALL array (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>
