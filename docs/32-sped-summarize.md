# Summarize {#sped-summarize}

> FIRST DRAFT OF NEW SUMMARIZE CHAPTER

- fix lists

----

In this lesson we'll actually get answers to the questions we posed when we started this quest. All of these questions refer to Austin ISD schools: 

- Which campus gained the most (count difference) special education students from 2015 to 2020?
- Which campus has the highest share (percent) of special education students in 2020?
- Which campus had the greatest change in share of in special education students between 2015 and 2020.
- How many AISD schools would be above the special education "audit threshold" of 8.5% in 2020 if it were still in effect? How does those numbers compare to 2015?

## New task, new notebook

We've been organizing our work into different RNotebooks that serve a single purpose. We started with downloading, importing and joining our data. We built a new notebook to handle our computations, and we'll build yet another one here for our analysis.

How you break up this work is really up to you, your colleagues you work with, and the needs of the project. For instance, I  typically include computations in either my import/clean or analysis notebooks, but I felt there were reasons to separate in this instance:

- The import step included downloading and processing of data. As I work through analysis, I often restart R and re-run my notebooks and I didn't want to re-download and process that data each time.
- Even though my immediate goal was to look at Austin ISD data, I wanted to preserve state-level data for possible comparison later. So I prepared the data for the entire state, leaving the Austin filtering for later.

Your needs may vary by project, but strive to live by these rules:

