# Mastery - Mixed Beverages {#mastery}

With this assignment you will be given a dataset, recorded interviews and some story ideas and you will build a full story based on the collection.

## The assignment outline

First, let's talk about the deliverables:

- You'll produce an 500-word data drop based on the data. This should be written as a news story like most of our other data drops. You need three or four "facts" from the data to build a good case, and then support those with quotes. Don't pad your story with an exposé on the drinking culture in Austin, just find more data facts and quotes to build a better story. (100 points)
- You'll turn in any analysis work you've done (your R project), regardless if it is used in the story. I want ALL of your work. (100 points)
- You'll produce at least one publishable chart to go with your story using ggplot or Datawrapper. This chart needs to have a proper headline, description, legend, annotations and such so that the chart can be understood outside the context of the story. Include an image and/or link in your story. (100 points)
- You will be assigned an editing partner from the class to work with. You will each do your own story (and must have different angles), but the idea is you have someone to regularly talk with about your analysis, edit your story and proof-read your charts. At the end of the first week you have an assignment where you tell me your editing partner and angle they are looking at, and then another later where you discuss how you helped each other.

## About the interviews

I have two recorded interviews for you to work from, and the **links are in Canvas** on the main assignment called "Mixed Beverage project". Both interviews include discussion of alcohol sales, including dealing with the pandemic. When these were recorded in spring 2021 we were also using TABC violations data, so the interviews also cover selling to minors and such. Those parts aren't really germane to this assignment, but there is plenty to draw from.

