# Summarize with math - analysis {#sums-analyze}

This chapter is by Prof. McDonald, who uses macOS.

In the last chapter, we learned about the LESO data ... that local law enforcement agencies can get surplus military equipment from the U.S. Department of Defense. We downloaded a combined version of the data, modified it for our purposes (used `mutate()` to create a new column calculated from other variables in the data) and then filtered it to just Texas records over a specific time period.

Throughout this lesson I'll give you a chance to work out the code on your own, but then give you the answer and explain it. **You won't learn this if you just copy/paste.** The key is not that the code runs, but that you understand what the code is doing.

## Learning goals of this lesson

In this chapter we will start querying the data using **summarize with math**, basically using summarize to add values in a column instead of counting rows, which we did with the Billboard assignment.

Our learning goals are:

- To use the combination of `group_by()`, `summarize()` and `arrange()` to add columns of data using `sum()`.
- To use different `group_by()` groupings in specific ways to get desired results.
- To practice using `filter()` on those summaries to better see certain results, including filtering with*in* a vector (or list of strings).
- We'll research and write about some of the findings, practicing data-centric ledes and sentences describing data.

## Questions to answer

All answers should be based on data about **Texas agencies** from **Jan. 1, 2010 to present**. All of these questions are for the "controlled" items, only.

- *How many total "controlled" items were transferred, and what are they all worth?* We'll summarize all the controlled items only to get the total quantity and total value of everything.
- *How many total "controlled" items did each agency get and how much was it all worth?* Which agency got the most stuff?
  - *How about local agencies?* I'll give you a list.
- *What specific "controlled" items did each agency get and how much were they worth?* Now we're looking at the kinds of items.
  - *What did local agencies get?*

You'll research some of the more interesting items the agencies received so you can include them in your data drop.

## Set up the analysis notebook

Before we get into how to do this, let's set up our analysis notebook.

1. Make sure you have your military surplus project open in RStudio. If you have your import notebook open, close it and use Run > Restart R and Clear Output.
1. Create a new RNotebook and edit the title as "Military surplus analysis".
1. Remove the boilerplate text.
1. Create a setup section (headline, text and code chunk) that loads the tidyverse library.
1. Save the notebook at `02-analysis.Rmd`.

We've started each notebook like this, so you should be able to do this on your own now.

<details>
  <summary>Library setup</summary>


```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
## ✔ ggplot2 3.3.6     ✔ purrr   0.3.4
## ✔ tibble  3.1.8     ✔ dplyr   1.0.9
## ✔ tidyr   1.2.0     ✔ stringr 1.4.1
## ✔ readr   2.1.2     ✔ forcats 0.5.1
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

</details>

### Load the data into a tibble

1. Next create an import section (headline, text and chunk) that loads the data from the previous notebook and save it into a tibble called `tx`.
1. Add a `glimpse()` of the data for your reference.

We did this in Billboard and you should be able to do it. You'll use `read_rds()` and find your data in your data-processed folder.

<details>
  <summary>Remember your data is in data-processed</summary>
  

```r
tx <- read_rds("data-processed/01-leso-tx.rds")

tx |> glimpse()
```

```
## Rows: 6,698
## Columns: 13
## $ state             <chr> "TX", "TX", "TX", "TX", "TX", "TX", "TX", "TX", "TX"…
## $ agency_name       <chr> "ABERNATHY POLICE DEPT", "ABERNATHY POLICE DEPT", "A…
## $ nsn               <chr> "2320-01-371-9584", "1240-01-540-3690", "1240-01-411…
## $ item_name         <chr> "TRUCK,UTILITY", "SIGHT,REFLEX", "SIGHT,REFLEX", "SI…
## $ quantity          <dbl> 1, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
## $ ui                <chr> "Each", "Each", "Each", "Each", "Each", "Each", "Eac…
## $ acquisition_value <dbl> 62627, 333, 396, 396, 396, 371680, 371680, 658000, 3…
## $ demil_code        <chr> "C", "D", "D", "D", "D", "Q", "Q", "C", "D", "D", "D…
## $ demil_ic          <dbl> 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 6, 7, 7, 1, 1…
## $ ship_date         <dttm> 2016-03-07, 2016-02-02, 2013-09-13, 2013-09-13, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
## $ total_value       <dbl> 62627, 1665, 396, 396, 396, 371680, 371680, 658000, …
## $ control_type      <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE…
```

</details>

<br/>

You should see the `tx` object in your Environment tab. You also have the glimpse that gives you an idea of what each variable in the data is.

## Filter for controlled items

For this assignment we want to focus on "controlled" items vs the more generic non-controlled items we learned about in the documentation. Let's filter to capture just the controlled data for our analysis.

As you might recall from the Billboard project, the `filter()` function is our workhorse for focusing our data. In our import notebook we created our `control_type` column so we could do exactly this: Find only the rows of "controlled" items.

1. Start a new Markdown section and note you are getting controlled items.
1. Start with  your `tx` data, but then filter it to `control_type == TRUE`.
1. Save the result into a new tibble called `tx_c`.


```r
tx_c <- tx |> 
  filter(control_type == TRUE)