1. Don't change or write over original data. One way to accomplish this is keep raw data in a separate folder and never write to it.
2. Notebooks should run independently. You should be able to open it and do Run All and it work. (It's OK to import data from a previous notebook, but R objects should not carry over.)
3. If notebooks must be run in series, then indicate that in the name of the file.
4. Use descriptive names for everything. Avoid generic terms in file names like "data" or "myfile".

This is a long-winded way of saying this: Time to start a new notebook.

### Create analysis notebook

- If you haven't already, make sure you have the project open, but close all files and restart R.
- Create a new RNotebook. Update the title so "Special Education AISD analysis". Remove the boilerplate code.
- Save the file and name it `03-analysis-aisd.Rmd`.
- Create your first chunk and name it "setup". Add the tidyverse and janitor libraries.


```r
library(tidyverse)
library(janitor)
```

### Import

We need to import our data using the `read_rds()` function.

- Create a new chunk. Name it import.
- Add the following


```r
sped_calcs <- read_rds("data-processed/02_sped_calcs.rds")

# peek at it
sped_calcs %>% glimpse()
```

```
## Rows: 6,962
## Columns: 13
## $ school_name   <chr> "CAYUGA H S", "CAYUGA MIDDLE", "CAYUGA EL", "ELKHART H S…
## $ district_name <chr> "CAYUGA ISD", "CAYUGA ISD", "CAYUGA ISD", "ELKHART ISD",…
## $ grade_range   <chr> "'09-12", "'06-08", "'EE-05", "'09-12", "'06-08", "'EE-0…
## $ campus        <chr> "001902001", "001902041", "001902103", "001903001", "001…
## $ sped_c_15     <dbl> 37, 16, 23, 33, 36, 29, 27, 28, 16, 34, 16, 25, 96, 44, …
## $ sped_p_15     <dbl> 18.0, 13.3, 9.2, 9.3, 11.8, 9.6, 10.5, 12.6, 9.2, 8.4, 1…
## $ sped_c_20     <dbl> 34, 17, 31, 44, 29, 48, 26, 19, 28, 44, 11, 14, 103, 70,…
## $ sped_p_20     <dbl> 19.8, 13.6, 11.9, 11.6, 11.2, 14.4, 9.4, 8.3, 15.9, 11.5…
## $ sped_c_diff   <dbl> -3, 1, 8, 11, -7, 19, -1, -9, 12, 10, -5, -11, 7, 26, 23…
## $ sped_c_prccng <dbl> -8.1, 6.3, 34.8, 33.3, -19.4, 65.5, -3.7, -32.1, 75.0, 2…
## $ sped_p_ppd    <dbl> 1.8, 0.3, 2.7, 2.3, -0.6, 4.8, -1.1, -4.3, 6.7, 3.1, -4.…
## $ sped15_thsh   <chr> "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "N", "Y", "…
## $ sped20_thsh   <chr> "Y", "Y", "Y", "Y", "Y", "Y", "Y", "N", "Y", "Y", "Y", "…
```

### Filter to Austin ISD

Since we are seeking answers about our local district, let's filter the data to just those schools.

- Create a new chunk and call is `aisd`.
- Use `filter()` to find rows with `district_name` of "AUSTIN ISD".
- Use `select()` to remove the `district_name` and `campus` columns.
- Assign the result  to a new data frame called `aisd`.
- Print the data frame to the screen to you can browse through it.


```r
aisd <- sped_calcs %>% 
  filter(district_name == "AUSTIN ISD") %>% 
  select(-district_name, -campus)

aisd
```

```
## # A tibble: 109 × 11
##    school_name   grade_range sped_c_15 sped_p_15 sped_c_20 sped_p_20 sped_c_diff
##    <chr>         <chr>           <dbl>     <dbl>     <dbl>     <dbl>       <dbl>
##  1 AUSTIN H S    '09-12            183       8.8       223       9.5          40
##  2 NAVARRO EARL… '09-12            198      12.3       241      15.8          43
##  3 MCCALLUM H S  '09-12            154       9.4       144       8.2         -10
##  4 NORTHEAST EA… '09-12            157      12.8       162      14.2           5
##  5 TRAVIS EARLY… '09-12            199      15.2       200      17             1
##  6 CROCKETT ECHS '09-12            228      15.3       238      15.5          10
##  7 ANDERSON H S  '09-12            146       6.6       190       8.6          44
##  8 BOWIE H S     '09-12            212       7.4       282       9.9          70
##  9 LBJ ECHS      '09-12            111      13.2       128      15.1          17
## 10 AKINS H S     '09-12            289      10.9       351      12.8          62
## # … with 99 more rows, and 4 more variables: sped_c_prccng <dbl>,
## #   sped_p_ppd <dbl>, sped15_thsh <chr>, sped20_thsh <chr>
```

## Sorting with arrange()

Our first question we were tasked to answer is: 

- Which campus gained the most (count difference) special education students from 2015 to 2020?

In our computations notebook we created the `sped_c_diff` column for just this purpose. We just need to "arrange" the data so we can see the highest number at the top!

### About arrange

The `arrange()` function sorts data.

```r
dataframe %>% 
  arrange(column_name)
```

It will sort in ascending (A-Z or 1-10) by default.

If you want to sort the column be descending order (Z-A or 10-1), then you add on `desc()` function:

```r
dataframe %>% 
  arrange(desc(column_name))
```

The above code wraps your sorting column with the `desc()` function. I'm more apt to write this the tidyverse way, as the pipe makes the order of operations more clear to me:

```r
dataframe %>% 
  arrange(column_name %>% desc())
```

### Most new special education students

So, let's take our example data and arrange it with the highest count diff at the top.

- Add a markdown headline `## Most new special education students`.
- Add a chunk called **cntdiff-highest**, add the code below and run it.


```r
aisd %>% 
  arrange(sped_c_diff %>% desc()) %>% 
  head(10)
```

```
## # A tibble: 10 × 11
##    school_name  grade_range sped_c_15 sped_p_15 sped_c_20 sped_p_20 sped_c_diff
##    <chr>        <chr>           <dbl>     <dbl>     <dbl>     <dbl>       <dbl>
##  1 BOWIE H S    '09-12            212       7.4       282       9.9          70
##  2 BLAZIER EL   'EE KG-06          78       8.1       142      15.5          64
##  3 AKINS H S    '09-12            289      10.9       351      12.8          62
##  4 SMALL MIDDLE '06-08            108      10.8       163      13.3          55
##  5 HART EL      'EE-05             49       6.9       104      15.7          55
##  6 BARANOFF EL  'EE KG-05          64       6.5       116      11.4          52
##  7 SUMMITT EL   'EE-05             55       7.1       105      12.4          50
##  8 PATTON EL    'EE-05             52       5.5       101      10.6          49
##  9 ALLISON EL   'EE-06             41       8.4        88      17.5          47
## 10 HILL EL      'EE-05             44       5          90       9            46
## # … with 4 more variables: sped_c_prccng <dbl>, sped_p_ppd <dbl>,
## #   sped15_thsh <chr>, sped20_thsh <chr>
```

OK, so Bowie High School is at the top with 70 new special education students. Bowie is the largest high school in the district, so perhaps that is not a surprise.

### The head() command

I've used the `head()` command above and a couple of times but haven't really explained it. Basically it just gives you the first six rows of data unless you tell it you want a specific number of rows, like I asked for 10 above. There is also a `tail()` command that gives you the bottom rows of the data.

I often use `head()` when I only need to see a couple of rows because .Rmd files get bigger when you display more data. While  printing a 1000-row table to the screen only shows us 10 rows at a time, it has all 1000 rows stored in memory.

### Highest share of special education students in 2020

We can reveal the answer for our next question by using `arrange()` with the `sped_p_20` column.


```r
aisd %>% 
  arrange(sped_p_20 %>% desc()) %>% 
  head(10)
```

```
## # A tibble: 10 × 11
##    school_name     grade_range sped_c_15 sped_p_15 sped_c_20 sped_p_20 sped_c_diff
##    <chr>           <chr>           <dbl>     <dbl>     <dbl>     <dbl>       <dbl>
##  1 BROOKE EL       'EE-05             43      12.4        71      24.6          28
##  2 ZAVALA EL       'EE-06             61      15.3        59      23.8          -2
##  3 DAWSON EL       'EE-05             74      22.2        86      23.7          12
##  4 GARCIA YMLA     '06-08             80      20.5        92      23.1          12
##  5 WIDEN EL        'EE-05             70      11.9       102      22.9          32
##  6 MARTIN MIDDLE   '06-08            107      19.3       122      22.6          15
##  7 WILLIAMS EL     'EE-05             79      15.4        93      22.2          14
##  8 BEDICHEK MIDDLE '06-08            166      17.1       187      22            21
##  9 GOVALLE EL      'EE-05             57      10.5        79      21.7          22
## 10 CUNNINGHAM EL   'EE-05             72      17.8        83      20.5          11
## # … with 4 more variables: sped_c_prccng <dbl>, sped_p_ppd <dbl>,
## #   sped15_thsh <chr>, sped20_thsh <chr>
```

It looks like Brooke Elementary has the highest share of special education students, almost 1 in 4.

### Greatest change in share of special education students

Our last question to answer with arrange is who had the "greatest change in the share of special education students". That's a mouthful and the answer is nuanced, too.

Let's start by arranging by the percent change in the count: `sped_c_prccng`.


```r
aisd %>% 
  arrange(
    sped_c_prccng
  )
```

```
## # A tibble: 109 × 11
##    school_name   grade_range sped_c_15 sped_p_15 sped_c_20 sped_p_20 sped_c_diff
##    <chr>         <chr>           <dbl>     <dbl>     <dbl>     <dbl>       <dbl>
##  1 NORMAN-SIMS … 'EE-06             34      11.4        12       9.5         -22
##  2 METZ EL       'EE-05             40      11.2        22      10.4         -18
##  3 SANCHEZ EL    'EE-05             38       8.8        21       7.8         -17
##  4 EASTSIDE MEM… '09-12            109      17.6        72      17.2         -37
##  5 BRYKER WOODS… 'EE KG-06          22       5.6        16       4            -6
##  6 PICKLE EL     'EE-05             48       6.5        37       7.3         -11
##  7 WINN EL       'EE-06             49      14.6        40      14.2          -9
##  8 REILLY EL     'EE-05             35      12.7        29      11.3          -6
##  9 ANDREWS EL    'EE-06             62       9.5        52      14           -10
## 10 OAK SPRINGS … 'EE-05             39      12.7        33      14.4          -6
## # … with 99 more rows, and 4 more variables: sped_c_prccng <dbl>,
## #   sped_p_ppd <dbl>, sped15_thsh <chr>, sped20_thsh <chr>
```

Seven schools more than doubled their share of special education students. Wooldridge Elementary went from 35 to 79 students, a 132 percent increase.

We can also look at the change in the percentage point change by sorting on `sped_p_ppd`.


```r
aisd %>% 
  arrange(sped_p_ppd %>% desc())
```

```
## # A tibble: 109 × 11
##    school_name   grade_range sped_c_15 sped_p_15 sped_c_20 sped_p_20 sped_c_diff
##    <chr>         <chr>           <dbl>     <dbl>     <dbl>     <dbl>       <dbl>
##  1 BROOKE EL     'EE-05             43      12.4        71      24.6          28
##  2 GOVALLE EL    'EE-05             57      10.5        79      21.7          22
##  3 WIDEN EL      'EE-05             70      11.9       102      22.9          32
##  4 PEREZ EL      'EE-05             58       7.2        95      17.2          37
##  5 WOOTEN EL     'EE-05             66       9.1        84      18.4          18
##  6 ALLISON EL    'EE-06             41       8.4        88      17.5          47
##  7 HART EL       'EE-05             49       6.9       104      15.7          55
##  8 ORTEGA EL     'EE-05             30       9.2        50      17.8          20
##  9 WOOLDRIDGE EL 'EE-05             34       6          79      14.6          45
## 10 ZAVALA EL     'EE-06             61      15.3        59      23.8          -2
## # … with 99 more rows, and 4 more variables: sped_c_prccng <dbl>,
## #   sped_p_ppd <dbl>, sped15_thsh <chr>, sped20_thsh <chr>
```

Brooke Elementary went from 12.4 percent to 24.6 percent, climbing from 43 to 71 students. It amounted to a 65 percent change in the share of students.

But which number makes more sense for our story? Both are accurate. Ask yourself which one a reader could wrap their head around the easiest. I would say the percent change gives the reader a better picture and more properly describes the issue.

## Aggregates with summarize()

Our last question is: How many AISD schools would be above the special education "audit threshold" of 8.5% in 2020 if it were still in effect? How does those numbers compare to 2015?

To answer this we need to introduce a new concept and function: `summarize()`, and it's companion `group_by()`.

The `summarize()` and `summarise()` functions compute tables _about_ your data. They are the same function, as R supports both the American and European spelling of summarize. I don't care which you use.

![Learn about your data with Summarize()](images/transform-summarize.png){width=500px}

Much like the `mutate()` function, we list the name of the new column first, then assign to it the function we want to accomplish using `=`.

To demonstrate, let's find the average number (or mean) of special education students in AISD schools in 2020. (You don't need to do this, just see it.)


