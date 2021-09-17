# Wrangle mastery {#wrangle-mastery}

Now that you've gone through the data wrangling process — importing data, cleaning it and querying it for answers — it's time to do this on your own with a new data set. You will also write a data drop about your answers.

## Military surplus transfers

In June 2020, Buzzfeed published the story [_Police Departments Have Received Hundreds Of Millions Of Dollars In Military Equipment Since Ferguson_](https://www.buzzfeednews.com/article/johntemplon/police-departments-military-gear-1033-program) about the amount of military equipment transferred to local law enforcement agencies since Michael Brown was killed in Ferguson, Missouri. After Brown's death there was a public outcry after "what appeared to be a massively disproportionate show of force during protests brought scrutiny to a federal program that transfers unused military equipment to local law enforcement." Reporter John Templon used data from the [Law Enforcement Support Office](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/) for the update on the program and published his [data analysis](https://github.com/BuzzFeedNews/2020-06-leso-1033-transfers-since-ferguson), which he did in Python.

You will analyze the same data focusing on some local police agencies and write a short data drop about transfers to those agencies.

## The LESO program

The Defense Logistics Agency transfers surplus military equipment to local law enforcement through its [Law Enforcement Support Office](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/). You can find more information [about the program here](https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/ProgramFAQs/).

The agency updates the data quarterly and the data I've collected contains transfers through **June 30, 2021**. The original file is linked from the headline "ALASKA - WYOMING AND US TERRITORIES".

The data there comes in an Excel spreadsheet that has a new sheet for each state. I used R to pull the data from each sheet and combine it into a single data set and I'll cover the process I used in class, but you won't have to do that part.

**I will supply a link to the combined data below.**

## About the data

There is no data dictionary or record layout included with the data but I have corresponded with the Defense Logistics Agency to get a decent understanding of what is included.

- sheet: Which sheet the data came from. This is an artifact from the data merging script.
- state: A two-letter designation for the state of the agency.
- agency_name: This is the agency that got the equipment.
- nsn: A special number that identifies the item. It is not germane to this specific assignment.
- item_name: The item transferred. Googling the names can sometimes yield more info on specific items.
- quantity: The number of the "units" the agency received.
- ui: Unit of measurement (item, kit, etc.)
- acquisition_value: a cost *per unit* for the item.
- demil_code: Another special code not germane to this assignment.
- demil_ic: Another special code not germane to this assignment.
- ship_date: The date the item(s) were sent to the agency.
- station_type: What kind of law enforcement agency made the request.

Each row of data is a transfer of a particular type of item from the U.S. Department of Defense to a local law enforcement agency. The row includes the type of item, the number of them, and the cost of each unit. This means to get the **total value** of the items in the shipment you have to multiply the `quantity` times the `acquisition_value`.

The agencies really only pay the shipping costs, _so you can't say they paid for the items_, so the **total value** you calculate is the "value" of the items, not their cost to the agency.

## Some helpful hints

> Note there are some "Technical hints" below that you will need to tackle the challenges noted below. Be sure to read those before proceeding.

## The questions to answer and write about

Read everything here before you start.

All answers should be based on data from **Jan. 1, 2010** to present. In addition, only consider **Texas** agencies as you answer the following.

- For each agency in Texas, find the **total_quantity** and **total_value** of the equipment they received.
  - Are there any that stand out? Why?
- Like above, find the **total_quantity** and **total_value** , but filter the summary to the following local agencies:
  - AUSTIN POLICE DEPT
  - SAN MARCOS POLICE DEPT
  - TRAVIS COUNTY SHERIFFS OFFICE
  - UNIV OF TEXAS SYSTEM POLICE HI_ED
  - WILLIAMSON COUNTY SHERIFF'S OFFICE
- What is the summed **total quantity** and summed **total value** of each **item** shipped to **each local agency** listed above. i.e., each agency should have its own table (own code chunk) that lists the unique items, their summed quantity and summed total value.
- Research some of the more interesting items in the items list (i.e. Google them).
  - You might check explore when they were shipped to the agency.

### Requirements of the assignment

You are following the same project structure employed with the Billboard project.

- Create a new project with the proper folder structure.
- Use separate RNotebooks for downloading/cleaning of the data and the analysis.
- Name your files logically and save files in proper folders.
- Each notebook should list the goals at the top.
- Each section within a notebook should have a headline and description for the task.
- Each notebook should run independently if you Restart R and Run All Chunks.

### Specifics for import/cleaning

These are not in a specific order, but make sure you take care of them at some point.

1. Use the `download.file()` function to download the file into your project. This is similar to what you did in the Billboard project to download the data. The url for the data is `https://github.com/utdata/rwd-r-leso/blob/main/data-processed/leso.csv?raw=true`. You will also need to supply the path and file name to save the data into, which is the second argument in that function. It should go into a `data-raw` folder, but you need to add a file name. (nont hot100, but something like `leso-data.csv`)
2. Once imported and saved into an R object, remove the columns we aren't using: `sheet`, `nsn`, `demil_code` and `demil_ic`. this is similar to how we removed columns in the Billboard assignment.
3. Make sure you focus only on Texas records. `filter()` is your friend here.
4. Make sure you use only records with the dates noted in the questions list. Again, `filter()`.
5. Make sure you create a new column (`mutate()`!) that gives the **total_value** of the equipment for each row. See the Technical note below "Create columns using math from other columns".
6. Export the cleaned data as an `.rds` file.

### Specifics for analysis

1. The analysis should use the cleaned data from the import notebook. You'll import this with `read_rds()`.
2. The summary tables you create require math beyond counting rows, so group_by/summarize are your friend (instead of `count()`). See the Technical note "Math within summarize".
3. You should end up with a table for each of the questions in the list. One of the questions requires multiple code chunks (one for each agency listed).

## How to tackle the summaries

When I am querying my data, I start by envisioning what the result should look like.

Let's take the first question: For each agency in Texas, find the **total_quantity** and **total_value** of the equipment they received.

Let's break this down:

- "For each agency in Texas". For all the questions, we only want Texas agencies. In the import notebook, you should filter for only the TX agencies. So, if done right, the TX agencies are already filtered. But the "For each agency" part tells me I need to **group_by** the `agency_name` so I can summarize totals within each agency.
- "find the **total_quantity** and **total_value**": Because I'm looking for a total (or `sum()` of columns) I need `summarize()`.

So I envision my result looking like this:

| agency_name        | item_count | equip_value |
|--------------------|-----------:|------------:|
| A POLICE DEPT      |       6419 |  10825707.5 |
| B SHERIFF'S OFFICE |        381 |  3776291.52 |
| C SHERIFF'S OFFICE |        270 |  3464741.36 |
| D POLICE DEPT      |       1082 |  3100420.57 |

With `group_by` I can organize all the rows by their `agency_name` so that my "summarize" can do the math within those groups.

```r
data %>% 
  group_by(agency_name)
```

Running that code by itself doesn't show me anything of worth. It is the summarize that adds the totals for `quantity` Here is what it looks like once I've added that, but see the Technincal help below "Math within summarize" for the details of how it works.

```r
data %>% 
  group_by(agency_name) %>% 
  summarize(
    sum_quantity = sum(quantity),
    sum_total_value = sum(total_value)
  )
```

In that `summarize()` I have two lines. Within each line I name the new column first and then make it equal the sum of the respective columns I'm adding.

## Technical help

There are some operations needed in this assignment that we touched on only tangentially in the Billboard assignment, so I want to provide some specifics here.

### Create columns using math from other columns

This relates to creating a `total_value` column in the import notebook to tell you the total value for the items the agency received.

When we used `mutate()` in the Billboard assignment, we were reassigning values in each row if a column back into the same column. This is when we converted the date.

In the "import" part of this assignment you'll need to use `mutate()` to create a new column with new values based on a calculation -- `quantity` multiplied by the `acquisition_value` -- for each row. So here is a quick discussion on that.

If you started with data like this:

| item  | item_count | item_value |
|-------|-----------:|-----------:|
| Bread |          2 |        1.5 |
| Milk  |          1 |       2.75 |
| Beer  |          3 |          9 |

And wanted to create a total value of each item, you would  use `mutate()`:

```r
data %>% 
  mutate(total_value = item_count * item_value)
```

And you would get a return like this:

| item  | item_count | item_value | total_value |
|-------|-----------:|-----------:|------------:|
| Bread |          2 |        1.5 |           3 |
| Milk  |          1 |       2.75 |        2.75 |
| Beer  |          3 |          9 |          27 |

Other math operators work as well: `+`, `-`,  `*` and `/`.

### Math within summarize

This relates to finding the *sum* of `quantity` and `total_value`.

While there was one example of summarizing number values in our Billboard assignment using `mean()`, you'll be doing more math summaries in this lesson, so ...

If you want to summarize to **add together all the values within a column** you use the `sum()` function:

If you started with the groceries table above and wanted to know the total number of all items and the total cost of all your groceries:

```r
data %>% 
  summarize(
    sum_items_count = sum(item_count),
    sum_total_value = sum(total_value)
  )
```

and you would end up with this:

| sum_item_count | sum_total_value |
|------------:|-----------:|
|           6 |      32.75 |

If you use a `group_by` before your summary, it will do the math _within_ each group.

### Filter from a collection

One last thing that might help in this assignment. This relates to the quest for finding the local agencies.

When you filter data, you usually choose the column and then compare for some value. To find the rows for "Bread" in our data above, we would use:

```r
groceries %>% 
  filter(item == "Bread")
```

You can also find look for rows that contain any values `%in%` a collection of terms. If we wanted to find all rows with "Bread" or "Beer", we could do this:

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

