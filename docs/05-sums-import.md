# Summarize with math - import {#sums-import}

> v1 draft

This chapter is by Prof. McDonald, who uses macOS.

**Note: The data you end up using might be updated, so your numbers may be slightly different.**

With our Billboard assignment, we went through some common data wrangling processes — importing data, cleaning it and querying it for answers. All of our answers involved using `group_by`, `summmarize` and `arrange` (which I dub GSA) and we summarized with `n()` to count the number of rows in our group.

For this data story we need the summary trio GSA again but we want to do different kinds of math within our summarize functions, mainly `sum()`.

## About the story: Military surplus transfers

After the 2014 death of Michael Brown and the unrest that followed, there was widespread criticism of Ferguson, Mo. police officers for their use of military-grade weapons and vehicles. There was also heightened scrutiny to a federal program that transfers unused military equipment to local law enforcement. Many news outlets, [including NPR](https://www.npr.org/2014/09/02/342494225/mraps-and-bayonets-what-we-know-about-the-pentagons-1033-program) and [Buzzfeed News](https://www.buzzfeednews.com/article/jimdalrympleii/war-zone-in-ferguson-how-billions-in-military-weapons-ended), did stories based on data from the "1033 program" handled through the [Law Enforcement Support Office](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/). Buzzfeed News also did a [followup report](https://www.buzzfeednews.com/article/johntemplon/police-departments-military-gear-1033-program) in 2020 where reporter John Templon published his [data analysis](https://github.com/BuzzFeedNews/2020-06-leso-1033-transfers-since-ferguson), which he did using Python.

You will analyze the same dataset to see how local police agencies have used the program and write a short data drop about transfers to those agencies.

### The 1033 program

To work through this story we need to understand how this transfer program works. You can [read all about it here](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/ProgramFAQs/), but here is the gist:

In 1997, Congress approved the "1033 program" that allows the U.S. military to give "surplus" equipment that they no longer need to law enforcement agencies like city police forces. The program is run by the [Law Enforcement Support Office](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/), which is part of the Defense Logistics Agency (which handles the global defense supply chain for all the branches of the military) within the Department of Defense. (The **program** is run by the **office** inside the **agency** that is part of the **department**.)

All kinds of equipment moves between the military and these agencies, from boots and water bottles to assault rifles and cargo planes. The local agency only pays for shipping the equipment, but that isn't listed in the data. What is in the data is the "value" of the equipment in dollars, but we can't say the agency paid for it, because they didn't.

Property falls into two categories: controlled and non-controlled. **Controlled** property always remains on the LESO "property book" because it still belongs and is accountable to the Department of Defense. A record of the transfer stays in the data.

But most of the transfers are for **non-controlled** property that can be sold even to the general public, like boots and blankets. Those items are removed from the data after one year, unless it is deemed a special circumstance.

The agency releases data quarterly, but it is really a “snapshot in time” and not a complete history. Those non-controlled items transferred more than a year prior are missing.


### About the data

![The raw data](images/leso-raw.png)

The data comes in a spreadsheet that has a different tab for each state and territory. The data we'll use here was from **March 31, 2022** and I've done some initial work on the original data that is beyond the scope of this class, so we'll use my copy of the data. **I will supply a link to the combined data below.**

There is no data dictionary or record layout included with the data but I have corresponded with the Defense Logistics Agency to get a decent understanding of what is included.

- **sheet**: Which sheet the data came from. This is an artifact from the data merging script.
- **state**: A two-letter designation for the state of the agency.
- **agency_name**: This is the agency that got the equipment.
- **nsn**: A special number that identifies the item in a government database.
- **item_name**: The item transferred. Googling the names can sometimes yield more info on specific items.
- **quantity**: The number of the "units" the agency received.
- **ui**: Unit of measurement (item, kit, etc.)
- **acquisition_value**: a cost *per unit* for the item.
- **demil_code**: Categories (as single letter key values) that indicate how the item should be disposed of. [Full details here](https://www.dla.mil/Working-With-DLA/Federal-and-International-Cataloging/DEMIL-Coding/DEMILCodes/)
- **demil_ic**: Also part of the disposal categorization.
- **ship_date**: The date the item(s) were sent to the agency.
- **station_type**: What kind of law enforcement agency made the request.



Here is a glimpse of a sample of the data:


```
## Rows: 10
## Columns: 12
## $ sheet             <dbl> 17, 42, 5, 45, 36, 33, 5, 22, 3, 22
## $ state             <chr> "KY", "SC", "CA", "TX", "OH", "NC", "CA", "MI", "AZ"…
## $ agency_name       <chr> "MEADE COUNTY SHERIFF DEPT", "PROSPERITY POLICE DEPT…
## $ nsn               <chr> "6115-01-435-1567", "1005-00-589-1271", "7520-01-519…
## $ item_name         <chr> "GENERATOR SET,DIESEL ENGINE", "RIFLE,7.62 MILLIMETE…
## $ quantity          <dbl> 5, 1, 32, 1, 1, 1, 1, 1, 1, 1
## $ ui                <chr> "Each", "Each", "Dozen", "Each", "Each", "Each", "Ea…
## $ acquisition_value <dbl> 4623.09, 138.00, 16.91, 749.00, 749.00, 138.00, 499.…
## $ demil_code        <chr> "A", "D", "A", "D", "D", "D", "D", "D", "D", "D"
## $ demil_ic          <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
## $ ship_date         <dttm> 2021-03-22, 2007-08-07, 2020-10-29, 2014-11-18, 2014…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
```

And a look at just some of the more important columns:


```r
leso_sample |> 
  select(agency_name, item_name, quantity, acquisition_value)
```

```
## # A tibble: 10 × 4
##    agency_name                      item_name          quantity acquisition_val…
##    <chr>                            <chr>                 <dbl>            <dbl>
##  1 MEADE COUNTY SHERIFF DEPT        GENERATOR SET,DIE…        5           4623. 
##  2 PROSPERITY POLICE DEPT           RIFLE,7.62 MILLIM…        1            138  
##  3 KERN COUNTY SHERIFF OFFICE       MARKER,TUBE TYPE         32             16.9
##  4 LEAGUE CITY POLICE DEPT          RIFLE,5.56 MILLIM…        1            749  
##  5 TRUMBULL COUNTY SHERIFF'S OFFICE RIFLE,5.56 MILLIM…        1            749  
##  6 VALDESE POLICE DEPT              RIFLE,7.62 MILLIM…        1            138  
##  7 SACRAMENTO POLICE DEPT           RIFLE,5.56 MILLIM…        1            499  
##  8 BERRIEN COUNTY SHERIFF'S OFFICE  RIFLE,5.56 MILLIM…        1            499  
##  9 LA PAZ COUNTY SHERIFF OFFICE     RIFLE,5.56 MILLIM…        1            499  
## 10 MUSKEGON HEIGHTS POLICE DEPT     RIFLE,5.56 MILLIM…        1            749
```

Each row of data is a transfer of a particular type of item from the U.S. Department of Defense to a local law enforcement agency. The row includes the name of the item, the quantity, and the value ($) of a single unit.

What the data doesn't have is the **total value** of the items in the shipment. If there are 5 generators as noted in the first row above and the cost of each one is $4623.09, we have to multiply the `quantity` times the `acquisition_value` to get the total value of that equipment.

The data also doesn't have any variable indicating if an item is controlled or non-controlled, but I've corresponded with the Defense Logistics Agency to gain a pretty good understanding of how to isolate them based on the **demil**itarization codes.

These are things I learned about by talking to the agency and reading through documentation. This kind of reporting and understanding ABOUT your data is vital to avoid mistakes.

## The questions we will answer

First, we'll consider only **Texas** data from **Jan. 1, 2010** to present. You answer the following:

- *How many total things did each agency get and how much was it all worth?* Like which agency got the most stuff?
- *What specific things did each agency get and how much were they worth?* Now we're looking at the kinds of items.
- *What kinds of items did local agencies get?* I'll provide a list of agencies.
- *How has the volume of controlled transfers changed over time?* Here we'll look at just the weapons kinds of things and see if the program is being used more/less by agencies.

We'll look more closely at those results for some local agencies. You'll research some of the more interesting items the agencies received (i.e. Google the names) so you can write about them in a data drop.

## Getting started: Create your project

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

### The goals of the notebook

As noted before, I separate cleaning into a separate notebook so that each subsequent analysis notebook can take advantage of that work. It's the DRY principal in programming: Don't Repeat Yourself. Often I will be in an analysis notebook realizing that it would be helpful to add a cleaning step to my import notebook, and I will. 
Because I've worked with and researched this data, I'm aware of cleaning steps that a newcomer exploring the might not be aware of at this point. But here we will take advantage of my experience and so all this work up front even though you haven't seen the "need" for them yet.

That's a long-winded opening to say let's add our notebook goals so you know what's going on here.

1. In Markdown, add a headline noting these are notebook goals.
1. Add the goals below:

```text
- Download the data
- Import the data
- Check datatypes
- Create a total_value variable
- Create a control_type variable
- Filter to Texas agencies
- Filter the date range (since Jan. 1 2010)
- Export the cleaned data
```

### Add a setup section

This is the section in the notebook where we add our libraries and such. Again, every notebook has this section, though the packages may vary on need.

1. Add a headline and text about what we are doing: Our project setup.
2. Add a code chunk to load the libraries. You should only need `tidyverse` for this notebook because the data already has clean names (no need for janitor) and the dates will import correctly (no need for lubridate for this notebook, but will will use it for our analysis).


```r
library(tidyverse)
```


### Download the data

1. A new section means a new headline and description. Add it. It is good practice to describe and link to the data you will be using. You can use this:

```text
While the data we will use here if from Prof. McDonald, it is from the [Law Enforcement Support Office](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/). Find more information [about the program here](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/ProgramFAQs/).
```

1. Use the `download.file()` function to download the date into your `data-raw` folder. Remember you need two arguments:

```r
download.file("url_to_data", "path_to_folder/filename.csv")
```

Windows users might need to add an additional argument: `mode = "wb"`.

- The data can be found at this url: `https://raw.githubusercontent.com/utdata/rwdir/main/data-raw/leso.csv`
- It should be saved into your `data-raw` folder with a name for the file.

Once you've built your code chunk and run it, you should make sure the file downloaded into the correct place: in your `data-raw` folder.

<details>
  <summary>Try this on your own first</summary>
  

```r
# You can comment the line below once you have the data
download.file("https://raw.githubusercontent.com/utdata/rwdir/main/data-raw/leso.csv",
              "data-raw/leso.csv", mode = "wb")
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
## Rows: 124848 Columns: 12
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr  (7): state, agency_name, nsn, item_name, ui, demil_code, station_type
## dbl  (4): sheet, quantity, acquisition_value, demil_ic
## dttm (1): ship_date
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
# printing the tibble
leso
```

```
## # A tibble: 124,848 × 12
##    sheet state agency_name       nsn   item_name quantity ui    acquisition_val…
##    <dbl> <chr> <chr>             <chr> <chr>        <dbl> <chr>            <dbl>
##  1     1 AL    ABBEVILLE POLICE… 2540… BALLISTI…       10 Kit             15872.
##  2     1 AL    ABBEVILLE POLICE… 1240… OPTICAL …        1 Each              246.
##  3     1 AL    ABBEVILLE POLICE… 1005… MOUNT,RI…       10 Each             1626 
##  4     1 AL    ABBEVILLE POLICE… 1240… SIGHT,RE…        9 Each              333 
##  5     1 AL    ABBEVILLE POLICE… 5855… ILLUMINA…       10 Each              926 
##  6     1 AL    ABBEVILLE POLICE… 2355… MINE RES…        1 Each           658000 
##  7     1 AL    ABBEVILLE POLICE… 2320… TRUCK,UT…        1 Each            62627 
##  8     1 AL    ABBEVILLE POLICE… 1385… UNMANNED…        1 Each            10000 
##  9     1 AL    ABBEVILLE POLICE… 6760… CAMERA R…        1 Each             1500 
## 10     1 AL    ABBEVILLE POLICE… 2320… TRUCK,UT…        1 Each            62627 
## # … with 124,838 more rows, and 4 more variables: demil_code <chr>,
## #   demil_ic <dbl>, ship_date <dttm>, station_type <chr>
```

</details>

### Glimpse the data

1. In a new block, print the tibble but pipe it into `glimpse()` so you can see all the column names.


```r
leso |>  glimpse()
```

```
## Rows: 124,848
## Columns: 12
## $ sheet             <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"…
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A…
## $ nsn               <chr> "2540-01-565-4700", "1240-DS-OPT-SIGH", "1005-01-587…
## $ item_name         <chr> "BALLISTIC BLANKET KIT", "OPTICAL SIGHTING AND RANGI…
## $ quantity          <dbl> 10, 1, 10, 9, 10, 1, 1, 1, 1, 1, 1, 1, 3, 12, 1, 5, …
## $ ui                <chr> "Kit", "Each", "Each", "Each", "Each", "Each", "Each…
## $ acquisition_value <dbl> 15871.59, 245.88, 1626.00, 333.00, 926.00, 658000.00…
## $ demil_code        <chr> "D", "D", "D", "D", "D", "C", "C", "Q", "D", "C", "C…
## $ demil_ic          <dbl> 1, NA, 1, 1, 1, 1, 1, 3, 7, 1, 1, NA, 1, 1, 1, 1, 1,…
## $ ship_date         <dttm> 2018-01-30, 2016-06-02, 2016-09-19, 2016-09-14, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
```

#### Checking datatypes

Take a look at your glimpse returns. These are the things to watch for:

- Are your variable names (column names) clean? All lowercase with `_` separating words?
- Are dates saved in a date format? `ship_date` looks good at `<dttm>`, which means "datetime".
- Are your numbers really numbers? `acquisition_value` is the column we are most concerned about here, and it looks good.

This data set looks good (because I pre-prepared it fo you), but you always want to check and make corrections, like we did to fix the date in the Billboard assignment.

### Remove unnecessary columns

Sometimes at this point in a project, you might not know what columns you need to keep and which you could do without. The nice thing about doing this with code in a notebook is we can always go back, make corrections and run our notebook again. In this case, we will remove the `-sheet` column since we don't need it. (It's an artifact of the processing I've done on the file.)

1. Start a new section with a headline, text to explain you are removing unneeded columns.
2. Add a code chunk and the following code. I'll explain it below.


```r
leso_tight <- leso |> 
  select(-sheet)

leso_tight |> glimpse()
```

```
## Rows: 124,848
## Columns: 11
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"…
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A…
## $ nsn               <chr> "2540-01-565-4700", "1240-DS-OPT-SIGH", "1005-01-587…
## $ item_name         <chr> "BALLISTIC BLANKET KIT", "OPTICAL SIGHTING AND RANGI…
## $ quantity          <dbl> 10, 1, 10, 9, 10, 1, 1, 1, 1, 1, 1, 1, 3, 12, 1, 5, …
## $ ui                <chr> "Kit", "Each", "Each", "Each", "Each", "Each", "Each…
## $ acquisition_value <dbl> 15871.59, 245.88, 1626.00, 333.00, 926.00, 658000.00…
## $ demil_code        <chr> "D", "D", "D", "D", "D", "C", "C", "Q", "D", "C", "C…
## $ demil_ic          <dbl> 1, NA, 1, 1, 1, 1, 1, 3, 7, 1, 1, NA, 1, 1, 1, 1, 1,…
## $ ship_date         <dttm> 2018-01-30, 2016-06-02, 2016-09-19, 2016-09-14, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
```

In English, we are creating a new tibble `leso_tight` and then filling it with this: `leso` and then use select to remove the colunn called `sheet`. We then glimpse the new data.

So now we have a tibble called `leso_tight` that we will work with in the next section.

### Create a total_value column

During my reporting about this data I learned that the `acquisition_value` noted in the data is for a single "unit" of each item. If the shipment item was a rifle with a `quantity` of "5" and `acquisition_value` of "200", then each rifle is worth \$200, but the total shipment would be 5 times \$200, or \$1,000. That \$1000 total value is not listed in the data, so we need to add it.

Let's walk through how to do that with a different example.

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
data |> 
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
leso_total <- leso_tight |> 
  mutate(
    total_value = quantity * acquisition_value
  )

leso_total |> glimpse()
```

```
## Rows: 124,848
## Columns: 12
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"…
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A…
## $ nsn               <chr> "2540-01-565-4700", "1240-DS-OPT-SIGH", "1005-01-587…
## $ item_name         <chr> "BALLISTIC BLANKET KIT", "OPTICAL SIGHTING AND RANGI…
## $ quantity          <dbl> 10, 1, 10, 9, 10, 1, 1, 1, 1, 1, 1, 1, 3, 12, 1, 5, …
## $ ui                <chr> "Kit", "Each", "Each", "Each", "Each", "Each", "Each…
## $ acquisition_value <dbl> 15871.59, 245.88, 1626.00, 333.00, 926.00, 658000.00…
## $ demil_code        <chr> "D", "D", "D", "D", "D", "C", "C", "Q", "D", "C", "C…
## $ demil_ic          <dbl> 1, NA, 1, 1, 1, 1, 1, 3, 7, 1, 1, NA, 1, 1, 1, 1, 1,…
## $ ship_date         <dttm> 2018-01-30, 2016-06-02, 2016-09-19, 2016-09-14, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
## $ total_value       <dbl> 158715.90, 245.88, 16260.00, 2997.00, 9260.00, 65800…
```

</details>
<br>

**Check that it worked!!**. Use the glimpsed data to check the first item: For me, 10 * 15871.59 = 158715.90, which is correct!

Note that new columns are added at the end of the tibble. That is why I suggested you glimpse the data instead of printing the tibble so you can easily see results on one screen.

### Controlled vs. non-controlled

Again, by reading through the [documentation](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/) about this data I learned about controlled vs non-controlled property. Basically non-controlled generic stuff like boots and blankets are removed from the data after one year, but controlled items like guns and airplanes remain on the list until they are returned to the military for disposal. It is the mainly the controlled items we are concerned with.

There isn't anything the data that says it is "controlled" and really no clear indication in the documentation on how to tell what is what. So, I emailed the agency and asked them. Here was their answer, edited:

> Property with the DEMIL codes A and Q6 are considered non-controlled general property and fall off the LESO property books after one year. All other Demil codes are considered controlled items and stay on the LESO property book until returned to DLA for disposition/disposal. However, there are some exceptions. For instance, aircraft are always controlled regardless of the demil code. Also, LESO has the discretion to keep items as controlled despite the demil code. This happens with some high value items. There isn’t a standard minimum value. It also may also depend on the type of property.

This actually took some back and forth to figure out, as I had noticed there were AIRPLANE, CARGO-TRANSPORT items in the data that were older than a year, along with some surveillance robots. That's when they replied about the airplanes, but it turns out the robots were simply an error. DATA IS DIRTY when humans get involved; somebody coded it wrong.

These "DEMIL codes" they referenced are the `demil_code` and `demil_ic` columns in the data, so we can use those to mark which records are "non-controlled" (A and Q6) and then mark all the rest as "controlled". We know of one exception -- airplanes -- which we need to mark controlled. We can't do much with the "high value" items since there isn't logic available to find them. We'll just have to note that in our story, something like "the agency sometimes designates high value items like airplanes as controlled, but they are not categorized as such and may have been dropped from our analysis."

But, we can catch most of them ... we just need to work through the logic. This is not an uncommon challenge in data science, so we have some tools to do this. Our workhorse is the `case_when()` function, where we can make decisions based on values in our data.

I usually approach this by thinking of the logic first, then writing some code, then testing it. Sometimes my logic is faulty and I have to try again, which is why we test the results. Know this could go on for many cycles. In the interest of time and getting this done, I will just show the finished code and explain how it works.

Here the basic idea:

- We want to create a new column to denote if the item is controlled.
- In that column we want it to be TRUE when an item is controlled, and FALSE when it is not.
- We know that items that with "AIRPLANE" are always controlled, no matter their demil designations.
- Otherwise we know that items that have a `demil_code` of "A", OR a `demil_code` of "Q" AND a `demil_id` of "6", are non-controlled.
- Everything else is controlled.

I've noted this logic in a specific order for a reason: It's the order that we write the logic in the code based on how the function `case_when()` works.

### Categorization logic with case_when()

We will use the `mutate()` function to create a new column called `control_type`. We've done that before, so no problem.

But this time we will fill in values in the new column based on other data inside each row. `case_when()` allows us to create a test (or number of tests) and then mark the new value based on the answer. Once new data has been written the function goes to the next row, so we write the most specific rules first.

This process is powerful and can get complicated depending on the logic needed. This example is perhaps more complicated than I like to explain this process, but this is real data we _need_ this, so here we go.

This is the code that does what we need and you can copy/paste the whole chunk, but be sure to read the explanation that follows it.


```r
leso_control <- leso_total |> 
  mutate(
    control_type = case_when(
      str_detect(item_name, "AIRPLANE") ~ T,
      (demil_code == "A" | (demil_code == "Q" & demil_ic == 6)) ~ F,
      TRUE ~ T
    )
  )

leso_control |> glimpse()
```

```
## Rows: 124,848
## Columns: 13
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"…
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A…
## $ nsn               <chr> "2540-01-565-4700", "1240-DS-OPT-SIGH", "1005-01-587…
## $ item_name         <chr> "BALLISTIC BLANKET KIT", "OPTICAL SIGHTING AND RANGI…
## $ quantity          <dbl> 10, 1, 10, 9, 10, 1, 1, 1, 1, 1, 1, 1, 3, 12, 1, 5, …
## $ ui                <chr> "Kit", "Each", "Each", "Each", "Each", "Each", "Each…
## $ acquisition_value <dbl> 15871.59, 245.88, 1626.00, 333.00, 926.00, 658000.00…
## $ demil_code        <chr> "D", "D", "D", "D", "D", "C", "C", "Q", "D", "C", "C…
## $ demil_ic          <dbl> 1, NA, 1, 1, 1, 1, 1, 3, 7, 1, 1, NA, 1, 1, 1, 1, 1,…
## $ ship_date         <dttm> 2018-01-30, 2016-06-02, 2016-09-19, 2016-09-14, 201…
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"…
## $ total_value       <dbl> 158715.90, 245.88, 16260.00, 2997.00, 9260.00, 65800…
## $ control_type      <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE…
```

OK, let's go through the code line-by-line.

- Our first line creates a new tibble and fills it with the result of the rest of our expression. We start with the `leso_total` tibble.
- We mutate the data and start with the name of new column: `control_type`. We are filling that column with the result of the `case_when()` function for each row.
- Within the `case_when()` we are making the determination if the item is controlled or not. The left side of the `~` is the test, and the right side of `~` is what we enter into the column. But we have more than one test:
  - The first test is we use the [`str_detect()`](https://stringr.tidyverse.org/reference/str_detect.html) function to look inside the `item_name` field looking for the term "AIRPLANE". If the test finds the term, then the `control_type` field gets a value of `TRUE` and we move to the next row. If not, it moves to the next rule to see if that is a match. (We could fill this column with any text or number we want, but we are using `TRUE` and `FALSE` because that is the most basic kind of data to keep. If the item is controlled, set the value is TRUE. If not, it should be set to FALSE.)
  - Our second rule has two complex tests and we want to mark the row FALSE if either are true. (Remember, this is based on what the DLA told me: items with A or Q6 are non-controlled.) Our `case_when()` logic first looks for the value "A" in the `demil_code` field. If it is yes, then it marks the row FALSE. If no it goes to the next part: Is there a "Q" in the `demil_code` field AND a "6" in the `demil_ic` field? Both "Q" and "6" have to be there to get marked as FALSE. If both fail, then we move to the next test.
  - The last test is our catch-all. If none of the other rules apply, then mark this row as `TRUE`, which means it is controlled. So our default in the end is to mark everything TRUE if any of the other rules don't mark it first.
- Lastly the glimpse at the data just so we can see the column was created.
  
As I said, we skipped the process of figuring all that out line-by-line, but I'll show some tests here to who we did what we were intending.

This shows airplanes are marked as controlled with `TRUE`.


```r
# showing the results and some columns that determined them
leso_control |> 
  select(item_name, demil_code, demil_ic, control_type) |> 
  filter(str_detect(item_name, "AIRPLANE"))
```

```
## # A tibble: 14 × 4
##    item_name                demil_code demil_ic control_type
##    <chr>                    <chr>         <dbl> <lgl>       
##  1 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
##  2 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
##  3 FIRST AID KIT,AIRPLANE   A                 1 TRUE        
##  4 FIRST AID KIT,AIRPLANE   A                 1 TRUE        
##  5 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
##  6 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
##  7 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
##  8 FIRST AID KIT,AIRPLANE   A                 1 TRUE        
##  9 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
## 10 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
## 11 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
## 12 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
## 13 AIRPLANE,CARGO-TRANSPORT Q                 6 TRUE        
## 14 AIRPLANE,FLIGHT T42A     Q                 3 TRUE
```

This shows how many items are marked TRUE vs FALSE for each `demil_code` and `demil_ic` combination. Don't sweat over this code as we cover it in later chapters but here I was looking that most A records were FALSE, along with Q6.


```r
leso_control |> 
  count(demil_code, demil_ic, control_type, name = "cnt") |> 
  pivot_wider(names_from = control_type, values_from = cnt) |> 
  DT::datatable()
```

```{=html}
<div id="htmlwidget-490734c2a614a0989ec6" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-490734c2a614a0989ec6">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29"],["A","A","A","A","B","B","B","C","C","C","C","C","D","D","D","D","D","E","E","E","F","F","F","Q","Q","Q","Q","Q","Q"],[0,1,7,null,0,3,null,0,1,4,7,null,0,1,4,7,null,1,7,null,1,7,null,0,1,3,5,6,null],[4,8315,224,4594,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,169,null],[null,3,null,null,1,31,115,1,6162,2,232,558,18,88733,10,1081,2888,125,6,3,4938,1180,25,1,7,5383,1,10,28]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>demil_code<\/th>\n      <th>demil_ic<\/th>\n      <th>FALSE<\/th>\n      <th>TRUE<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,3,4]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

