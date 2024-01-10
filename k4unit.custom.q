// Helper functions for test discovery
/
Returns all files under specified directory
\
walk:{$[(x1~x) or ()~x1:key x;x1;raze .z.s each .Q.dd/:[x;x1]]};

/
Base name of a file handle e.g. /path/to/file.txt -> file.txt
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

// Command line parsing functions
/
Display help texts from manual file then exit when help option is given
\
displayHelp:{[f;x] if[any x like\: "-*help";neg[1]@/:read0 man;exit 0];};

/
Workflow for parsing CLI options
\
parseArgs:{
  displayHelp[`:./man.txt;x];                    / CLI help
  d:`VERBOSE`DEBUG`DELIM`SAVEFILE`PATTERNS#.KU;       / Defaults defined in .KU
  .KU,:a:.Q.def[d;upper[key opt]!value opt:.Q.opt x]; / Update .KU namespace with args
  show a;
  };

// Variables
.KU.PATTERNS:enlist"test*.csv";   / List of patterns used to discern test files

// Workflows
main:{
  parseArgs .z.x;                                 / Parse CLI options
  safeKUltf each findFiles[`:../..;.KU.PATTERNS]; / Test discovery under directory by pattern
  KUrt`;    / Run tests
  KUstr`;   / Save test results
  };

main`;