```

At this point you have a new tibble called `tx_c` that has only the weapons and other controlled property, so now we can take a closer look at that data.

## Building summaries with math

As we get into the first quest, let's talk about "how" we go about these summaries.

When I am querying my data, I start by envisioning what the result should look like. Let's take the first question: **How many total "controlled" items were transferred, and what are they all worth?**

Let's break this down:

- "How many total controlled items" is how many individual things were transferred. We have this `quantity` column that has the number of items in each row, so if we want the total for the data set, we can add together all the values in that column. We do this within a `summarize()` but instead of counting rows using `n()`, we'll use the function `sum(quantity)` which will add all the values in `quantity` column together.
- "... what are they all worth" is very similar, but we want to add together all those values in our `total_value` column. (Remember, we don't want to use `acquisition_value` because that is the value of only ONE item, not the total for the row.

### Summarize across the data

So, let's put this together with code.

1. Start a new Markdown section that you are getting total values.
1. Add a code chunk like below and run it.


```r
tx_c |> 
  summarise(
    sum(quantity),
    sum(total_value)
  )
```

```
## # A tibble: 1 × 2
##   `sum(quantity)` `sum(total_value)`
##             <dbl>              <dbl>
## 1           22583         134445960.
```

Walking through the code ...

- We start with the `tx_c` tibble of the controlled items.
- Then we pipe into `summarize()`. Because we are going to add multiple things, I put them on separate lines just to make this more readable.

You'll notice that the names of the columns are the function names. We can "name" our new columns just like we did in Billboard. We could call this whatever we want, but good practice is to name it what it is. We'll use good naming techniques and split the words using `_`. I also use all lowercase characters.

1. **Edit your chunk** to add in the new column names and run it.


```r
tx_c |> 
  summarise(
    summed_quantity = sum(quantity),
    summed_total_value = sum(total_value)
  )
```

```
## # A tibble: 1 × 2
##   summed_quantity summed_total_value
##             <dbl>              <dbl>
## 1           22583         134445960.
```

OK, from this we have learned something: **Since Jan. 1, 2010, Texas law enforcement agencies have received more than 26,000 controlled items worth nearly $140 million**.

We're going to do this again below, so I'll dive deeper into explanations there.

### NA values in a sum, mean and median

When we do math like this within summarize we need to take special note if our column has any blank values, called `NA`, as in not available. If there are, then you will get `NA` for the result. R will NOT do the math on the remaining values unless you tell it so. This is true not only for `sum()`, but also for `mean()` which gets an average, and for `median()` which finds the middle number in a column.

There is a way to get around this by including an argument within the mathy function: `sum(col_name, na.rm = TRUE)`.

I can show this with the `demil_ic` column which is a number datatype with some NA values. To be clear, the `demil_ic` variable isn't really designed to do math on it as it is really a category, but it will show what I'm talking about here.


```r
tx_c |> 
  summarise(
    dumb_sum = sum(demil_ic),
    less_dumb_sum = sum(demil_ic, na.rm = TRUE),
    dumb_avg = mean(demil_ic),
    less_dumb_avg = mean(demil_ic, na.rm = TRUE)
  )
