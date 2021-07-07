# Review - Data wrangling

For practice, we are going to import some marijuana arrests data from the Austin Police Department. The data was obtained through an open records request as an Excel spreadsheet, which will be new for us. I've removed the names of the suspects.

The **story** here is we want to see how many "B Misdemeanor" arrests there have been over time in Austin. This are arrest for small amounts of marijuana, less than 2 ounces.

Our **goal** here is to practice setting up a project and importing data. Because this is a real-world example, it will not go quite as planned. We'll continue to learn new things as we progress.

If a step in the process is something we've done before, I'll give brief directions. If something is new, I'll provide more detail and explanation.

## Start a new project

A new project means we start from scratch. Close out any previous project work you have open. File > Close Project is a good way.

> It is possible to have two RStudio projects open at the same time, but you'll need open the second one as a "new session". It is also possible to open notebooks from different projects in the same session, but I would not recommend that.

- Use the +R icon or File > New Project. Go through the steps to create your project folder in a place where you can find it later. For the purposes of this class, name it `yourname-arrests`.
- Use the Files panel to create two new folders called `data-raw` and `data-processed`. (I name my folders like this so all the data folders are together when I view them.)
- Create a new RNotebook called `01-import.Rmd`, update the metadata at the top and remove the boilerplate code.
- Create a chunk called "setup" and add the following libraries.


```r
library(tidyverse)
library(janitor)
library(readxl)
library(lubridate)
```



When you run the setup chunk, you'll _probably_ get some errors that some packages are not installed. Look at the list and use your Console to install them: `install.packages("readxl")` for example. [Readxl](https://readxl.tidyverse.org/) allows us to import Excel data into R. The other new package, [lubridate](https://lubridate.tidyverse.org/), helps us with dates and times in data.

## Downloading our data

Like with our special education data, we're going to download our data using the `download.file()` function.

- Add some text that explains you are downloading the data.
- Create an R chunk called "download" and add the following code:

```r
# arrest data download
download.file("https://github.com/utdata/rwdir/blob/main/data-raw/APD_marijuana_arrests_2016-2020_data.xlsx?raw=true", "data-raw/APD_marijuana_arrests_2016-2020_data.xlsx")
```

You should get a response like this:

```
trying URL 'https://github.com/utdata/rwdir/blob/main/data-raw/APD_marijuana_arrests_2016-2020_data.xlsx?raw=true'
Content type 'application/octet-stream' length 567494 bytes (554 KB)
==================================================
downloaded 554 KB
```

This downloads the spreadsheet into your `data-raw` folder. Once you've done this, you can add a `#` to the front of the `download.file` line to comment it out since you won't need to download it again.

If you open up that spreadsheet in Excel, you'll notice there are two sheets. The first sheet has summary notes included by the public information officer:

![PIR notes](images/arrests-excel-notes.png)

And the second is the actual data, on a sheet called "Results". Again, note I've removed the "Name of arrestee" as we are just interested in counts for this exercise.

![Results](images/arrests-excel-data.png)

## Importing from an Excel spreadsheet

- Add a new Markdown header: `## Import`.
- Add a note that you are adding data from the specific sheet called "Results".
- Start a new chunk and name it "import".
- Add the following code:


```r
data <- read_excel(
    "data-raw/APD_marijuana_arrests_2016-2020_data.xlsx",
    sheet = "Results"
  ) %>% clean_names()

data %>% glimpse()
```

```
## Rows: 7,828
## Columns: 9
## $ arrest_primary_key  <dbl> 201600012, 201600018, 201600061, 201600074, 20160…
## $ arrest_date         <dttm> 2016-01-01, 2016-01-01, 2016-01-01, 2016-01-01, …
## $ arrest_charge       <chr> "POSS MARIJUANA <2OZ", "POSS MARIJ < 2OZ", "POSS …
## $ apd_race            <chr> "BLACK", "BLACK", "HISPANIC OR LATINO", "HISPANIC…
## $ sex                 <chr> "M", "M", "M", "M", "M", "M", "F", "M", "M", "M",…
## $ arrest_location     <chr> "2336 DOUGLAS ST", "212 E 6TH ST", "100 TILLERY S…
## $ zip                 <dbl> 78741, 78701, 78702, 78758, 78758, 78752, 78758, …
## $ arrest_x_coordinate <dbl> 3117763, 3114977, 3125173, 3124635, 3128359, 3125…
## $ arrest_y_coordinate <dbl> 10056344, 10070652, 10065077, 10124175, 10107000,…
```

I suppressed the warnings in my output, but you will some warnings:

> Expecting numeric in A4572 / R4572C1: got '201717-10450'Expecting numeric in A5460 / R5460C1: got '201818-01877'Expecting numeric in A5748 / R5748C1: got '201818-03343'Expecting numeric in A5784 / R5784C1: got '201818-03522'Expecting numeric in A5889 / R5889C1: got '201818-04226'Expecting numeric in A6023 / R6023C1: got '201818-05278'Expecting numeric in A6116 / R6116C1: got '201818-06048'Expecting numeric in A6156 / R6156C1: got '201818-06369'Expecting numeric in A6221 / R6221C1: got '201818-07021'Expecting numeric in A6344 / R6344C1: got '201818-08182'Expecting numeric in A6761 / R6761C1: got '201818-11409'Expecting numeric in A6814 / R6814C1: got '201818-11848'

We can't ignore this, and it is one of the challenges of importing data into R or any other strict database. I wasn't sure what was going on here so I opened the spreadsheet and searched for '201818-03522' as noted in the error.

![Data issues](images/arrests-data-issues.png)

And if I look at the `glimpse()` returns I see that the `arrest_primary_key` is considered a `<dbl>` data type, which is a number. **So what does that row look like in my data?**. Let's look at all the rows from Sept. 17, 2017.

- Add a new chunk called "date-test" and add the following code:

> The `ymd()` part of the filter below is using lubridate to note the format of my date so R can understand it. It stands for year-month-day. We'll get more into dates later.


```r
data %>% 
  filter(arrest_date == ymd("2017-09-28")) %>% 
  head()
```

```
## # A tibble: 6 x 9
##   arrest_primary_… arrest_date         arrest_charge apd_race sex  
##              <dbl> <dttm>              <chr>         <chr>    <chr>
## 1               NA 2017-09-28 00:00:00 POSS MARIJ <… WHITE    M    
## 2        201735768 2017-09-28 00:00:00 POSS MARIJ <… WHITE    F    
## 3        201735775 2017-09-28 00:00:00 POSS MARIJ <… BLACK    M    
## 4        201735797 2017-09-28 00:00:00 POSS MARIJ >… HISPANI… M    
## 5        201735808 2017-09-28 00:00:00 POSS MARIJ    HISPANI… M    
## 6        201735836 2017-09-28 00:00:00 POSS MARIJ <… BLACK    M    
## # … with 4 more variables: arrest_location <chr>, zip <dbl>,
## #   arrest_x_coordinate <dbl>, arrest_y_coordinate <dbl>
```

Note that first record doesn't have an primary key! This is a problem. R is considering that column to be a set of numbers - <dbl> - and '201717-10450' is not a real number because it has a dash in it, so it was imported as `NA`. **This is not good.** We want all the `arrest_primary_key`s to be text, not numbers. While fixing that we'll also make sure the ZIP code is text.

