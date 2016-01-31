#Ruby Sexp analysis

Tool for quickly scanning a project and counting sexp values.
Can use to get a quick overview of the domain concepts used in an app.

`stop_words` includes words you would typically wish to ignore in a ruby or rails project

#Usage

```
./analysis.rb <glob> [exclusion_glob]

#examples

./analysis.rb ../app/models/**/*.rb
10987  Foo
5132   Bar
32     Baz
....

./analysis.rb ../app/**/*.rb ../app/views/**/*
99910987  Foo
995132    Bar
12332     Baz

```