```

```
## # A tibble: 1 × 4
##   dumb_sum less_dumb_sum dumb_avg less_dumb_avg
##      <dbl>         <dbl>    <dbl>         <dbl>
## 1       NA          7562       NA          1.41
```

So there you have examples of using `sum()` and `mean()` with and without `na.rm = TRUE`. OK, you've been warned.

## Totals by agency

OK, your next question is this: **For each agency, how many things did they get and how much was it all worth?**

The key part of thinking about this logically is **For each agency**. That "for each" is a clue that we need `group_by()` for something. We basically need what we did above, but we first need to group_by the `agency_name`.

Let's break this question down:

- "For each agency" tells me I need to **group_by** the `agency_name` so I can summarize totals within each agency.
- "how many total things" means how many items. Like before, we have the `quantity` variable, so we need to add all those together within summarize like we did above.
- "how much was it worth" is another sum, but this time we want to sum the `total_value` column 

So I envision my result looking like this:

| agency_name        | summed_quantity | summed_total_value |
|--------------------|-----------:|------------:|
| AFAKE POLICE DEPT      |       6419 |  10825707.5 |
| BFAKE SHERIFF'S OFFICE |        381 |  3776291.52 |
| CFAKE SHERIFF'S OFFICE |        270 |  3464741.36 |
| DFAKE POLICE DEPT      |       1082 |  3100420.57 |

The first columns in that summary will be our grouped values. This example is only grouping by one thing, `agency_name`. The other two columns are the summed values I'm looking to generate.

### Group_by, then summary with math

We'll start with the **total_quantity**.

1. Add a new section (headline, text and chunk) that describes the second quest: For each agency in Texas, find the summed **quantity** and summed **total value** of the equipment they received.
1. Add the code below into the chunk and run it.



```r
tx_c |> 
  group_by(agency_name) |> 
  summarize(
    summed_quantity = sum(quantity)
  )
```

```
## # A tibble: 335 × 2
##    agency_name                     summed_quantity
##    <chr>                                     <dbl>
##  1 ABERNATHY POLICE DEPT                         6
##  2 ALLEN POLICE DEPT                            11
##  3 ALVARADO ISD PD                               4
##  4 ALVIN POLICE DEPT                           478
##  5 ANDERSON COUNTY SHERIFFS OFFICE               7
##  6 ANDREWS COUNTY SHERIFF OFFICE                12
##  7 ANSON POLICE DEPT                             9
##  8 ANTHONY POLICE DEPT                          10
##  9 ARANSAS PASS POLICE DEPARTMENT               28
## 10 ARCHER COUNTY SHERIFF OFFICE                  3
## # … with 325 more rows
```

Let's break this down a little.

- We start with the `tx_c`, which is the "controlled" data, and then ...
- We group by `agency_name`. This organizes our data (behind the scenes) so our summarize actions will happen _within each agency_. Now I normally say run your code one line at a time, but you would not be able to _see_ the groupings at this point, so I usually write `group_by()` and `summarize()` together.
- In `summarize()` we first name our new column: `summed_quantity`, then we set that column to equal `=` the **sum of all values in the `quantity` column**. `sum()` is the function, and we feed it the column we want to add together: `quantity`.
- I put the inside of the summarize function in its own line because we will add to it. I enhances readability. RStudio will help you with the indenting, etc.

If you look at the first line of the return, it is taking all the rows for the "ABERNATHY POLICE DEPT" and then adding together all the values in the `quantity` field.

If you wanted to test this (and that is a real good idea), you might look at the data from one of the values and check the math. Here are the Abernathy rows. I usually do these tests in a code chunk of their own, and sometimes I delete them after I'm sure my logic works.


```r
tx_c |> 
  filter(agency_name == "ABERNATHY POLICE DEPT")
```

```
## # A tibble: 2 × 13
##   state agency_name          nsn   item_…¹ quant…² ui    acqui…³ demil…⁴ demil…⁵
##   <chr> <chr>                <chr> <chr>     <dbl> <chr>   <dbl> <chr>     <dbl>
## 1 TX    ABERNATHY POLICE DE… 2320… TRUCK,…       1 Each    62627 C             1
## 2 TX    ABERNATHY POLICE DE… 1240… SIGHT,…       5 Each      333 D             1
## # … with 4 more variables: ship_date <dttm>, station_type <chr>,
## #   total_value <dbl>, control_type <lgl>, and abbreviated variable names
## #   ¹​item_name, ²​quantity, ³​acquisition_value, ⁴​demil_code, ⁵​demil_ic
```

If we look at the `quantity` column there and eyeball all the rows, we see there 8 rows with a value of "1", and one row with a value of "5". 8 + 5 = 13, which matches our `summed_quantity` answer in our summary table. We're good!

### Add the total_value

We don't have to stop at one summary. We can perform multiple summarize actions on the same or different columns within the same expression.

**Edit your summary chunk** to:

1. Add add a comma after the first summarize action.
1. Add the new expression to give us the `summed_total_value` and run it.


```r
tx_c |> 
  group_by(agency_name) |> 
  summarize(
    summed_quantity = sum(quantity),
    summed_total_value = sum(total_value)
  )
