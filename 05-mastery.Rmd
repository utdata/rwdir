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

There are some operations needed in this assignment that we touched on only tangentially in the Billboard assignment, so I want to provide some specifics here.

### Create columns using math from other columns

When we used `mutate()` in the Billboard assignment, we were reassigning values in each row if a column back into the same column. This is when we converted the date.

In this assignment you'll need to use `mutate()` to create a new column with new values based on a calculation -- `quantity` multiplied by the `acquisition_value` -- for each row. So here is a quick discussion on that.

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

While there was one example of summarizing number values in our Billboard assignment using `mean()`, you'll be doing more math summaries in this lesson, so ...

If you want to summarize to **add together all the values within a column** you use the `sum()` function:

If you started with the groceries table above and wanted to know the total number of all items and the total cost of all your groceries:

```r
data %>% 
  summarize(
    total_items = sum(item_count),
    total_cost = sum(total_value)
  )
```

and you would end up with this:

| total_items | total_cost |
|------------:|-----------:|
|           6 |      32.75 |

If you use a `group_by` before your summary, it will do the math _within_ each group.

### Filter from a collection

One last thing that might help in this assignmentment.

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

## The questions to answer and write about

All answers should be based on data from **Jan. 1, 2010** to present. In addition, only consider **Texas** agencies as you answer the following.

- Which agency in Texas has received the most equipment by **total value**?
  - Also include the summed total **quantity** in the summary.
  - Are there any that stand out? Why?
- Focus a similar summary to the following local agencies:
  - AUSTIN POLICE DEPT
  - SAN MARCOS POLICE DEPT
  - TRAVIS COUNTY SHERIFFS OFFICE
  - UNIV OF TEXAS SYSTEM POLICE HI_ED
  - WILLIAMSON COUNTY SHERIFF'S OFFICE
- What is the summed **total quantity** and summed **total value** of each **item** shipped to **each local agency** listed above. i.e., each agency should have its own table that lists unique items, their summed quantity and summed total value.
- Research some of the more interesting items in the items list. You might check when they were shipped to the agency.

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

1. Use the `download.file()` function to download the file into your project. The url for the data is `https://github.com/utdata/rwd-r-leso/blob/main/data-processed/leso.csv?raw=true`
2. Remove the columns we aren't using: `sheet`, `nsn`, `demil_code` and `demil_ic`.
3. Make sure you focus only on Texas records.
4. Make sure you use only records with the dates noted in the questions list.
5. Make sure you create a new column that gives the total value of the equipment for each row.

### Specifics for analysis

1. The analysis should use cleaned data from the import notebook.
2. The summary tables require math beyond counting rows, so group_by/summarize are your friend (instead of `count()`.
3. You should end up with a table for each of the questions in the list. One of them requires a multiple code chunks (one for each agency listed).

### Write a data drop

Once you've found answers to all the questions listed, you'll weave those into a writing assignment. Include this as a Microsoft Word document saved into your project folder along with your notebooks.

You will **not** be writing a full story ... we are just practicing writing a lede and "data sentences" about what you've found. You _do_ need to source the data and briefly describe the program but this is not a fully-fleshed story. Just concentrate on how you would write the facts and attribution.

- Use Microsoft Word and include it with your project when you upload it to canvas.
- Write a data drop from the data of between four and six paragraphs. Be sure to include attribution about where the data came from.
- You can pick the lede angle from any of the questions outlined above. Each additional paragraph should describe what you found from the data.

Here is a **partial** example to give you an idea of what I'm looking for. (You can't use this angle ;-)).

> The Jefferson County Sheriff's Office is flying high thanks to gifts of over $3.5 million worth of surplus U.S. Department of Defense equipment.

> Among the items transferred over the past decade to the department was a $923,000 helicopter in October 2016 and related parts the following year, according to data from the Defense Logistics Agency data — the agency that handles the transfers.

> The sheriff's office has received the fourth highest value of equipment among any law enforcement agency in Texas since August 2014 despite being a county of only 250,000 people.

