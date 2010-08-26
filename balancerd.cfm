<cfset text="<html> This is a test case for tags.  What will work, <la dee da>
<bad tag> We have unbalanced tags, all sorts of <br> stuff.

<p align='right'>Test attributes and blocks and all kinds of wee fun</p>
<title>Untitled</title> - <h1 style='color:red'>hey</h1> you, what's going on with the gestapo crap.  <a href='http://slashdot.org'>links to slashdot</a> and how about some <a href='javascript:alert('foo')'>javascript links</a>? or some <span onmouseover='alert('foo');'>stuff?</span>  

and lets leave some open tags <b><i>
for good measure.
</head><body>">
<cfoutput>#text#</cfoutput>
<cfoutput>#Chr(13)##Chr(10)##Chr(13)##Chr(10)##Chr(13)##Chr(10)#</cfoutput>



<textarea style="width:100%;height:80%;"><cfloop index="i" from="1" to="1000"><cfoutput>#safetext(text)#</cfoutput></cfloop></textarea>

<CFSCRIPT>
/** 
 * balanceTags
 *
 * Balances Tags of string using a modified stack.
 *
 * @param text      Text to be balanced
 * @return          Returns balanced text
 * @author          Leonard Lin (leonard@acm.org)
 * @version         v1.0
 * @date            October 28, 2001
 * @license         GPL v2.0
 * @notes           MUST KILL PERSON WHO DECIDED ARRAYS SHOULD START AT 1
 *
**/

function balanceTags(text) {
  var tagstack = ArrayNew(1);
  var stacksize = 0;
  var tagqueue = "";
  var newtext = "";
  var offset = 0;
  var regex = 0;
  var space = 0;
  var attributes = "";
  var tag = "";

  // DEBUG
  var debug = "";  
  
  regex = REFind("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",  text, 1, TRUE);

  // what the hell is this retarded object construct?  fuck cold fusion.  fuck cold fusion.
  // this makes no sense, why don't you count starting with 0.  why do you have an array
  // within an object?  what's your damage heather?
  
  // did i mention how moronic mixing javascript syntax with cf operators is?
  while(regex.pos[1]) {
    // hey bitches, it's not a "JavaScript-like language" if you can't do simple
    // += concatenation.  what kind of monkeys devised CFMLScript again?
    // there we go mixing cf and js again.
    newtext = newtext & tagqueue;
    
    // DEBUG
    debug = debug & "tagqueue: " & tagqueue & "#Chr(13)##Chr(10)#";
    
    // Clear shifter
    tagqueue = "";
    
    // Pop or Push
    if (Mid(text, regex.pos[1]+1, 1) eq "/") { // Close Tag
      tag = Lcase(Mid(text,regex.pos[1]+2, regex.len[1]-3));

    // DEBUG 
    debug = debug & "tag: " & tag & "#Chr(13)##Chr(10)#";
    debug = debug & "arraylen: " & ArrayLen(tagstack) & "#Chr(13)##Chr(10)#";
    debug = debug & "tagstack[" & ArrayLen(tagstack) & "] : " & tagstack[ArrayLen(tagstack)] & "#Chr(13)##Chr(10)#";
    /* for(i=1; i lte ArrayLen(tagstack); i=i+1) {
    debug = debug & tagstack[i] & " - " & Mid(text, regex.pos[1]+1, 3) & "#Chr(13)##Chr(10)#";
    } */
     
      //too many closing tags
      if(ArrayIsEmpty(tagstack)) {
        tag = ""; // can close (tag = "</" & tag & ">";) if you wanted to be safe
      } else if(tagstack[ArrayLen(tagstack)] eq tag) { // found tag at top in stack
        tag = "</" & tag & ">";
        //Pop
        
        debug = debug & "pop!!!!!" & "#Chr(13)##Chr(10)#";
        
        ArrayDeleteAt(tagstack, ArrayLen(tagstack)) ;
      } else { // closing tag not at top, search for it
        for(j=ArrayLen(tagstack); j gte 1;j=j-1) {
          if(tagstack[j] eq tag) {
            //add tag (and preceding) to tagqueue
            for(k=ArrayLen(tagstack);k gte j;k=k-1) {
              tagqueue = tagqueue & "</" & tagstack[k] & ">";
              ArrayDeleteAt(tagstack, k);
            }
            break;
          }
        }

        // it's an extra closing tag
        tag = ""; // can close (tag = "</" & tag & ">";) if you wanted to be safe
      }  
    } else { // Open Tag
    
      // Need to separate Attributes from Tags because cf Regex doesn't return groupings correctly
      // BAD cf.  BAD BAD BAD
      tag = Lcase(Mid(text,regex.pos[1]+1, regex.len[1]-2));
      space = Find(" ", tag);
      if(space) {
        attributes = " " & Right(tag,Len(tag)-space);
        tag = Left(tag, space-1);
      } else {
        attributes = "";
      }
      
      // Push if tag should be closed
      if(tag neq "br" and tag neq "img" and tag neq "hr") {
        ArrayAppend(tagstack, tag);
      }
      
      // Tag Cleaning (future call)
      // checkTag(tag);
      // cleanAttributes(attributes);
      // return tag and attributes
      
      // once checkTag, add if(tag) {
      tag = "<" & tag & attributes & ">";
      // }
    }
    
    // DEBUG
    // debug =  debug & Mid(text, regex.pos[1], regex.len[1]) & "#Chr(13)##Chr(10)#";

    // need extra code b/c cf sucks.
    if(Left(text, regex.pos[1]) eq "<") {
      newtext = newtext & tag;
    } else {
      newtext = newtext & Mid(text, 1, regex.pos[1]-1) & tag;
    }
    if(Len(text) lt regex.pos[1]+regex.len[1]) {
      text = "";
    } else {
      text = Mid(text, regex.pos[1]+regex.len[1], Len(text));  
    }

    regex = REFind("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",  text, 1, TRUE);

    // Debug
    debug = debug & "#Chr(13)##Chr(10)#";
    debug = debug & "#Chr(13)##Chr(10)#";
  }

  // Clear Tag Queue
  newtext = newtext & tagqueue;
  
  // Empty Stack (failsafe)
  for(i=1;i lte ArrayLen(tagstack);i=i+1) {
    newtext = newtext & "</" & tagstack[i] & ">";
  }
  
  // Add Remaing Text
  newtext = newtext & text;
 
  return newtext;
}
 
 
function VariancePop(values)
{
  Var MyArray = 0;
  Var NumValues = 0;
  Var xBar = 0;
  Var SumxBar = 0;  
  Var i=0;
  if (IsArray(values)){
     MyArray = values;
    }
  else {
     MyArray = ListToArray(values);
    }
  NumValues = ArrayLen(MyArray);
  xBar = ArrayAvg(MyArray);
  for (i=1; i LTE NumValues; i=i+1) {
    SumxBar = SumxBar + ((MyArray[i] - xBar)*(MyArray[i] - xBar));
    }
  Return SumxBar/NumValues;
}


