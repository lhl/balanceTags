<cfset text="<html> This is a test case for tags.  What will work, <la dee da>
<bad tag> We have unbalanced tags, all sorts of <br> stuff.

<p align='right'>Test attributes and blocks and all kinds of wee fun</p>
<br><br><title>Untitled</title> - <h1 style='color:red'>hey</h1> you, what's going on with the gestapo crap.  <a href='http://slashdot.org/UpperCase'>links to slashdot</a> and how about some <a href='javascript:alert('foo')'>javascript links</a>? or some <span onmouseover='alert('foo');'>stuff?</span>  

<p>and lets leave some open tags <b><i>
for good measure.
</head><body>">

<cfset text="It requires that someone be arrested under one of these moronic provisions. ... and if nobody is, then why worry about the law? And that person had better have a few bucks in the bank, because they're gonna need a whole bunch of dough for bail and for an attorney. 

this is a big test sometimes succeed this is a big test sometimes succeed this is a big test sometimes succeed this is a big test sometimes succeed this is a big test sometimes succeed

this is a big test sometimes succeed this is a big test sometimes succeed this is a big test sometimes succeed this is a big test sometimes succeed this is a big test sometimes succeed">
<cfset text="<i <i &nbsp>><i <i &nbsp>>Inside</i <i &nbsp>> foo
">
<cfset text="&lt; &lt & asdf &amp; &gt; &; &##x2021; &##34; <p src=""javascript:bad test""></p><p src=""&{bad}""><p random=""foo foo"" number2=javascript:noquote v=""not at beggining javascript://""><cr asdf=""java
script></p></p><i <i &nbsp>><i <i &nbsp>>Inside</i <i &nbsp>> foo">
<cfset text="favorite line from the cert advisory: <i><b>Web Users Should Not Engage in Promiscuous Browsing</i><br>
<br>
and remember kids, don't drink fake shakes.<br></extra></closing></tags>">
<cfset text="<a href=""&##0106;avascript:alert('foo');""  (window.status='Clinton wins in landslide - dole dejected'); return true>test</a>">
<cfset text="<a href=""http://slashdot.org/article.pl?sid=01/11/07/1312214&mode=nested"" ""is this working""?' title=""foo foo"">link">
<cfoutput>#balanceTags(text)#</cfoutput> foo
<textarea style="width:100%;height:80%;">
<cfloop index="i" from="1" to="1"><cfoutput>#balanceTags(text)#</cfoutput></cfloop></textarea>

<CFSCRIPT>
/*
 balanceTags
 
 Balances Tags of string using a modified stack.
 
 @param text      Text to be balanced
 @return          Returns balanced text
 @author          Leonard Lin (leonard@acm.org)
 @version         v1.51
 @date            November 5, 2001
 @license         GPL v2.0
 @notes           MUST KILL PERSON WHO DECIDED ARRAYS SHOULD START AT 1
 @todo            Refine tag regex to deal better w/ unclosed brackets
 @changelog
             1.51 checkTags for 'marquee' and 'blink' because they're annoying
             1.5  fixed closing tag behavior (allows extra closing tags
                  only when stack is empty - otherwise was adding doubles)
                  cleanAttributes now has more robust value handling
                  (javascript: etc attacks)
             1.41 Allows decimal and hex HTML entities
                  # SIGN BAD
                  filterText filters quotes
             1.4  Changed filterText to better allow HTML entities
                  Changed default behaviour to allow extra closing tags
             1.32 Added filterText function because HTMLEditFormat() strips CRLFs
                  MACROMEDIA MUST DIE
             1.31 Fixed LCase of attribute values
             1.3  Added cleanAttributes function
                  Added HTML Entity Filtering for non tagged text
                  Figured out CF RE subexpressions. Let me reiterate,
                  Counting from 1 is moronic.
                  
             1.2  Added checkTag function (filters malicious tags)
             
             1.1  Fixed handling of append/stack pop order of end text
                  Fixed crash w/ tag w/ space but no attributes
                  Removed most of the invective (I just had to vent)

             1.0  First Version, converted from PHP code
*/

