# OScript-WebScript-AdventOfCode
My Advent of Code Solutions in OScript/~~WebScript~~

**Update**: It was *painful*. Webscript has a lot of restrictions for Oscript. Some were reasonably easy to get around. For example the inability to call Assoc keys by variable (eg. myAssoc.(myVar) ) was able to work around with some fancy footwork. Other restrictions were silly: inability to use the word "set", or "long" even in comments.
The breaking point unfortunately was with lack of Global Variables. Day 12 part 2 in particular I needed a global but because I could not call it, I had to keep passing around an Assoc cache as a variable. This slowed down the code so much as the assoc got many millions of entries. Some timimg:
* Raw recursion: 48 hours and it only got through 19 of the thousand lines.
* Recursion with cache passed through: 48 hours and got to line 640 of the thousand lines. Each line started taking 10 minutes, etc.
* Recursion with cache being RESET(!!!) each line: 25 minutes to complete.
* In Oclipse, with a Global variable: 49 seconds.
I expected OScript to be slower - it's from the early 1990's, it's not compiled, it's not meant for this kind of thing. But as of day 12 part 2 I'm going full Oscript. Still am limited with the API, and no multithreading.

Thank you for your understanding. :-)

Some earlier notes below:

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
- There is no ability to multithread.
- Resticted to the following packages: Assoc, Bytes, Date, List, Math, Pattern, RecArray, Str, String, Boolean, Undefined, Void, Integer, Real, Record
  - Note that subitems are not allowed. For example, we cannot use PatFind or PatChange. Need to overload Pattern all the time.

Input
- Data Source Type: Content Server File
- File Type: Separated Values
- Content Type: No cells are quoted
- Column Separator: typically "," but sometimes ":"
- Row Separator: \n
- Column Headings Included: Unchecked

My approach is to solve the problems - not necessarily to be elegant or efficient. Just see if I can solve them given the tools available.

One update: Enabled the keyword "Set" to be allowed. This is strictly for Str.Set. Day 10 part 2 was when it was first used.
There is someone who solved all of them with a Commodore 64, so there is that.... :-)