/**
 * Removes potentially nasty HTML text.
 * 
 * @param text 	 String to be modified. 
 * @param strip 	 Boolean value (defaults to false) that determines if HTML should be stripped or just escaped out. 
 * @param badTags 	 A list of bad tags. Has a long default list. Consult source. 
 * @param badEvents 	 A list of bad HTML events. Has a long default list. Consult source. 
 * @return Returns a string. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, July 17, 2001 
 */
function safetext(text) {
	//default mode is "escape"
	var mode = "escape";
	//the things to strip out (badTags are HTML tags to strip and badEvents are intra-tag stuff to kill)
	//you can change this list to suit your needs
	var badTags = "SCRIPT,OBJECT,APPLET,EMBED,FORM,LAYER,ILAYER,FRAME,IFRAME,FRAMESET,PARAM,META";
	var badEvents = "onClick,onDblClick,onKeyDown,onKeyPress,onKeyUp,onMouseDown,onMouseOut,onMouseUp,onMouseOver,onBlur,onChange,onFocus,onSelect,javascript:";
	var stripperRE = "</?(" & ListChangeDelims(badTags,"|") & ")[^>]*>";		
	//set up variable to parse and while we're at it trim white space and deal with "smart quotes" from MS Word, etc.
	var theText = trim(REReplace(text,"(’|‘)", "'", "ALL"));
	//find the first open bracket to start parsing
	var obracket = find("<",theText);		
	//var for badTag
	var badTag = "";
	//var for the next start in the parse loop
	var nextStart = "";
	//if there is more than one argument and the second argument is boolean TRUE, we are stripping
	if(arraylen(arguments) GT 1 AND arguments[2]) mode = "strip";
	if(arraylen(arguments) gt 2 and len(arguments[3])) badTags = arguments[3];
	if(arraylen(arguments) gt 2 and len(arguments[4])) badEvents = arguments[4];
	
	//if escaping, run through the code bracket by bracket and escape the bad tags.
	if(mode is "escape"){
		//go until no more open brackets to find
		while(obracket){
			//find the next instance of one of the bad tags
			badTag = REFindNoCase(stripperRE,theText,obracket,1);
			//if a bad tag is found, escape it
			if(badTag.pos[1]){
				theText = Replace(theText,Mid(TheText,badtag.pos[1],badtag.len[1]),HTMLEditFormat(Mid(TheText,badtag.pos[1],badtag.len[1])),"ALL");
				nextStart = badTag.pos[1] + badTag.len[1];
			}
			//if no bad tag is found, move on
			else{
				nextStart = obracket + 1;
			}
			//find the next open bracket
			obracket = find("<",theText,nextStart);
		}
	}
	//if not escaping, assume stripping
	else{
		theText = REReplaceNoCase(TheText,StripperRE,"","ALL");
	}
	//now kill the bad "events" (intra tag text)
	theText = REReplace(theText,(ListChangeDelims(badEvents,"|")),"","ALL");
	//return theText
	return theText;
}



</CFSCRIPT> 


<!--

