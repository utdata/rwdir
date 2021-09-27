# Summarize with count - analysis {#count-analysis}

> THIS IS IN MIDDLE OF REWRITE AFTER FALL 2021.

## Rewrite goals

- Rearranging order of challenges to more clearly cover GSA.
- Move talk of distinct to end
- Cover count at the very end. Don't confuse learning GSA.

---

This chapter continues the Billboard Hot 100 project. In the previous chapter we downloaded, imported and cleaned the data. We'll be working in the same project.

## Goals of this lesson

- To use group by/summarize/arrange combination to count rows.
- To use filter to both focus data for summaries, and to logically end summary lists.
- Introduce the shortcut `count()` function.

## The questions we'll answer

Now that we have the Billboard Hot 100 charts data in our project it's time to find the answers to the following questions:

- Which performers had the most appearances on the Hot 100 chart at any position?
- Which performer/song combination has been on the charts the most number of weeks at any position?
- Which performer/song combination was No. 1 for the most number of weeks?
- Which performer had the most songs reach No. 1?
- Which performer had the most songs reach No. 1 in the most recent five years?
- Which performer had the most Top 10 hits overall?

> What are your guesses for the questions above? No peeking!

Before we can get into the analysis, we need to set up a new notebook.

## Setting up an analysis notebook

At the end of the last notebook we exported our clean data as an `.rds` file. We'll now create a new notebook and import that data. It will be much easier this time.

1. If you don't already have it open, go ahead and open your Billboard project.
1. If your import notebook is still open, go ahead and close it.
1. Use the `+` menu to start a new **RNotebook*.
1. Update the title as "Billboard analysis" and then remove all the boilerplate text below the YAML metadata.
1. Save the file as `02-analysis.Rmd` in your project folder.
1. Check your Environment tab (top right) and make sure the Data pane is empty. We don't want to have any leftover data. If there is, then go under the **Run** menu and choose **Restart R and Clear Output**.

Since we are starting a new notebook, we need to set up a few things. First up we want to list our goals.

1. Add a headline and text describing the goals of this notebook. You are exploring the Billboard Hot 100 charts data.
1. Go ahead and copy all the questions outlined above into your notebook.
1. Start each line with a `-` or `*` followed by a space.
1. Now add a headline (two hashes) called Setup.
1. Add a chunk, also name it "setup" and add the tidyverse library.
1. Run the chunk to load the library.


```r
library(tidyverse)
```

### Import the data on your own

In this next part I want you to think about how you've did the import in the last notebook and I want you to:

1. Write a section to import the data using `read_rds()` and put it into a tibble called `hot100`.

Yes, it is true that we haven't talked about [`read_rds()`](https://readr.tidyverse.org/reference/read_rds.html) yet but it works exactly the same way as `read_csv()`, so you should try to figure it out.

Here are some hints and guides:

- Start a new section with a headline and text to say what you are doing
- Don't forget to name your code chunk (this should all be getting familiar).
- `read_rds()` works the same was as `read_csv()`. The path _should_ be `data-processed/01-hot100.rds` if you did the previous notebook properly.
- Remember the tibble needs to be named first and read data pushed into it.
- Add a glimpse to the chunk so you can refer to the data.

<details>
  <summary>Try real hard first before clicking here for the answer</summary>


```r
hot100 <- read_rds("data-processed/01-hot100.rds")

# peek at the data
hot100 %>% glimpse()
```

```
## Rows: 327,895
## Columns: 7
## $ week_id                <date> 1958-08-02, 1958-08-02, 1958-08-02, 1958-08-02…
## $ week_position          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, …
## $ song                   <chr> "Poor Little Fool", "Patricia", "Splish Splash"…
## $ performer              <chr> "Ricky Nelson", "Perez Prado And His Orchestra"…
## $ previous_week_position <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ peak_position          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, …
## $ weeks_on_chart         <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
```

</details>

## Introducing dplyr

