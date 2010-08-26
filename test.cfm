<cfoutput>#foo()#</cfoutput>

<cfscript>
function foo() {
      var quote = 0;
      var regex = "";
      var newa = "";
      var attributes = "tag";

   
      // Can't you do a frickin RE right?  apparently not - [[:space]] doesn't work within a character set
      regex = REFind("([^\r\n =]+)[[:space:]]*([=]*)",  attributes, 1, True);

      newa = newa & "[attributes]" & attributes & "[/attributes]";
      newa = newa & "<br>[" & StructKeyList(regex) & ": " & regex.pos[1] & "," & regex.len[1] & "]";
      newa = newa & "<br>[regex.1]" & Mid(attributes, regex.pos[1], regex.len[1]) & "[/regex.1]";
      newa = newa & "<br>[regex.2]" & Mid(attributes, regex.pos[2], regex.len[2]) & "[/regex.2]";      
      newa = newa & "<br>[regex.3]" & Mid(attributes, regex.pos[3], regex.len[3]) & "[/regex.3]";      
      newa = newa & ":<br>[Len(attributes)]" & Len(attributes) & "[/Len]";

      if(Len(attributes) lt regex.pos[1]+regex.len[1] or regex.pos[1] eq 0) {
        attributes = "";
        found = 0;
      } else {
        attributes = Mid(attributes, regex.pos[1]+regex.len[1], Len(attributes));  
      }
      
      newa = newa & "<br>[nextattributes]" & attributes & "[/nextattributes]";

      
      
  if(quote) {
    newa = newa & """";
  }

      return newa;
}
</cfscript>      