function balanceTags(text) {
  var tagstack = ArrayNew(1);
  var tagqueue = "";
  var newtext = "";
  var regex = 0;
  var space = 0;
  var attributes = "";
  var tag = "";
  
  // would kill for a actual regex subsets vs string pointers
  regex = REFind("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",  text, 1, True);

  while(regex.pos[1]) {
    // Appending shifted code
    newtext = newtext & tagqueue;
  
    // Clear shifter
    tagqueue = "";
    
    // Pop or Push
    if (Mid(text, regex.pos[1]+1, 1) eq "/") { // Close Tag
      tag = Lcase(Mid(text,regex.pos[2]+1, regex.len[2]-1));

      //too many closing tags
      if(ArrayIsEmpty(tagstack)) {
        // it's an extra closing tag
        tag = "</" & tag & ">"; // close to be safe
        //tag = ""; // otherwise you can get rid of it
      } else if(tagstack[ArrayLen(tagstack)] eq tag) { // found tag at top in stack
        tag = "</" & tag & ">";
        //Pop   
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
        //tag = "</" & tag & ">"; // close to be safe
         tag = ""; // otherwise you can get rid of it
      }  
    } else { // Open Tag
    
      tag = Lcase(Mid(text,regex.pos[2], regex.len[2]));

      if(checkTag(tag)) {
        // Push if tag should be closed
        if(tag neq "br" and tag neq "img" and tag neq "hr") {
          ArrayAppend(tagstack, tag);
        }

        // Attributes
        //attributes = Mid(text,regex.pos[3],regex.len[3]);
        attributes = cleanAttributes(Mid(text,regex.pos[3],regex.len[3]));
        if(attributes neq "") {
          attributes = " " & attributes;
        }

        // DEBUG
        //newtext = newtext & "[attributes]" & attributes & "[/attributes]";
  
        tag = "<" & tag & attributes & ">";
      } else {
        tag = "";
      }
    }

    // need extra code b/c cf sucks.
    if(Left(text, regex.pos[1]) eq "<") {
      newtext = newtext & tag;
    } else {
      newtext = newtext & filterText(Mid(text, 1, regex.pos[1]-1)) & tag;
    }
    if(Len(text) lt regex.pos[1]+regex.len[1]) {
      text = "";
    } else {
      text = Mid(text, regex.pos[1]+regex.len[1], Len(text));  
    }

    regex = REFind("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",  text, 1, True);
  }

  // Clear Tag Queue
  newtext = newtext & tagqueue;

  // Add Remaing Text
  newtext = newtext & filterText(text);
 
  // Empty Stack (failsafe)
  for(i=1;i lte ArrayLen(tagstack);i=i+1) {
    newtext = newtext & "</" & tagstack[i] & ">";
  }
  
  // DEBUG
  // newtext = text;
 
  return newtext;
}

/*
 checkTag
 
 Checks Tag of string against known "malicious" tags.  Allows <img>.
 
 @param text      Tag text (must be preparsed)
 @return          Returns boolean if the tag is allowable
 @author          Leonard Lin (leonard@acm.org)
 @version         v1.01
 @date            November 4, 2001
 @license         GPL v2.0
 @notes           see http://www.whitehatsec.com/defcon9_pres_html/dc9_pres.txt
 @changelog 
             1.01 Added "link" tag filtering      
             1.0  First Version, converted from PHP code
*/
function checkTag(tag) {
  var ok = 1;
  if (tag eq "applet" or tag eq "base" or tag eq "body" or tag eq "embed" or tag eq "frame" or tag eq "frameset" or tag eq "html" or tag eq "iframe" or tag eq "layer" or tag eq "link" or tag eq "meta" or tag eq "object" or tag eq "script" or tag eq "style" or eq "blink" or eq "marquee") {
    ok = 0;
  }
  return ok;
}


