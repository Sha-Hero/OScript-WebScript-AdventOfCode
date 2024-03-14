# WebScript-AdventOfCode-2023
My Advent of Code Solutions in OScript/WebScript for 2023

Note that these make the following assumptions:
- Each has been implemented as oscript functions in webscript in a WebReport in GCdocs
- Each has the input file as the WebReport source
- "Vanilla" permissions. That is, restricted to the default functions available in WebScripts

Restrictions/Quirks
- WebReports don't "run" linearly per-se. They interpret then display.
- "Error with [LL_WEBREPORT_STARTSCRIPT /]. The use of .() is not permitted within an Oscript block in a reportview.. "
  - This means limited use of Assoc.
  - However, the workaround is to use a stringified input (the "myAssoc" here): String output = ._subtag(Str.ValueToString(myAssoc),'ASSOC:'+ myKey)
  - Of course, with the Content Server bug the Assoc value must also be a string. So store the value as a stringified value.
- All coding is done in OScript. There is some jQuery and HTML but that's only for displaying results.
- WebScript - you can't assign return values to a variable. Return values are only "displayable"
-   Remember - WebReports are primarily meant for prettifying output.

Input
- Data Source Type: Content Server File
- File Type: Separated Values
- Content Type: No cells are quoted
- Column Separator: typically "," but sometimes ":"
- Row Separator: \n
- Column Headings Included: Unchecked

My approach is to solve the problems - not necessarily to be elegant or efficient. Just see if I can solve them given the tools available.
