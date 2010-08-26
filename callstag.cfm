<cfset text="<html> This is a test case for tags.  What will work, <la dee da>
<bad tag> We have unbalanced tags, all sorts of <br> stuff.

<p align='right'>Test attributes and blocks and all kinds of wee fun</p>
<title>Untitled</title> - <h1 style='color:red'>hey</h1> you, what's going on with the gestapo crap.  <a href='http://slashdot.org'>links to slashdot</a> and how about some <a href='javascript:alert('foo')'>javascript links</a>? or some <span onmouseover='alert('foo');'>stuff?</span>  

and lets leave some open tags <b><i>
for good measure.
</head><body>">

<textarea style="width:100%;height:80%;"><cfloop index="i" from="1" to="1"><cfoutput><CF_balanceTags text=#text#></cfoutput></cfloop></textarea>
