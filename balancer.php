<?
require('timing.inc');
?>

<? $text = "<u><h1><h2><strong><em><h2></h2></em></strong></u>asdf"; ?>
<? $text = join('',file("test.txt")); ?>

<? // Tag Closer / Balancer
/*
  ideally would use a stack, but if left open, can't...
  ie: <a><b><u></b></a> - everything but the i is closed will it go on?
  2) (and this is easier right? make a stack/array of open tags and pop em off when they're closed
  
   push called on tag open
   
   modpop called on tag close
     if stacktop value = tag close value then pop
     else search stack
       if found, then close and pop all to value
       else close tag
  
  ok, this is my idea for a tag balancer.  instead of mapping out a tree, i'll do the simple thing and do a funky stack hack.  it'll push open tags onto the stack, and try to push things off. but, if it can't find the value, it'll try going through the whole stack. if it doesn't find it at all, it'll close the value.  if it find the value, but not at the top of the stack, it'll close all the tags on the stack preceding it.
  
  this insures that <a><b><u><i></b></a> will be properly closed as <a><b><u><i></i></u></b></a>
  
  tested:
  
  php1 6.335606s 
  php2 6.345435s 
  
  cf1  21.191s
  cf2  20.630s
  
  new (preg)
  php  2.893254s
  cf  21.842s
*/

?>
<textarea style="width:100%;height:80%;">
<? ss_timing_start(); for($i=0;$i<100;$i++) { echo balanceTags($text); } ss_timing_stop(); ?></textarea>

time: <?= ss_timing_current(); ?>s

<?

/*
 balanceTags
 
 Balances Tags of string using a modified stack.
 
 @param text      Text to be balanced
 @return          Returns balanced text
 @author          Leonard Lin (leonard@acm.org)
 @version         v1.1
 @date            November 4, 2001
 @license         GPL v2.0
 @notes           
 @changelog       
             1.2  ***TODO*** Make better - change loop condition to $text
             uhuh, it seems your code transformed <img src="" tag=""> into <img src=" tag=">
             it's in the file b2functions.php - for unicodewell
             
             1.1  Fixed handling of append/stack pop order of end text
                  Added Cleaning Hooks
             1.0  First Version
*/

function balanceTags($text) {
  $tagstack = array();
  $stacksize = 0;
  $tagqueue = '';

 	while (preg_match("/<(\/?\w*)\s*([^>]*)>/",$text,$regex)) {
    $newtext = $newtext . $tagqueue;
    
		$i = strpos($text,$regex[0]);
		$l = strlen($tagqueue) + strlen($regex[0]);

    // clear the shifter
    $tagqueue = '';
   
    // Pop or Push
		if ($regex[1][0] == "/") { // End Tag
      $tag = strtolower(substr($regex[1],1));
      
      // if too many closing tags
      if($stacksize <= 0) { 
        $tag = '';
        //or close to be safe $tag = '/' . $tag;
      }
      // if stacktop value = tag close value then pop
      else if ($tagstack[$stacksize - 1] == $tag) { // found closing tag
        $tag = '</' . $tag . '>'; // Close Tag
        // Pop
        array_pop ($tagstack);
        $stacksize--;
      } else { // closing tag not at top, search for it
        for ($j=$stacksize-1;$j>=0;$j--) {
          if ($tagstack[$j] == $tag) {
            // add tag to tagqueue
            for ($k=$stacksize-1;$k>=$j;$k--){
               $tagqueue .= '</' . array_pop ($tagstack) . '>';
               $stacksize--;
            }
            break;
          }
        }
          $tag = '';
      }
    }	else { // Begin Tag
      $tag = strtolower($regex[1]);

      // Tag Cleaning
      if(checkTag($tag)) {
        // Push if not img or br or hr
        if($tag != 'br' && $tag != 'img' && $tag != 'hr') {
          $stacksize = array_push ($tagstack, $tag);
        }

        // Attributes
        // $attributes = $regex[2];
        $attributes = cleanAttributes($regex[2]);
        if($attributes) {
          $attributes = " " . $attributes;
        }

        $tag = "<$tag" . $attributes . ">";
      } else {
        $tag = '';
      }
    }

 		$newtext .= substr($text,0,$i) . $tag;
		$text = substr($text,$i+$l);
  }  

  // Clear Tag Queue
  $newtext = $newtext . $tagqueue;
  
  // Add Remaining text
  $newtext .= $text;

  // Empty Stack
  while($x = array_pop($tagstack)) {
    $newtext = $newtext . '</' . $x . '>'; // Add remaining tags to close      
  }

  return $newtext;
}



function checkTag($tag) {
  $ok = 1;

  // the using ifs are 25% faster than declaring an array and using in_array()
  if ($tag == 'applet' || $tag == 'base' || $tag == 'body' || $tag == 'embed' || $tag == 'frame' || $tag == 'frameset' || $tag == 'html' || $tag == 'iframe' || $tag == 'layer' || $tag == 'meta' || $tag == 'object' || $tag == 'script' || $tag == 'style') {
    $ok = 0;
  }

  return $ok;
}

function cleanAttributes($attributes) {
  $name = 1; // if we're in a name or a value
  $quote = 0; // quote open or not
  $new ='';
  $attr = '';
  $i = 0;
  $l = 0;
 
  while($attributes) {
    if($name) {
      $found = preg_match('/([^\s=]+)\s*([=]*)/i', $attributes, $regex);
      
      $attr .= strtolower($regex[1]);
  		$i = strpos($attributes,$regex[0]);
      
      //$new .= "[name]$attr" . '[/name]';
      
      // DEBUG
      //echo "<fieldset><legend>name</legend>attributes: [$attributes]<br>regex[1]: [$regex[1]]</fieldset><br>";

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
          if(substr($attributes,$i+$l)) $attr .= ' ';
        }
      }
    } else { //var
      $found = preg_match('/("?)([^\s"]+)("?)/i', $attributes, $regex);
      $attr = $regex[0];
  		$i = strpos($attributes,$regex[0]);
	  	$l = strlen($regex[0]);

      //DEBUG
      //echo "<fieldset><legend>var</legend>found: $found<br>attributes: [$attributes]<br>regex[2]: [$regex[2]]<br>";
      //print_r($regex);
      //echo "</fieldset><br>";
      
      if($regex[1]) $quote ? !$quote : $quote;
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

  //allow badly formed attributes?  i don't think so
  //$new .= $attributes;

  // open quote
  $quote ? $new .= '"' : $new ;

  return $new;
}

function filterText($text) {
  // checkwords
  // checkhtml
}



function print_array($array) {
  echo "---\nValue:$array\n---\n";
}
?>

<? // Simple Balancer
   /* regexp to array for open tags
      regexp to array for close tags 
      those that don't balance, add
    
   */
   
?>

<? // End Balancer
   /* regexp, push, pop for name
      anything left at the end pop */
?>