```

```
## # A tibble: 335 × 3
##    agency_name                     summed_quantity summed_total_value
##    <chr>                                     <dbl>              <dbl>
##  1 ABERNATHY POLICE DEPT                         6             64292 
##  2 ALLEN POLICE DEPT                            11           1404528 
##  3 ALVARADO ISD PD                               4               480 
##  4 ALVIN POLICE DEPT                           478           2436004.
##  5 ANDERSON COUNTY SHERIFFS OFFICE               7            733720 
##  6 ANDREWS COUNTY SHERIFF OFFICE                12              1476 
##  7 ANSON POLICE DEPT                             9              5329 
##  8 ANTHONY POLICE DEPT                          10              7490 
##  9 ARANSAS PASS POLICE DEPARTMENT               28            515396.
## 10 ARCHER COUNTY SHERIFF OFFICE                  3           1101000 
## # … with 325 more rows
```

### Arrange the results

OK, this gives us our answers, but in alphabetical order. We want to arrange the data so it gives us the most `summed_total_value` in **desc**ending order.

1. EDIT your block to add an `arrange()` function below


```r
tx_c |> 
  group_by(agency_name) |> 
  summarize(
    summed_quantity = sum(quantity),
    summed_total_value = sum(total_value)
  ) |> 
  arrange(summed_total_value |> desc())
```

```
## # A tibble: 335 × 3
##    agency_name                       summed_quantity summed_total_value
##    <chr>                                       <dbl>              <dbl>
##  1 HOUSTON POLICE DEPT                          2384           7322064.
##  2 JEFFERSON COUNTY SHERIFFS OFFICE              206           3412547.
##  3 SAN MARCOS POLICE DEPT                        600           3200702.
##  4 DPS SWAT- TEXAS RANGERS                       137           3015221 
##  5 AUSTIN POLICE DEPT                           1392           2622087.
##  6 ALVIN POLICE DEPT                             478           2436004.
##  7 HARRIS COUNTY CONSTABLE PCT 3                 291           2321126.
##  8 MILAM COUNTY SHERIFF DEPT                      83           2196952.
##  9 HARRIS COUNTY SHERIFF'S OFFICE                 16           1834141 
## 10 VAN ZANDT COUNTY SHERIFF'S OFFICE              45           1789636.
## # … with 325 more rows
```

So now we've sorted the results to put the highest `summed_total_value` at the top.

Remember, there are two ways we can set up that `arrange()` function in descending order: 

- `arrange(summed_total_value |> desc())`
- `arrange(desc(summed_total_value))`

Both work and are correct. It really is your preference.

### Consider the results

Is there anything that sticks out in that list? It helps if you know a little bit about Texas cities and counties, but here are some thoughts to ponder:

- Houston is the largest city in the state (4th largest in the country, in fact). It makes sense that it tops the list. Same for Harris County or even the state police force. Austin being up there is also not crazy, as it's almost a million people.
- But what about San Marcos (pop. 63,220)? Or Milam County (pop. 24,770)? Those are way smaller cities and law enforcement agencies. They might be worth looking into.

Perhaps we should look some at the police agencies closest to us.

## Looking a local agencies

Our second quest had a second part: **How does this look for local police agencies?**

We'll take the summary above, but then filter it to show only local agencies of interest.

### Save our "by agency" list

Since we want to take an existing summary and add more filtering to it, it makes sense to go back into that chunk and save it into a new object so we can reuse it.

1. EDIT your existing summary chunk to save the result into a new tibble. Name it `tx_agency_totals` so we are all on the same page.
1. Add a new line that prints the result to the screen so you can still see it.


```r
# adding the new tibble object in next line
tx_agency_totals <- tx_c |> 
  group_by(agency_name) |> 
  summarize(
    summed_quantity = sum(quantity),
    summed_total_value = sum(total_value)
  ) |> 
  arrange(summed_total_value |> desc())

