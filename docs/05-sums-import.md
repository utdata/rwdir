# Summarize with math - import {#sums-import}

With our Billboard assignment, we went through some common data wrangling processes — importing data, cleaning it and querying it for answers. All of our answers involved counting numbers of rows and we did so with two methods: The summary trio: `group_by`, `summmarize` and `arrange` (which I dub GSA), and then the shortcut `count()` that allows us to do all of that in one line.

For this data story we need to leave `count` behind and stick with the summary trio GSA because now we must do different kinds of math within our summarize functions, mainly `sum()`.

## About the story: Military surplus transfers

In June 2020, Buzzfeed published the story [_Police Departments Have Received Hundreds Of Millions Of Dollars In Military Equipment Since Ferguson_](https://www.buzzfeednews.com/article/johntemplon/police-departments-military-gear-1033-program) about the amount of military equipment transferred to local law enforcement agencies since Michael Brown was killed in Ferguson, Missouri. After Brown's death there was a public outcry after "what appeared to be a massively disproportionate show of force during protests brought scrutiny to a federal program that transfers unused military equipment to local law enforcement." Reporter John Templon used data from the [Law Enforcement Support Office](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/) for the update on the program and published his [data analysis](https://github.com/BuzzFeedNews/2020-06-leso-1033-transfers-since-ferguson), which he did in Python.

You will analyze the same dataset focusing on some local police agencies and write a short data drop about transfers to those agencies.

### The LESO program

The Defense Logistics Agency transfers surplus military equipment to local law enforcement through its [Law Enforcement Support Office](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/). You can find more information [about the program here](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/ProgramFAQs/).

The agency updates the data quarterly and the data I've collected contains transfers through **June 30, 2021**. The original file is linked from the headline "ALASKA - WYOMING AND US TERRITORIES".

The data there comes in an Excel spreadsheet that has a new sheet for each state. I used R to pull the data from each sheet and combine it into a single data set and I'll cover the process I used in class, but you won't have to do that part.

**I will supply a link to the combined data below.**

### About the data

There is no data dictionary or record layout included with the data but I have corresponded with the Defense Logistics Agency to get a decent understanding of what is included. Columns in bold are those we care about the most.

- sheet: Which sheet the data came from. This is an artifact from the data merging script.
- **state**: A two-letter designation for the state of the agency.
- **agency_name**: This is the agency that got the equipment.
- nsn: A special number that identifies the item. It is not germane to this specific assignment.
- **item_name**: The item transferred. Googling the names can sometimes yield more info on specific items.
- **quantity**: The number of the "units" the agency received.
- ui: Unit of measurement (item, kit, etc.)
- **acquisition_value**: a cost *per unit* for the item.
- demil_code: Another special code not germane to this assignment.
- demil_ic: Another special code not germane to this assignment.
- **ship_date**: The date the item(s) were sent to the agency.
- station_type: What kind of law enforcement agency made the request.

Here is a sample of our main columns of interest, except for the date:




```{=html}
<div id="htmlwidget-1831c3910b3c594aea07" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-1831c3910b3c594aea07">{"x":{"filter":"none","vertical":false,"data":[["KY","SC","CA","TX","OH"],["MEADE COUNTY SHERIFF DEPT","PROSPERITY POLICE DEPT","KERN COUNTY SHERIFF OFFICE","LEAGUE CITY POLICE DEPT","TRUMBULL COUNTY SHERIFF'S OFFICE"],["GENERATOR SET,DIESEL ENGINE","RIFLE,7.62 MILLIMETER","MARKER,TUBE TYPE","RIFLE,5.56 MILLIMETER","RIFLE,5.56 MILLIMETER"],[5,1,32,1,1],[4623.09,138,16.91,749,749]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>state<\/th>\n      <th>agency_name<\/th>\n      <th>item_name<\/th>\n      <th>quantity<\/th>\n      <th>acquisition_value<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","columnDefs":[{"className":"dt-right","targets":[3,4]}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```
<br>

Each row of data is a transfer of a particular type of item from the U.S. Department of Defense to a local law enforcement agency. The row includes the name of the item, the quantity, and the value ($) of a single unit.

What the data doesn't have is the **total value** of the items in the shipment. If there are 5 generators as noted in the first row above and the cost of each one is $4623.09, we have to multiply the `quantity` times the `acquisition_value` to get the total value of that equipment. We will do that as part of the assignment.

The local agencies really only pay the shipping costs for the item, _so you can't say they paid for the items_, so the **total value** you calculate is the "value" of the items, not their cost to the local agency.

## The questions we will answer

All answers will be based on data from **Jan. 1, 2010** to present. In addition, we'll only consider **Texas** agencies as you answer the following.

- For each agency in Texas, find the summed **quantity** and summed **total value** of the equipment they received. (When I say "summed" that means we'll add together all the values in the column.)
  - Once you have the list, we'll think about what stands out and why?
- We'll take the list above, but filter that summary to show only the following local agencies:
  - AUSTIN POLICE DEPT
  - SAN MARCOS POLICE DEPT
  - TRAVIS COUNTY SHERIFFS OFFICE
  - UNIV OF TEXAS SYSTEM POLICE HI_ED
  - WILLIAMSON COUNTY SHERIFF'S OFFICE
- For each of the agencies above we'll use summarize to get the  _summed_ **quantity** and _summed_ **total_value** of each **item** shipped to the agency. We'll create a summarized list for each agency so we can write about each one.
- You'll research some of the more interesting items the agencies received (i.e. Google the names) so you can include them in your data drop.

## Create your project

We will build the same project structure that we did with the Billboard project. In fact, all our class projects will have this structure. Since we've done this before, some of the directions are less detailed.

1. With RStudio open, make sure you don't have a project open. Go to File > Close project.
1. Use the create project button (or File > New project) to create a new project in a "New Directory". Name the directory "yourname-military-surplus".
1. Create two folders: `data-raw` and `data-processed`.

## Import/cleaning notebook

Again, like Billboard, we'll create a notebook specifically for downloading, cleaning and prepping our data.

1. Create your RNotebook.
1. Rename the title "Military Surplus import/clean".
1. Remove the rest of the boilerplate template.
1. Save the file and name it `01-import.Rmd`.

### Add the goals of the notebook

1. In Markdown, add a headline noting these are notebook goals.
1. Add the goals below:

```text
- Download the data
- Import the data
- Clean datatypes
- Remove unnecessary columns
- Create a total_value column
- Filter to Texas agencies
- Filter the date range (since Jan. 1 2010)
- Export the cleaned data
```

> NOTE: Most of these are pretty standard in a import/cleaning notebook. Filtering to Texas agencies is specific to this data set, but we would do all these other things in all projects.

### Add a setup section

This is the section where we add our libraries and such. Again, every notebook has this section, though the packages may vary on need.

1. Add a headline and text about what we are doing: Our project setup.
2. Add a code chunk to load the libraries. You should only need `tidyverse` for this notebook because the data already has clean names (no need for janitor) and the dates will import correctly (no need for lubridate).


```r
library(tidyverse)
```


### Download the data

1. A new section means a new headline and description. Add it. It is good practice to describe and link to the data you will be using. You can use this:

```text
The Defense Logistics Agency transfers surplus military equipment to local law enforcement through its [Law Enforcement Support Office](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/). You can find more information [about the program here](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/ProgramFAQs/).
```

1. Use the `download.file()` function to download the date into your `data-raw` folder. Remember you need two arguments:

```r
download.file("url_to_data", "path_to_folder/filename.csv")
```

- The data can be found at this url: `https://github.com/utdata/rwd-r-leso/blob/main/data-processed/leso.csv?raw=true`
- It should be saved into your `data-raw` folder with a name for the file.

Once you've built your code chunk and run it, you should make sure the file downloaded into the correct place: in your `data-raw` folder.

<details>
  <summary>You should be able to do this on your own. Really.</summary>
  

```r
# You can comment the line below once you have the data
download.file("https://github.com/utdata/rwd-r-leso/blob/main/data-processed/leso.csv?raw=true",
              "data-raw/leso.csv")
```

</details>

### Import the data

We are again working with a CSV, or comma-separated-values text file.

1. Add a new section: Headline, text if needed, code chunk.

I suggest you build the code chunk a bit at a time in this order:

1. Use `read_csv()` to read the file from our `data-raw` folder.
1. Edit that line to put the result into a tibble object using `<-`. Name your new tibble `leso`.
1. Print the tibble as a table to the screen again by putting the tibble object on a new line and running it. This allows you to see it in columnar form.

<details>
  <summary>Try real hard first before clicking here for the answer. Note the book will also show the response.</summary>
  

```r
# assigning the tibble
leso <- read_csv("data-raw/leso.csv")
```

```
## Rows: 129348 Columns: 12
```

```
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (7): state, agency_name, nsn, item_name, ui, demil_code, station_type
## dbl  (4): sheet, quantity, acquisition_value, demil_ic
## dttm (1): ship_date
```

```
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
# printing the tibble
leso
```

```
## # A tibble: 129,348 × 12
##    sheet state agency_name           nsn   item_name quantity ui    acquisition_val…
##    <dbl> <chr> <chr>                 <chr> <chr>        <dbl> <chr>            <dbl>
##  1     1 AL    ABBEVILLE POLICE DEPT 1005… MOUNT,RI…       10 Each             1626 
##  2     1 AL    ABBEVILLE POLICE DEPT 1240… SIGHT,RE…        9 Each              333 
##  3     1 AL    ABBEVILLE POLICE DEPT 1240… OPTICAL …        1 Each              246.
##  4     1 AL    ABBEVILLE POLICE DEPT 1385… UNMANNED…        1 Each            10000 
##  5     1 AL    ABBEVILLE POLICE DEPT 2320… TRUCK,UT…        1 Each            62627 
##  6     1 AL    ABBEVILLE POLICE DEPT 2320… TRUCK,UT…        1 Each            62627 
##  7     1 AL    ABBEVILLE POLICE DEPT 2355… MINE RES…        1 Each           658000 
##  8     1 AL    ABBEVILLE POLICE DEPT 2540… BALLISTI…       10 Kit             15872.
##  9     1 AL    ABBEVILLE POLICE DEPT 5855… ILLUMINA…       10 Each              926 
## 10     1 AL    ABBEVILLE POLICE DEPT 6760… CAMERA R…        1 Each             1500 
## # … with 129,338 more rows, and 4 more variables: demil_code <chr>,
## #   demil_ic <dbl>, ship_date <dttm>, station_type <chr>
```

</details>

### Glimpse the data

1. In a new block, print the tibble but pipe it into `glimpse()` so you can see all the column names.


```r
leso %>% glimpse()
```

```
## Rows: 129,348
## Columns: 12
## $ sheet             <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"…
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A…
## $ nsn               <chr> "1005-01-587-7175", "1240-01-411-1265", "1240-DS-OPT…
## $ item_name         <chr> "MOUNT,RIFLE", "SIGHT,REFLEX", "OPTICAL SIGHTING AND…
## $ quantity          <dbl> 10, 9, 1, 1, 1, 1, 1, 10, 10, 1, 5, 10, 11, 10, 1, 3…
## $ ui                <chr> "Each", "Each", "Each", "Each", "Each", "Each", "Eac…
## $ acquisition_value <dbl> 1626.00, 333.00, 245.88, 10000.00, 62627.00, 62627.0…
## $ demil_code        <chr> "D", "D", "D", "Q", "C", "C", "C", "D", "D", "D", "D…
## $ demil_ic          <dbl> 1, 1, NA, 3, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 1, NA, 1,…
## $ ship_date         <dttm> 2016-09-19, 2016-09-14, 2016-06-02, 2017-03-28, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
```

#### Checking datatypes

Take a look at your glimpse returns. These are the things to watch for:

- Are your variable names (column names) clean? All lowercase with `_` separating words?
- Are dates saved in a date format? `ship_date` looks good at `<dttm>`, which means "datetime".
- Are your numbers really numbers? `acquisition_value` is the column we are most concerned about here, and it looks good.

This data set looks good (because I pre-prepared it fo you), but you always want to check and make corrections, like we did to fix the date in the Billboard assignment.

### Remove unnecessary columns

Sometimes at this point in a project, you might not know what columns you need to keep and which you could do without. The nice thing about doing this with code in a notebook is we can always go back, make corrections and run our notebook again. In this case, I'm going to tell you which columns you can remove so we have a tighter data set to work with. We'll also learn a cool trick with `select()`.

1. Start a new section with a headline, text to explain you are removing unneeded columns.
2. Add a code chunk and the following code. I'll explain it below.


```r
leso_tight <- leso %>% 
  select(
    -sheet,
    -nsn,
    -starts_with("demil")
  )

leso_tight %>% glimpse()
```

```
## Rows: 129,348
## Columns: 8
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"…
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A…
## $ item_name         <chr> "MOUNT,RIFLE", "SIGHT,REFLEX", "OPTICAL SIGHTING AND…
## $ quantity          <dbl> 10, 9, 1, 1, 1, 1, 1, 10, 10, 1, 5, 10, 11, 10, 1, 3…
## $ ui                <chr> "Each", "Each", "Each", "Each", "Each", "Each", "Eac…
## $ acquisition_value <dbl> 1626.00, 333.00, 245.88, 10000.00, 62627.00, 62627.0…
## $ ship_date         <dttm> 2016-09-19, 2016-09-14, 2016-06-02, 2017-03-28, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
```

We did a select like this with billboard, but note the third item within the `select()`:

`-starts_with("demil")`.

This removes both the `demil_code` and `demil_ic` columns in one move by finding all the columns that "start with 'demil'". The `-` before it negates (or removes) the columns.

There are other special operators you can use with select(), like: `ends_with()`, `contains()` and many more. [Check out the docs on the select function](https://dplyr.tidyverse.org/reference/select.html).

So now we have a tibble called `leso_tight` that we will work with in the next section.

### Create a total_value column

When we used `mutate()` to convert the date in the Billboard assignment, we were reassigning values in each row of a column back into the same column.

In this assignment, we will use `mutate()` to create a **new** column with new values based on a calculation (`quantity` multiplied by the `acquisition_value`) for each row. Let's review the concept first.

If you started with data like this:

| item  | item_count | item_value |
|-------|-----------:|-----------:|
| Bread |          2 |        1.5 |
| Milk  |          1 |       2.75 |
| Beer  |          3 |          9 |

And wanted to create a total value of each item in the table, you would use `mutate()`:

```r
data %>% 
  mutate(total_value = item_count * item_value)
```

And you would get a return like this, with your new `total_value` column added at the end:

| item  | item_count | item_value | total_value |
|-------|-----------:|-----------:|------------:|
| Bread |          2 |        1.5 |           3 |
| Milk  |          1 |       2.75 |        2.75 |
| Beer  |          3 |          9 |          27 |

Other math operators work as well: `+`, `-`,  `*` and `/`.

So, now that we've talked about how it is done, I want you to:

1. Create a new section with headline, text and code chunk.
1. Use `mutate()` to create a new `total_value` column that multiplies `quantity` times `acquisition_value`.
2. Assign those results into a new tibble called `leso_total` so we can all be on the same page.
3. Glimpse the new tibble so you can check the results.

<details>
  <summary>Try it on your own. You can figure it out!</summary>


```r
leso_total <- leso_tight %>% 
  mutate(
    total_value = quantity * acquisition_value
  )

leso_total %>% glimpse()
```

```
## Rows: 129,348
## Columns: 9
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"…
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A…
## $ item_name         <chr> "MOUNT,RIFLE", "SIGHT,REFLEX", "OPTICAL SIGHTING AND…
## $ quantity          <dbl> 10, 9, 1, 1, 1, 1, 1, 10, 10, 1, 5, 10, 11, 10, 1, 3…
## $ ui                <chr> "Each", "Each", "Each", "Each", "Each", "Each", "Eac…
## $ acquisition_value <dbl> 1626.00, 333.00, 245.88, 10000.00, 62627.00, 62627.0…
## $ ship_date         <dttm> 2016-09-19, 2016-09-14, 2016-06-02, 2017-03-28, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
## $ total_value       <dbl> 16260.00, 2997.00, 245.88, 10000.00, 62627.00, 62627…
```

</details>
<br>

**Check that it worked!!**. Use the glimpsed data to check the first item: For me, 10 * 1626.00 = 16260.00, which is correct!

Note that new columns are added at the end of the tibble. That is why I suggested you glimpse the data instead of printing the tibble so you can easily see results on one screen.

### Filtering our data

You used `filter()` in the Billboard lesson to get No. 1 songs and to get a date range of data. We need to do something similar here to get only Texas data of a certain date range, but we'll build the filters one at a time so we can check the results.

#### Apply the TX filter

1. Create a new section with headlines and text that denote you are filtering the data to Texas and since Jan. 1, 2010
2. Create the code chunk and start your filter process using the `leso_total` tibble.
3. Use `filter()` on the `state` column to keep all rows with "TX".

<details>
  <summary>Really, you got this.</summary>


```r
leso_total %>% 
  filter(
    state == "TX"
  )
```

```
## # A tibble: 8,684 × 9
##    state agency_name           item_name                    quantity ui    acquisition_val…
##    <chr> <chr>                 <chr>                           <dbl> <chr>            <dbl>
##  1 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  2 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  3 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  4 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  5 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  6 TX    ABERNATHY POLICE DEPT RIFLE,5.56 MILLIMETER               1 Each             749  
##  7 TX    ABERNATHY POLICE DEPT RIFLE,5.56 MILLIMETER               1 Each             749  
##  8 TX    ABERNATHY POLICE DEPT SIGHT,REFLEX                        5 Each             333  
##  9 TX    ABERNATHY POLICE DEPT TRUCK,UTILITY                       1 Each           62627  
## 10 TX    ABILENE POLICE DEPT   RIFLE,5.56 MILLIMETER               1 Each             499  
## # … with 8,674 more rows, and 3 more variables: ship_date <dttm>,
## #   station_type <chr>, total_value <dbl>
```

</details>

How do you know if it worked? Well the first column in the data is the `state` column, so they should all start with "TX". Also note you started with nearly 130k observations (rows), and there are only 8,600+ in Texas.

#### Add the date filter

1. Now, **EDIT THAT SAME CHUNK** to add a new part to your filter to also get rows with a `ship_date` of 2010-01-01 or later.

<details>
  <summary>If you do this on your own, treat yourself to a cookie</summary>


```r
leso_total %>% 
  filter(
    state == "TX",
    ship_date >= "2010-01-01"
  )
```

```
## # A tibble: 7,407 × 9
##    state agency_name           item_name                    quantity ui    acquisition_val…
##    <chr> <chr>                 <chr>                           <dbl> <chr>            <dbl>
##  1 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  2 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  3 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  4 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  5 TX    ABERNATHY POLICE DEPT PISTOL,CALIBER .45,AUTOMATIC        1 Each              58.7
##  6 TX    ABERNATHY POLICE DEPT RIFLE,5.56 MILLIMETER               1 Each             749  
##  7 TX    ABERNATHY POLICE DEPT RIFLE,5.56 MILLIMETER               1 Each             749  
##  8 TX    ABERNATHY POLICE DEPT SIGHT,REFLEX                        5 Each             333  
##  9 TX    ABERNATHY POLICE DEPT TRUCK,UTILITY                       1 Each           62627  
## 10 TX    ALLEN POLICE DEPT     SIGHT,REFLEX                        1 Each             333  
## # … with 7,397 more rows, and 3 more variables: ship_date <dttm>,
## #   station_type <chr>, total_value <dbl>
```

</details>

#### Checking the results with summary()

How do you know this date filter worked? Well, we went from 8600+ rows to 7400+ rows, so we did something. You might look at the results table and click over to the `ship_date` columns so you can see some of the results, but you can't be sure the top row is the oldest. We could use an `arrange()` to test that, but I have another suggestion: `summary()`.

Now, `summary()` is different than `summarize()`, which we'll do plenty of in a mintue. The `summary()` function will show you some results about each column in your data, and when it is a number or date, it will give you some basic stats like min, max and median values.

1. Use the image below to add a `summary()` function to your filtering data chunk.
2. Once you've confirmed that the "Min." of `ship_date` is not older than 2010, then **REMOVE THE SUMMARY STATEMENT**.

If you leave the summary statement there when we create our updated tibble, then you'll "save" the summary and not the data.


![Summary function](images/military-date-summary.png)

#### Add filtered data to new tibble

Once you've checked and removed the summary, you can save your filtered data into a new tibble.

1. Edit the filtering chunk to put the results into a new tibble called `leso_filtered`.

<details>
  <summary>Seriously? You were going to look?</summary>


```r
leso_filtered <- leso_total %>% 
  filter(
    state == "TX",
    ship_date >= "2010-01-01"
  )

leso_filtered %>% glimpse()
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

</details>

### Export cleaned data

Now that we have our data selected, mutated and filtered how we want it, we can export your `leso_filtered` tibble into an `.rds` file to use in our analysis notebook. If you recall, we use the `.rds` format because it will remember data types and such.

1. Create a new section with headline and text explaining that you are exporting the data.
1. Do it. The function you need is called `write_rds` and you need to give it a path/name that saves the file in the `data-processed` folder. Name it `01-leso-tx.rds` so you know it a) came from the first notebook b) is the Texas only data. **Well-formatted, descriptive file names are important to your future self and other colleagues**.

<details>
  <summary>Try it</summary>


```r
leso_filtered %>% write_rds("data-processed/01-leso-tx.rds")
```

</details>

## Things we learned in this lesson

This chapter was similar to when we imported data for Billboard, but we did introduce a couple of new concepts:

- `starts_with()` can be used within a `select()` function to select columns with similar names. There are also `ends_with()` and `contains()` and others. [See the documentation on Select](https://dplyr.tidyverse.org/reference/select.html).
- `summary()` gives you descriptive statistics about your tibble. We used it to check the "min" date, but you can also see averages (mean), max and medians.