OK, onto the next task to get Texas data for specific dates.

### Filtering our data

You used `filter()` in the Billboard lesson to get No. 1 songs and to get a date range of data. We need to do something similar here to get only Texas data of a certain date range, but we'll build the filters one at a time so we can check the results.

#### Apply the TX filter

1. Create a new section with headlines and text that denote you are filtering the data to Texas and since Jan. 1, 2010
2. Create the code chunk and start your filter process using the `leso_control` tibble.
3. Use `filter()` on the `state` column to keep all rows with "TX".

<details>
  <summary>Try this on your own, but the code is here.</summary>


```r
leso_control |> 
  filter(
    state == "TX"
  )
```

```
## # A tibble: 8,663 × 13
##    state agency_name  nsn   item_name quantity ui    acquisition_val… demil_code
##    <chr> <chr>        <chr> <chr>        <dbl> <chr>            <dbl> <chr>     
##  1 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
##  2 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
##  3 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
##  4 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
##  5 TX    ABERNATHY P… 1005… RIFLE,5.…        1 Each             749   D         
##  6 TX    ABERNATHY P… 2320… TRUCK,UT…        1 Each           62627   C         
##  7 TX    ABERNATHY P… 1240… SIGHT,RE…        5 Each             333   D         
##  8 TX    ABERNATHY P… 1005… RIFLE,5.…        1 Each             749   D         
##  9 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
## 10 TX    ABILENE POL… 1005… RIFLE,5.…        1 Each             499   D         
## # … with 8,653 more rows, and 5 more variables: demil_ic <dbl>,
## #   ship_date <dttm>, station_type <chr>, total_value <dbl>, control_type <lgl>
```

