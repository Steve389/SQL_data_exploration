# SQL_data_exploration
Exploratory Data Analysis performed using Structured Query Language.

In this project, I analyzed the official datasets relative to Covid19 deaths and Covid19 vaccinations which I downloaded from the
website [Our World in Data](https://ourworldindata.org).

## 1. Dataset formatting
After downloading the datasets, the first thing I did was a quick pre-formatting on excel; I simply removed unnecessary columns and 
changed the index of specific columns.

## 2. Importing dataset to MySQL with Python
This stage revealed itself to be quite tricky because for some reason (maybe the size of the dataset) I could not import the data 
into MySQL using either the Table Data Import Wizard or the LOAD DATA INFILE function.
As a result, I decided to import the dataset using a Python script. All the code can be found in the 'CSV to SQL connector' file.

## 3. Data Exploration in MySQL
At this point, I could start finding patterns in the dataset through SQL queries.
My analysis focused on answering the following questions:

- Looking at total_deaths per total_cases ratio -->  likelihood of dying if you contract Covid in your country.
- Looking at total_cases vs population --> percentage of populationwho got infected.
- Looking at countries with the highest infection rate.
- Looking at countries with the highest death count.
- Looking at countries with the highest death rate.
- Looking at continents with the highest death count.
- Looking at global figures.
- Looking at number of vaccinations per location and date.
- Looking at incremental number of vaccinations per day vs population.
- Creating views to store data for later visualizations.
