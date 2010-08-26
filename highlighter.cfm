<cfset text="<a href=""asdf""><asdf>Hello Mister ASDF asdf</asdf></a>asdf">
<cfset text="<a href=""http://kottke.org"">Hello Mister kottkesss</a> kottke">

<textarea style="width:100%;height:80%;">
<cfoutput>#text#</cfoutput>
---
<cfloop index="i" from="1" to="1"><cfoutput>#highlighter(text, #popunder#)#</cfoutput></cfloop></textarea>

<CFSCRIPT>
/*
 highlighter
 
 Highlights keyword on text (but not when the keyword is within HTML)
 
 @param text      Text to be balanced (don't use # signs)
 @param keyword   keyword to search for (use # signs)
 @return          Returns highlighted text
 @author          Leonard Lin (leonard@acm.org)
 @version         v1.0
 @date            November 4, 2001
 @license         GPL v2.0
 @notes           Adapted from balanceTags function
 @changelog  
             1.01 Fixed extra tag append
             1.0  First Version
*/

function highlighter(text, keyword) {
  var newtext = "";
  var regex = 0;
  var tag ="";
  
  regex = REFind("</?[[:alpha:]]*[[:digit:]]?[[:space:]]*[^>]*>",  text, 1, True);
  while(regex.pos[1]) {
    tag = Mid(text,regex.pos[1], regex.len[1]);
    
    // need extra code b/c cf sucks.
    if(Left(text, regex.pos[1]) eq "<") {
      newtext = newtext & tag;
    } else {
      newtext = newtext & mark(Mid(text, 1, regex.pos[1]-1), keyword) & tag;
    }
    if(Len(text) lt regex.pos[1]+regex.len[1]) {
      text = "";
    } else {
      text = Mid(text, regex.pos[1]+regex.len[1], Len(text));  
    }

    regex = REFind("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",  text, 1, True);
  }

  // Add Remaing Text
  newtext = newtext & mark(text, keyword);
 
  return newtext;
}

function mark(text, keyword) {
  REReplaceNoCase(text, "(#keyword#)", "<b>\1</b>", "ALL");
}
</CFSCRIPT>
