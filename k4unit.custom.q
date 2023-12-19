// Helper functions for test discovery
/
Returns all files under specified directory
\
walk:{$[(x1~x) or ()~x1:key x;x1;raze .z.s each .Q.dd/:[x;x1]]};

/
Base name of a file handle
e.g. /path/to/file.txt -> file.txt
\
basename:{`$last "/" vs string x};

/
Find all test files under specified directory 
that are matching any of the specified pattern(s)
\
findFiles:{[dir;pattern] f where any (basename each f:walk dir) like\:/: pattern};

/
Load test file (KUltf) with error catch
\
safeKUltf:{@[KUltf;x;{neg[2i]"Failed to load test file ",string[x]," due to: ",y}[x]]};

// TODO: Take CLI arguments
/ .KU.argsType:`verbose`debug`delim`savefile!`long`bool`char`;
/ .KU.args:where[not ()~/:trim .KU.args]#.KU.args:.Q.opt[.z.x];
.KU.PATTERNS:enlist"test*.csv";   / List of patterns used to discern test files

// Test Discovery from within this repository
safeKUltf each findFiles[`:../..;.KU.PATTERNS]; / Load all test files by pattern under kdb directory

// Run Tests
KUrt`;

// TODO: Save Test Results
/ .KU.SAVEFILE:`:./dir/to/save/to/filename.csv;
/ KUstr`;