# Tap Utils

Tiny utilities to extract information from your TapCellar backup.

Currently these utils need a valid JSON file as input. Argument and error handling is a bit crude at the moment.

## tap-avg-grades.rb

Returns a table of styles for all graded beers, including:

* style name
* average grade for the style
* number of beers rated for the style
* standard deviation of grades

```
                       Style  Avg Grade  Rated  Std Deviation
  American-Style Amber/Red Ale  C+         4      0.764
      American-Style Black Ale  C          1
      American-Style Brown Ale  C+         1
 American-Style Imperial Stout  B+         6      0.401
 American-Style India Pale Ale  B          25     0.755
       American-Style Pale Ale  B-         10     0.837
       American-Style Pilsener  C-         2      0.719
American-Style Strong Pale Ale  B-         1
 American-Style Wheat Wine Ale  D          1
```

Pass in the path and filename of a valid TapCellarBackup.json file.

```ruby tap-avg-grades.rb TapCellarBackup.json```

## tap-shopping.rb

A command line version of the Shopping List filter.

Pass in the path and filename of a valid TapCellarBackup.json file.

```ruby tap-shopping.rb TapCellarBackup.json```

Currently the output is sorted by beer name.

## tap-styles.rb

Returns a chart illustrating the number of graded beers for all styles with grades, as well as broad style categories such as IPAs, Stouts and so on.

```
                         Style  Rated Beers
  American-Style Amber/Red Ale  ||||
      American-Style Black Ale  |
      American-Style Brown Ale  |
 American-Style Imperial Stout  ||||||
 American-Style India Pale Ale  |||||||||||||||||||||||||
       American-Style Pale Ale  ||||||||||
       American-Style Pilsener  ||
American-Style Strong Pale Ale  |
 American-Style Wheat Wine Ale  |
```

Pass in the path and filename of a valid TapCellarBackup.json file.

```ruby tap-styles.rb TapCellarBackup.json```

## tap-timeline.rb

Returns a chart illustrating grades over time (oldest to newest) for styles containing a specified string.

```
Grade timeline for styles containing: Stout

Date        Grade F          A+
2014-10-12  A               *
2014-10-12  B            *
2014-10-12  B+            *
2014-10-12  A               *
2014-10-12  B            *
2014-10-12  C         *
2014-11-11  B+            *
2014-11-16  B            *
2014-11-17  B+            *
```

Pass in a string to match against style names as the first argument and the path and filename of a valid TapCellarBackup.json file as the second argument.

```ruby tap-styles.rb [style] [filename]```

For example, the following returns all IPAs, including double and imperial variants.

```ruby tap-timeline.rb "india pale ale" TapCellarBackup.json```

If the style name or file name contains spaces or characters that require escaping, use quotes around the string. Which is a good idea in any case.