function balanceTags($text) {
  $tagstack = array();
  $stacksize = 0;
  $tagqueue = '';       // holds closing tag

 	while (ereg("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",$text,$regex)) {
    $tmp = $tmp . $tagqueue;
    
		$i = strpos($text,$regex[0]);
		$l = strlen($tagqueue) + strlen($regex[0]);

    // clear the kludge variables;
    $tagqueue = '';
    $instack = 0;
   
    // Pop or Push
		if ($regex[1][0] == "/") { // End Tag
      $tag = strtolower(substr($regex[1],1));
      
      // DEBUG
      echo "Closing: /$tag\n";
      
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
          }
        }
          $tag = '';
          //close to be safe $tag = '/' . $tag;
      }
    }	else { // Begin Tag
      $tag = strtolower($regex[1]);
      
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
  
  // Empty Stack
  while($x = array_pop($tagstack)) {
    $tmp = $tmp . '</' . $x . '>'; // Add remaining tags to close      
  }
  
  // Add Remaining text
  $tmp .= $text;
  echo $tmp;
}


-->

<!---
<cfset tagstack = "ArrayNew()">
<cfset stacksize = "0">
<cfset tagqueue = "">
<cfset i = "1">
<cfset l = "0">




<cfloop condition="text gt 0">


  <cfset regex = REFind("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",text,i,"TRUE")> 
  
  <cfoutput>
    Substring is: [#Mid(text,regex.pos[1],regex.len[1])#]
  </cfoutput>

  <cfset l = regex.pos[1] + regex.len[1]>
  <cfset i = l + i>
  <cfset test = Right(text,Len(text)-l+1)>
  <cfoutput>
    l: #l#
    i: #i#
    test: #test#
  </cfoutput>
  
  
  

</cfloop>

--->

</textarea>
<hr>
<!--
REFind(reg_expression, string [, start ] 
  [, returnsubexpressions ] ) 

  
 	while (ereg("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",$text,$regex)) {
    // DEBUG
    //echo "\$text: $text\n";
    //echo "\$tmp: $tmp\n";
    //echo "Adding \$tagqueue: $tagqueue\n";
  
    $text = $text . $tagqueue;
		$i = strpos($text,$regex[0]);
		$l = strlen($tagqueue) + strlen($regex[0]);

    // clear the kludge variables;
    $tagqueue = '';
    $instack = 0;
    
    
    // DEBUG
    //array_walk($regex, 'print_array');
    
    //echo "stacksize: $stacksize\n";
    
    //print_r($tagstack);
    //print_r($regex);
    //array_walk($tagstack, 'print_array');
  
    // Pop or Push
		if ($regex[1][0] == "/") { // End Tag
      $tag = strtolower(substr($regex[1],1));
      
      // DEBUG
      //echo "Closing: /$tag\n";
      
      // if too many closing tags
      if($stacksize <= 0) { //close to be safe
        $tag = '/' . $tag;
        
        // DEBUG
        //echo "Popping $tag to be safe (stacksize 0, shouldn't happen)\n";
      }
      // if stacktop value = tag close value then pop
      else if ($tagstack[$stacksize - 1] == $tag) { // found closing tag
        $tag = '/' . $tag; // Close Tag
        
        // DEBUG
        //echo "Popping $tag (top of stack)\n";
              
        // Pop
        array_pop ($tagstack);
        $stacksize--;
      } else { // closing tag not at top, search for it
        $instack = 0;
        for ($j=$stacksize-1;$j>=0;$j--) {
          // DEBUG
          //echo "-Looking through \$tagstack[$j]\n";
          if ($tagstack[$j] == $tag) {
            // DEBUG
            //echo "Found a match for $tag at \$tagstack[$j]\n";
          
            // add tag to tagqueue
            for ($k=$stacksize-1;$k>=$j;$k--){

               // DEBUG
               //echo "Popping $tagstack[$k] (found in stack)\n";

               $tagqueue = '</' . array_pop ($tagstack) . '>' . $tagqueue;
               $stacksize--;
               
               $instack = 1;
            }
          }
        }
        if (!$instack) {
          // DEBUG
          //echo "Closing $tag (not in stack!)\n";
        
          $tag = '/' . $tag; // Close Tag
        }
      }
      
      //search&pop
    }	else { // Begin Tag
      $tag = strtolower($regex[1]);
      
      //DEBUG
      //echo "Pushing $tag\n";
      
      // Push if not img or br
      if($tag != 'br' && $tag != 'img') {
        $stacksize = array_push ($tagstack, $tag);
      }
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
 
    if($instack) {
      $tag = '';
    }
        
		$tmp .= substr($text,0,$i) . $tag;
		$text = substr($text,$i+$l);
  }  

  // Clear Tag Queue
  $tmp = $tmp . $tagqueue;
  
  // DEBUG
  //echo "Extra in the stack, popping $x\n";
  
  // Empty Stack
  while($x = array_pop($tagstack)) {
    $tmp = $tmp . '</' . $x . '>'; // Add remaining tags to close      
  }

  echo $tmp;
}
-->
