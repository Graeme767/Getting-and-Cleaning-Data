---
title: "Getting and Cleaning Data Project"
author: "Graeme"
date: "02/08/2020"
output: html_document
---

This repository contains work done for a peer reviewed review assignment as a requirement for the Getting and Cleaning data module, which forms part of the Data Science Specialization course on Coursera.

The goal of the project is to take separate text files containing data from the Galaxy S phone activity tracking measurements from gyroscopes and accelerometers and to combine these files into a single, tidy data set, which is then saved as a text file.

Asside from this README file, this repository contains a codebook detailing how the final tidy data set was obtained, the base R script and the text file containing the final data set.

The run_analysis.R is structured as follows:

* Clear working directory
* Import required library
* Extract and read data
* Join test and train data
* Variable extraction based on variable name
* Renaming the variables
* Calculating the average of each number of variable per subject and activity
* Export data

For a more detailed description of the script, refer to codeBook.md.
