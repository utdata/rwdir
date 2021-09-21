# Summarize with math - analysis {#sums-analyze}

> Mid-draft in progress.

In the last chapter, we covered the overall story about the LESO data ... that local law enforcement agencies can get surplus military equipment from the U.S. Department of Defense. We downloaded a pre-processed version of the data and filtered it to just Texas records over a specific time period (2010 to present), and used `mutate()` to create a new column calculated fron other variables in the data.

## Learning goals of this lesson

In this chapter we will start querying the data using **summarize with math**, basically using summarize to add values in a column instead of counting rows, which we did with the Billboard assignment.

Our learning goals are:

- To use the combination of `group_by()`, `summarize()` and `arrange()` to add columns of date using `sum()`.
- To use different groupings `group_by()` to do the above in specified ways to get desired results.
- To practice using `filter()` on those summaries to better see certain results.
- We'll research and write about some of the findings, practicing data-centric ledes and sentences describing data.

## Questions to answer

A reminder of what we are looking for: All answers are be based on data from **Jan. 1, 2010** to present for only consider **Texas** agencies. We did this filtering already. 

- For each agency in Texas, find the summed **quantity** and summed **total value** of the equipment they received. (When I say "summed" that means we'll add together all the values in the column.)
  - Once you have the list, we'll think about what stands out and why?
- We'll take the list above, but filter that summary to show only the following local agencies:
  - AUSTIN POLICE DEPT
  - SAN MARCOS POLICE DEPT
  - TRAVIS COUNTY SHERIFFS OFFICE
  - UNIV OF TEXAS SYSTEM POLICE HI_ED
  - WILLIAMSON COUNTY SHERIFF'S OFFICE
- For each of the agencies above we'll summarize the **total quantity** and **acquisition_value** of each **item** shipped to the agency. We'll arrange the list by agency so we can write about each one.
- You'll research some of the more interesting items the agencies received (i.e. Google the names) so you can include them in your data drop.

## Set up the analysis notebook

Before we get into how to do this, let's set up our analysis notebook.

1. Make sure you have your military surplus project open in RStudio. If you have your import notebook open, close it and use Run > Restart R and Clear Output.
1. Create a new RNotebook and edit the title as "Military surplus analysis".
1. Remove the boilerplate text.
1. Create a setup section (headline, text and code chunk) that loads the tidyverse library.

We've started each notebook like this, so you should be able to do this on your own now.



### Load the data into a tibble

1. Next create an import section (headline, text and chunk) that loads the data from the previous notebook and save it into a tibble called `tx`.
1. Add a `glimpse()` of the data for your reference.

We did this in Billboard and you should be able to do it. You'll use `read_rds()` and find your data in your data-raw folder.

<details>
  <summary>Remember your data is in data-raw</summary>

```r
tx <- read_rds("data-processed/01-leso-tx.rds")

tx %>% glimpse()
```

```
## Rows: 7,407
## Columns: 9
## $ state             <chr> "TX", "TX", "TX", "TX", "TX", "TX", "TX", "TX", "TX"…
## $ agency_name       <chr> "ABERNATHY POLICE DEPT", "ABERNATHY POLICE DEPT", "A…
## $ item_name         <chr> "PISTOL,CALIBER .45,AUTOMATIC", "PISTOL,CALIBER .45,…
## $ quantity          <dbl> 1, 1, 1, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
## $ ui                <chr> "Each", "Each", "Each", "Each", "Each", "Each", "Eac…
## $ acquisition_value <dbl> 58.71, 58.71, 58.71, 58.71, 58.71, 749.00, 749.00, 3…
## $ ship_date         <dttm> 2011-11-03, 2011-11-03, 2011-11-03, 2011-11-03, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
## $ total_value       <dbl> 58.71, 58.71, 58.71, 58.71, 58.71, 749.00, 749.00, 1…
```

<details>

You should see the `tx` object in you Environment.

## How to tackle summaries

As we get into the first quest, let's talk about "how" we do summaries.

When I am querying my data, I start by envisioning what the result should look like.

Let's take the first question: For each agency in Texas, find the **total_quantity** and **total_value** of the equipment they received.

Let's break this down:

- "For each agency in Texas". For all the questions, we only want Texas agencies. In the import notebook, you should've filter for only the TX agencies. So, if done right, the TX agencies are already filtered. But the "For each agency" part tells me I need to **group_by** the `agency_name` so I can summarize totals within each agency.
- "find the **total_quantity** and **total_value**": Because I'm looking for a total (or `sum()` of columns) I need `summarize()`.

So I envision my result looking like this:

| agency_name        | item_count | equip_value |
|--------------------|-----------:|------------:|
| AFAKE POLICE DEPT      |       6419 |  10825707.5 |
| BFAKE SHERIFF'S OFFICE |        381 |  3776291.52 |
| CFAKE SHERIFF'S OFFICE |        270 |  3464741.36 |
| DFAKE POLICE DEPT      |       1082 |  3100420.57 |

With `group_by` I can organize all the rows by their `agency_name` so that my "summarize" can do the math within those groups.

```r
tx %>% 
  group_by(agency_name)
```

Running that code by itself doesn't show me anything of worth. It's grouping the data, but we can't _see_ it at this point. We need `summarize()` for that. A `group_by` almost is almost always followed by `summarize`.

### Summaries with math

We'll start with the **total_quantity**.

1. Add a new section (headline, text and chunk) that describes the first quest: For each agency in Texas, find the summed **quantity** and summed **total value** of the equipment they received.



```r
tx %>% 
  group_by(agency_name) %>% 
  summarize(
    sum_quantity = sum(quantity)
  )
```

```
## # A tibble: 357 × 2
##    agency_name                     sum_quantity
##    <chr>                                  <dbl>
##  1 ABERNATHY POLICE DEPT                     13
##  2 ALLEN POLICE DEPT                         11
##  3 ALVARADO ISD PD                            4
##  4 ALVIN POLICE DEPT                        539
##  5 ANDERSON COUNTY SHERIFFS OFFICE            8
##  6 ANDREWS COUNTY SHERIFF OFFICE             12
##  7 ANSON POLICE DEPT                          9
##  8 ANTHONY POLICE DEPT                       10
##  9 ARANSAS PASS POLICE DEPARTMENT            38
## 10 ARP POLICE DEPARTMENT                     18
## # … with 347 more rows
```

Let's break this down a little.

- We start with the tx data, and then ...
- We group by `agency_name`. This organizes our data (behind the scenes) so our summarize actions will happen _within each agency_.
- In `summarize()` we first name our new column: `sum_quantity`. We could call this whatever we want, but good practice is to name it what it is. We use good naming techniqes and split the words using `_`. I also use all lowercase.
- We set that column to equal `=` the **sum of all values in the `quantity` column**. `sum()` is the function, and we feed it the column we want to add together: `quantity`.
- I put the inside of the summarize function in its own line because we will add to it. I increases readability. RStudio will help you with the indenting, etc.

This is taking all the rows for the "ABERNATHY POLICE DEPT" and then adding together all the values in the `quantity` field.

If you wanted to test this (and it is a real good idea), you might look at the data from one of the values and check the math. Here are the Abernathy rows.


```r
tx %>% 
  filter(agency_name == "ABERNATHY POLICE DEPT")
```

```
## # A tibble: 9 × 9
##   state agency_name           item_name                    quantity ui    acquisition_val…
##   <chr> <chr>                 <chr>                           <dbl> <chr>            <dbl>
## 1 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
## 2 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
## 3 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
## 4 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
## 5 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
## 6 TX    ABERNATHY POLICE DEPT RIFLE,5.56 MILLIMETER               1 Each             749  
## 7 TX    ABERNATHY POLICE DEPT RIFLE,5.56 MILLIMETER               1 Each             749  
## 8 TX    ABERNATHY POLICE DEPT SIGHT,REFLEX                        5 Each             333  
## 9 TX    ABERNATHY POLICE DEPT TRUCK,UTILITY                       1 Each           62627  
## # … with 3 more variables: ship_date <dttm>, station_type <chr>,
## #   total_value <dbl>
```

If we look at the `quantity` column there and eyeball all the rows, we see there 8 rows with a value of "1", and one row with a value of "5". 8 + 5 = 13, which matches our `sum_quantity` answer in our summary table. We're good!

### Add the total_value

We don't have to stop at one summary. We can perform other summarize actions on the same or other columns in the same expression.

**Edit your chunk** to:

1. Add add a comma after the first summarize action.
1. Add the new expression to give us the `sum_total_value`.


```r
tx %>% 
  group_by(agency_name) %>% 
  summarize(
    sum_quantity = sum(quantity),
    sum_total_value = sum(total_value)
  )
```

```
## # A tibble: 357 × 3
##    agency_name                     sum_quantity sum_total_value
##    <chr>                                  <dbl>           <dbl>
##  1 ABERNATHY POLICE DEPT                     13          66084.
##  2 ALLEN POLICE DEPT                         11        1404024 
##  3 ALVARADO ISD PD                            4            480 
##  4 ALVIN POLICE DEPT                        539        2545240.
##  5 ANDERSON COUNTY SHERIFFS OFFICE            8         827891 
##  6 ANDREWS COUNTY SHERIFF OFFICE             12           1476 
##  7 ANSON POLICE DEPT                          9           5077 
##  8 ANTHONY POLICE DEPT                       10           7490 
##  9 ARANSAS PASS POLICE DEPARTMENT            38         571738 
## 10 ARP POLICE DEPARTMENT                     18           5789.
## # … with 347 more rows
```

### Arrange the results

OK, this gives us our answers, but in alphabetical order. We want to arrange the data so it gives us the most `sum_total_value` in **desc**ending order.

1. EDIT your block to add an `arrange()` function below


```r
tx %>% 
  group_by(agency_name) %>% 
  summarize(
    sum_quantity = sum(quantity),
    sum_total_value = sum(total_value)
  ) %>% 
  arrange(sum_total_value %>% desc())
```

```
## # A tibble: 357 × 3
##    agency_name                       sum_quantity sum_total_value
##    <chr>                                    <dbl>           <dbl>
##  1 HOUSTON POLICE DEPT                       6419       10825708.
##  2 HARRIS COUNTY SHERIFF'S OFFICE             381        3776292.
##  3 DPS SWAT- TEXAS RANGERS                   1730        3520630.
##  4 JEFFERSON COUNTY SHERIFF'S OFFICE          270        3464741.
##  5 SAN MARCOS POLICE DEPT                    1082        3100421.
##  6 AUSTIN POLICE DEPT                        1458        2741021.
##  7 MILAM COUNTY SHERIFF DEPT                  125        2723192.
##  8 ALVIN POLICE DEPT                          539        2545240.
##  9 HARRIS COUNTY CONSTABLE PCT 3              293        2376945.
## 10 PARKS AND WILDLIFE DEPT                   5608        2325655.
## # … with 347 more rows
```

### Consider the results

Is there anything that sticks out in that list? It helps if you know a little bit about Texas cities and counties, but here are some thoughts to poder:

- Houston is the largest city in the state (4th largest in the country). It makes sense that it tops the list. Same for Harris County or even the state police force.
- Looking locally, Austin being up there is also not crazy, as it's almost a million people. But San Marcos (63,220)? Or Milam County (24,770)?

Perhaps we should look some at the police agencies closest to us.

## Looking a local agencies

### Filter in a vector

Filter list to local agencies. see tech note below.

### Item quantiies, totals for local agencies

The separate chunks.



### Filter from a collection

One last thing that might help in this assignment. This relates to the quest to filter your summary to the local agencies.

When you filter data, you usually choose the column and then compare for some value. To find the rows for "Bread" in our data above, we would use:

```r
groceries %>% 
  filter(item == "Bread")
```

You can also filter for rows that contain any value in a collection of terms. If we wanted to find all rows with "Bread" or "Beer", we could do this:

```r
groceries %>% 
  filter(item %in% c("Bread", "Beer"))
```

The `c()` function is for "combine" to create a collection of values. You can even save that collection in an object and use that in a function:

```r
items_important = c("Bread", "Beer")

groceries %>% 
  filter(item %in% items_important)
```

## Write a data drop

Once you've found answers to all the questions listed, you'll weave those into a writing assignment. Include this as a Microsoft Word document saved into your project folder along with your notebooks. (If you are a Google Docs fan, you can write there and then export as a Word doc.)

You will **not** be writing a full story ... we are just practicing writing a lede and "data sentences" about what you've found. You _do_ need to source the data and briefly describe the program but this is not a fully-fleshed story. Just concentrate on how you would write the facts and attribution.

- Use Microsoft Word and include it with your project when you upload it to canvas.
- Write a data drop from the data of between four and six paragraphs. Be sure to include attribution about where the data came from.
- You can pick the lede angle from any of the questions outlined above. Each additional paragraph should describe what you found from the data.

Here is a **partial** example to give you an idea of what I'm looking for. (These numbers may be old and you can't use this angle ;-)).

> The Jefferson County Sheriff's Office is flying high thanks to gifts of over $3.5 million worth of surplus U.S. Department of Defense equipment.

> Among the items transferred over the past decade to the department was a $923,000 helicopter in October 2016 and related parts the following year, according to data from the Defense Logistics Agency data — the agency that handles the transfers.

> The sheriff's office has received the fourth highest value of equipment among any law enforcement agency in Texas since August 2014 despite being a county of only 250,000 people.