</details>

How do you know if it worked? Well the first column in the data is the `state` column, so they should all start with "TX". Also note you started with nearly 130k observations (rows), and there are only 8,600+ in Texas.

#### Add the date filter

1. Now, **EDIT THAT SAME CHUNK** to add a new part to your filter to also get rows with a `ship_date` of 2010-01-01 or later.
2. Save the result into a new tibble called `leso_filtered`.
3. Print out the new tibble `leso_filtered`.

<details>
  <summary>If you do this on your own, treat yourself to a cookie</summary>


```r
leso_filtered <- leso_control |> 
  filter(
    state == "TX",
    ship_date >= "2010-01-01"
  )

leso_filtered
```

```
## # A tibble: 7,411 × 13
##    state agency_name  nsn   item_name quantity ui    acquisition_val… demil_code
##    <chr> <chr>        <chr> <chr>        <dbl> <chr>            <dbl> <chr>     
##  1 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
##  2 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
##  3 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
##  4 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
##  5 TX    ABERNATHY P… 1005… RIFLE,5.…        1 Each             749   D         
##  6 TX    ABERNATHY P… 2320… TRUCK,UT…        1 Each           62627   C         
##  7 TX    ABERNATHY P… 1240… SIGHT,RE…        5 Each             333   D         
##  8 TX    ABERNATHY P… 1005… RIFLE,5.…        1 Each             749   D         
##  9 TX    ABERNATHY P… 1005… PISTOL,C…        1 Each              58.7 D         
## 10 TX    ALLEN POLIC… 1240… SIGHT,RE…        1 Each             333   D         
## # … with 7,401 more rows, and 5 more variables: demil_ic <dbl>,
## #   ship_date <dttm>, station_type <chr>, total_value <dbl>, control_type <lgl>
```