```r
aisd %>% 
  summarize(
    mean_sped_students = sped_c_20 %>% mean()
  )
```

```
## # A tibble: 1 × 1
##   mean_sped_students
##                <dbl>
## 1               90.4
```
You might also see that calculation as: `mean_sped_students = mean(sped_c_20)`. Both are correct. I flip back and forth, using tidyverse pipe method when I think it is more clear. Others may disagree.

A mean (or average in common terms) is a way to use one number to represent a group of numbers. It works well when the variance in the numbers is not great. `median()` is another way, and sometimes better when there are high or low numbers that would unduly influence a mean. It's the "middle" value.

## Group_by()

The `summarize()` function is an especially useful in combination with another function called `group_by()`, which allows us to categorize our data by common values before aggregating on thos values. You might review the [Group & Aggregate](https://vimeo.com/showcase/7320305/video/435910349) video that explains the concept.

![Group by](images/transform-groupby.png)

This is easier to understand when you can see an example, so let's do it.

### Group and count

If we want to know how many schools how many AISD schools were above the the 8.5% threshold in 2015 (our `sped_)


```r
aisd %>% 
  group_by(sped15_thsh) %>% 
  summarize(schools = n())
```

```
## # A tibble: 2 × 2
##   sped15_thsh schools
##   <chr>         <int>
## 1 N                43
## 2 Y                66
```
Let's break this down:

- The `group_by` has organized (or "grouped") all our data by the `sped15_thsh` value first (N vs Y)
- Then inside `summarize()` we counted the number `n()` of rows. We named that new column "schools", because that is what we are really counting.

### The count() function shortcut

We count row A LOT in data science, so there is a convenience function to do this: `count()`. We used it earlier when we wanted to know our instruction types.

Let's rewrite this with count:


```r
aisd %>% 
  count(sped15_thsh)
```

```
## # A tibble: 2 × 2
##   sped15_thsh     n
##   <chr>       <int>
## 1 N              43
## 2 Y              66
```

Under the hood, `count()` is doing the same thing as the "group and summarize" function above it. 

### Comparing thresholds for 2015 and 2020

When we use count, we just feed it the columns that we want to group data by. And we can feed it more than one column.

In our case, we want to know the number of schools for both 2015 and 2020, so let's feed count with both columns:

- Add a Markdown header: `# Comparing thresholds 2015 and 2020`.
- Create a new chunk and name it `thsh-compare`.
- Add the following code:


```r
aisd %>% 
  count(sped15_thsh, sped20_thsh)
```

```
## # A tibble: 4 × 3
##   sped15_thsh sped20_thsh     n
##   <chr>       <chr>       <int>
## 1 N           N               7
## 2 N           Y              36
## 3 Y           N               2
## 4 Y           Y              64
```

To break down our results here:

- Our first row (N and N) is schools below the threshold in both years: 7.
- The second ( N and Y) is schools that were below in 2015 but above in 2020: 36.
- The third (Y and N) is the schools that were above in 2015, but dropped in 2020: 2.
- The last (Y and Y) are the schools above in both years: 64.

With this we can write a sentence describing how many schools climbed above 8.5% (36) and how many dropped (just 2).

Note the count column has a header of "n", for the number of rows. We can make this a little prettier by renaming that column.

- Modify your code chunk to add the rename() function below:


```r
aisd %>% 
  count(sped15_thsh, sped20_thsh) %>% 
  rename(schools = n)
```

```
## # A tibble: 4 × 3
##   sped15_thsh sped20_thsh schools
##   <chr>       <chr>         <int>
## 1 N           N                 7
## 2 N           Y                36
## 3 Y           N                 2
## 4 Y           Y                64
```

## More on summarize

Let's review the group_by and summarize combo:

- We start with our data frame.
- We then **group_by** the data by column or columns we want to consider. If we printed the data frame at this point, we won't really see a difference. The `group_by()` function always needs another function to see a result.
- We then **summarize** the grouped data. Common summaries are to count rows `n()`, or do match on the results in a column like `mean()` (the average), `median()` (middle value) or `sum()` (adds together). If we want to name our new column, we do so first: `new_name = mean(col_name)`.

We can do multiple calculations within the `summarize()` function, like this:

![Group and summarize](images/transform-group-summarise.png)

### Ignoring NA values

Sometimes you'll try to calculate a `mean()` with summarize and get an error because there are blank values. We don't have an example in our special education data, but consider this data set of water wells, trying to find the average depth of the well: `borehold_depth`.

![Attempt to find the mean](images/transform-wells-nanowork.png)

We get an error because some rows of the data don't have a value for `borehole_depth`. They are NA values, or Not Available.

We can apply a function inside `summarize()` called `na.rm`, which "removes" NA values before doing the summary. Like this:

![NAs removed from summarize](images/transform-wells-narm.png)


## Review what we learned

In this lesson used `arrange()` to sort our data, `summarize()` and the shortcut `count()` to find aggregates, like the number of rows based on values within the data. We'll do lots more of this in lessons to come.

Next we'll practice all the things we've learned with a new data set.
