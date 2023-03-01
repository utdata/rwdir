# R Functions {#functions}

An opinionated list of the most common data wrangling functions. It leans heavily into the [Tidyverse](https://www.tidyverse.org/).

## Import/Export

- [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) imports data from a CSV file. (It handles data types better than the base R `read.csv()`). Also `write_csv()` when you need export as CSV. **Example:** `read_csv("path/to/file.csv")`.
- [`write_rds`](https://readr.tidyverse.org/reference/read_rds.html) to save a data frame as an `.rds` R data data file. This preserves all the data types. [`read_rds()`](https://readr.tidyverse.org/reference/read_rds.html) to import R data. **Example:** `read_rds("path/to/file.rds")`.
- [`readxl`](https://readxl.tidyverse.org/) is a package we didn't use, but it has [read_excel()](https://readxl.tidyverse.org/reference/read_excel.html) that allows you to import from an Excel file, including specified sheets and ranges.
- [`clean_names()`](https://cran.r-project.org/web/packages/janitor/vignettes/janitor.html) from the `library(janitor)` package standardizes column names.

## Data manipulation

- [`select()`](https://dplyr.tidyverse.org/reference/select.html) to select columns. **Example:** `select(col01, col02)` or `select(-excluded_col)`.
- [`rename()`](https://dplyr.tidyverse.org/reference/rename.html) to rename a column. **Example:** `rename(new_name = old_name)`.
- [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) to filter rows of data. **Example:** `filter(column_name == "value")`.
  - See [Relational Operators](https://www.rdocumentation.org/packages/base/topics/Logic) like `==`, `>`, `>=` etc.
  - See [Logical operators](https://www.rdocumentation.org/packages/base/topics/Logic) like `&`, `|` etc.
  - See [is.na](https://www.rdocumentation.org/packages/base/topics/NA) tests if a value is missing.
- [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html) will filter rows down to the unique values of the columns given.
- [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) sorts data based on values in a column. Use `desc()` to reverse the order. **Example:** `arrange(col_name %>% desc())`
- [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) changes and existing column or creates a new one. **Example:** `mutate(new_col = (col01 / col02))`.
- [`round()`](https://www.rdocumentation.org/packages/base/topics/Round) is a base R function that can round a number to a set decimal point. Often used within a `mutate()` function.
- [`recode()`](https://dplyr.tidyverse.org/reference/recode.html), [`if_else()`](https://dplyr.tidyverse.org/reference/if_else.html) and [`case_when()`](https://dplyr.tidyverse.org/reference/case_when.html) are all functions that can be used with `mutate()` to create new categorizations with your data.
- [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) "lengthens" data, increasing the number of rows and decreasing the number of columns. **Example:** `pivot_longer(cols = 3:5, names_to = "new_key_col_name", values_to = "new_val_col_name")` will take the third through the fifth columns and turn each value into a new row of data. It will put them into two columns: The first column will have the name you give it in `names_to` and contain the old column name that corresponds to each value pivoted. The second column will have the name of whatever you set in `values_to` and will contain all the values from each of the columns.
- [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html) is the opposite of `pivot_longer()`.  **Example:** `pivot_wider(names_from = col_of_key_values, values_from = col_with_values)`. See the link. 


## Aggregation

- [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) and [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) often come together. When you use `group_by()`, every function after it is broken down by that grouping. We often add [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) to these, calling this our GSA functions. **Example:** `group_by(song, artist) %>% summarize(weeks = n(), top_chart_position = min(peak_position))`. To break or remove groupings, use `ungroup()`.
- [`count()`](https://dplyr.tidyverse.org/reference/count.html) is a shortcut for GSA that count the number rows based on variable groups you feed it.

## Math

These are the function often used within `summarize()`:

- `n()` to count the number of rows. [`n_distinct()`](https://dplyr.tidyverse.org/reference/n_distinct.html) counts the unique values.
- `sum()` to add things together.
- `mean()` to get an average.
- `median()` to get the median.
- `min()` to get the smallest value. `max()` for the largest.
- `+`, `-`, `*`, `/` are math operators similar to a calculator.