# peek at the result
tx_agency_totals
```

```
## # A tibble: 335 × 3
##    agency_name                       summed_quantity summed_total_value
##    <chr>                                       <dbl>              <dbl>
##  1 HOUSTON POLICE DEPT                          2384           7322064.
##  2 JEFFERSON COUNTY SHERIFFS OFFICE              206           3412547.
##  3 SAN MARCOS POLICE DEPT                        600           3200702.
##  4 DPS SWAT- TEXAS RANGERS                       137           3015221 
##  5 AUSTIN POLICE DEPT                           1392           2622087.
##  6 ALVIN POLICE DEPT                             478           2436004.
##  7 HARRIS COUNTY CONSTABLE PCT 3                 291           2321126.
##  8 MILAM COUNTY SHERIFF DEPT                      83           2196952.
##  9 HARRIS COUNTY SHERIFF'S OFFICE                 16           1834141 
## 10 VAN ZANDT COUNTY SHERIFF'S OFFICE              45           1789636.
## # … with 325 more rows
```

The result is the same, but we can reuse the `tx_agency_totals` tibble.

### Filtering within a vector

**Let's talk through the filter concepts before you try it with this data.**

When we talked about filtering with the Billboard project, we discussed using the `|` operator as an "OR" function. If we were to apply that logic here, it would look like this:

```r
data |> 
  filter(column_name == "Text to find" | column_name == "More text to find")
```

That can get pretty unwieldy if you have more than a couple of things to look for.

There is another operator `%in%` where we can search for multiple items from a list. (This list of terms is officially called a vector, but whatever.) Think of it like this in plain English: *Filter* the *column* for things *in* this *list*.

```r
data |> 
  filter(col_name %in% c("This string", "That string"))
```

We can take this a step further by saving the items in our list into an R object so we can reuse that list and not have to type out all the terms each time we use them.

```r
list_of_strings <- c(
  "This string",
  "That string"
)

data |> 
  filter(col_name %in% list_of_strings)
```

### Create a vector to build this filter

In the interest of time, I'm going to give you the list of local police agencies to filter with. To be clear, I did considerable work to figure out the exact names of these agencies. I consulted a different data set that lists all law enforcement agencies in Texas and then I used some creative filtering to find their "official" names in the leso data. It also helps that I'm familiar with local cities and counties so I can recognize the names. **I don't want to get sidetracked on that process here so I'll give you the list and show you how to use it.**

1. Create a new section (headline, text and chunk) and describe you are filtering the summed quantity/values for local agencies.
1. Add the code below into that chunk.


```r
local_agencies <- c(
  "AUSTIN PARKS POLICE DEPT", #NI
  "AUSTIN POLICE DEPT",
  "BASTROP COUNTY SHERIFF'S OFFICE",
  "BASTROP POLICE DEPT",
  "BEE CAVE POLICE DEPT",
  "BUDA POLICE DEPT",
  "CALDWELL COUNTY SHERIFFS OFFICE",
  "CEDAR PARK POLICE DEPT",
  "ELGIN POLICE DEPARTMENT",
  "FLORENCE POLICE DEPT", #NI
  "GEORGETOWN POLICE DEPT",
  "GRANGER POLICE DEPT", #NI
  "HAYS CO CONSTABLE PRECINCT 4",
  "HAYS COUNTY SHERIFFS OFFICE",
  "HUTTO POLICE DEPT",
  "JARRELL POLICE DEPT", #NI
  "JONESTOWN POLICE DEPT", #NI
  "KYLE POLICE DEPT",
  "LAGO VISTA POLICE DEPT",
  "LAKEWAY POLICE DEPT", #NI
  "LEANDER POLICE DEPT",
  "LIBERTY HILL POLICE DEPT", #NI
  "LOCKHART POLICE DEPT",
  "LULING POLICE DEPT",
  "MANOR POLICE DEPT",
  "MARTINDALE POLICE DEPT", #NI
  "PFLUGERVILLE POLICE DEPT",
  "ROLLINGWOOD POLICE DEPT", #NI
  "SAN MARCOS POLICE DEPT",
  "SMITHVILLE POLICE DEPT", #NI
  "SUNSET VALLEY POLICE DEPT", #NI
  "TAYLOR POLICE DEPT", #NI
  "THRALL POLICE DEPT", #NI
  # TEXAS STATE UNIVERSITY HI_ED
  "TRAVIS COUNTY SHERIFFS OFFICE",
  # TRAVIS CONSTABLE OFFICE,
  # SOUTHWESTERN UNIVERSITY HI_ID
  "WESTLAKE HILLS POLICE DEPT", #NI
  "UNIV OF TEXAS SYSTEM POLICE HI_ED",
  "WILLIAMSON COUNTY SHERIFF'S OFFICE"
)

tx_agency_totals |> 
  filter(agency_name %in% local_agencies)
