# Tap Utils

Tiny utilities to extract information from your TapCellar backup.

Currently these utils need a valid JSON file as input. Argument and error handling is a bit crude at the moment.

## tap-avg-grades.rb

Returns a table of styles for all graded beers, including:

* style name
* average grade for the style
* number of beers rated for the style
* standard deviation of grades

Pass in the path and filename of a valid TapCellarBackup.json file.

```ruby tap-avg-grades.rb TapCellarBackup.json```

## tap-shopping.rb

A command line version of the Shopping List filter.

Pass in the path and filename of a valid TapCellarBackup.json file.

```ruby tap-shopping.rb TapCellarBackup.json```

Currently the output is sorted by beer name.

## tap-styles.rb

Returns a chart illustrating the number of graded beers for all styles with grades, as well as broad style categories such as IPAs, Stouts and so on.

Pass in the path and filename of a valid TapCellarBackup.json file.

```ruby tap-styles.rb TapCellarBackup.json```

## tap-timeline.rb

Returns a chart illustrating grades over time (oldest to newest) for styles containing a specified string.

Pass in a string to match against style names as the first argument and the path and filename of a valid TapCellarBackup.json file as the second argument.

```ruby tap-styles.rb [style] [filename]```

For example, the following returns all IPAs, including double and imperial variants.

```ruby tap-timeline.rb "india pale ale" TapCellarBackup.json```

If the style name or file name contains spaces or characters that require escaping, use quotes around the string. Which is a good idea in any case.