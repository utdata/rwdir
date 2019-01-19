# Introduction to R {#intro}

## RStudio tour

When you launch RStudio, you'll get a screen that looks like this:

![Rstudio launch screen](images/intro-start.png){width=100%}

## Updating preferences

There is a preference in RStudio that I would like you to change. By default, the program wants to save a the state of your work (all the variables and such) when you close a project, but that is not good practice. We'll change that.

- Go to the **RStudio** menu and choose **Preferences**
- Under the **General** tab, uncheck the first four boxes
- On the option "Save Workspace to .Rdata on exit", change that to **Never**.
- Click *OK* to close the box.

## Starting a new Project

When we work in RStudio, we will create "Projects" to hold all the files related to one another. This sets the "working directory", which is a sort of home base for the project.

- Click on the second button that has a green `+R` sign.
- That brings up a box to create the project with several options. You want **New Directory** (unless you already have a Project directory, which you don't for this.)
- For **Project Type**, choose **New Project**.
- Next, for the **Directory name**, choose a new name for your project folder. For this project, use "firstname-first-project" but use YOUR firstname.

I want you to be anal about naming your folders. It's a good programming habit.

- Use lowercase characters.
- Don't use spaces. Use dashes.
- For this class, start with your first name.

![Rstudio project name, directory](images/intro-newproject.png){width=400px}

When you hit **Create Project**, your RStudio window will refresh and you'll see the `yourfirstname-first-project.Rproj` file in your Files list.

## Using R Notebooks

For this class, we will almost always use [R Notebooks](https://rmarkdown.rstudio.com/lesson-10.html). This format allows us to write text in between our blocks of code. The text is written in a language called [R Markdown](https://rmarkdown.rstudio.com/lesson-1.html), a juiced-up version of the common documentation syntax used by programmers, Markdown. It's not hard to learn. Here's a [Markdown guide](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf).

### Create your first notebook

- Click on the button at the top-left of RStudio that has just the green `+` sign.
- Choose the item **R Notebook**.

This will open a new file with some boilerplate R Markdown code.

- At the top between the `---` marks, is the **metadata**. This is written using YAML, and what is inside are commands for the R Notebook. Don't sweat the YAML syntax too much right now, as we won't be editing it often.
- Next, you'll see a couple of paragraphs of text that describes how to use an R Notebooks. It is written in R Markdown, and has some inline links and bold commands, which you will learn,
- Then you will see an R code chunk that looks like the figure below.

![R code chunk](images/intro-rcodechunk.png){width=600px}

Let's take a closer look at this:

- The three back tick characters ( found at the top left on your keyboard) followed by the `{r}` indicate that this is a chunk of R code. The last three back ticks say the code chunk is over.
- The `{r}` bit can have some parameters added to it. We'll get into that later.
- The line `plot(cars)` is R programming code. We'll see what those commands do in a bit.
- The green right-arrow to the far right is a play button to run the code that is inside the chunk.
- The green down-arrow and bar to the left of that runs all the code in the Notebook up to that point.

### Save the .Rmd file

- Do command-s or hit the floppy disk icon to save the file.
- It will ask you what you want to name this file. Call it `01-first-file.Rmd`.

When you do this, you may see another new file created in your Files directory. It's the pretty version of the notebook which we'll see in a minute.

In the metadata portion of the file, give your notebook a better title.

- Replace "R Notebook" in the `title: "R Notebook"` code to be "Christian's first notebook", but use your name.

### Run the notebook

There is only one chunk to run in this notebook, so:

- Click on the green right-arrow to run the code.

You should get something like this:

![Cars plot](images/intro-defaultplot.png){width=600px}

What you've done here is create a plot chart of a piece of sample data that is already inside R. (FWIW, It is the speed of cars and the distances taken to stop. Note that the data were recorded in the 1920s.)

But that wasn't a whole lot of code to see there is a relationship with speed vs stopping distance, eh?

### Adding new code chunks

The text after the chart describes how to insert a new code chunk. Let's do that.

- Add a return after the paragraph of text about code chunks, but before the next bit about previews.
- Use the keys *Cmd+Option+I* to add the chunk.
- Your cursor will be inserted into the middle of the chunk. Type in this code in the space provided:

```r
# update 52 to your age
age = 52
(age - 7) * 2
```

- Change for "52" to your real age.
- With your cursor somewhere in the code block, use the key command *Cmd+Shift+Return*, which is the key command to RUN ALL LINES of code chunk.
- NOTE: To run an individual line, use *Cmd+Return* while on that line.

Congratulations! The answer given at the bottom of that code chunk is the [socially-acceptable maximum age of anyone you should date](https://www.psychologytoday.com/us/blog/meet-catch-and-keep/201405/who-is-too-young-or-too-old-you-date).

Throwing aside whether the formula is sound, let's break down the code.

- `# update 52 to your age` is a comment. It's a way to explain what is happening in the code without being considered part of the code.
- `age = 52` is assigning a number (`52`) to a variable name (`age`). A variable is a placeholder. It can hold numbers, text or even groups of numbers. They are key to programming because they allow you to change the value of the variable as you go along.
- The next part is simple math: `(age - 7) * 2` takes the value of `age` and subtracts `7`, then multiplies by `2`.
- When you run it, you get `[1] 90`. That means there was one observation, and the value was "90". For the record, my wife is _much_ younger than that.

Now you can play with the age variable assignment to test out different ages.

### Practice adding code chunks

Now, on your own, add a similar code chunk that calculates the minimum age of someone you should date, but using the formula `(age / 2) + 7`. Add a comment in the code that explains what it is for.

### Preview the report

The rest of the boilerplate text here describes how you can *Preview* and *Knit* a notebook. Let's do that now.

- Press *Cmd+Shift+K* to open a Preview.

This will open a new window and show you the "pretty" notebook that we are building.

Preview is a little different than *Knit*, which runs all the code, then creates the new knitted HTML document. It's **Knit to HMTL** that you'll want to do before turning in your assignments.

### The toolbar

One last thing to point out before we turn this in: The toolbar that runs across the top of the R Notebook file window. The image below explains some of the more useful tools, but you _REALLY_ should learn and use keyboard commands when they are available.

![R Notebook toolbar](images/intro-toolbar.png){width=600px}

### Knit the final workbook

- Save your File with *Cmd+S*.
- Use the **Knit** button in the toolbar to choose **Knit to HTML**.

## Turning in our projects

If you now look in your Files pane, you'll see you have four files in our project.  (Note the only one you actually edited was the `.Rmd` file.)

![Files list](images/intro-files.png){width=500px}

The best way to turn in all of those files into Canvas is to compress them into a single `.zip` file that you can upload to the assignment.

- In your computer's Finder, open the `Documents/rwd` folder.
- Follow the directions for your operating system linked below to create a compressed version of your `yourname-final-project` folder.
- [Compress files on a Mac](http://www.macinstruct.com/node/159).
- [Compress flies on Windows](https://www.laptopmag.com/articles/how-to-zip-files-windows-10).
- Upload the resulting `.zip` file to the assignment for this week in Canvas.

Here is what the compression steps looks like on a Mac:

![Compress file: Mac](images/intro-compress.gif){width=400px}

If you find you make changes to your R files after you've zipped your folder, you'll need to delete the `zip` file and do it again.

Because we are building "repeatable" code, I'll be able to download your `.zip` files, uncompress them, and the re-run them to get the same results.

Well done! You've completed the first level and earned the _Beginner_ badge.

