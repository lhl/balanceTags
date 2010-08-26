<cfsetting enablecfoutputonly="yes">
<cfparam name="attributes.text" default="">

<cfset tagstack=ArrayNew(1)>
<cfset tagqueue="">
<cfset newtext="">
<cfset regex=0>
<cfset space=0>
<cfset attributes="">
<cfset tag="">

<cfset regex=REFind('<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>',  attributes.text, 1, TRUE)>

<cfloop condition="regex.pos[1] neq 0">
  <cfset newtext=#newtext# & #tagqueue#>
  
  <!--- Clear Shifter --->
  <cfset tagqueue="">

  <!--- Pop or Push --->
  <cfif Mid(attributes.text, regex.pos[1]+1, 1) eq "/">
    <cfset tag=#Lcase(Mid(attributes.text,regex.pos[1]+2, regex.len[1]-3))#>

    <cfif ArrayIsEmpty(tagstack) eq 0>
      <cfset tag="">
    <cfelseif tagstack[ArrayLen(tagstack)] eq tag>
      <cfset tag="</" & #tag# & ">">
      <!--- Why is it so hard to frickin execute a function w/o assigning it or outputting anywhere or launching a different language? CF SUX! --->
      <cfscript>ArrayDeleteAt(tagstack, ArrayLen(tagstack));</cfscript>
    <cfelse>
      <cfloop index="j" from=#ArrayLen(tagstack)# to="1" step="-1">
        <cfif tagstack[j] eq tag>
          <cfloop index="k" from=#ArrayLen(tagstack)# to=#j#  step="-1">
            <cfset tagqueue=#tagqueue# & "</" & #tagsstack[k]# & ">">
            <cfscript>ArrayDeleteAt(tagstack, ArrayLen(tagstack));</cfscript>
          </cfloop>
          <cfbreak>
        </cfif>
      </cfloop>     
      <cfset tag="">
    </cfif>
  <cfelse>
    <!--- Separating attributes because cf is retarded --->
    <cfset tag=#Lcase(Mid(attributes.text,regex.pos[1]+1, regex.len[1]-2))#>
    <cfset space=#Find(" ", tag)#>
    <cfif #space#>
      <cfset attributes=" " & #Right(tag,Len(tag)-space)#>
      <cfset tag=#Left(tag, space-1)#>
    <cfelse>
      <cfset attributes="">
    </cfif>

    <cfif tag neq "br" and tag neq "img" and tag neq "hr">
      <cfscript>ArrayAppend(tagstack, tag);</cfscript>
    </cfif>
  
    <!--- Tag Cleaning calls here --->

    <cfset tag="<" & #tag# & #attributes# & ">">
  </cfif>

  <!--- Need extra code b/c cf sucks --->  
  <cfif Left(attributes.text, regex.pos[1]) eq "<">
    <cfset newtext=#newtext# & #tag#>
  <cfelse>
    <cfset newtext=#newtext# & #Mid(attributes.text, 1, #regex.pos[1]#-1)# & #tag#>
  </cfif>
  <cfif (Len(attributes.text) lt #regex.pos[1]#+#regex.len[1]#)>
    <cfset attributes.text="">
  <cfelse>
    <cfset attributes.text=#Mid(attributes.text, regex.pos[1]+regex.len[1], Len(attributes.text))#>
  </cfif>
  
  <cfset regex=#REFind("<(/?[[:alpha:]]*[[:digit:]]?)[[:space:]]*([^>]*)>",  attributes.text, 1, TRUE)#>
</cfloop>

<!--- Clear Tag Queue --->
<cfset newtext=#newtext# & #tagqueue#>

<!--- Empty Stack (failsafe --->
<cfloop index="i" from="1" to=#ArrayLen(tagstack)#>
  <cfset newtext=#newtext# & "</" & #tagstack[i]# & ">">
</cfloop>

<!--- Add Remaining Text --->  
<cfset newtext=#newtext# & #attributes.text#>
 
<cfoutput>#newtext#</cfoutput>