```

```
## # A tibble: 19 × 3
##    agency_name                        summed_quantity summed_total_value
##    <chr>                                        <dbl>              <dbl>
##  1 SAN MARCOS POLICE DEPT                         600           3200702.
##  2 AUSTIN POLICE DEPT                            1392           2622087.
##  3 UNIV OF TEXAS SYSTEM POLICE HI_ED                3           1305000 
##  4 LEANDER POLICE DEPT                            212           1182083 
##  5 GEORGETOWN POLICE DEPT                          41           1075807.
##  6 CALDWELL COUNTY SHERIFFS OFFICE                339            977096.
##  7 CEDAR PARK POLICE DEPT                         106            970222.
##  8 TRAVIS COUNTY SHERIFFS OFFICE                   78            896006.
##  9 BASTROP COUNTY SHERIFF'S OFFICE                263            712074.
## 10 HAYS COUNTY SHERIFFS OFFICE                    384            442203.
## 11 KYLE POLICE DEPT                               197            149673.
## 12 WILLIAMSON COUNTY SHERIFF'S OFFICE             165             75460 
## 13 LOCKHART POLICE DEPT                            16             54177.
## 14 BEE CAVE POLICE DEPT                            38             51929.
## 15 HUTTO POLICE DEPT                               90             13524.
## 16 PFLUGERVILLE POLICE DEPT                         1             10747 
## 17 BASTROP POLICE DEPT                             10              4990 
## 18 LULING POLICE DEPT                              16              4700.
## 19 BUDA POLICE DEPT                                16              1736.
```

Let's walk through that code and my notes there.

- We start by giving our list of agencies a name: `local_agencies`. This creates an R object that we can reuse. We will need this list a number of times, and it makes sense to manage it in once place instead of each time we need it.
- Next we fill that object with a list of agency names. Again, I did some pre-work to figure out those names that we aren't covering here, and in some cases there is a comment `#NI` next to them. That is a note to myself that the particular agency is NOT INCLUDED in our data, which means I haven't confirmed the name spelling. It could be at a later date the Austin Parks department gets equipment, but they list their name as "CITY OF AUSTIN PARKS" instead of "AUSTIN PARKS POLICE DEPT" and it would not be filtered properly. This is another example that **your most important audience for your code is your future self**.
- Now that our list is created, we can use it to filter our `tx_agency_totals` data. So, we start with that data, and then ...
- We pipe into `filter()`, but inside our filter we don't set it `==` to a single thing, instead we say: `agency_name %in% local_agencies`, which says look inside that `agency_name` column and keep any row that has a value that is also in our `local_agencies` vector.

This filters our list of agencies to just those in Central Texas.

## Types of items shipped to each agency

Now that we have an overall idea of what local agencies are doing, let's dive a little deeper. It's time to figure out the specific items that they received.

Our question is this: **What specific "controlled" items did each agency get and how much were they worth?**

In some cases an agency might get the same item shipped to them at different times. For instance, "AUSTIN POLICE DEPT" has multiple rows where they get a single "ILLUMINATOR,INTEGRATED,SMALL ARM" shipped to them on the same date, but then on other dates they have the same item but the quantity is 30. We want all of these "ILLUMINATOR,INTEGRATED,SMALL ARM" for the Austin police added together into a single record.

The logic works like this: 

- Start with the controlled data, and then ...
- Group by the `agency_name` and `item_name`, which will group all the rows where those values are the same. All "AUSTIN POLICE DEPT" rows with "ILLUMINATOR,INTEGRATED,SMALL ARM" will be considered together, and then ...
- Summarize to sum the `quantity`, and then do the same for `total_value`.

The code for this is very similar to what we did above when we summaries agencies, except we are grouping by two things, the **agency_name** and the **item_name**. Let's do it:

1. Create a new section (headline, text and code chunk) and describe that you are finding the sums for each item that each agency has received since 2010.
2. Consult (or even copy) the code you wrote when you created the agency totals, but modify the `group_by()` to add the `item_name`, like this: `group_by(agency_name, item_name)`.
3. Be sure you rename your created R objects, too, perhaps to `tx_agency_item_totals`.

<details>
  <summary>Give it a go on your own first, then check here</summary>


```r
# adding the new tibble object in next line
tx_agency_item_totals <- tx_c |> 
  group_by(agency_name, item_name) |> 
  summarize(
    summed_quantity = sum(quantity),
    summed_total_value = sum(total_value)
  ) |> 
  arrange(summed_total_value |> desc())
```

```
## `summarise()` has grouped output by 'agency_name'. You can override using the
## `.groups` argument.
```