Within the `read_excel()` function we can either set all the columns to the same data type, like "text", or we have to set each individual column, which is what we have to do. The description of all the [readxl data types are here](https://readxl.tidyverse.org/reference/read_excel.html), but note we are using "guess" for those we aren't being specific about. We list the data types in the order of the columns in the spreadsheet.

- Edit your code chunk to add the `col_types` part below. I added notes to myself to keep track of the columns.


```r
data <- read_excel(
    "data-raw/APD_marijuana_arrests_2016-2020_data.xlsx",
    sheet = "Results",
    col_types = c(
      "text",  # key
      "guess", # date
      "guess", # charge
      "guess", # race
      "guess", # sex
      "guess", # location
      "text",  # zip
      "guess", # x coordinate
      "guess"  # y coordinate
    )
  ) %>% clean_names()

data %>% glimpse()
```

```
## Rows: 7,828
## Columns: 9
## $ arrest_primary_key  <chr> "201600012", "201600018", "201600061", "201600074…
## $ arrest_date         <dttm> 2016-01-01, 2016-01-01, 2016-01-01, 2016-01-01, …
## $ arrest_charge       <chr> "POSS MARIJUANA <2OZ", "POSS MARIJ < 2OZ", "POSS …
## $ apd_race            <chr> "BLACK", "BLACK", "HISPANIC OR LATINO", "HISPANIC…
## $ sex                 <chr> "M", "M", "M", "M", "M", "M", "F", "M", "M", "M",…
## $ arrest_location     <chr> "2336 DOUGLAS ST", "212 E 6TH ST", "100 TILLERY S…
## $ zip                 <chr> "78741", "78701", "78702", "78758", "78758", "787…
## $ arrest_x_coordinate <dbl> 3117763, 3114977, 3125173, 3124635, 3128359, 3125…
## $ arrest_y_coordinate <dbl> 10056344, 10070652, 10065077, 10124175, 10107000,…
```

No more warnings about bad data! As we look through the `glimpse()` output we see `arrest_primary_key` and `zip` are now "<chr>" and just as important our `arrest_date` is still a date and coordinates are still numbers.

Now run your date test just to make sure we no longer have the `NA`:


```r
data %>% 
  filter(arrest_date == ymd("2017-09-28")) %>% 
  head()
```

```
## # A tibble: 6 x 9
##   arrest_primary_… arrest_date         arrest_charge apd_race sex  
##   <chr>            <dttm>              <chr>         <chr>    <chr>
## 1 201717-10450     2017-09-28 00:00:00 POSS MARIJ <… WHITE    M    
## 2 201735768        2017-09-28 00:00:00 POSS MARIJ <… WHITE    F    
## 3 201735775        2017-09-28 00:00:00 POSS MARIJ <… BLACK    M    
## 4 201735797        2017-09-28 00:00:00 POSS MARIJ >… HISPANI… M    
## 5 201735808        2017-09-28 00:00:00 POSS MARIJ    HISPANI… M    
## 6 201735836        2017-09-28 00:00:00 POSS MARIJ <… BLACK    M    
## # … with 4 more variables: arrest_location <chr>, zip <chr>,
## #   arrest_x_coordinate <dbl>, arrest_y_coordinate <dbl>
```

## A quick look at our data

Now that we have our data imported with the correct data types, we can start exploring it. We want to learn about the values in each column, look for problems and generally become familiar with our data.

We've used `glimpse()` already and we'll be looking at that for column names and such. We can run `summary()` to get some basic stats on numeric fields, then run some `count()`s to look at categorical values.

- Run `summary()` on your data. Don't forget to name the chunk.


```r
data %>% summary()
```

```
##  arrest_primary_key  arrest_date                  arrest_charge     
##  Length:7828        Min.   :2016-01-01 00:00:00   Length:7828       
##  Class :character   1st Qu.:2016-10-10 00:00:00   Class :character  
##  Mode  :character   Median :2017-06-20 00:00:00   Mode  :character  
##                     Mean   :2017-08-08 23:39:45                     
##                     3rd Qu.:2018-04-27 00:00:00                     
##                     Max.   :2020-03-15 00:00:00                     
##                                                                     
##    apd_race             sex            arrest_location        zip           
##  Length:7828        Length:7828        Length:7828        Length:7828       
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##                                                                             
##  arrest_x_coordinate arrest_y_coordinate
##  Min.   :      0     Min.   :       0   
##  1st Qu.:3111496     1st Qu.:10057200   
##  Median :3120470     Median :10073148   
##  Mean   :2972667     Mean   : 9602880   
##  3rd Qu.:3128359     3rd Qu.:10099438   
##  Max.   :3172781     Max.   :10156802   
##  NA's   :22          NA's   :22
```

The `summary()` doesn't do much for us with this data set. The `arrest_date` column is good because we can see the oldest and newest dates. The coordinates are the only true numbers in our data but stats on them don't help us given it is really geographical data. In a later lesson we'll use those to map these records.

- Use `count()` to look at the categorical fields of `arrest_charge`, `apd_race`, and `sex` and `zip`. You might also find `arrange()` useful. We won't deal with the location fields until later.


```r
data %>% count(arrest_charge) %>% 
  arrange(n %>% desc())
```

```
## # A tibble: 155 x 2
##    arrest_charge                    n
##    <chr>                        <int>
##  1 POSS MARIJ < 2OZ              2214
##  2 POSS MARIJ <2OZ               1963
##  3 POSS MARIJUANA <2OZ           1355
##  4 POSS MARIJ <2OZ (MB)           848
##  5 POSSESSION OF MARIJUANA <2OZ   346
##  6 POSS MARIJ                     199
##  7 POSS MARIJUANA                 140
##  8 POSS MARIJ >2OZ<=4OZ            85
##  9 POSS MARIJ >4OZ<=5LBS           82
## 10 POSS MARIJ <= 5LBS > 4OZ        57
## # … with 145 more rows
```


```r
data %>% count(apd_race)
```

```
## # A tibble: 8 x 2
##   apd_race                           n
## * <chr>                          <int>
## 1 AMERICAN INDIAN/ALASKAN NATIVE     3
## 2 ASIAN                             48
## 3 BLACK                           2733
## 4 HAWAIIAN/PACIFIC ISLANDER          1
## 5 HISPANIC OR LATINO              3202
## 6 MIDDLE EASTERN                    21
## 7 UNKNOWN                            7
## 8 WHITE                           1813
```


```r
data %>% count(sex)
```

```
## # A tibble: 2 x 2
##   sex       n
## * <chr> <int>
## 1 F      1272
## 2 M      6556
```


```r
data %>% count(zip) %>%
  arrange(n %>% desc())
```

```
## # A tibble: 52 x 2
##    zip       n
##    <chr> <int>
##  1 78753   794
##  2 78758   684
##  3 78741   680
##  4 78701   671
##  5 78702   479
##  6 78723   471
##  7 78744   457
##  8 78745   437
##  9 <NA>    391
## 10 78704   359
## # … with 42 more rows
```

The `arrest_charge` is a mess and also the field we are most interested in, so our next lesson will involve cleaning up that field. The other fields are in good shape. 

We'll continue with this same project in the next chapter.



