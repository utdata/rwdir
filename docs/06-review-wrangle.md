# Review - Data wrangling

For practice, we are going to import some marijuana arrests data from the Austin Police Department. The data was obtained through an open records request as an Excel spreadsheet, which will be new for us. I've removed the names of the suspects.

Our goal here is to practice some of what we've learned already, but because this is a new data set, there will also be new challenges. We'll continue to learn new things as we progress.

If a step in the process is something we've done before, I'll give brief directions. If something is new, I'll provide more detail and explanation.

## Start a new project

A new project means we start from scratch. Close out any previous project work you have open.

> It is possible to have two RStudio projects open at the same time, but you'll need open the second one as a "new session". It is also possible to open notebooks from different projects in the same session, but I would not recommend that.

- Use the +R icon or File > New Project.
- Go through the steps to create a new folder in a place where you can find it later. For the purposes of this class, name it `yourname-arrests`.
- Use the Files panel to create two new folders called `data-raw` and `data-processed`. (I name my folders like this so all the data folders are together when I view them.)
- Create a new RNotebook called `01-import.Rmd`, update the metadata at the top and remove the boilerplate code.
- Create a chunk called "setup" and add the tidyversejanitor libraries.



## Downloading our data

Like with our special education data, we're going to download our data using the `download.file()` function.

- Create an R chunk called "download" and add the following code:



- Introduce pot data
- Get to point for cleaning chapter