```r
# peek at the result
tx_agency_item_totals
```

```
## # A tibble: 1,548 × 4
## # Groups:   agency_name [335]
##    agency_name                       item_name              summed_qua…¹ summe…²
##    <chr>                             <chr>                         <dbl>   <dbl>
##  1 HOUSTON POLICE DEPT               AIRCRAFT, FIXED WING              1 5390000
##  2 DPS SWAT- TEXAS RANGERS           MINE RESISTANT VEHICLE            4 2611000
##  3 DEPT OF CRIM JUSTICE OIG          TRUCK,CARGO                       4 1446516
##  4 UNIV OF TEXAS SYSTEM POLICE HI_ED MINE RESISTANT VEHICLE            2 1228000
##  5 JEFFERSON COUNTY SHERIFFS OFFICE  HELICOPTER,UTILITY                1  922704
##  6 ALVIN POLICE DEPT                 HOIST,INTERNAL RESCUE             6  900420
##  7 VAN ZANDT COUNTY SHERIFF'S OFFICE TRUCK,WRECKER                     1  880674
##  8 BURKBURNETT POLICE DEPT           MINE RESISTANT VEHICLE            1  865000
##  9 CLEBURNE POLICE DEPT              MINE RESISTANT VEHICLE            1  865000
## 10 CUERO POLICE DEPT                 MINE RESISTANT VEHICLE            1  865000
## # … with 1,538 more rows, and abbreviated variable names ¹​summed_quantity,
## #   ²​summed_total_value
```

</details>

<br/>

This reuse of code like this -- copying the agency grouping code and editing it to add the item_name value -- is very common in coding, and there is nothing wrong with doing so as long as you are careful.

When you reuse code, review it carefully so you don't override things by accident. In this instance, our original code created an R object: `tx_agency_totals <- tx_c |> ...` that holds the result of our functions, and we call that later to view it. If we reuse this code and don't update that object name, we'll reset the values inside that already-existing object, which was not our intent. We wabt to create a NEW thing `tx_agency_item_totals` so we can use that later, too. And if we don't update the "peek" at the object, we'll be looking at the old one instead of the new one.

OF NOTE: With that last code chunk you'll see a warning in your R Console: *`summarise()` has grouped output by 'agency_name'. You can override using the `.groups` argument.* This is not a problem, it's just a reminder that when we group by more than one thing, the first grouping is retained when future functions are applied to this result. It's more confusing than helpful, to be honest. Just know if we wanted to do further manipulation, we might need to use `ungroup()` first.

### Items for local agencies

Just like we did for our agency totals, we want to filter this list of items to those sent to our local agencies. However, this time we've already created the list of local agencies so we don't have to redo that part ... we just need to filter by it.

1. Start a new section (headline, text) and explain that you are looking at items sent to local agencies.
2. Use `filter()` to focus the data just on or `local_agencies`.


```r
tx_agency_item_totals |> 
  filter(agency_name %in% local_agencies)
```

```
## # A tibble: 175 × 4
## # Groups:   agency_name [19]
##    agency_name                       item_name                   summe…¹ summe…²
##    <chr>                             <chr>                         <dbl>   <dbl>
##  1 UNIV OF TEXAS SYSTEM POLICE HI_ED MINE RESISTANT VEHICLE            2  1.23e6
##  2 AUSTIN POLICE DEPT                HELICOPTER,FLIGHT TRAINER         1  8.33e5
##  3 TRAVIS COUNTY SHERIFFS OFFICE     MINE RESISTANT VEHICLE            1  7.67e5
##  4 CEDAR PARK POLICE DEPT            MINE RESISTANT VEHICLE            1  7.33e5
##  5 GEORGETOWN POLICE DEPT            MINE RESISTANT VEHICLE            1  7.33e5
##  6 LEANDER POLICE DEPT               MINE RESISTANT VEHICLE            1  7.33e5
##  7 SAN MARCOS POLICE DEPT            MINE RESISTANT VEHICLE            1  7.33e5
##  8 BASTROP COUNTY SHERIFF'S OFFICE   MINE RESISTANT VEHICLE            1  6.58e5
##  9 SAN MARCOS POLICE DEPT            CAPABILITIES SET,NON-LETHAL       1  4.95e5
## 10 AUSTIN POLICE DEPT                IMAGE INTENSIFIER,NIGHT VI…      85  4.59e5
## # … with 165 more rows, and abbreviated variable names ¹​summed_quantity,
## #   ²​summed_total_value
```

