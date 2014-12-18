# Tap Utils

Tiny utilities to extract information from your [TapCellar](http://tapcellar.com/) backup.

Currently these utils need a valid TapCellarBackup.json data file as input, which you can extract from a TapCellar Backup.tap file. Argument and error handling is a bit crude at the moment.

## Extracting TapCellarBackup.json

It's easy to create a backup of your TapCellar data. Swipe from the left, then select "Preferences" and "Backup Your Database".

There are several options for backing up your data. The backup can be quite large &mdash; mine are over 30 MB &mdash; so choose a location that can accommodate a large file. I've used both Dropbox and AirDrop with success.

You'll end up with a backup.tap file. As described in the TapCellar help:

> TapCellar backups are zip files with the extension “.tap”. If you want to look inside one, just change the extension to “.zip” and have a look. Just be warned that messing with a backup may mean you can’t restore it later.

While you're changing the extension, I suggest changing the name of the file so you don't accidentally overwrite it with a future backup. Adding a date is a decent idea:

```mv backup.tap backup_2014-11-30.zip```

Now you can open the zip archive. The following utilities read their data from the TapCellarBackup.json file. Note the path to this file and pass it as the last argument when you run these Ruby scripts.

## tap-avg-grades.rb

Returns a table of styles for all graded beers, including:

* style name
* average grade for the style
* number of beers rated for the style
* standard deviation of grades

The output looks something like this:

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

TapCeller has a nice Shopping List saved filter. This utility just lets you output the Shopping List from your backup for, say, printing. If that's how you roll.

The output looks something like this:

```
# TapCellar Shopping List #

Chasin' Freshies [American-Style India Pale Ale]
Deschutes Brewery

Sensi Harvest [Fresh "Wet" Hop Ale]
Sixpoint Brewery

Hi-Res [Imperial or Double India Pale Ale]
Sixpoint Brewery

Heady Topper [Imperial or Double India Pale Ale]
The Alchemist

War Elephant [Imperial or Double India Pale Ale]
Rushing Duck Brewing Company
```

Pass in the path and filename of a valid TapCellarBackup.json file as the last argument. Options are optional.

```ruby tap-shopping.rb [options] [filename]```

Takes the following options:

| Option | Description |
| ------ | ----------- |
| -f, --filter STRING  | Filter results of sort category by [STRING] |
| -n, --name           |  Sort results by name |
| -b, --brewery        |  Sort results by brewery (default) |
| -s, --style          |  Sort results by style |
| -h, --help           |  Display this screen |

For example, the following returns a shopping list sorted by brewery.

```ruby tap-shopping.rb -b TapCellarBackup.json```

This returns a shopping list sorted by style and only styles that contain the string "ale".

```ruby tap-shopping.rb -s -f ale TapCellarBackup.json```


## tap-styles.rb

Returns a chart illustrating the number of graded beers for all styles with grades, as well as broad style categories such as IPAs, Stouts and so on.

```ruby tap-shopping.rb [options] [filename]```

Optionally pass in the **-c** or **--csv** flag to return style counts in CSV format.

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

Date        Grade F          A+  Name
2014-10-12  A               *    Imperial Russian Stout
2014-10-12  B            *       Sea Monster
2014-10-12  B+            *      Old Growth
2014-10-12  A               *    Yin
2014-10-12  B            *       Old Rasputin
2014-10-12  C         *          Overcast Espresso Stout
2014-11-11  B+            *      Milk Stout Nitro
2014-11-16  B            *       35K
2014-11-17  B+            *      Dragon's Milk
2014-11-25  A+               *   Aún Más Café Jesús
2014-12-05  A+               *   Bourbon County Brand Stout
2014-12-10  A               *    Ten Fidy
```

Pass in a string to match against style names as the first argument and the path and filename of a valid TapCellarBackup.json file as the second argument.

```ruby tap-styles.rb [style] [filename]```

For example, the following returns all IPAs, including double and imperial variants.

```ruby tap-timeline.rb "india pale ale" TapCellarBackup.json```

If the style name or file name contains spaces or characters that require escaping, use quotes around the string. Which is a good idea in any case.

## Changelog

### 12/18/2014

tap-avg-grades.rb
"fixed letter grade conversion"

tap-styles.rb
"simplify reading json" with error handling
"added option handling"
"csv output option"

tap-timeline.rb
"fixed letter grade conversion"
"added beer name to output"