/*
 cleanAttributes
 
 Parses and cleans attributes of dangerous names and values.
 
 @param text      Attribute text
 @return          Cleaned attribute text
 @author          Leonard Lin (leonard@acm.org)
 @version         v1.21
 @date            November 6, 2001
 @license         GPL v2.0
 @notes           MY GOD COLD FUSION SUCKS ASS
                  stupid subexpressions
                    /Developing_ColdFusion_Applications/regexp6.html#1099114
 
                  . cleans: 
                      names: "style", "type", "on*"
                      values: "javascript:"
                  . closes quotes

 @changelog
             1.22 fixed &quot; bugs
             1.21 HTML Entity filtering for attributes
             1.2  More robust value filtering (javascript: etc)
                  Modified quote behavior
                  Strips <'s from names
                  Spacing fix
                 
             1.01 Fixed Lcase of attributes
             1.0  First Version, converted from PHP code
*/
function cleanAttributes(attributes) {
  var name = 1; // if we're in a name or a value
  var quote = 0; // quote open or not
  var newa = "";
  var attr = "";
  var regex = 1;
  var found = 1;
  var debug = "";
  
  while(found) {
    if(name) {  
      // Can't you do a frickin RE right?  apparently not - [[:space]] doesn't work within a character set
      // 1 hour wasted chasing down bugs because CF doesn't read the escape codes even though the docs
      // /Developing_ColdFusion_Applications/regexp3.html#1098982 say it should.  FUCK YOU ALLAIRE
      regex = REFind("([^#Chr(10)##Chr(13)##Chr(09)# =]+)[[:space:]]*([=]*)", attributes, 1, True);
      found = regex.pos[1];
      
      if(found) {
        attr = Lcase(Mid(attributes, regex.pos[2], regex.len[2]));
      }
    
      // strip quotes in attribute names
      attr = Replace(attr, """", "", "ALL");
      
      // strip <'s - maybe use HTMLEditFormat later...
      attr = Replace(attr, "<", "", "ALL");
      
      // entity filtering
      attr = HTMLEditFormat(attr);
      
      //debug = debug & "#Chr(13)#[attr1]" & attr & "[/attr1]#Chr(13)#";
   
      // DEBUG
      //newa = newa & "[attr name]" & attr & "[/attr name]";
      
      if(attr eq "style" or attr eq "type" or REFind("^on", attr)) { // allow src and hrefs
        attr = " ";
      } else if(found) {
        if(regex.len[3]) {
          attr = attr & "=";
          name = 0;
        } else {
          attr = attr & " ";
        }
        ; // stupid cfscript parser
      }
    } else { //var
      regex = REFind("(""?)([^#Chr(10)##Chr(13)##Chr(09)# ""]+)(""?)", attributes, 1, True);
      found = regex.pos[1];

      if(found) {
        attr = HTMLEditFormat(Mid(attributes,regex.pos[1],regex.len[1]));  
      }

      // FILTERING
      
      attr = REReplaceNoCase(attr, "^([""]?)(javascript:|livescript:|mocha:|&\{)", "\1[filtered]");

      // attack (whitespace) filtering
      if(REFind("^([""]?)(javascript:|livescript:|mocha:)", Trim(Lcase(attr)))) {
        attr = ""; // attack going on, just nullify the whole thing
        // deal with quotes
        if(quote) {
         attr = "[filtered]""";
        } else {
          attr = """[filtered]""";
        }
      }
      // deal with quotes (not attack filtering) 
      else if(found) {
        //replace quotes back
        attr = Replace(attr, "&quot;", """", "ALL");
        
        if(regex.len[2]) {
          if(quote) {
            quote = 0;
          } else {
            quote = 1;
          }        
        }
  
        if(regex.len[4]) {
          if(quote) {
            quote = 0;
          } else {
            quote = 1;
          }        
        }
      }      
      
      // sets to name if closed quote
      if(quote) {
        name = 0;
      } else {
        name = 1;
      }

      attr = attr & " ";
    }

    if(found) {
      newa = newa & attr;
   		//newa = newa & Mid(attributes,1,regex.pos[1]-1) & attr;

     // DEBUG
     //debug = debug & "#Chr(13)#[newa]" & newa & "[/newa]#Chr(13)#";
     //debug = debug & "#Chr(13)#[attr]" & attr & "[/attr]#Chr(13)#";     
     //debug = debug & "#Chr(13)#[mid]" & Mid(attributes,1,regex.pos[1]-1) & "[/mid]#Chr(13)#";
     //return debug;
      
    }
    // DEBUG
    //debug = "#Chr(13)#[attributes]" & attributes & "[/attributes]#Chr(13)#";
    //return debug;

    if(Len(attributes) lt regex.pos[1]+regex.len[1] or regex.pos[1] eq 0) {
      attributes = "";
      found = 0;
    } else {
      attributes = Mid(attributes, regex.pos[1]+regex.len[1], Len(attributes));  
    }
    
    // DEBUG
    //debug = "#Chr(13)#[attributes]" & attributes & "[/attributes]#Chr(13)#";
    //return debug;
    
    attr = "";
  }

  // open quote
  if(quote) {
    newa = newa & """";
  }

  return RTrim(newa);
  
}

// Have to use this because HTMLEditFormat strips CRLFs.  morons
function filterText(text) {
  text = Replace(text, """", "&quot;", "ALL");
  text = Replace(text, ">", "&gt;", "ALL");
  text = Replace(text, "<", "&lt;", "ALL");

  // stupid pound sign
  // bigtime hack because i can't find the opposite regex
  // but it's secure because it's using the previously filtered < as placeholder
  text = REReplace(text, "&([A-Za-z]+;|##[0-9]{2,4};|##x[0-9A-Fa-f]{2,4};)", "<\1", "ALL");  // matches what we want  [A-Za-z]+; - char  #[0-9]{2,4}; - number  #x[0-9A-Fa-f]{2,4}; - hex
  text = Replace(text, "&", "&amp;", "ALL"); // replaces rest of the ampersands
  text = Replace(text, "<", "&", "ALL");

  // not working REReplace(text, "&([^A-Za-z]+[^;])", "&amp;\1", "ALL");

  return text;
}
</CFSCRIPT>
