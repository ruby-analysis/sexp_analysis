#Ruby Sexp analysis

Tool for quickly scanning a project and counting sexp values.
Can use to get a quick overview of the domain concepts used in an app.

`stop_words` includes words you would typically wish to ignore in a ruby or rails project

#Usage

##Sexp analysis
This counts and sorts the S-expressions in the glob of files.

```
./analysis <glob> [exclusion_glob]

#examples

./analysis ../app/models/**/*.rb
10987  Foo
5132   Bar
32     Baz
....

./analysis ../app/**/*.rb ../app/views/**/*
99910987  Foo
995132    Bar
12332     Baz

```

##Tree cohesiveness visualization

This just provides a visualization of terms used and how dispersed they are
* Green tick - full path matches the term
* Red cross  - no match of path but term in file
* White Dot  - a file with no match

```
./tree "../app/**/*" search
../app/assets/stylesheets........X.....
../app/controllers
../app/controllers/admin.................
../app/controllers/search√..........
../app/decorators.....
../app/decorators/structure_formatter..
../app/decorators/structure_formatter/coordinates.......
../app/forms....
../app/helpersX
../app/interactors....
../app/kanji......
../app/models..............
../app/models/wwjdic.......................
../app/search.√
../app/views
../app/views/admin
../app/views/admin/users....
../app/views/assembly_line_quizzes.
../app/views/beginner........
../app/views/dashboards.
../app/views/examples...
../app/views/flags.
../app/views/guesses.
../app/views/kanjis........
../app/views/layouts....
../app/views/most_mistakens.
../app/views/my_profiles...
../app/views/navigation.....
../app/views/primitives..X..
../app/views/quizzes.....
../app/views/search
../app/views/search/lookups√√√
../app/views/study_items..
../app/views/subscriptions..
../app/views/unfinished_quizzes...
../app/views/welcome........
```


#Future ideas
* Use more information from the sexp to determine class and method definitions
and try and infer usages.
* Use data to make an estimate of afferent and efferent coupling.
* Create a heuristic using the coupling info plus each file sexp as a sub-branch upon
each file node in the directory strucutre.
* Turn heuristic analysis into a useful metric for cohesiveness and highlight potential
code/architectural issues like code climate.


for each file
  count each term (exclude stop words)
    #find the main purpose of this file
    most common terms get a multiplier

for each term
  calculate an incoherence value
    add distance of directory traversals to other mentions
    optionally: increase based on alphabetic distance within a directory

add sum of terms in a file, gives an incoherence value

