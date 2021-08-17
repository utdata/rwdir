# Verbs {#verbs}

## NEEDS REVIEW

---

An opinionated list of the most common [Tidyverse](https://www.tidyverse.org/) and other R verbs used with data storytelling.

## Import/Export

- [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) imports data from a CSV file. (It handles data types better than the base R `read.csv()`). Also `write_csv()` when you need export as CSV. **Example:** `read_csv("path/to/file.csv")`.
- [`write_rds`](https://readr.tidyverse.org/reference/read_rds.html) to save a data frame as an `.rds` R data data file. This preserves all the data types. [`read_rds()`](https://readr.tidyverse.org/reference/read_rds.html) to import R data. **Example:** `read_rds("path/to/file.rds")`.
- [`readxl`](https://readxl.tidyverse.org/) is a package we didn't talk about, but it has [read_excel()](https://readxl.tidyverse.org/reference/read_excel.html) that allows you to import from an Excel file, including specified sheets.
- [clean_names()]() from the `library(janitor)` package standardizes column names.

## Data manipulation

- [`select()`](https://dplyr.tidyverse.org/reference/select.html) to select columns. **Example:** `select(col01, col02)` or `select(-excluded_col)`.
- [`rename()`](https://dplyr.tidyverse.org/reference/select.html) to rename a column. **Example:** `rename(new_name = old_name)`.
- [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) to filter rows of data. **Example:** `filter(column_name == "value")`.
  - See [Relational Operators](https://www.rdocumentation.org/packages/base/versions/3.5.3/topics/Logic) like `==`, `>`, `>=` etc.
  - See [Logical operators](https://www.rdocumentation.org/packages/base/versions/3.5.3/topics/Logic) like `&`, `|` etc.
  - See [is.na](https://www.rdocumentation.org/packages/base/versions/3.5.3/topics/NA) tests if a value is missing.
- [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html) will filter rows down to the unique values of the columns given.
- [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) sorts data based on values in a column. Use `desc()` to reverse the order. **Example:** `arrange(col_name %>% desc())`
- [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) changes and existing column or creates a new one. **Example:** `mutate(new_col = (col01 / col02))`.
- [`gather()`](https://tidyr.tidyverse.org/reference/gather.html) collapses columns into two, one a key and the other a value. Turns wide data into long. **Example:** `gather(key = "new_key_col_name", value = "new_val_col_name", 3:5)` will gather columns 3 through 5. Can also name columns to gather.
- [`spread()`](https://tidyr.tidyverse.org/reference/spread.html) turns long data into wide by spreading into multiple columns based on as key.

## Aggregation

- [`count()`](https://dplyr.tidyverse.org/reference/tally.html) will count the number rows based on columns you feed it.
- [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) and [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) often come together. When you use `group_by()`, every function after it is broken down by that grouping. **Example:** `group_by(song, artist) %>% summarize(weeks = n(), top_chart_position = min(peak_position))`

## Math

These are the function often used within `summarize()`:

- [`n()`](https://dplyr.tidyverse.org/reference/n.html) to count the number of rows. [`n_distinct()`](https://dplyr.tidyverse.org/reference/n_distinct.html) counts the unique values.
- `sum()` to add things together.
- `mean()` to get an average.
- `median()` to get the median.
- `min()` to get the smallest value. `max()` for the largest.
- `+`, `-`, `*`, `/` are math operators similar to a calculator.