</details>

#### Checking the results with summary()

How do you know this date filter worked? Well, we went from 8600+ rows to 7400+ rows, so we did something. You might look at the results table and click over to the `ship_date` columns so you can see some of the results, but you can't be sure the top row is the oldest. We could use an `arrange()` to test that, but I have another suggestion: `summary()`.

Now, `summary()` is different than `summarize()`, which we'll do plenty of in a minute. The `summary()` function will show you some results about each column in your data, and when it is a number or date, it will give you some basic stats like min, max and median values.

1. **Edit your chunk** to not just print out the tibble, but pipe that into `summary()`, like this:



```r
leso_filtered |> summary()
```

```
##     state           agency_name            nsn             item_name        
##  Length:7411        Length:7411        Length:7411        Length:7411       
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##                                                                             
##     quantity             ui            acquisition_value  demil_code       
##  Min.   :   1.000   Length:7411        Min.   :      0   Length:7411       
##  1st Qu.:   1.000   Class :character   1st Qu.:    131   Class :character  
##  Median :   1.000   Mode  :character   Median :    499   Mode  :character  
##  Mean   :   5.886                      Mean   :  18210                     
##  3rd Qu.:   1.000                      3rd Qu.:   2494                     
##  Max.   :1223.000                      Max.   :5390000                     
##                                                                            
##     demil_ic       ship_date                      station_type      
##  Min.   :1.000   Min.   :2010-01-05 00:00:00.00   Length:7411       
##  1st Qu.:1.000   1st Qu.:2012-03-14 00:00:00.00   Class :character  
##  Median :1.000   Median :2014-10-12 00:00:00.00   Mode  :character  
##  Mean   :1.417   Mean   :2015-09-10 12:54:09.72                     
##  3rd Qu.:1.000   3rd Qu.:2019-02-04 00:00:00.00                     
##  Max.   :7.000   Max.   :2021-12-29 00:00:00.00                     
##  NA's   :647                                                        
##   total_value      control_type   
##  Min.   :      0   Mode :logical  
##  1st Qu.:    333   FALSE:1336     
##  Median :    749   TRUE :6075     
##  Mean   :  20125                  
##  3rd Qu.:   4510                  
##  Max.   :5390000                  
## 
```

Now look at the "Min." value of `ship_date` and make sure it is not older than 2010.

### Export cleaned data

Now that we have our data selected, mutated and filtered how we want it, we can export your `leso_filtered` tibble into an `.rds` file to use in our analysis notebook. If you recall, we use the `.rds` format because it will remember data types and such.

1. Create a new section with headline and text explaining that you are exporting the data.
1. Do it. The function you need is called `write_rds` and you need to give it a path/name that saves the file in the `data-processed` folder. Name it `01-leso-tx.rds` so you know it a) came from the first notebook b) is the Texas only data. **Well-formatted, descriptive file names are important to your future self and other colleagues**.



```r
leso_filtered |> write_rds("data-processed/01-leso-tx.rds")
```


## Things we learned in this lesson

This chapter was similar to when we imported data for Billboard, but we did introduce a couple of new concepts:

- [`case_when()`](https://dplyr.tidyverse.org/reference/case_when.html) allows you to categorize a new column based on logic within your data.
- `summary()` gives you descriptive statistics about your tibble. We used it to check the "min" date, but you can also see averages (mean), max and medians.
