<?
require('timing.inc');
?>

<? // Time for loading file

$i=0;

ss_timing_start();

for ($i;$i<1000;$i++) {
  $cleaned = join('',file("test.txt"));
//  echo $cleaned;
}

ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>File loading and joining (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";

?>

<? // Used for Stripping
$text = join('',file("test.txt")); 
?>

<? // Tag Stripping with ereg

$i=0;

ss_timing_start();

for ($i;$i<1000;$i++) {
  $cleaned = ereg_replace('<([^>]|\n)*>', '', $text);
//  echo $cleaned;
}

ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>Total Stripping w/ ereg (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";

?>

<? // Complete Tag Stripping
$i = 0;

ss_timing_start();

for ($i;$i<1000;$i++) {
  $cleaned = strip_tags($text); 
}

ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>Total Stripping Time (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>

<? // Selected Tag Stripping
$i = 0;

ss_timing_start();

for ($i;$i<1000;$i++) {
  $cleaned = strip_tags($text,'<a><b><i><u><img><ul><ol><li>'); 
}

ss_timing_stop();

$time1 = ss_timing_current();

echo "<table><tr><td width='300'>Selected Stripping Time (1,000x):</td><td width='200'>$time1</td></tr></table><div style='border:1px solid black;padding:10px;width:300px;margin-bottom:30px;'>$cleaned</div>";
?>





<? // Attribute Cleaner

// strip problem tags


//remove all attributes except for list
// alt, style

eregi_replace("([ \f\r\t\n\'\"])style=[^>]+", "\\1", $string);
eregi_replace("([ \f\r\t\n\'\"])on[a-z]+=[^>]+", "\\1", $string);


// convert unbalanced > and < to entities;

// clean hrefs (no javascript:)
// clean events
// clean attribute=""attribute2 (space smuggling)
// clean attribut=" attribute2=""
// clean attributes without values
// clean attribute=" attribute2=""
// clean attribute=" attrnoval>

// * str_repl( event array tag)
// * str_repl ( javascript: within href)


/*
function safeHTML($text) {
$text = stripslashes($text);
$text = strip_tags($text, '<b><i><u><a>');
$text = ereg_replace ("<a[^>]+href *= *([^ ]+)[^>]*>", "<a href=\\1>", $text);
$text = ereg_replace ("<([b|i|u])[^>]*>", "<\\1>", $text);
return $text;
}
*/

function safeHTML($html, $tags = "b|br|i|u|ul|ol|li") { 
// removes all tags that are considered unsafe 

// why should there be a null character 
$html = preg_replace('/\0/', '', $html); 
// convert the ampersants to null characters 
$html = preg_replace('/\&/', '\0', $html); 
// convert the sharp brackets to there html code and excape special charachters such as " 
$html=htmlspecialchars($html);
// restore the tags that are concidered safe 
if ($tags) { 
//this statement not only escapes "unsafe" tags, but also removes all attributes from SAFE tags
$html = preg_replace("/&lt;($tags).*?&gt;/i", '<\1>', $html); 
$html = preg_replace("/&lt;\\/($tags)&gt;/i", '</\1>', $html); 
} 
/*if (count($tags_with_attrs)){

}*/
// restore the ampersants 
$html = preg_replace('/\0/', '&', $html); 

return($html); 
} // safeHTML

?>

