<? $att = 'href = "http://stupidtest.org/UpperCase/" src="javascript:window.open" single test = making it hard style = "attribute'; ?>
<?= cleanAttributes($att) ?>

<?

function cleanAttributes($attributes) {
  // do a regex to separate attributes
  // STYLE SRC HREF TYPE on*
  // preg_match ("/^on/", $attributes);

  $name = 1; // if we're in a name or a value
  $quote = 0; // quote open or not
  $new ='';
  $attr = '';
  $i = 0;
  $l = 0;
  $found = 1;
 
  while($found) {
    if($name) {
      $found = preg_match('/([^\s=]+)\s*([=]*)/i', $attributes, $regex);
      
      $attr .= strtolower($regex[1]);
  		$i = strpos($attributes,$regex[0]);
      
      // DEBUG
      echo "<fieldset><legend>name</legend>attributes: [$attributes]<br>regex[1]: [$regex[1]]</fieldset><br>";
	  	$l = strlen($regex[0]);

      // strip quotes in attribute names
      $attr = str_replace('"', '', $attr);
      
      if($attr == 'style' || $attr == 'type' || preg_match('/^on/', $attr)) { // allow src and hrefs
        $attr = ' ';
      } else {
        if($regex[2]) {
          $attr .= '=';
          $name = 0;
        } else {
          $attr .= ' ';
        }
      }
    } else { //var
      $found = preg_match('/("?)([^\s"]+)("?)/i', $attributes, $regex);
      $attr = $regex[0];
  		$i = strpos($attributes,$regex[0]);
	  	$l = strlen($regex[0]);

      //DEBUG
      echo "<fieldset><legend>var</legend>found: $found<br>attributes: [$attributes]<br>regex[2]: [$regex[2]]<br>";
      print_r($regex);
      echo "</fieldset><br>";
      
      if($regex[0]) $quote ? !$quote : $quote;
      if($regex[3]) $quote ? !$quote : $quote;

      if(preg_match('/javascript:/', $attr)) {
        $attr = '""';
      }

      // sets to name if closed quote
      $quote ? $name = 0 : $name = 1;
    }

 		$new .= substr($attributes,0,$i) . $attr;
    $attr = '';
		$attributes = substr($attributes,$i+$l);
  }

  $new .= $attributes;

  // open quote
  $quote ? $new .= '"' : $new ;

  return $new;
}

?>