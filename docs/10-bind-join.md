# Bind and join {#bind-join}

So far all of our lessons have come from a single data source, but that's not always the case in the real world. With this lesson we'll learn how to "bind" and "join" data, which are different ways to bring multiple data frames together into a single object. 

This is the first of a two-chapter project. It is by Prof. McDonald, using a Mac.

## Goals of the chapter

- Merge multiple data files with `bind_rows()`
- Join data frames with `inner_join()`
- Use `str_remove()` to clean data
- Introduce `if_else()` for categorization

We'll use the results of this chapter in our next one.

## The story: An update to Denied

In 2016, the Houston Chronicle published a multi-part series called [Denied](https://www.houstonchronicle.com/denied/1/) that outlined how a Texas Education Agency policy started in 2004 could force an audit of schools that have more than 8.5% of their students in special education programs. The story was a Pulitzer Prize finalist. Here's an excerpt:

> Over a decade ago, the officials arbitrarily decided what percentage of students should get special education services — 8.5% — and since then they have forced school districts to comply by strictly auditing those serving too many kids.

> Their efforts, which started in 2004 but have never been publicly announced or explained, have saved the Texas Education Agency billions of dollars but denied vital supports to children with autism, attention deficit hyperactivity disorder, dyslexia, epilepsy, mental illnesses, speech impediments, traumatic brain injuries, even blindness and deafness, a Houston Chronicle investigation has found.

> More than a dozen teachers and administrators from across the state told the Chronicle they have delayed or denied special education to disabled students in order to stay below the 8.5 percent benchmark. They revealed a variety of methods, from putting kids into a cheaper alternative program known as "Section 504" to persuading parents to pull their children out of public school altogether.

Following the Chronicle's reporting (along with other news orgs), the Texas Legislature in 2017 [unanimously banned](https://www.chron.com/news/houston-texas/houston/article/Legislature-unanimously-approves-bill-designed-to-11134046.php) using a target or benchmark on how many students a district or charter school enrolls in special education.

We want to look into the result of this reporting based on three things:

- Has the percentage of special education students in Texas changed since the benchmarking policy was dropped?
- How many districts were above that arbitrary 8.5% benchmark before and after the changes? 
- How have local districts changed?

To prepare for this:

1. Read [Part 1](https://www.houstonchronicle.com/denied/1/) of the original Denied series.
1. Read [About this series](https://www.houstonchronicle.com/denied/about/)
1. Read [this followup](https://www.chron.com/news/houston-texas/houston/article/Legislature-unanimously-approves-bill-designed-to-11134046.php) about the legislative changes.

## About the data

Each year, the Texas Education Agency publishes the percentage of students in special education as part of their [Texas Academic Performance Reports](https://tea.texas.gov/texas-schools/accountability/academic-accountability/performance-reporting/texas-academic-performance-reports). We can download a file that has the percentages for each district in the state.

There are some challenges, though:

- We have to download each year individually. There are nine years of data.
- The are no district names in the files, only a district ID. We can get a reference file, though.
- There are some differences is formatting for some files.

I will save you the hassle of going through the TAPR database to find and download the individual files, and I will also supply code to clean the files to make them consistent. I'll try not to get lost in the weeds along the way.

### Set up your project

1. Go to [this page](https://github.com/utdata/rwdir/blob/main/resources/rwdir-sped-template.zip).
1. Look for the **Download** button and download the zip file.
1. Find that on your computer and uncompress it.
1. Rename the folder to `yourname-sped` **but use your name**.
1. Move the folder to your `rwd` folder or wherever you've been saving your class projects.
1. In RStudio, choose File > New Project. **Choose Next Directory** at the next step and then find the folder you just moved. Use that to create your project.

You should now have your own project that already has a head start on this project. It has the data in a `data-raw` folder, and your first notebook `01-import` that already has some code in it.




### Open, read and run

Once you have your project set up ...

1. Open up the `01-import` notebook.
2. Read every line
3. Run each chunk as you do.

Go ahead. I'll wait.

<div style="width:100%;height:0;padding-bottom:56%;position:relative;"><iframe src="https://giphy.com/embed/ExSXXwQmCSMWKor0qb" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p><a href="https://giphy.com/gifs/snl-saturday-night-live-season-47-ExSXXwQmCSMWKor0qb">via GIPHY</a></p>

There is a lot to take in there about where the data came from and how we dealth with it. Here is where you end up:

- **You have nine data files for each year and one reference file imported.**

## Merging data together

OK, so we have nine different yearly files. Wouldn't it be a lot easier if these were ONE thing? Indeed, we can **merge** these files together by stacking them on top of each other. Let's review the concept using Starburst data:

<iframe width="560" height="315" src="https://www.youtube.com/embed/9WA8YxMjpnI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Here's an image representation of the concept. You have two data sets and you stack them on top of each other where the column names match. (Note here that identical rows in both data sets remain).

![](images/bind_rows.png)

Since all nine of our data files have the same column names, we can easily merge them with function **`bind_rows()`**.

Let's demonstrate through building it.

1. Start a new section on your R Markdown document and note you are merging data
1. Add a chunk with just the `dstud13` data and run it.


```r
dstud13
```

```
## # A tibble: 1,228 × 5
##    district year  dpetallc dpetspec dpetspep
##    <chr>    <chr>    <dbl>    <dbl>    <dbl>
##  1 001902   2013       595       73     12.3
##  2 001903   2013      1236      113      9.1
##  3 001904   2013       751       81     10.8
##  4 001906   2013       406       45     11.1
##  5 001907   2013      3288      252      7.7
##  6 001908   2013      1619      151      9.3
##  7 001909   2013       439       48     10.9
##  8 002901   2013      3617      250      6.9
##  9 003801   2013       635       45      7.1
## 10 003902   2013      2726      196      7.2
## # … with 1,218 more rows
```

The result shows there are **1,228** rows and **5** variables in the data, which should match what shows for `dstud13` in your Environment tab.

1. Now **edit** that chunk to use `bind_rows()` with `dstud14`.


```r
dstud13 %>% 
  bind_rows(dstud14)
```

```
## # A tibble: 2,455 × 5
##    district year  dpetallc dpetspec dpetspep
##    <chr>    <chr>    <dbl>    <dbl>    <dbl>
##  1 001902   2013       595       73     12.3
##  2 001903   2013      1236      113      9.1
##  3 001904   2013       751       81     10.8
##  4 001906   2013       406       45     11.1
##  5 001907   2013      3288      252      7.7
##  6 001908   2013      1619      151      9.3
##  7 001909   2013       439       48     10.9
##  8 002901   2013      3617      250      6.9
##  9 003801   2013       635       45      7.1
## 10 003902   2013      2726      196      7.2
## # … with 2,445 more rows
```

This shows we now have **2,455** rows and **5** variables. This is good ... we've addded the rows of `dstud14` but we don't have any new columns because the column names were identical.

Now **edit the chunk** to do all these things:

1. Save the result of the merge into a new data frame called `sped_merged`.
1. Tack on another `bind_rows()` for the `dstud15` data so you can see you are adding more on.
1. At the bottom of the chunk print out the `sped_merged` tibble and pipe it into `count(year)` so you can make sure you continue to add rows correctly.

It should look like this:


```r
sped_merged <- dstud13 %>% 
  bind_rows(dstud14) %>% 
  bind_rows(dstud15)

# we use this to ensure we bind correctly when we add new years
sped_merged %>% count(year)
```

```
## # A tibble: 3 × 2
##   year      n
##   <chr> <int>
## 1 2013   1228
## 2 2014   1227
## 3 2015   1219
```

We are NOT saving the `count()` result here, we are just printing it to our screen to make sure we get all the years.

Now that we know this is working, you'll finish this out on your own.

1. **Edit your chunk** to add `bind_rows()` for the rest of the files `dstud16` through `dstud21`. You just keep tacking them on like we did with `dstud15`.
2. After you are done, make sure you look at the `sped_merged` listing in your environment to make sure you end up with **10,891** rows of data and **5** variables.



OK, we have all our data in one file, but we still don't know the district names. It's time to **Join** our data with our reference file.

## About joins

OK, before we go further we need to talk about joining data. It's one of those [Basic Data Journalism Functions](https://vimeo.com/showcase/7320305) ...

<iframe width="560" height="315" src="https://www.youtube.com/embed/T6PPd-ukFyk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

What joins do is match rows from two data sets that have a column of common values, like an ID or county name. (The `district` ID column in our case). Columns from the second data set will be added based on where the ID's match.

There are several types of [joins](https://dplyr.tidyverse.org/reference/mutate-joins.html). We describe these as left vs right based on which table we reference first (which is the left one). How much data you end up with depends on the "direction" of the join.

- An **inner_join** puts together columns from both tables where there are matching rows. If there are records in either table where the IDs don't match, they are dropped.
- A **left_join** will keep ALL the rows of your first table, then bring over columns from the second table where the IDs match. If there isn't a match in the second table, then new values will be blank in the new columns.
- A **right_join** is the opposite of that: You keep ALL the rows of the second table, but bring over only matching rows from the first.
- A **full_join** keeps all rows and columns from both tables, joining rows when they match.

Here are two common ways to think of this visually.

In the image below, The orange represents the data that remains after the join.

![](images/joins-description.png)

This next visual shows this as tables where only two rows "match" so you can see how non-matches are handled (the lighter color represents blank values). The functions listed there are the tidyverse versions of each join type.

![](images/join_types.png)

### Joining our reference table

In our case we start with the `dref` data and then use an **inner_join** to add all the yearly data values. We're doing it in this order so the `dref` values are listed first in our resulting table.

1. Start a new Markdown section and note we are joining the reference data
2. Add the chunk below and run it


```r
sped_joined <- dref %>% 
  inner_join(sped_merged, by = "district")

sped_joined %>% head()
```

```
## # A tibble: 6 × 9
##   district distname  cntyname dflalted dflchart year  dpetallc dpetspec dpetspep
##   <chr>    <chr>     <chr>    <chr>    <chr>    <chr>    <dbl>    <dbl>    <dbl>
## 1 001902   CAYUGA I… ANDERSON N        N        2013       595       73     12.3
## 2 001902   CAYUGA I… ANDERSON N        N        2014       553       76     13.7
## 3 001902   CAYUGA I… ANDERSON N        N        2015       577       76     13.2
## 4 001902   CAYUGA I… ANDERSON N        N        2016       568       78     13.7
## 5 001902   CAYUGA I… ANDERSON N        N        2017       576       82     14.2
## 6 001902   CAYUGA I… ANDERSON N        N        2018       575       83     14.4
```

```r
sped_joined %>% glimpse()
```

```
## Rows: 10,684
## Columns: 9
## $ district <chr> "001902", "001902", "001902", "001902", "001902", "001902", "…
## $ distname <chr> "CAYUGA ISD", "CAYUGA ISD", "CAYUGA ISD", "CAYUGA ISD", "CAYU…
## $ cntyname <chr> "ANDERSON", "ANDERSON", "ANDERSON", "ANDERSON", "ANDERSON", "…
## $ dflalted <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "…
## $ dflchart <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "…
## $ year     <chr> "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020…
## $ dpetallc <dbl> 595, 553, 577, 568, 576, 575, 564, 557, 535, 1236, 1207, 1217…
## $ dpetspec <dbl> 73, 76, 76, 78, 82, 83, 84, 82, 78, 113, 107, 126, 144, 139, …
## $ dpetspep <dbl> 12.3, 13.7, 13.2, 13.7, 14.2, 14.4, 14.9, 14.7, 14.6, 9.1, 8.…
```

I'm showing both a `head()` and `glimpse()` here so you can see all the columns have been added.

Let's explain what is going on here:

- We are creating a new bucket `sped_joined` to save our data.
- We start with `dref` so those fields will be listed first in our result.
- We then pipe into `inner_join()` to `sped_merged`, which will attach our `dref` data to our merged data when the ID matches in the `district` variable.
- The `by = "district"` argument ensures that we are matching based on the `district` column in both data sets.

We could've left out the `by =` argument and R would match columns of the same name, but it is best practice to specify your joining columns so it is clear what is happening. You wouldn't want to be surprised by other columns of the same name that you didn't want to join on. If you wanted to specify join columns of different names it would look like this: `df1 %>% inner_join(df2, by = c("df1_id" = "df2_id))`

There are now **10,684** rows in our joined data, fewer than what was in the original merged file because some districts (mostly charters) have closed and were not in our reference file. We are comparing only districts that have been open during this time period. For that matter, we don't want charter or alternative education districts at all, so we'll drop those next.

## Some cleanup: filter and select

Filtering and selecting data is something we've done time and again, so you should be able to do this on your own.

You will next remove the charter and alternative education districts. This is a judgement call on our part to focus on just traditional public schools. We can always come back later and change if needed.

You'll also remove and rename columns to make the more descriptive.

1. Start a new markdown section and note you are cleaning up your data.
1. Create an R chunk and start with the `sped_joined` and then do all these things ...
1. Use `filter()` to keep rows where:
    - the `dflalted` field is "N"
    - AND the `dflchart` field is "N"
1. Use `select()` to:
    - remove (or not include) the `dflalted` and `dflchart` columns. (You can only do this AFTER you filter with them!)
1. Use `select()` or `rename()` to rename the following columns:
    - change `dpetallc` to `all_count`
    - change `dpetspec` to `sped_count`
    - change `dpetspep` to `sped_percent`
1. Make sure all your changes are saved into a new data frame called `sped_cleaned`.

I really, really suggest you don't try to write that all at once. Build it one line at a time so you can see the result as you build your code.

<details>
  <summary>I'm being too nice here</summary>

```r
sped_cleaned <- sped_joined %>% 
  filter(dflalted == "N" & dflchart == "N") %>% 
  select(
    district,
    distname,
    cntyname,
    year,
    all_count = dpetallc,
    sped_count = dpetspec,
    sped_percent = dpetspep
  )
```
</details>
<br>

You should end up with **9,182** rows and **7** variables.

## Create an audit benchmark column

Part of this story is to note when a district is above the "8.5%" benchmark that the TEA was using for their audit calculations. It would be useful to have a column that noted if a district was above or below that threshold so we could plot districts based on that flag. We'll create this new column and introduce the logic of [`if_else()`](https://dplyr.tidyverse.org/reference/if_else.html).

OK, our data looks like this:


```r
sped_cleaned %>% head()
```

```
## # A tibble: 6 × 7
##   district distname   cntyname year  all_count sped_count sped_percent
##   <chr>    <chr>      <chr>    <chr>     <dbl>      <dbl>        <dbl>
## 1 001902   CAYUGA ISD ANDERSON 2013        595         73         12.3
## 2 001902   CAYUGA ISD ANDERSON 2014        553         76         13.7
## 3 001902   CAYUGA ISD ANDERSON 2015        577         76         13.2
## 4 001902   CAYUGA ISD ANDERSON 2016        568         78         13.7
## 5 001902   CAYUGA ISD ANDERSON 2017        576         82         14.2
## 6 001902   CAYUGA ISD ANDERSON 2018        575         83         14.4
```

We want to add a column called `audit_flag` that says **ABOVE** if the `sped_percent` is above "8.5", and says **BELOW** if it isn't. This is a simple true/false condition that is perfect for the `if_else()` function.

1. Add a new Markdown section and note that you are adding an audit flag column
2. Create an r chunk that and run it and I'll explain after.


```r
sped_flag <- sped_cleaned %>% 
  mutate(audit_flag = if_else(sped_percent > 8.5, "ABOVE", "BELOW"))

# this pulls 30 random rows so I can check results
sped_flag %>% sample_n(10)
```

```
## # A tibble: 10 × 8
##    district distname cntyname year  all_count sped_count sped_percent audit_flag
##    <chr>    <chr>    <chr>    <chr>     <dbl>      <dbl>        <dbl> <chr>     
##  1 031905   LA FERI… CAMERON  2014       3597        257          7.1 BELOW     
##  2 133901   CENTER … KERR     2021        534         77         14.4 ABOVE     
##  3 219905   KRESS I… SWISHER  2020        282         23          8.2 BELOW     
##  4 242906   FORT EL… WHEELER  2021        144         13          9   ABOVE     
##  5 007905   PLEASAN… ATASCOSA 2016       3507        289          8.2 BELOW     
##  6 126904   GRANDVI… JOHNSON  2021       1332        134         10.1 ABOVE     
##  7 011904   SMITHVI… BASTROP  2019       1800        192         10.7 ABOVE     
##  8 045903   RICE CI… COLORADO 2015       1255        132         10.5 ABOVE     
##  9 030903   BAIRD I… CALLAHAN 2015        322         36         11.2 ABOVE     
## 10 072901   THREE W… ERATH    2019        162          4          2.5 BELOW
```

Let's walk through the code above:

- We're making a new data frame called `sped_flag` and then starting with `sped_cleaned`.
- We use `mutate()` to create a new column and we name it `audit_flag`.
- We set the value of `audit_flag` to be the result of this `if_else()` function. That function takes three arguments: A condition test (`sped_percent > 8.5` in our case), what is the result if the condition is true ("ABOVE" in our case), and what is the result if the condition is NOT true ("BELOW") in our case.
- Lastly we print out the new data `sped_cleaned` and pipe it into `sample_n()` which gives us a number of random rows from the data. I do this because the top of the data was all TRUE so I couldn't see if the mutate worked properly or not. (Always check your calculations!!)


## Export the data

This is something you've done a number of times as well, so I leave you to you:

1. Make a new section and note you are exporting the data
2. Export your `sped_flag` data using `write_rds()` and save it in your `data-processed` folder.

In the next chapter we'll build an analysis notebook to find our answers!



