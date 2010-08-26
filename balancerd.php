<?
require('timing.inc');
?>

<? $text = join('',file("test.txt")); ?>
<? $text = "<u><h1><h2><strong><em><h2></h2></em></strong></u></u></u>asdf"; ?>


<textarea style="width:100%;height:80%;"><? ss_timing_start(); balanceTags($text); ss_timing_stop(); ?></textarea>

time: <?= ss_timing_current() ?>s

<?
function balanceTags($text) {
  $tagstack = array();
  $stacksize = 0;
  $tagqueue = '';       // holds closing tag


  // DEBUG
  echo "$text\n\n";
  //echo "\$text = \"$text\"\n\n";
  
 	while (ereg("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",$text,$regex)) {
    // DEBUG
    echo "\$text: $text\n";
    echo "\$tmp: $tmp\n";
    echo "Adding \$tagqueue: $tagqueue\n";
  
    $tmp = $tmp . $tagqueue;
    
		$i = strpos($text,$regex[0]);
		$l = strlen($tagqueue) + strlen($regex[0]);

    // clear the shifter
    $tagqueue = '';
    
    
    // DEBUG
    //array_walk($regex, 'print_array');
    
    echo "stacksize: $stacksize\n";
    
    print_r($tagstack);
    //print_r($regex);
    //array_walk($tagstack, 'print_array');
  
    // Pop or Push
		if ($regex[1][0] == "/") { // End Tag
      $tag = strtolower(substr($regex[1],1));
      
      // DEBUG
      echo "Closing: /$tag\n";
      
      // if too many closing tags
      if($stacksize <= 0) { 
        $tag = '';
        //or close to be safe $tag = '/' . $tag;
        
        // DEBUG
        echo "Popping $tag to be safe (stacksize 0, shouldn't happen)\n";
      }
      // if stacktop value = tag close value then pop
      else if ($tagstack[$stacksize - 1] == $tag) { // found closing tag
        $tag = '</' . $tag . '>'; // Close Tag
        
        // DEBUG
        echo "Popping $tag (top of stack)\n";
              
        // Pop
        array_pop ($tagstack);
        $stacksize--;
      } else { // closing tag not at top, search for it
        for ($j=$stacksize-1;$j>=0;$j--) {
          // DEBUG
          echo "-Looking through \$tagstack[$j]\n";
          if ($tagstack[$j] == $tag) {
            // DEBUG
            echo "Found a match for $tag at \$tagstack[$j]\n";
          
            // add tag to tagqueue
            for ($k=$stacksize-1;$k>=$j;$k--){

               // DEBUG
               echo "Popping $tagstack[$k] (found in stack)\n";

               $tagqueue .= '</' . array_pop ($tagstack) . '>';
               $stacksize--;
            }
            break;
          }
        }
          // DEBUG
          echo "$tag (not in stack!)\n";
        
          $tag = '';
          //close to be safe $tag = '/' . $tag;
      }
    }	else { // Begin Tag
      $tag = strtolower($regex[1]);
      
      //DEBUG
      echo "Pushing $tag\n";
      
      // Push if not img or br
      if($tag != 'br' && $tag != 'img') {
        $stacksize = array_push ($tagstack, $tag);
      }
    
    /* Tag Cleaning
		if ($a = $AllowableHTML[$tag])
			if ($regex[1][0] == "/") $tag = "</$tag>";
			elseif (($a == 1) || ($regex[2] == "")) $tag = "<$tag>";
			else {
			  // Place here the double quote fix function.
        // SEE PHP Nuke code for ATTRIB CLEANING
			  //$attrb_list=delQuotes($regex[2]);

			  $tag = "<$tag" . $attrb_list . ">";
			} # Attribs in tag allowed
		else $tag = "";
    */

    // Attributes
    $attributes = $regex[2];
    if($attributes) {
      $attributes = " " . $attributes;
    }
    
    $tag = "<$tag" . $attributes . ">";
  }

 		$tmp .= substr($text,0,$i) . $tag;
		$text = substr($text,$i+$l);
  }  

  // Clear Tag Queue
  $tmp = $tmp . $tagqueue;
  
  // Add Remaining text
  $tmp .= $text;

  // Empty Stack
  while($x = array_pop($tagstack)) {
    // DEBUG
    echo "Extra in the stack, popping $x\n";
    $tmp = $tmp . '</' . $x . '>'; // Add remaining tags to close      
  }
  
  echo $tmp;
}