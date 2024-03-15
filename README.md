# OScript-WebScript-AdventOfCode
My Advent of Code Solutions in OScript/WebScript

Note that these take the following approaches:
- Each has been implemented as oscript functions in webscript in a WebReport in GCdocs
- Each has the input file as the WebReport source
- "Vanilla" permissions. That is, restricted to the default functions available in WebScripts

Restrictions/Quirks
- WebReports and particularly script results don't "run" linearly per-se. They interpret then display.
- WebScript - you can't assign return values to a variable. Calling a Webscript just outputs directly to the page.
  - Remember - WebReports are primarily meant for prettifying output.
- "Error with [LL_WEBREPORT_STARTSCRIPT /]. The use of .() is not permitted within an Oscript block in a reportview.. "
  - This means limited use of Assoc - which is normally very simple to leverage - primarily around key/value retrieval.
    - The workaround for adding a key/value is create a new assoc, and then Assoc.Merge() the two.
    - The workaround for retrieval is to use a stringified input (the "myAssoc" here): String output = ._subtag(Str.ValueToString(myAssoc),'ASSOC:'+ myKey)
  - Of course, there is a Content Server bug that can only retrieve STRINGS from Assocs, so we must store the value as a stringified value (i.e. '{ 1, 2, 3}')
- All coding is done in OScript. There may be some jQuery and HTML but that's only for displaying results.

Input
- Data Source Type: Content Server File
- File Type: Separated Values
- Content Type: No cells are quoted
- Column Separator: typically "," but sometimes ":"
- Row Separator: \n
- Column Headings Included: Unchecked

My approach is to solve the problems - not necessarily to be elegant or efficient. Just see if I can solve them given the tools available.
