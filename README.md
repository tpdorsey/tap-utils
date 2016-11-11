# Tap Utils

Tiny utilities to extract information from your [TapCellar](http://www.macdrifter.com/2016/10/the-end-for-tapcellar.html) backup.

Currently these utils need a valid TapCellarBackup.json data file as input, which you can extract from a TapCellar Backup.tap file. Argument and error handling is a bit crude at the moment.

## Extracting TapCellarBackup.json

It's easy to create a backup of your TapCellar data. Swipe from the left, then select "Preferences" and "Backup Your Database".

There are several options for backing up your data. The backup can be quite large &mdash; mine are over 30 MB &mdash; so choose a location that can accommodate a large file. I've used both Dropbox and AirDrop with success.

You'll end up with a backup.tap file. As described in the TapCellar help:

> TapCellar backups are zip files with the extension “.tap”. If you want to look inside one, just change the extension to “.zip” and have a look. Just be warned that messing with a backup may mean you can’t restore it later.

While you're changing the extension, I suggest changing the name of the file so you don't accidentally overwrite it with a future backup. Adding a date is a decent idea:

```mv backup.tap backup_2014-11-30.zip```

Now you can open the zip archive. The following utilities read their data from the TapCellarBackup.json file. Note the path to this file and pass it as the last argument when you run these Ruby scripts.

## tap-archive.rb

New utility under development to transform TapCellarBackup.json data to CSV for export into other data stores.

Details TK.

## tap-avg-grades.rb

Returns a table of styles for all graded beers, including:

* style name
* average grade for the style
* number of beers rated for the style
* standard deviation of grades

```ruby tap-avg-grades.rb [options] [filename]```

Optionally pass in the **-c** or **--csv** flag to return style counts in CSV format. CSV output includes an integer value between 1 (F) and 13 (A+) for the average grade.

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

The script expects the second to last argument is the keyword string and the last argument is the path and filename of a valid TapCellarBackup.json file.

```ruby tap-shopping.rb [options] [keyword] [filename]```

Takes the following options:

| Option | Description |
| ------ | ----------- |
| -b, --brewery |  Filter on brewery |
| -n, --name    |  Filter on name |
| -s, --style   |  Filter on style (default) |
| -c, --csv     |  Output CSV |
| -h, --help    |  Display help for options |

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

Mean Grade: A-             *
```

For example, the following returns all IPAs, including double and imperial variants.

```ruby tap-timeline.rb "india pale ale" TapCellarBackup.json```

This example returns all Evil Twin beers.

```ruby tap-timeline.rb -b "evil twin" TapCellarBackup.json```

If the filter keyword or file name contains spaces or characters that require escaping, use quotes around the string. Which is a good idea in any case.

## TapCellar Backup Data Reference

This section defines the data exported in a TapCellar backup.

### TapCellarBackup.json Properties

TapCellarBackup.json contains all of the data for your beer and tasting records.

All values are returned as strings.

TapCellarBackup.json will always provide these two base properties.

| Property | Description |
| --- | --- |
| beercount | The number of objects in the `tapcellarbeers` collection. |
| [tapcellarbeers](#tapcellarbeers) | Collection of objects representing beers. |

Note that `beercount` represents only the number of objects returned, not the total number of _valid_ beer records. When parsing beer records you should test against the `tapcellarbeers.grade` property for valid records. Details provided below.

Example:

    {
      "beercount": "349",
      "tapcellarbeers": [...]
    }

### tapcellarbeers

Each object in the `tapcellarbeers` collection represents an individual beer. The data in these records may have been provided by TapCellar's sync function with BreweryDB or by manually adding a record via the "Add a Beer" command within the app.

Each object may contain some or all of the following properties.

| Property | Description |
| --- | --- |
| abv | Alcohol by volume (ABV). |
| bdb_abv | Alcohol by volume (ABV) (provided by BreweryDB). |
| bdb_beeradvocatelink | URL of the Beer Advocate web page for the beer (provided by BreweryDB). |
| bdb_beercolor | Hex color value representing the beer's Standard Reference Method (SRM) color (provided by BreweryDB). |
| bdb_beerdescription | Description of beer (provided by BreweryDB). |
| bdb_beeribu | International Bittering Units (IBU) of beer (provided by BreweryDB). |
| bdb_beerid | ID of the beer in the BreweryDB API. |
| bdb_beerimageurl | URL of a beer label image file (provided by BreweryDB). |
| bdb_beername | Name of the beer (provided by BreweryDB). |
| bdb_breweryname | Name of the brewer (provided by BreweryDB). |
| bdb_ratebeerlink | URL of the RateBeer web page for the beer (provided by BreweryDB). |
| bdb_srm | SRM beer color value (provided by BreweryDB). |
| bdb_style | Name of the beer style (provided by BreweryDB). |
| bdb_styledescription | Description of the beer style (provided by BreweryDB). |
| bdb_untappdlink | URL of the Untappd web page for the beer (provided by BreweryDB). |
| bdb_updatedate | Timestamp of last update for the record (provided by BreweryDB). |
| bdbeditdate | Timestamp related to BreweryDB data, but not sure what it means. |
| beeradvocatelink | URL of the Beer Advocate web page for the beer. |
| beerid | TapCellar ID for the beer. May be the same as `bdb_beerid` if the data came from BreweryDB. |
| beername | Name of the beer. |
| bookmarked | Indicates whether the beer is bookmarked. 0 = false, 1 = true. |
| breweryname | Name of the brewery |
| cellarcount | Number of cellared beers as set by user. |
| color | Hex color value representing the beer's SRM color. |
| createddate | Timestamp indicating when the beer record was originally created. |
| description | Description of the beer. |
| editdate | Timestamp indicating the last time any change was made to the beer record by the user. Does not reflect `bdb_updatedate` changes. |
| grade | Most recent user grade represented as a float. See [Grade Values](#gradevalues) for further explanation of these values and how they can be translated to letter grades. |
| ibu | IBU of the beer. |
| photoname | File name of the beer label image. For example, "BeerLabel Nov 9, 2014, 700 PM.png". If your backup included photos these image files are in the same folder as TapCellarBackup.json. |
| ratebeerlink | URL of the RateBeer web page for the beer. |
| shoppingcart | Indicates whether the beer is on the Shopping List. 0 = false, 1 = true. |
| sortindex | Single character indicating the index category for the beer name. Typically first letter of the beer name or # for names that start with a number. |
| srm | SRM beer color value. |
| style | Name of the beer style. |
| syncdate | Timestamp indicating when beer record data was synced back to BreweryDB. |
| [tastings](#tapcellarbeerstastings) | Collection of objects containing individual Beer Journal entry data. |
| untappdlink | URL of the Untappd web page for the beer. |
| vintage | Vintage year for the beer. |

The data returned has the following structure (some descriptions truncated for clarity):

    {
      "bdb_style": "American-Style India Pale Ale",
      "bdb_abv": "8",
      "style": "American-Style India Pale Ale",
      "color": "E58500",
      "bdb_beercolor": "E58500",
      "bdb_beerid": "R7DkqA",
      "srm": "9",
      "beername": "Vicinity",
      "bdb_srm": "9",
      "editdate": "2016-09-05 08:44:20 GMT-04:00",
      "bdb_beername": "Vicinity",
      "cellarcount": "0",
      "abv": "8",
      "breweryname": "Trillium Brewing",
      "bdb_updatedate": "2016-08-22 16:01:27 GMT-04:00",
      "grade": "3.291906833648682",
      "bdb_styledescription": "American-style India pale ales are perceived to have medium-high to intense hop bitterness...",
      "sortindex": "V",
      "bdb_beerdescription": "Brewed in celebration of the first anniversary of Row 34, our favorite Fort Point oyster bar...",
      "vintage": "0",
      "createddate": "2016-09-05 08:36:35 GMT-04:00",
      "beerid": "R7DkqA",
      "tastings": [...],
      "description": "Brewed in celebration of the first anniversary of Row 34, our favorite Fort Point oyster bar..."
    },

### tapcellarbeers.tastings

The `tastings` collection contains one object for each Beer Journal entry for the beer.

Each object may contain some or all of the following properties.

| Property | Description |
| --- | --- |
| comment | User description of the beer. |
| geo | Location coordinates at the time the Beer Journal entry was created. |
| photofilename | File name of a photo added or taken for the entry. For example, "TastingNote Sep 5, 2016, 844 AM.jpg". If your backup included photos these image files are in the same folder as TapCellarBackup.json. |
| tastingid | ID of the Beer Journal entry. |
| timestamp | Timestamp indicating when the entry was created or last edited. |

The data returned has the following structure:

    "tastings": [
      {
        "geo": "43.173107,-73.058390",
        "photofilename": "TastingNote Sep 5, 2016, 844 AM.jpg",
        "timestamp": "2016-09-05 08:43:18 GMT-04:00",
        "comment": "Dry hopped version. Awesome!",
        "tastingid": "522AB147-6128-49D2-BA4E-97D5AE9653F7"
      }
    ],

## Grade Values

While TapCeller uses letter grades between A+ and F for setting and displaying grades, the grade data is represented internally as a float value between 0 and 4.0.

The reasoning behind this is that beers are given unique values and are shown positionally along the grade slider. In theory this enables the user to rate beers and view ratings in terms of, while several beers may be rated A, beer X is slightly better than beer Y, and so on.

Translating `grade` property values back to letter grades is straightforward.

| Value Range | Grade |
| --- | --- |
| 3.80 - 4.00 | A+ |
| 3.47 - 3.79 | A |
| 3.14 - 3.46 | A- |
| 2.81 - 3.13 | B+ |
| 2.48 - 2.80 | B |
| 2.15 - 2.47 | B- |
| 1.82 - 2.14 | C+ |
| 1.49 - 1.81 | C |
| 1.16 - 1.48 | C- |
| 0.83 - 1.15 | D+ |
| 0.50 - 0.82 | D |
| 0.17 - 0.49 | D- |
| 0.00 - 0.16 | F |

Actual `grade` values have far more precision than the values used here, but I found, for the purposes of translating grades, two-place precision was sufficient.

Any grade less than 0 should be considered invalid. Typically you can ignore these records.

## Changelog

### 11/11/2016

tap-archive.rb
* Adding new utility. Not functional at this time.

README.md
* Adding tap-archive.rb information
* Adding TapCellar backup information

### 01/20/2015

tap-timeline.rb
* Added options to filter on brewery or beer name

### 12/24/2014

tap-timeline.rb
* Added 0-4, 0-5, stars and 100-based grades to CSV output
* Added mean grade to standard output
* Fixed output justification

### 12/18/2014

tap-avg-grades.rb
* Fixed letter grade conversion
* CSV output option

tap-styles.rb
* Simplify reading JSON with error handling
* Added option handling
* CSV output option

tap-timeline.rb
* Fixed letter grade conversion
* Added beer name to output
* CSV output option
