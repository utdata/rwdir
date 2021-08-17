# Old - Summarize

## MIDDLE OF REWRITE VERSON

## Summarize()

The `summarize()` and `summarise()` functions compute tables _about_ your data. They are the same function, as R supports both the American and European spelling of summarize. I don't care which you use.

![Learn about your data with Summarize()](images/transform-summarise.png){width=600px}

Much like the `mutate()` function, we list the name of the new column first, then assign to it the function we want to accomplish using `=`.

Let's find the average `borehole_depth` of all the wells.

![Attempt to find the mean](images/transform-wells-nanowork.png)

But, our return isn't good? What's up with that?

### ignoring na

In short, you can't divide by zero or a NULL or NA value. I'll show you how to ignore them, but first we should find out how many there are:

![Find NA values](images/transform-wells-findna.png)

Take a look at this and guess what is happening. Clearly `is.na` is a thing. How is it being used?

There are 22 records returned out of 18k+. Can we safely exclude them without affecting the results? I think so.

We can apply a similar function `na.rm` function inside our `summarise()` function to remove the missing values before the calculation, like this:

![NAs removed from summarize](images/transform-wells-narm.png)

A mean (or average in common terms) is a way to use one number to represent a group of numbers. It works well when the variance in the numbers is not great. Median is another way, and sometimes better when there are high or low numbers that would unduly influence a mean.

### Your turn with summarise

Like filter and mutate, you can do more than one calculation within a summarize function. Edit the code chunk above in two ways:

- Make sure to name the code chunk, something like `depth_summaries`.
- Modify the summarize function to also create a `median_depth` summary. Look at your dplyr cheat sheet or google to find out how.




## Group_by()

The `summarise()` function is an especially useful in combination with another function called `group_by()`, which allows us to pivot tables to count and measure data by its values.

![Group by](images/transform-groupby.png)

This is easier to understand when you can see an example, so let's do it.

### Group and count

So, we have more than 18,000 wells, but we don't know how many of each kind. We could filter them one-by-one, but there is an easier way.

![Group and count](images/transform-wells-groupbyn.png)

Let's break this down:

- We start with the **wells** data frame.
- We then **group_by** the data by the `proposed_use`. If we print the data frame at this point, we won't really see a difference. The `group_by()` function always needs another function to see a result.
- We then **summarise** the grouped data. In this case, we are creating a column called `count`, and we are assigning to is a special function `n()` which counts the number of records within each group.
    + The result is for each unique value in the **prospose_use** column, we get the number of records that have that have that value.
- We then **arrange** the resulting table in descending order by our new column, `count`, so we can see which value has the most records.

We can see that "Domestic" wells are more prevalent by a wide margin. If page through the list, you'll see that to get an accurate count of each type of well, we'll need to do some data cleaning. We'll do that at another time.

Let's walk through another example:

![Group and summarise](images/transform-group-summarise.png)

### Your turn to group

- How many wells were drilled in each county? Use the same `group_by` and `summarise` method to make a table that counts wells drilled in each county.
- Since you can `summarise` by more than one thing, try to find the count and average (mean) borehole_depth of wells by proposed use. You can copy the first summary we did and work from that, editing the `summarise` statement.

### Counting only

We'll use summarize to do more than count, but if counting  is all you want to know, there is an easier way. (I'll try not to show you too many alternate methods ... there are many ways to do everything, but this is worth knowing.)

```r
well %>% 
  count(proposed_use)
```

It creates a column named "n" with the count. You could _then_ use `rename(new = old)` to call it something else, like "wells_drilled".