One of the packages within the tidyverse is [dplyr](https://dplyr.tidyverse.org/). Dplyr allows us to transform our data frames in ways that let us explore the data and prepare it for visualizing. It's the R equivalent of common Excel functions like sort, filter and pivoting.

> There is a cheatsheet on the [dplyr](https://dplyr.tidyverse.org/) that you might find useful. 

![dplyr. Images courtesy Hadley and Charlotte Wickham](images/transform-dplyractions.png){width=600px}

We've used `select()`, `mutate()` and `arrange()` already, but we'll introduce more dplyr functions in this chapter.

## Most appearances

Our first question: Which performers had the most appearances on the Hot 100 chart at any position?

### Group & Aggregate

Before we dive into the code, let's review this video about "Group and Aggregate" to get a handle on the concept.

<iframe width="560" height="315" src="https://www.youtube.com/embed/a3VNWYJoy5A" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<br>
Let's work through the logic of what we need to do to get our answer before I explain exactly how.

- Each row in the data is one song on the chart.
- Each of those rows has the `performer` which is the person(s) who performed it.
- To figure out how many times a performer is in the data, we need to count the rows with the same performer.

We'll use the tidyverse's version of Group and Aggregate to get this answer. It is actually two different functions within dplyr that often work together: `summarize()` and it's companion `group_by()`.

### Summarize

> `summarize()` and `summarise()` are the same function, as R supports both the American and UK spelling of summarize. I don't care which you use.

We'll start with [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) first because it can stand alone.

The `summarize()` function **computes tables _about_ your data**. Our logic above has us wanting a "summary" of how many times certain performers appear in data, hence we use this function.

Here is an example in a different context:

![Learn about your data with summarize()](images/transform-summarise.png){width=500px}

Much like the `mutate()` function we used earlier, we list the name of the new column first, then assign to it the function we want to accomplish using `=`.

The example above is giving us two summaries: It is applying a function `mean()` (or average) on all the values in the `lifeExp` column, and then again with `min()`, the lowest life expectancy in the data.

Let me show you a similar example with our data answer this question:

Let's find the average "peak_position" of all songs on the charts through history: 


```r
hot100 %>% 
  summarize(mean_position = mean(peak_position))
```

```
## # A tibble: 1 × 1
##   mean_position
##           <dbl>
## 1          41.4
```

Meaning the average song on the charts tops out at No. 41.

> This is an admittedly simplistic view of the average `peak_position` since the same song will be listed multiple times with possibly new `peak_position`s, but hopefully you get the idea.

But in our case we want to **count** the number of rows, and there is a function for that: `n()`. (Think "number of observations or rows".)

Let's write the code and run it on our code, then I'll explain:

1. Set up a new section with a headline, text and empty code chunk.
1. Inside the code chunk, add the following:


```r
hot100 %>% 
  summarize(appearances = n())
```

```
## # A tibble: 1 × 1
##   appearances
##         <int>
## 1      327895
```

- We start with the tibble first and then pipe into `summarize()`.
- Within the function, we define our summary:
  + We name the new column "appearances" because that is a descriptive column name for our result.
  + We set that new column to count the **n**umber of rows.
  
Basically we are summarizing the total number of rows in the data.

AN ASIDE: I often break up the inside a `summarize()` into new lines so they are easier to read.

```r
# you don't have to do this here, but know
# it is helpful when you have more than one summary
hot100 %>% 
  summarize(
    appearances = n()
  )

```

But your are asking: Professor, we want to count the performers, right?

This is where `summarize()`'s close friend `group_by()` comes in.

### Group by

Here is a weird thing about [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html): It is always followed by another function. It really just pre-sorts data into groups so that whatever function is applied after happens within each individual group.

If add a `group_by()` on our performers before our summarize function, it will put all of the "Aerosmith" rows together, then all the "Bad Company" rows together, etc. and then we count the rows _within_ those groups.
 
1. Modify your code block to add the group_by:


```r
hot100 %>%
  group_by(performer) %>% 
  summarize(appearances = n())
```

```
## # A tibble: 10,061 × 2
##    performer                            appearances
##    <chr>                                      <int>
##  1 "? (Question Mark) & The Mysterians"          33
##  2 "'N Sync"                                    172
##  3 "'N Sync & Gloria Estefan"                    20
##  4 "'N Sync Featuring Nelly"                     20
##  5 "'Til Tuesday"                                53
##  6 "\"Groove\" Holmes"                           14
##  7 "\"Little\" Jimmy Dickens"                    10
##  8 "\"Pookie\" Hudson"                            1
##  9 "\"Weird Al\" Yankovic"                       91
## 10 "(+44)"                                        1
## # … with 10,051 more rows
```

What we get in return is a **summarize**d table that shows all 10,000+ different performers that have been on the charts, and **n**umber of rows in which they appear in the data.

That's great, but who had the most?

### Arrange the results

Remember in our import notebook when we had to sort the songs by date. We'll use the same `arrange()` function here, but we'll change the result to **desc**ending order, because journalists almost always want to know the _most_ of something.

1. Add the pipe and arrange function below and run it, then I'll explain.


```r
hot100 %>%
  group_by(performer) %>% 
  summarize(appearances = n()) %>% 
  arrange(appearances %>% desc())
```

```
## # A tibble: 10,061 × 2
##    performer     appearances
##    <chr>               <int>
##  1 Taylor Swift         1022
##  2 Elton John            889
##  3 Madonna               857
##  4 Kenny Chesney         758
##  5 Drake                 746
##  6 Tim McGraw            731
##  7 Keith Urban           673
##  8 Stevie Wonder         659
##  9 Rod Stewart           657
## 10 Mariah Carey          621
## # … with 10,051 more rows
```

- We added the `arrange()` function and fed it the column of "appearances". If we left it with just that, then it would list the smallest values first.
- _Within the arrange function_ we piped the "appearances" part into another function: `desc()` to change the order.

So if you read that line in English it would be "arrange by (appearances AND THEN descending order)".

You may also see this as `arrange(desc(appearances))`.

### Get the top of the list

We've printed 10,000 rows of data into our notebook when we really only wanted the Top 10 or so. You might think it doesn't matter, but your knitted HTML file will store all that data and can make it a big file (like in megabytes), so I try to avoid that when I can.

We can use the `head()` command again to get our Top 10.

1. Pipe the result into `head()` function set to 10 rows.


```r
hot100 %>%
  group_by(performer) %>% 
  summarize(appearances = n()) %>% 
  arrange(appearances %>% desc()) %>% 
  head(10)
```

```
## # A tibble: 10 × 2
##    performer     appearances
##    <chr>               <int>
##  1 Taylor Swift         1022
##  2 Elton John            889
##  3 Madonna               857
##  4 Kenny Chesney         758
##  5 Drake                 746
##  6 Tim McGraw            731
##  7 Keith Urban           673
##  8 Stevie Wonder         659
##  9 Rod Stewart           657
## 10 Mariah Carey          621
```

If I was to explain the code above in English, I would descibe it as this:

- We start with the hot100 data AND THEN
- we group the data by performer AND THEN
- we summarize it by counting the number of rows in each group, calling the count "appearances" AND THEN
- we arrange the result by appearances in descending order AND THEN
- we kept just the first 10 rows

Since we have our answer here and we're not using the result later, we don't need to create a new tibble or anything.

> AN IMPORTANT NOTE: The list we've created here is based on unique `performer` names, and as such considers collaborations separately. For instance, Drake is near the top of the list but those are only songs he performed alone and not the many, many collaborations he has had with other performers. So, songs by "Drake" are counted separately than "Drake featuring Future" and "Future featuring Drake". You'll need to make this clear when you write your data drop in a later assignment.

So, **Taylor Swift** ... is that who you guessed? A little history here, Swift past Elton John in the summer of 2019. Elton John has been around a long time, but Swift's popularity at a young age, plus changes in how Billboard counts plays in the modern era (like streaming) has rocketed her to the top. (Sorry, Rocket Man).

## Performer/song with most appearances

Our quest here is this: **Which performer/song combination has been on the charts the most number of weeks at any position?**

This is very similar to our quest to find the artist with the most appearances, but we have to consider `performer` and `song` together because different artists can perform songs of the same name. For example, 17 different performers have a song called "Hold On" on the Hot 100 (at least through 2020).

1. Start a new section (headline, text describing goal and a new code chunk.)
1. Add the code below to the chunk and run it and then I'll outline it below.


```r
hot100 %>% # start with the data, and then ...
  group_by(performer, song) %>% # group by performer and song, and then ..
  summarize(appearances = n()) %>% # name the column, then fill it with the number of rows ...
  arrange(appearances %>% desc()) # arrange by appearances in descending order
```

```
## `summarise()` has grouped output by 'performer'. You can override using the `.groups` argument.
```

```
## # A tibble: 29,389 × 3
## # Groups:   performer [10,061]
##    performer                                 song                    appearances
##    <chr>                                     <chr>                         <int>
##  1 Imagine Dragons                           Radioactive                      87
##  2 AWOLNATION                                Sail                             79
##  3 Jason Mraz                                I'm Yours                        76
##  4 The Weeknd                                Blinding Lights                  76
##  5 LeAnn Rimes                               How Do I Live                    69
##  6 LMFAO Featuring Lauren Bennett & GoonRock Party Rock Anthem                68
##  7 OneRepublic                               Counting Stars                   68
##  8 Adele                                     Rolling In The Deep              65
##  9 Jewel                                     Foolish Games/You Were…          65
## 10 Carrie Underwood                          Before He Cheats                 64
## # … with 29,379 more rows
```

The logic is actually straightforward:

- We want to count combinations over two columns: `song, performer`. When you  group_by more then one column, it will group rows where the values are the same in all columns. i.e. all rows with both "Rush" as a performer and _Tom Sawyer_ as a song. Rows with "Rush" and _Red Barchetta_ will be considered in a different group.
- With `summarize()`, we name the new column first (we chose `appearances`), then describe what should fill it. In this case we filled the column using the `n()`, which counts the number of rows in each group.
- Once you have a summary table, we sort it by appearances and set it to **desc**ending order, which puts the highest value on the top.

We will _often_ use `group_by()`, `summarize()` and `arrange()` together, which is why I'll refer to this as the GSA trio. They are like three close friends that always want to be together.

### Introducing filter()

I showed you `head()` in the previous quest and that is useful to quickly cut off a list, but it does so indiscriminately. In this case, if we use the default `head()` that retains six rows, it would cut right in the middle of a tie at 68 records. (at least with data through 2020). A better strategy is to cut off the list at a logical place using `filter()`. Let's dive into this new function:

Filtering is one of those Basic Data Journalism Functions:

<iframe width="560" height="315" src="https://www.youtube.com/embed/ckojM4rtlMc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<br>
The dplyr function `filter()` reduces the number of rows in our data based on one or more criteria.

The syntax works like this:

```r
# this is psuedo code. don't run it
data %>% 
  filter(variable comparison value)

# example
hot100 %>% 
  filter(performer == "Judas Priest")
```

The `filter()` function typically works in this order:

- What is the variable (or column) you are searching in.
- What is the comparison you want to do. Equal to? Greater than?
- What is the observation (or value in the data) you are looking for?

Note the two equals signs `==` in our Judas Priest example above. It's important to use two of them when you are looking for "equals", as a single `=` will not work, as that means something else in R.

#### Comparisons: Logical tests

There are a number of these logical test for the comparison:

| Operator          | Definition               |
|:------------------|:-------------------------|
| x **<** y         | Less than                |
| x **>** y         | Greater than             |
| x **==** y        | Equal to                 |
| x **<=** y        | Less than or equal to    |
| x **>=** y        | Greater than or equal to |
| x **!-** y        | Not equal to             |
| x **%in%** c(y,z) | In a group               |
| **is.na(**x**)**  | Is NA                    |
| **!is.na(**x**)** | Is not NA                |

Where you apply a filter matters. If we filter before group by/summarize/arrange (GSA) we are focusing the data before we summarize. If we filter after the GSA, we are affecting only the results of the summarize function, which is what we want to do here.

#### Filter to a logical cutoff

In this case, I want you to use filter _after_ the GSA actions to include **only results with 65 or more appearances**.

1. Edit your current chunk to add a filter as noted in the example below. I'll explain it afte.


```r
hot100 %>%
  group_by(performer, song) %>%
  summarize(appearances = n()) %>%
  arrange(appearances %>% desc()) %>% 
  filter(appearances >= 65) # this is the new line
```

```
## `summarise()` has grouped output by 'performer'. You can override using the `.groups` argument.
```

```
## # A tibble: 9 × 3
## # Groups:   performer [9]
##   performer                                 song                     appearances
##   <chr>                                     <chr>                          <int>
## 1 Imagine Dragons                           Radioactive                       87
## 2 AWOLNATION                                Sail                              79
## 3 Jason Mraz                                I'm Yours                         76
## 4 The Weeknd                                Blinding Lights                   76
## 5 LeAnn Rimes                               How Do I Live                     69
## 6 LMFAO Featuring Lauren Bennett & GoonRock Party Rock Anthem                 68
## 7 OneRepublic                               Counting Stars                    68
## 8 Adele                                     Rolling In The Deep               65
## 9 Jewel                                     Foolish Games/You Were …          65
```

Let's break down that last line:

- `filter()` is the function.
- The first argument in the function is the column we are looking in, `appearances` in our case.
- We then provide a comparison operator `>=` to get "greater than or equal to".
- We then give the value to compare, `65` in our case.

## Song/Performer with most weeks at No. 1

We introduced `filter()` in rhe last quest to limit the summary. For this quest you'll need to filter the data _before_ the group by/summarize/arrange trio.

Let's review the quest: **Which performer/song combination was No. 1 for the most number of weeks?**

While this quest is very similar to the one above, it _really_ helps to think about the logic of what you nneed and then build the query one line at a time to make each line works.

Let's talk through the logic:

- We are starting with our `hot100` data.
- Do we want to consider all the data? In this case, no: We only want songs that have a `week_position` of 1. This means we will **filter** before any summarizing.
- Then we want to count the number of rows with the same **performer** and **song** combinations. This means we need to `group_by` both `performer` and `song`.
- Since we are **counting row**, we need use `n()` as our summarize function, which counts the **number** or rows in each group.

So let's step through this with code: 

1. Create a section with a headline, text and code chunk
2. Start with the `hot100` data and then pipe into `filter()`.
1. Within the filter, set the `week_position` to be `==` to `1`.
1. Run the result and check it


```r
hot100 %>% 
  filter(week_position == 1)
```

```
## # A tibble: 3,279 × 7
##    week_id    week_position song      performer   previous_week_p… peak_position
##    <date>             <dbl> <chr>     <chr>                  <dbl>         <dbl>
##  1 1958-08-02             1 Poor Lit… Ricky Nels…               NA             1
##  2 1958-08-09             1 Poor Lit… Ricky Nels…                1             1
##  3 1958-08-16             1 Nel Blu … Domenico M…                2             1
##  4 1958-08-23             1 Little S… The Elegan…                2             1
##  5 1958-08-30             1 Nel Blu … Domenico M…                2             1
##  6 1958-09-06             1 Nel Blu … Domenico M…                1             1
##  7 1958-09-13             1 Nel Blu … Domenico M…                1             1
##  8 1958-09-20             1 Nel Blu … Domenico M…                1             1
##  9 1958-09-27             1 It's All… Tommy Edwa…                3             1
## 10 1958-10-04             1 It's All… Tommy Edwa…                1             1
## # … with 3,269 more rows, and 1 more variable: weeks_on_chart <dbl>
```

The result should show _only_ songs with a `1` for `week_position`.

The rest of our logic is just like our last quest. We need to group by the `song` and `performer` and then `summarize` using `n()` to count the rows.

1. Edit your existing chunk to add the `group_by` and `summarize` functions. Name your new column `appearances` and set it to count the rows with `n()`.

> While I say to write and run your code one line at a time, `group_by()` won't actually show you any different results, so I usually write `group_by()` and `summarize()` together.

<detail>
  <summary>Try this on your own before you peek</summary>

```r
hot100 %>%
  filter(week_position == 1) %>% 
  group_by(performer, song) %>%
  summarize(appearances = n())
```

```
## `summarise()` has grouped output by 'performer'. You can override using the `.groups` argument.
```

```
## # A tibble: 1,124 × 3
## # Groups:   performer [744]
##    performer                          song                             appearances
##    <chr>                              <chr>                                  <int>
##  1 ? (Question Mark) & The Mysterians 96 Tears                                   1
##  2 'N Sync                            It's Gonna Be Me                           2
##  3 24kGoldn Featuring iann dior       Mood                                       8
##  4 2Pac Featuring K-Ci And JoJo       How Do U Want It/California Love           2
##  5 50 Cent                            In Da Club                                 9
##  6 50 Cent Featuring Nate Dogg        21 Questions                               4
##  7 50 Cent Featuring Olivia           Candy Shop                                 9
##  8 6ix9ine & Nicki Minaj              Trollz                                     1
##  9 A Taste Of Honey                   Boogie Oogie Oogie                         3
## 10 a-ha                               Take On Me                                 1
## # … with 1,114 more rows
```
</detail>

Look at your results to make sure you have the three columns you expect: performer, song and appearances.

This doesn't quite get us where we want because it is alphabetically by the perfomer. You need to **arrange** the data to show us the most appearances at the top.

1. Edit your chunk to add the `arrange()` function to sort by `appearances` in `desc()` order. This is just like our last quest.

<detail>
  <summary>Maybe check your last chunk on how you did this</summary>
  

```r
hot100 %>%
  filter(week_position == 1) %>% 
  group_by(performer, song) %>%
  summarize(appearances = n()) %>%
  arrange(appearances %>% desc())
```

```
## `summarise()` has grouped output by 'performer'. You can override using the `.groups` argument.
```

```
## # A tibble: 1,124 × 3
## # Groups:   performer [744]
##    performer                                         song            appearances
##    <chr>                                             <chr>                 <int>
##  1 Lil Nas X Featuring Billy Ray Cyrus               Old Town Road            19
##  2 Luis Fonsi & Daddy Yankee Featuring Justin Bieber Despacito                16
##  3 Mariah Carey & Boyz II Men                        One Sweet Day            16
##  4 Boyz II Men                                       I'll Make Love…          14
##  5 Elton John                                        Candle In The …          14
##  6 Los Del Rio                                       Macarena (Bays…          14
##  7 Mariah Carey                                      We Belong Toge…          14
##  8 Mark Ronson Featuring Bruno Mars                  Uptown Funk!             14
##  9 The Black Eyed Peas                               I Gotta Feeling          14
## 10 Whitney Houston                                   I Will Always …          14
## # … with 1,114 more rows
```
</detail>

You have your answer now (you go, Lil Nas) but we are listing more than 1,000 rows. Let's cut this off at a logical place like we did in our last quest.

1. Use `filter()` to cut your summary off at `appearances` of 14 or greater.

<detail>
  <summary>You've done this before ... try it on your own!</summary>


```r
hot100 %>%
  filter(week_position == 1) %>% 
  group_by(performer, song) %>%
  summarize(appearances = n()) %>%
  arrange(appearances %>% desc()) %>% 
  filter(appearances >= 14)
```

```
## `summarise()` has grouped output by 'performer'. You can override using the `.groups` argument.
```

```
## # A tibble: 10 × 3
## # Groups:   performer [10]
##    performer                                         song            appearances
##    <chr>                                             <chr>                 <int>
##  1 Lil Nas X Featuring Billy Ray Cyrus               Old Town Road            19
##  2 Luis Fonsi & Daddy Yankee Featuring Justin Bieber Despacito                16
##  3 Mariah Carey & Boyz II Men                        One Sweet Day            16
##  4 Boyz II Men                                       I'll Make Love…          14
##  5 Elton John                                        Candle In The …          14
##  6 Los Del Rio                                       Macarena (Bays…          14
##  7 Mariah Carey                                      We Belong Toge…          14
##  8 Mark Ronson Featuring Bruno Mars                  Uptown Funk!             14
##  9 The Black Eyed Peas                               I Gotta Feeling          14
## 10 Whitney Houston                                   I Will Always …          14
```
</detail> 

Now you have the answers to the performer/song with the most weeks at No. 1 with a logical cutoff. If you add to the data, that logic will still hold and not cut off arbitrarily at a certain number of records.

## Performer with most songs to reach No. 1

Our new quest is this: **Which performer had the most songs reach No. 1?** The answer might be easier to guess if you know music history, but perhaps not.

This sounds similar to our last quest, but there is a **distinct** difference. (That's a bad joke that will reveal itself here in a bit.)

Again, let's think through the logic of what we have to do to get our answer:

- We need to consider only No. 1 songs. (filter!)
- Because a song could be No. 1 for more than one week, we need to consider the same song/performer combination only once. (We'll introduce a new function for this.)
- Once we have all the unique No. 1 songs in a list, then we can group by **performer** and count how many times many times they are on the list.

Let's start by getting the No. 1 songs. You've did this in the last quest.

1. Create a new section with a headline, text and code chunk.
1. Start with the `hot100` data and filter it so you only have `week_position` of 1.

<detail>
  <summary>Try on your own. You got this!</summary.

```r
hot100 %>% 
  filter(week_position == 1)
```

```
## # A tibble: 3,279 × 7
##    week_id    week_position song      performer   previous_week_p… peak_position
##    <date>             <dbl> <chr>     <chr>                  <dbl>         <dbl>
##  1 1958-08-02             1 Poor Lit… Ricky Nels…               NA             1
##  2 1958-08-09             1 Poor Lit… Ricky Nels…                1             1
##  3 1958-08-16             1 Nel Blu … Domenico M…                2             1
##  4 1958-08-23             1 Little S… The Elegan…                2             1
##  5 1958-08-30             1 Nel Blu … Domenico M…                2             1
##  6 1958-09-06             1 Nel Blu … Domenico M…                1             1
##  7 1958-09-13             1 Nel Blu … Domenico M…                1             1
##  8 1958-09-20             1 Nel Blu … Domenico M…                1             1
##  9 1958-09-27             1 It's All… Tommy Edwa…                3             1
## 10 1958-10-04             1 It's All… Tommy Edwa…                1             1
## # … with 3,269 more rows, and 1 more variable: weeks_on_chart <dbl>
```
</detail>  

Now look at the result. Note how "Poor Little Fool" shows up more than once? Other songs to as well. If we counted rows by `performer` now, we could count that song more than once. That's not what we want. 

### Using distinct()

Our next challenge in our logic is to show only unique performer/song combinations. We do this with [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html).

We feed the `distinct()` function with the variables we want to consider together, in our case the `perfomer` and `song`. All other columns are dropped since including them would mess up their distinctness.

1. Add the distinct() function to your code chunk.


```r
hot100 %>% 
  filter(week_position == 1) %>% 
  distinct(song, performer)
```

```
## # A tibble: 1,124 × 2
##    song                            performer                       
##    <chr>                           <chr>                           
##  1 Poor Little Fool                Ricky Nelson                    
##  2 Nel Blu Dipinto Di Blu (Volaré) Domenico Modugno                
##  3 Little Star                     The Elegants                    
##  4 It's All In The Game            Tommy Edwards                   
##  5 It's Only Make Believe          Conway Twitty                   
##  6 Tom Dooley                      The Kingston Trio               
##  7 To Know Him, Is To Love Him     The Teddy Bears                 
##  8 The Chipmunk Song               The Chipmunks With David Seville
##  9 Smoke Gets In Your Eyes         The Platters                    
## 10 Stagger Lee                     Lloyd Price                     
## # … with 1,114 more rows
```

Now we have a list of just No. 1 songs!

### Summarize the performers

Now that we have our list of No. 1 songs, we can "count" the number of times a performer is in the list to know how many No. 1 songs they have.

We'll again use the group_by/summarize combination for this, but we are only grouping by `performer` since that is what we are counting.

1. Edit your chunk to add a group_by on `performer` and then a `summarize()` to count the rows. Name the new column `no_hits`. Run it.
1. After you are sure the group_by/summarize runs, add an `arrange()` to show the `no1_hits` in descending order.

<detail>
  <summary>You've done this. Give it ago!</summary>

```r
hot100 %>% 
  filter(week_position == 1) %>%
  distinct(song, performer) %>%
  group_by(performer) %>%
  summarize(no1_hits = n()) %>%
  arrange(no1_hits %>% desc())
```

```
## # A tibble: 744 × 2
##    performer          no1_hits
##    <chr>                 <int>
##  1 The Beatles              19
##  2 Mariah Carey             16
##  3 Madonna                  12
##  4 Michael Jackson          11
##  5 Whitney Houston          11
##  6 The Supremes             10
##  7 Bee Gees                  9
##  8 The Rolling Stones        8
##  9 Janet Jackson             7
## 10 Stevie Wonder             7
## # … with 734 more rows
```
</detail>

### Filter for a good cutoff

Like we did earlier, use a `filter()` after your arrange to cut the list off at a logical place.

1. Edit your chunk to filter the summary to show performer with `8` or more No. 1 hits.

<detail>
  <summary>You can do this. Really</summary>

```r
hot100 %>% 
  filter(week_position == 1) %>%
  distinct(song, performer) %>%
  group_by(performer) %>%
  summarize(no1_hits = n()) %>%
  arrange(no1_hits %>% desc()) %>% 
  filter(no1_hits >= 8)
```

```
## # A tibble: 8 × 2
##   performer          no1_hits
##   <chr>                 <int>
## 1 The Beatles              19
## 2 Mariah Carey             16
## 3 Madonna                  12
## 4 Michael Jackson          11
## 5 Whitney Houston          11
## 6 The Supremes             10
## 7 Bee Gees                  9
## 8 The Rolling Stones        8
```

</detail>

## No. 1 hits in last five years





> THIS IS WHERE I STOPPED TONIGHT






Which performer had the most songs reach No. 1 in the most recent five years?

This time I'll have you try the `count()` method on your own with some hints, but you'll need to do the group/summarize method all on your own.

Let's talk through the logic. This is very similar to the No. 1 hits above but with two differences:

- In addition to filtering for No. 1 songs, we also want to filter for songs in 2016-2020.
- We might need to adjust our last filter for a better "break point".

We haven't talked about filtering dates, so let me tell you this: You can use filter operations on dates just like you do any other text. This will give you rows _after_ 2015.

```r
filter(week_id > "2015-12-31")
```

Go back and review the "Complex filters" section where I showed how to combine more than one filter and apply that logic here. There is more than one correct answer. Here's the task:

1. Build a summary table that gets the most No. 1 hits in the last five years. Exclude results with a single No. 1 hit. Use the `count()` method.

<details>
  <summary>No, really. Try it on your own first.</summary>


```r
hot100 %>% 
  filter(
    week_position == 1,
    week_id > "2015-12-31"
  ) %>% 
  distinct(song, performer) %>% 
  count(performer, sort = T, name = "top_hits") %>% 
  filter(top_hits > 1)
```

```
## # A tibble: 10 × 2
##    performer      top_hits
##    <chr>             <int>
##  1 Drake                 5
##  2 Ariana Grande         3
##  3 Taylor Swift          3
##  4 BTS                   2
##  5 Cardi B               2
##  6 Ed Sheeran            2
##  7 Justin Bieber         2
##  8 Olivia Rodrigo        2
##  9 The Weeknd            2
## 10 Travis Scott          2
```

</details>

### Group on your own

1. Find the same results as above, but using the `group_by()` and `summarize()` method instead of count.

No hints this time ;-).

## Top 10 hits overall

Which performer had the most Top 10 hits overall?

This time we'll talk through the logic, but you have to figure out the answer on your own using the group_by/summarize method.

The logic is very similar to the "most No. 1 hits" quest you did above, but you need to adjust your filter to find songs within position 1 through 10. Don't overthink it, but do recognize that the "top" of the charts are smaller numbers.

1. Make a new section
1. Describe what you are doing
1. Do it using the group_by/summarize method
1. Filter to cut off at a logical number or rows. (i.e., don't stop at a tie)





### A shortcut: count()

You are going to think I'm a horrible person, but there is an easier way to do this ...

We count stuff in data science (and journalism) all the time. Because of this tidyverse has a shortcut to group and count rows of data. I needed to show you the long way because a) we will use `group_by()` and `summarize()` with other math that isn't just counting rows, and b) you need to understand what is happening when you use `count()`, which is really just using group_by/summarize underneath.

The [`count()`](https://dplyr.tidyverse.org/reference/count.html) function takes the columns you want to group and then does the summarize on `n()` for you:


```r
hot100 %>% 
  count(performer)
```

```
## # A tibble: 10,061 × 2
##    performer                                n
##    <chr>                                <int>
##  1 "? (Question Mark) & The Mysterians"    33
##  2 "'N Sync"                              172
##  3 "'N Sync & Gloria Estefan"              20
##  4 "'N Sync Featuring Nelly"               20
##  5 "'Til Tuesday"                          53
##  6 "\"Groove\" Holmes"                     14
##  7 "\"Little\" Jimmy Dickens"              10
##  8 "\"Pookie\" Hudson"                      1
##  9 "\"Weird Al\" Yankovic"                 91
## 10 "(+44)"                                  1
## # … with 10,051 more rows
```

To get the same pretty table you still have to rename the new column and reverse the sort, you just do it differently as arguments within the `count()` function. You must still pipe into `head()` to limit the output. You can view the [`count()` options here.](https://dplyr.tidyverse.org/reference/count.html)

- Add this chunk to your notebook (with a note you are trying `count()`) so you have it to refer to.


```r
hot100 %>% 
  count(performer, name = "appearances", sort = TRUE) %>%
  head(10)
```

```
## # A tibble: 10 × 2
##    performer     appearances
##    <chr>               <int>
##  1 Taylor Swift         1022
##  2 Elton John            889
##  3 Madonna               857
##  4 Kenny Chesney         758
##  5 Drake                 746
##  6 Tim McGraw            731
##  7 Keith Urban           673
##  8 Stevie Wonder         659
##  9 Rod Stewart           657
## 10 Mariah Carey          621
```

So you have to do the same things get the nice Top 10 table, but when you just need a quick count to get an answer, then `count()` is brilliant.

## Review of what we've learned

We introduced a number of new functions in this lesson, most of them from the [dplyr](https://dplyr.tidyverse.org/) package. Mostly we filtered and summarized our data. Here are the functions we introduced in this chapter, many with links to documentation:

- [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) returns only rows that meet logical criteria you specify.
- [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) builds a summary table _about_ your data. You can count rows [`n()`](https://dplyr.tidyverse.org/reference/n.html) or do math on numerical values, like `mean()`.
- [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) is often used with `summarize()` to put data into groups before building a summary table based on the groups.
- [`count()`](https://dplyr.tidyverse.org/reference/count.html) is a shorthand for the group_by/summarize operation to count rows based on groups. You can name your summary columns and sort the data within the same function.
- [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html) returns rows based on unique values in columns you specify. i.e., it deduplicates data.

## Turn in your project

1. Make sure everything runs properly (Restart R and Run All Chunks) and then Knit to HTML.
1. Zip the folder.
1. Upload to the Canvas assignment.

## Soundtrack for this assignment

This lesson was constructed with the vibes of [The Bright Light Social Hour](https://www.thebrightlightsocialhour.com/home). They've never had a song on the Hot 100 (at least not through 2020).

## Leftovers



### Complex filters

Don't do these, but you'll need them for reference later:

If you want single expression with multiple criteria, you write two equations and combine with `&`. Only rows with both sides being true are returned.

```r
# gives you only Poor Little Fool rows where song is No. 1, but not any other position
filter(song == "Poor Little Fool" & week_position == 1)
```

If you want an "or" filter, then you write two equations with a `|` between them.

> `|` is the _Shift_ of the `\` key above Return on your keyboard. That `|` character is also sometimes called a "pipe", which gets confusing in R with ` %>% `.)

```r
# gives you Taylor or Drake songs
filter(performer == "Taylor Swift" | performer == "Drake")
```

If you have multiple criteria, you separate them with a comma `,`. Note I've also added returns to make it more readable.

```r
# gives us rows with either Taylor Swift or Drake, but only those at No. 1
filter(
  performer == "Taylor Swift" | performer == "Drake",
  week_position == 1
)
```

Getting back to our quest to find the artist with the most No. 1 hits ...

If you look at our original filter result, you now only have No. 1 songs. But also note that Ricky Nelson's _Poor Little Fool_ is listed more than once (as are other songs.) That's because it was No. 1 on more than one week.
