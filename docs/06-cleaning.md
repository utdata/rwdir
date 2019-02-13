# Cleaning {#cleaning}

## Goals for this section

- Create a new notebook for cleaning data
- Throughout the notebook, we want to explain our thoughts and goals in Markdown. Each code block should have a human readable explanation of the goal or task.
- Import most recent data
- Create cleaned proposed_use column
- Export data for next notebook

### Resources

- [Strings](https://r4ds.had.co.nz/strings.html) chapter from Hadley Wickham's book, specifically about [`str_replace()`](https://r4ds.had.co.nz/strings.html#replacing-matches).
- [RDocumentation](https://www.rdocumentation.org/packages/stringr/versions/1.3.1/topics/str_replace) on `str_replace()`.
- [stringr cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/strings.pdf).

## Taking stock of the data

As we were looking at the `proposed_use` field in the wells data, we found that the values there were pretty dirty, with misspellings and unofficial designations. If we look at the official designations for Proposed Use on [page 10 of the data user manual ](http://www.twdb.texas.gov/groundwater/data/doc/TWRSRS_UserManual.pdf?d=43539.49999999895), we see there are 14 official designations, none with any of various spellings of [Piezo](https://en.wikipedia.org/wiki/Piezometer), which looks to be monitor wells.

We need to create a clean version of the `proposed_use` column to use with our analysis and visualizations. Typically when I discover a situation like this, I go back to my first "import and cleaning" notebook and make changes there so the work can carry through to all subsequent notebooks, but in this case we'll just make our changes in a new notebook and then document and export the changes for future work.




## Setup and import

- Create a new R Notebook with a title "Wells cleaning" and a filename of `03-wells-cleaning.Rmd`.
- In Markdown, write down our purpose and goals in your own words.
- Set up the tidyverse library and import the `data/wells_02.rds` file that we exported at the end of our last notebook. (If you don't recall how to do this, look at your last notebook, but update the code to reflect the new filename.) For this block and all others, make sure you have a Markdown description of the goal or task.

## Clean the proposed_use column

### Count values in a column

Let's look again at the the values in the `proposed_use` column of the wells data. One way to see all the unique values and also find out how many there are is to use the `count()` function, which is a simple pivot table.

```r
wells %>% 
  count(proposed_use)
```

Which gives us a list that looks something like this:

| proposed_use                        |    n |
|:------------------------------------|-----:|
| AG WELL                             |    3 |
| Closed-Loop Geothermal              |  246 |
| Commercial                          |    1 |
| De-watering                         |   33 |
| Domestic                            | 8408 |
| Environmental Soil Boring           | 3719 |
| Ground Well for Electric Substation |    2 |
| Industrial                          |  102 |
| Injection                           |   61 |
| Irrigation                          | 1493 |
| IRRIGATION/TESTWELL                 |    1 |
| Monitor                             | 3354 |
| Monitor-VMP                         |    2 |
| peizometer                          |    1 |
| Peizometer                          |    8 |
| piezo                               |    1 |
| Piezo                               |   12 |
| piezometer                          |   43 |
| Piezometer                          |   25 |
| Piezometer Installation             |    1 |
| PLUGGING                            |    1 |
| Public Supply                       |  174 |
| Rig Supply                          |   14 |
| Soil Vapor Monitor                  |   10 |
| Stock                               |  259 |
| Surface Slab Repair                 |    1 |
| Test Well                           |  266 |
| Unknown                             |    5 |
| Vapor Monitoring Point              |    1 |
| VAPOR POINT                         |    1 |

We have 30 different values here that we need to combine into at most 14 categories, which are the official ones listed on [page 10 of the data user manual ](http://www.twdb.texas.gov/groundwater/data/doc/TWRSRS_UserManual.pdf?d=43539.49999999895). After looking through it and doing some Googling, I came to a couple of conclusions:

- Anything named "piezo" or a variant should be a Monitor well.
- Anything named "vapor" should be a Monitor well.
- Anything that isn't on the official list should be Other.

TBH, if I was writing stories about this data, I would call the TWDB and make my sure that my educated assumptions are correct. But they seem reasonable given the documentation.

### Change values in a column

So, our goal here is to create a new column that starts with the value of `proposed_use`, but then we search through the values for things like "piezo" and set them to something more useful.

We'll utilize a stringr function called `str_replace()` using [regular expressions](https://drive.google.com/open?id=1DvAM4lnGJLefo9skD8GgM-_9S1BEhpjJfV86yhJavI0) to do this, within a `mutate()` function, which we know we can use to create or make changes in a column data. And, of course, we need to figure out how to do it before we save it, so let's work through it.

Start by calling the `wells` data frame, then using mutate to create a new column from `proposed_use`, and then count the rows from the new column. For now, it will be the same as it was for `proposed use` but we'll fix that.

```r
wells %>% 
  mutate(
    use_clean = proposed_use
  ) %>% 
  count(use_clean)
```

#### Convert to lowercase

It will be much easier for us to deal with different spellings of words if everything was lower case. "Piezo" is different than "piezo", so let's convert everything to lower case.

```r
wells %>% 
  mutate(
    use_clean = tolower(proposed_use)
  ) %>% 
  count(use_clean)
```

Now our results are all lowercase. It looks something like this:

| use_clean              |   n |
|:-----------------------|----:|
| ag well                |   3 |
| closed-loop geothermal | 246 |
| commercial             |   1 |
| de-watering            |  33 |

#### Clean up the piezo-ish values

We still have four different versions of "piezo" and the like, which need to be labeled as "monitor". You might check make a mental note of how many values you have for "monitor" now so we can be know that value is growing as we fix our piezos. (I have 3354 in our example, but the number will be different when the data is pulled at a later date). We can continue to stack changes inside our `mutate()` function to deal with this using `str_replace()`.

There are three arguments to the [`str_replace()` function](https://www.rdocumentation.org/packages/stringr/versions/1.3.1/topics/str_replace):

- what column are we working on.
- what pattern are we looking for, as a regular expression.
- what value do we want it to be.

We have created a new column `use_clean` that we want to continue to modify, so it is both our target and our source of the mutate.

The pattern we want is anything that starts with the word "piezo" and "peizo" with anything that follows. The regex expression for "anything" is `.*`, so `piezo.*` with catch "piezo", "piezometer" and "piezo installation". We want to set any value with those terms to "monitor", so we set up our string replace function: `str_replace(use_clean, "piezo.*", "monitor")` and add it to our list of mutates:

```r
wells %>% 
  mutate(
    use_clean = tolower(proposed_use),
    use_clean = str_replace(use_clean, "piezo.*", "monitor")
  ) %>% 
  count(use_clean)
```

If we look at the results of that change, we see we are left with the one misspelled "peizometer". We can fix that by adding an "or" section to our search pattern, using the regular expression key `|`.

```r
wells %>% 
  mutate(
    use_clean = tolower(proposed_use),
    use_clean = str_replace(use_clean, "piezo.*|peizo.*", "monitor")
  ) %>% 
  count(use_clean)
```

Check your results and make sure that there are no longer any versions of "piezo" in use_clean.

You can keep stacking these `str_replace()` mutates to clean further values.

#### Your turn: str_replace functions

Now it's up to you to add more mutate strings to clean the rest of the column to get the 14 official "Proposed Use" designations listed below. It would make sense to organize your new mutate lines in logical ways, like perhaps to capture all the terms that would go into "other" together using the `|` in your search pattern, like we did with piezo and peizo example above. Here's the official list:

- closed-loop geothermal
- de-watering
- domestic
- environmental soil boring
- industrial
- injection
- irrigation
- monitor
- other
- public supply
- rig supply
- stock
- test
- unknown

#### Double-check our results

It might make sense to do one last check of our conversions before reassigning all of changes back to the wells data frame. Change the last `count()` function to the following:

```r
  count(use_clean) #change this line
  distinct(proposed_use, use_clean) # to this line
```

The result looks something similar to this:

| proposed_use                        | use_clean                 |
|-------------------------------------|---------------------------|
| Irrigation                          | irrigation                |
| Domestic                            | domestic                  |
| Monitor                             | monitor                   |
| Public Supply                       | public supply             |
| Environmental Soil Boring           | environmental soil boring |
| Closed-Loop Geothermal              | closed-loop geothermal    |
| Industrial                          | industrial                |
| Piezo                               | monitor                   |
| Stock                               | stock                     |
| Piezometer                          | monitor                   |
| Test Well                           | test                      |
| Unknown                             | unknown                   |
| piezometer                          | monitor                   |
| De-watering                         | de-watering               |
| Ground Well for Electric Substation | other                     |
| VAPOR POINT                         | monitor                   |
| Piezometer Installation             | monitor                   |
| Surface Slab Repair                 | other                     |
| Monitor-VMP                         | monitor                   |
| peizometer                          | monitor                   |
| piezo                               | monitor                   |
| Vapor Monitoring Point              | monitor                   |
| Injection                           | injection                 |
| Peizometer                          | monitor                   |
| Commercial                          | other                     |
| IRRIGATION/TESTWELL                 | test                      |
| Soil Vapor Monitor                  | monitor                   |
| PLUGGING                            | other                     |
| AG WELL                             | other                     |
| Rig Supply                          | rig supply                |

This will allow you to double check that all your conversions happened properly.

### Reassign your changes back to the data frame

Once you have all your column changes worked out, you need to fix it up to reassign the values to the data frame, and then **add Markdown commentary above it to explain the purpose of the code chunk**.

- Edit your code chunk to remove the `distinct()` or `count()` functions at the end.
- Edit the code chunk to reassign the values back to `wells`.

```r
wells <- wells %>% 
  mutate(
    use_clean = tolower(proposed_use),
    use_clean = str_replace(use_clean, "piezo.*|peizo.*", "monitor"),
    # your other str_replace items ...
  )
```

## Export your updated data frame

Let's again export our data so we can use it in a new notebook. Since we are in our third notebook of this project, let's name the file `wells_03.rds`.

```r
saveRDS(wells, "data-out/wells_03.rds")
```

## Future addition

While this data doesn't support it, it would be good to have here an example of how you might take a column made up of codes, like school accountability ratings being "M", "I", "A", etc. and convert them to their readable values like like "Met standard", "Needs Improvement" and "Alternative standard".

