# Data manipulation {#manipulation}

## Goals of this lesson

- Use the janitor plugin to clean columns names
- Fix data columns and other data types
- Learn filter, arrange and mutate
- Do some pivots to explore the data

## Relaunch the Wells project

- Launch RStudio. It _might_ open to your last project, but I tried to turn that off in preferences our first day. Hollar if that happens.
- Open your Wells project. There are several ways you can accomplish this:
    + If you've had the project open before, you can use the drop down in the top-right of RStudio to see a list of recent projects, and choose it from there.
    + Or, under the **File** menu to **Recent projects** and choose it.
    + Or, under **File** you can use **Open Project...** and go to that folder and choose it.
- Use the **Run** button in the R Notebook toolbar to **Run All** of the chunks, which will load all your data and load the tibble from our last assignment.

## Clean up column names

I'm a bit anal about cleaning up column names in my data frames, because it makes them easier to work with. Well use a function called `clean_names` from the "janitor" package to fix them.

- After your list of things to fix, write a Markdown headline `## Clean column names`. Using the `##` makes this a smaller headline than the title. The more `###` the smaller the headline. The idea is to use these to organize your code and thoughts.
- Explain in text that we'll use janitor to clean the column names.
- Insert a new code chunk (*Cmd+shift+i* should be second nature by now.)
- Insert the name of your `wells_raw` tibble and run it to inspect the column names again.

These are _too_ bad, but they are a mix of upper and lowercase names, and some of them are rather long. We'll try the janitor `clean_names` function first.

- Wrap the tibble name in the clean_names function like this, then rerun it:

```pre
clean_names(wells_raw)
```

> add screenshot
