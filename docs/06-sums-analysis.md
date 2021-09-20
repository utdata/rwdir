# Summarize with math - analysis {#sums-analyze}

> Pre-draft notes. Will become detailed instructions (with quests) for analysis notebook.

## Analysis notebook

### Requirements of the assignment

You are following the same project structure employed with the Billboard project.

- Create a new project with the proper folder structure.
- Use separate RNotebooks for downloading/cleaning of the data and the analysis.
- Name your files logically and save files in proper folders.
- Each notebook should list the goals at the top.
- Each section within a notebook should have a headline and description for the task.
- Each notebook should run independently if you Restart R and Run All Chunks.

### Specifics for import/cleaning

Make sure you take care of each of these.

1. Use the `download.file()` function to download the file into your project. This is similar to what you did in the Billboard project to download the data. The url for the data is `https://github.com/utdata/rwd-r-leso/blob/main/data-processed/leso.csv?raw=true`. You will also need to supply the path and file name to save the data into, which is the second argument in that function. It should go into a `data-raw` folder, but you need to add a file name. (not hot100, but something like `leso-data.csv`)
3. Make sure you focus only on Texas records (TX). `filter()` is your friend here.
4. Make sure you use only records from **Jan. 1, 2010** or later. Again, `filter()`.
2. AFTER you have filtered for only Texas records, remove the columns we aren't using: `sheet`, `state`, `nsn`, `demil_code` and `demil_ic`. this is similar to how we removed columns in the Billboard assignment.
5. Make sure you create a new column (`mutate()`!) that gives the **total_value** of the equipment for each row. See the Technical note below "Create columns using math from other columns".
6. Export the cleaned data as an `.rds` file to your data-processed folder.

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



### Adding values within summarize

This relates to finding the *sum* of the `quantity` and `total_value` columns.

If you want to summarize to **add together all the values within a column** you use the `sum()` function:

If you started with the groceries table above and wanted to know the total number of all items and the total cost of all your groceries:

```r
data %>% 
  summarize(
    sum_item_count = sum(item_count),
    sum_total_value = sum(total_value)
  )
```

and you would end up with this:

| sum_item_count | sum_total_value |
|------------:|-----------:|
|           6 |      32.75 |

If you use a `group_by` before your summary, it will do the math _within_ each group. i.e., in our military surplus data, if you group by `agency_name`, it will summarize the columns for each one.

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