Because our original list arranged the data by the most expensive items, we can see that here. But it might be easier to rearrange the data by agency name first, then the most expensive items.

1. EDIT your chunk to add an arrange function.
2. Within the arrange, set it to `agency_name` first, then `summed_total_value` in descending order.


```r
tx_agency_item_totals |> 
  filter(agency_name %in% local_agencies) |> 
  arrange(agency_name, desc(summed_total_value))
```

```
## # A tibble: 175 × 4
## # Groups:   agency_name [19]
##    agency_name        item_name                                  summe…¹ summe…²
##    <chr>              <chr>                                        <dbl>   <dbl>
##  1 AUSTIN POLICE DEPT HELICOPTER,FLIGHT TRAINER                        1 833400 
##  2 AUSTIN POLICE DEPT IMAGE INTENSIFIER,NIGHT VISION                  85 458831.
##  3 AUSTIN POLICE DEPT SIGHT,THERMAL                                   29 442310 
##  4 AUSTIN POLICE DEPT PACKBOT 510 WITH FASTAC REMOTELY CONTROLL…       4 308000 
##  5 AUSTIN POLICE DEPT SIGHT,REFLEX                                   420 169256.
##  6 AUSTIN POLICE DEPT ILLUMINATOR,INTEGRATED,SMALL ARMS              135 122302 
##  7 AUSTIN POLICE DEPT RECON SCOUT XT                                   8  92451.
##  8 AUSTIN POLICE DEPT TEST SET,NIGHT VISION VIEWER                     2  55610 
##  9 AUSTIN POLICE DEPT SCOPE,NIGHT-POCKET                               5  20535 
## 10 AUSTIN POLICE DEPT POWER SUPPLY ASSEMBLY                           63  20086.
## # … with 165 more rows, and abbreviated variable names ¹​summed_quantity,
## #   ²​summed_total_value
```

### Research some interesting items

You'll want a little more detail about some of these items for your data drop. I realize (and you should, too) that for a "real" story we would need to reach out to sources for more information, but you can get a general idea from what you find online to at least describe some of these items. There are a couple of ways to go about researching items.

1. Simply search for the items on Google, [like this](https://www.google.com/search?q=ILLUMINATOR%2CINTEGRATED%2CSMALL+ARMS&oq=ILLUMINATOR%2CINTEGRATED%2CSMALL+ARMS).
2. Each item has a "National Stock Number," which is an ID for a government database of supplies. You can search the data for the `nsn` value and then look up that value online. 

Let do an example, looking up "ILLUMINATOR,INTEGRATED,SMALL ARMS". First we filter the data to find the item. (I'm also using select so we can control the output and see it in this book, but you might not want that in your notebook so you can also check `ship_dates`, etc.)


```r
tx_c |> 
  filter(
    item_name == "ILLUMINATOR,INTEGRATED,SMALL ARMS",
    agency_name == "AUSTIN POLICE DEPT"
    ) |> 
  select(item_name, nsn)
```

```
## # A tibble: 100 × 2
##    item_name                         nsn             
##    <chr>                             <chr>           
##  1 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
##  2 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
##  3 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-571-1258
##  4 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
##  5 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
##  6 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
##  7 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
##  8 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
##  9 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
## 10 ILLUMINATOR,INTEGRATED,SMALL ARMS 5855-01-534-5931
## # … with 90 more rows
```

It looks like most of these illuminators use this `nsn`: 5855-01-534-5931.

Now we go to the website <https://nationalstocknumber.info/> and plug that number into the search bar. We get a couple of returns, and if we click on one we [get this page](https://nationalstocknumber.info/national-stock-number/5855-01-534-5931). It gives us a description of the item:

> "A device which is a combination of several lasers and white light illumination used to provide multiple capabilities for engaging targets and providing light. The device may contain a flashlight or other white light illumination source, an illuminator, infrared and stand alone aiming lasers/pointers. The device has the capability to mount on an individual weapon."

Not every item is in the database, but it is worth checking.

## Write a data drop

Once you've found answers to all the questions listed, you may be asked to use that information in a writing assignment. See Canvas for details.

## What we learned in this chapter

- We used `sum()` within a `group_by()`/`summarize()` function to add values within a column.
- We used `summary()` to get descriptive statistics about our data, like the minimum and maximum values, or an average (mean).
- We learned how to use `c()` to **combine** a list of like values into a _vector_, and then used that vector to filter a column for values `%in%` that vector.