- **Andy Kahn** is a bartender at The Mockingbird near campus. He worked previously as a manager at The Hole in the Wall.
- **Chad Womack** is the owner of The Dogwood, which has locations on W. 6th and in The Domain (as well as other cities). He co-owns them with his brother Brad (yes, [that Brad Womack](https://en.wikipedia.org/wiki/The_Bachelor_(American_season_15))) and Jason Carrier through Carmack Concepts.

It is worth going through the interviews early on so you can tailor your analysis around what they talk about.

## About the data

You'll be drawing from at least five years of data from the [Mixed Beverage Gross Receipts](https://data.texas.gov/Government-and-Taxes/Mixed-Beverage-Gross-Receipts/naix-2893) for locations with an Austin local address. You should take a look at that page while you familiarize yourself with the data, which also serves as your data dictionary.

Each month, every Texas establishment that sells liquor-by-the-drink (restaurants, bars, stadiums, etc) has to report their sales to the state for tax purposes.

### Important things to know

Each row of the data is the amount of total money brought in **_each month_** by an establishment, based on the Obligation End Date, which is always the last day of the reporting month. This means you can see trends by month, but not any time period smaller than that.

There are four values of money reported: Total Receipts, Wine Receipts, Beer Receipts, Liquor Receipts and Cover Charge Receipts. The beer, wine, liquor and cover charge values _should_ add up to the Total Receipts, though I've found that is not always true. I would **stay away from any analysis on Cover Charges** as there must be some special rules of when they need to be reported that would need investigation to understand. The amounts are sales amounts (i.e., total amount of money bought in for that month for that category) and **not** profits or number of drinks sold.

Some other things to know:

- Sometimes names of taxpayers and locations are obscured. Hotel chains may have a company that serves all their hotels. A beverage company may hold license to sell in multiple locations. It is important to group by both Location Name AND Location Address to find specific locations. You can google the address to find out the real name of an establishment.
- Also be aware that some companies have more than one location with the same name, so again you should group by both Location Name and Location Address to get totals specific locations.
- Each Taxpayer Name has only one Taxpayer Number, but that company could own many establishments in many locations.
- For the most part we can ignore Responsibility Begin and End dates if you always group by Location Name and Location Address when looking at single locations. This is used when an establishment changes hands and has different owners within the same month.

## Story ideas

Here is a list of questions you could ask that can lead to story ideas.

- Which establishments have sold the most alcohol over the past five years? How does that look on a monthly basis? (Be sure to watch for multiple locations of the same name and name changes of the same location.)
  - Perhaps take the same idea but for a smaller geographic area. The Drag (Guadalupe between 19th and 30th). West Campus (78705). The Domain area (78758). Downtown (78701). South Austin (78704). East Austin (78702) and north of there (78722). One thing to be aware of here is that ZIPs cross over city boundaries
  - You could compare sales between popular areas. Or sales over time in a certain area.
- How did COVID-19 affect sales in 2020 and how are they rebounding in 2021?
- Is the number of restaurants or bars growing in certain areas? Like in east or south Austin? Again, ZIP codes might be a good geography to hone in on.
- How do sales break down by alcohol type? Who sold the most beer last year? Wine? Again, could break down by geography.
- How do sales change over the seasons around West Campus? What do establishments do to deal with that?
- How much does March mean to sales of alcohol downtown during SXSW? (Like what percentage of their yearly sales?) What was the difference in 2020 and 2021 compared to 2019?
- What owner/company has sold the most alcohol? (Taxpayer name). Or who owns the most locations in the city?

There are certainly other ideas, but key are the fact you have date ranges, some geographic locations like addresses and ZIP codes and the beer/wine/liquor/total sales values to work from.

## Downloading and cleaning the data

We'll get our data directly from the [data.texas.gov](https://data.texas.gov/Government-and-Taxes/Mixed-Beverage-Gross-Receipts/naix-2893) portal using the Socrata API. You'll need to install the RSocrata package first, but you don't need an API key for this.

1. Go ahead and set up a new project. You'll have a separate import-cleaning notebook from your analysis notebook. Use good naming practices.
1. Install the RSocrata package in your console: `install.packages("RSocrata")`.
1. You'll need the following libraries:


```r
library(tidyverse)
library(janitor)
library(RSocrata)
```

### Set up the download url

The key to using RSocrata and the Socrata API is to build a URL that will get us the data we want. I figured this out by reading through their [documentation](https://dev.socrata.com/docs/queries/) but that is beyond the scope of this lesson. But I will explain it, more or less.

For this first part we are just building a flexible way to filter our data before downloading. I'll explain below.


```r
mixbev_base_url = 'https://data.texas.gov/resource/fp9t-htqh.json?'
start_date = '2016-01-31'
end_date = '2021-08-31'
city = 'AUSTIN'

download_url <-  paste(
  mixbev_base_url,
  "$limit=100&", # comment out this line in your notebook
  "$where=obligation_end_date_yyyymmdd%20between%20",
  "'", start_date, "'",
  " and ",
  "'", end_date, "'",
  "&location_city=",
  "'", city, "'",
  sep = ""
)

download_url
```

```
## [1] "https://data.texas.gov/resource/fp9t-htqh.json?$limit=100&$where=obligation_end_date_yyyymmdd%20between%20'2016-01-31' and '2021-08-31'&location_city='AUSTIN'"
```

- The first several lines are creating variables for the base URL and dates ranges for the data. If we wanted data from a different date range or city, we could change those. It just provides flexibility and ease for updates.
- One thing about those dates: We are filtering the data to include five full years plus valid months in 2021. Since reporting lags on this by as much as two months, we don't have full reports for September or October 2021 so we are excluding them.
- The `download_url` object pieces together the parts of the url that we need to download the data. This url is an "endpoint" for the Socrata API for this dataset. It uses [SoQL](https://dev.socrata.com/docs/queries/) queries to select only the data we want. The `paste()` function is just putting together the pieces of the URL endpoint based on our variables. I print it out at the end so you can see what the finished URL looks like. You could copy/paste that endpoint (between the "") into a browser to see what the data looks like.
- I have a `limit` line in here for testing. I just pull 1000 lines of the data instead of all of them. **You need to comment out this line in your notebook to get all the data.**

> **REALLY, REALLY IMPORTANT NOTE**: Hey, did you see that note about the `"$limit=100&"` line? You **must** comment out the limit to get all the data you need.

This example above could be repurposed to pull data from a different dataset on any agency's Socrata platform.

### Download the data

Now that we have the url we can download the data into an R object. **This can take 30 seconds or more** as it a decent amount of data, about 75k rows. (Though I only show 100 here. Remember to comment that `limit` line out when you are ready to pull **all** of the data).


```r
receipts_api <- read.socrata(download_url)

# look at the data
receipts_api %>% glimpse()
```

```
## Rows: 100
## Columns: 24
## $ taxpayer_number                     <chr> "32039395531", "12630963622", "174…
## $ taxpayer_name                       <chr> "CORNER WEST, LLC", "MAC ACQUISITI…
## $ taxpayer_address                    <chr> "715 W 6TH ST", "1855 BLAKE ST STE…
## $ taxpayer_city                       <chr> "AUSTIN", "DENVER", "MERRILLVILLE"…
## $ taxpayer_state                      <chr> "TX", "CO", "IN", "FL", "TX", "TX"…
## $ taxpayer_zip                        <chr> "78701", "80202", "46410", "32837"…
## $ taxpayer_county                     <chr> "227", "0", "0", "0", "227", "227"…
## $ location_number                     <chr> "1", "7", "39", "5", "3", "3", "2"…
## $ location_name                       <chr> "THE DOGWOOD", "ROMANO'S MACARONI …
## $ location_address                    <chr> "715 W 6TH ST", "701 E STASSNEY LN…
## $ location_city                       <chr> "AUSTIN", "AUSTIN", "AUSTIN", "AUS…
## $ location_state                      <chr> "TX", "TX", "TX", "TX", "TX", "TX"…
## $ location_zip                        <chr> "78701", "78745", "78701", "78758"…
## $ location_county                     <chr> "227", "227", "227", "227", "227",…
## $ inside_outside_city_limits_code_y_n <chr> "Y", "Y", "Y", "Y", "Y", "Y", "Y",…
## $ tabc_permit_number                  <chr> "MB750447", "MB710753", "MB913070"…
## $ responsibility_begin_date_yyyymmdd  <dttm> 2010-06-15, 2008-12-18, 2015-07-0…
## $ obligation_end_date_yyyymmdd        <dttm> 2016-04-30, 2016-10-31, 2018-02-2…
## $ liquor_receipts                     <chr> "237013", "2658", "63669", "73418"…
## $ wine_receipts                       <chr> "5497", "8537", "41558", "20379", …
## $ beer_receipts                       <chr> "83765", "1309", "20078", "105510"…
## $ cover_charge_receipts               <chr> "0", "0", "0", "0", "0", "0", "0",…
## $ total_receipts                      <chr> "326275", "12504", "125305", "1993…
## $ responsibility_end_date_yyyymmdd    <dttm> NA, 2018-02-14, NA, NA, NA, NA, N…
```

### Fix some values

If you look at the data types of these columns you'll find that the `_receipts` columns are `<chr>` (which means characters) instead of `<dbl>` (which is numbers). We can't do math with text, so we need to fix that.

I'm going to give you an assist here because I found a pretty cool way to do this that I want to share.

Tidyverse has a function called [type_convert()](https://readr.tidyverse.org/reference/type_convert.html) that helps change between text and number data types and it can help us here. It allows us to specify data types for specific columns.

1. Start a new section and note you are fixing the receipts columns.
2. Add this code block and run it.


```r
receipts_converted <- receipts_api %>%
  type_convert(
    cols(
        .default = col_character(), # sets a default of character unless specified below
        liquor_receipts = col_double(),
        wine_receipts = col_double(),
        beer_receipts = col_double(),
        cover_charge_receipts = col_double(),
        total_receipts = col_double()
    )
  )

receipts_converted %>% glimpse()
```

```
## Rows: 100
## Columns: 24
## $ taxpayer_number                     <chr> "32039395531", "12630963622", "174…
## $ taxpayer_name                       <chr> "CORNER WEST, LLC", "MAC ACQUISITI…
## $ taxpayer_address                    <chr> "715 W 6TH ST", "1855 BLAKE ST STE…
## $ taxpayer_city                       <chr> "AUSTIN", "DENVER", "MERRILLVILLE"…
## $ taxpayer_state                      <chr> "TX", "CO", "IN", "FL", "TX", "TX"…
## $ taxpayer_zip                        <chr> "78701", "80202", "46410", "32837"…
## $ taxpayer_county                     <chr> "227", "0", "0", "0", "227", "227"…
## $ location_number                     <chr> "1", "7", "39", "5", "3", "3", "2"…
## $ location_name                       <chr> "THE DOGWOOD", "ROMANO'S MACARONI …
## $ location_address                    <chr> "715 W 6TH ST", "701 E STASSNEY LN…
## $ location_city                       <chr> "AUSTIN", "AUSTIN", "AUSTIN", "AUS…
## $ location_state                      <chr> "TX", "TX", "TX", "TX", "TX", "TX"…
## $ location_zip                        <chr> "78701", "78745", "78701", "78758"…
## $ location_county                     <chr> "227", "227", "227", "227", "227",…
## $ inside_outside_city_limits_code_y_n <chr> "Y", "Y", "Y", "Y", "Y", "Y", "Y",…
## $ tabc_permit_number                  <chr> "MB750447", "MB710753", "MB913070"…
## $ responsibility_begin_date_yyyymmdd  <dttm> 2010-06-15, 2008-12-18, 2015-07-0…
## $ obligation_end_date_yyyymmdd        <dttm> 2016-04-30, 2016-10-31, 2018-02-2…
## $ liquor_receipts                     <dbl> 237013, 2658, 63669, 73418, 203774…
## $ wine_receipts                       <dbl> 5497, 8537, 41558, 20379, 6527, 26…
## $ beer_receipts                       <dbl> 83765, 1309, 20078, 105510, 21446,…
## $ cover_charge_receipts               <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
## $ total_receipts                      <dbl> 326275, 12504, 125305, 199307, 231…
## $ responsibility_end_date_yyyymmdd    <dttm> NA, 2018-02-14, NA, NA, NA, NA, N…
```

Let's break this down

- We start with a new R Object to fill (and a glimpse of it at the end).
- We take `receipts_api` and pipe into `type_convert()` and specify the `cols()` function there.
- The first line inside cols is `.default = col_character()` which tells type_convert to only change columns we specify after it. If we didn't include this then the `*_zip` and `*_county` columns would be converted to numbers and we don't want that. Especially the ZIP code, because that is NOT a number.
- The rest of the lines set the receipts columns to `col_double()` to make them numbers.

We could've done this using `mutate()` with `as.numeric()` and overwriting the columns, but I like this method and wanted to show it to you.

## Export your data

This tibble `receipts_converted` is ready to be exported as an .rds file to use in your analysis notebook. I'll leave that up to you ;-).

## How to tackle the analysis

The specifics will depend on what you are trying to learn from the data, but check out the next chapter "How to interview your data" for some general tips and concept reviews.

