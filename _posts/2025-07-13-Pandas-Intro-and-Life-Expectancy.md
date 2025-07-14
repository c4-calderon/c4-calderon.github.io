---
title: 'An Easy Introduction to Pandas'
date: 2025-07-13
permalink: /posts/2025/07/A Light Introduction to Pandas/
tags:
  - Data Analysis
  - Python
  - Pandas
  - Life Expectancy
---

Learn how to use the `pandas` library in Python for data analysis and manipulation. This beginner-friendly guide covers essential pandas functions with hands-on examples using real-world data.

## Introduction

As described on the official [pandas](https://pandas.pydata.org/) site: 
> `pandas` is a fast, powerful, flexible and easy to use open source data analysis and manipulation tool, built on top of the Python programming language.

I this post, we'll explore its main functionalities using the `Life Expectancy at Birth` dataset, available [here](https://clio-infra.eu/Indicators/LifeExpectancyatBirthTotal.html#) and provided by [*Clio Infra*](https://clio-infra.eu/index.html).

**Clio Infra** is a collaborative project, primarily housed at the **International Institute of Social History (IISH)** in the Netherlands, that gathers and provides access to extensive historical data.


```python
# Turn off warnings
import warnings
warnings.filterwarnings("ignore")
```

## 1. Getting Started

You can install `pandas` from your terminal, depending on your Python package manager:

* For `pip` users: 
```
pip install pandas
```
* For `conda` users: 
```
conda install -c conda-forge pandas
```

💡 Tip: If you're using _Anaconda_, pandas usually comes pre-installed.

Then, import `pandas`. It is common to use `pd` as alias:


```python
import pandas as pd
```

## 2. Creating your first dataframe

You can create your dataframe from several Data Structures:


```python
# 1. Python Dictionaries
data = {
    'Team': ['Real Madrid', 'Bayern München', 'Manchester United'],
    'Country': ['Spain', 'Germany', 'England']
}
df = pd.DataFrame(data)

# 2. List of Dictionaries
# each dictionary represents a row
data = [
    {'Team': 'Real Madrid', 'Country': 'Spain'},
    {'Team': 'Bayern München', 'Country': 'Germany'},
    {'Team': 'Manchester United', 'Country': 'England'}
]
df = pd.DataFrame(data)

# 3. List of tuples
# each tuple represents a row
data = [
    ('Real Madrid', 'Spain'),
    ('Bayern München', 'Germany'),
    ('Manchester United', 'England')
]
# Create DataFrame with column names
df = pd.DataFrame(data, columns=['Team', 'Country'])

# 4. NumPy Arrays
# When your data is numerical
import numpy as np
data = np.array([[1,2,3], [4,5,6], [7,8,9]])
df = pd.DataFrame(data, columns=['A', 'B', 'C'])

# 5. Pandas series
# Each series can be a column in a DataFrame
s1 = pd.Series(['Real Madrid', 'Bayern München', 'Manchester United'])
s2 = pd.Series(['Spain', 'Germany', 'England'])
df = pd.DataFrame({'Team': s1, 'Country': s2})

# 6. Reading from a CSV, Excel, JSON and other file formats:
# There are many ways to read data into a DataFrame with pd.read_* methods.
df = pd.read_csv('path_to_your_file.csv')
df = pd.read_excel('path_to_your_file.xlsx')
df = pd.read_json('path_to_your_file.json')


# 7. Reading from a SQL database
import sqlite3
conn = sqlite3.connect('path_to_your_database.db')
df = pd.read_sql_query('SELECT * FROM your_table_name', conn)
```

## 3. Loading the data

As mentioned earlier, we'll be using the dataset _Life Expectancy at Birth_, which is provided as an Excel (`xlsx`) file. This file contains several sheets, including:

* `"Data Clio Infra Format"` (wide format)
* `"Data Long Format"` (tidy format)

Since the Excel file has more than one sheet, we need to explicitly specify which one to load using the `sheet_name` argument in `pandas.read_excel()`:


```python
# Load "Data Clio Infra Format"
df_wide = pd.read_excel('LifeExpectancyatBirth(Total)_Broad.xlsx', sheet_name='Data Clio Infra Format')
# Load "Data Long Format"
df_tidy = pd.read_excel('LifeExpectancyatBirth(Total)_Broad.xlsx', sheet_name='Data Long Format')
```

## 4. Exploring the data

Let's try out some essential exploration methods here:

* **`df.shape`** – Returns the number of rows and columns in the DataFrame.
* **`df.columns`** : – Lists the column names as a pandas `Index` [object](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.dtypes.html)
* **`df.head(n)`** / **`df.tail(n)`** : – Displays the first or last `n` rows; defaults to **5** if `n` is not specified.
* **`df.info()`** – Summarizes the dataset, showing column data types, non-null counts, and memory usage. Useful for identifying missing data.
* **`df.describe()`** – Generates summary statistics for numeric columns (mean, std, min, max, etc.).


```python
# df.shape
print('* The df shape is: ', df_tidy.shape)
```

    * The df shape is:  (12863, 4)
    


```python
# df.columns
print('* df columns: \n', df_tidy.columns)  # Display df columns
```

    * df columns: 
     Index(['ccode', 'country.name', 'year', 'value'], dtype='object')
    


```python
df.head(n)
print('* First 15 rows: \n', df_tidy.head(15))  # Display first 15 rows
```

    * First 15 rows: 
         ccode    country.name  year  value
    0     826  United Kingdom  1543  33.94
    1     826  United Kingdom  1548  38.82
    2     826  United Kingdom  1553  39.59
    3     826  United Kingdom  1558  22.38
    4     826  United Kingdom  1563  36.66
    5     826  United Kingdom  1568  39.67
    6     826  United Kingdom  1573  41.06
    7     826  United Kingdom  1578  41.56
    8     826  United Kingdom  1583  42.70
    9     826  United Kingdom  1588  37.05
    10    826  United Kingdom  1593  38.05
    11    826  United Kingdom  1598  37.82
    12    826  United Kingdom  1603  38.53
    13    826  United Kingdom  1608  39.59
    14    826  United Kingdom  1613  36.79
    


```python
df.tail(n)
print('* Last 8 rows: \n', df_tidy.tail(8))  # Display last 8 rows
```

    * Last 8 rows: 
            ccode    country.name  year  value
    12855    724           Spain  2011  82.40
    12856    752          Sweden  2011  81.76
    12857    756     Switzerland  2011  82.57
    12858    792          Turkey  2011  74.60
    12859    826  United Kingdom  2011  80.80
    12860    840   United States  2011  78.70
    12861    484          Mexico  2012  74.40
    12862    792          Turkey  2012  74.60
    


```python
df.info()
df_tidy.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 12863 entries, 0 to 12862
    Data columns (total 4 columns):
     #   Column        Non-Null Count  Dtype  
    ---  ------        --------------  -----  
     0   ccode         12863 non-null  int64  
     1   country.name  12863 non-null  object 
     2   year          12863 non-null  int64  
     3   value         12863 non-null  float64
    dtypes: float64(1), int64(2), object(1)
    memory usage: 402.1+ KB
    


```python
df.describe()
print('* Some descriptive statistics: \n', df_tidy.describe())
```

    * Some descriptive statistics: 
                   ccode          year         value
    count  12863.000000  12863.000000  12863.000000
    mean     431.595351   1966.640830     58.418561
    std      255.710872     40.737402     13.169179
    min        4.000000   1543.000000     14.491000
    25%      208.000000   1956.000000     47.829000
    50%      417.000000   1974.000000     60.300000
    75%      662.000000   1992.000000     69.823000
    max      894.000000   2012.000000     83.090000
    

## 5. Selecting and Filtering Data


```python
# Select a specific column
df_wide['country name']
```




    0      Afghanistan
    1          Albania
    2          Algeria
    3          Andorra
    4           Angola
              ...     
    193      Venezuela
    194        Vietnam
    195          Yemen
    196         Zambia
    197       Zimbabwe
    Name: country name, Length: 198, dtype: object




```python
# Filter rows based on a condition
df_wide[df_wide['country name'] == 'Germany']
```




<div class="table-container">
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ccode</th>
      <th>country name</th>
      <th>1500</th>
      <th>1501</th>
      <th>1502</th>
      <th>1503</th>
      <th>1504</th>
      <th>1505</th>
      <th>1506</th>
      <th>1507</th>
      <th>...</th>
      <th>2041</th>
      <th>2042</th>
      <th>2043</th>
      <th>2044</th>
      <th>2045</th>
      <th>2046</th>
      <th>2047</th>
      <th>2048</th>
      <th>2049</th>
      <th>2050</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>63</th>
      <td>276.0</td>
      <td>Germany</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>1 rows × 553 columns</p>
</div>




```python
# Select multiple columns
df_wide[['ccode', 'country name', '2000']]
```




<div class="table-container">
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ccode</th>
      <th>country name</th>
      <th>2000</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>4.0</td>
      <td>Afghanistan</td>
      <td>55.818</td>
    </tr>
    <tr>
      <th>1</th>
      <td>8.0</td>
      <td>Albania</td>
      <td>75.404</td>
    </tr>
    <tr>
      <th>2</th>
      <td>12.0</td>
      <td>Algeria</td>
      <td>69.403</td>
    </tr>
    <tr>
      <th>3</th>
      <td>20.0</td>
      <td>Andorra</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>24.0</td>
      <td>Angola</td>
      <td>47.242</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>193</th>
      <td>862.0</td>
      <td>Venezuela</td>
      <td>72.766</td>
    </tr>
    <tr>
      <th>194</th>
      <td>704.0</td>
      <td>Vietnam</td>
      <td>74.376</td>
    </tr>
    <tr>
      <th>195</th>
      <td>887.0</td>
      <td>Yemen</td>
      <td>60.981</td>
    </tr>
    <tr>
      <th>196</th>
      <td>894.0</td>
      <td>Zambia</td>
      <td>43.944</td>
    </tr>
    <tr>
      <th>197</th>
      <td>716.0</td>
      <td>Zimbabwe</td>
      <td>43.074</td>
    </tr>
  </tbody>
</table>
<p>198 rows × 3 columns</p>
</div>



There is a particularly useful method for reshaping data, from wide to long (tidy) format:
* **`df.melt()`** - Unpivots a DataFrame from wide to long format, optionally leaving identifiers set.


```python
# df.melt()
df_long_reshaped = df_wide.melt(
    id_vars=["ccode", "country name"],
    var_name="year",
    value_name="life_expectancy"
)
print(df_long_reshaped)
```

            ccode country name  year  life_expectancy
    0         4.0  Afghanistan  1500              NaN
    1         8.0      Albania  1500              NaN
    2        12.0      Algeria  1500              NaN
    3        20.0      Andorra  1500              NaN
    4        24.0       Angola  1500              NaN
    ...       ...          ...   ...              ...
    109093  862.0    Venezuela  2050              NaN
    109094  704.0      Vietnam  2050              NaN
    109095  887.0        Yemen  2050              NaN
    109096  894.0       Zambia  2050              NaN
    109097  716.0     Zimbabwe  2050              NaN
    
    [109098 rows x 4 columns]
    

## 6. Data Cleaning & Transformation

You can perform common data cleaning steps like removing missing values, change column types, apply filters to columns, etc.:


```python
# Remove missing values: 
df_clean = df_long_reshaped.dropna()
print(df_clean)
```

            ccode    country name  year  life_expectancy
    8702    826.0  United Kingdom  1543            33.94
    9692    826.0  United Kingdom  1548            38.82
    10682   826.0  United Kingdom  1553            39.59
    11672   826.0  United Kingdom  1558            22.38
    12662   826.0  United Kingdom  1563            36.66
    ...       ...             ...   ...              ...
    101360  792.0          Turkey  2011            74.60
    101366  826.0  United Kingdom  2011            80.80
    101367  840.0   United States  2011            78.70
    101486  484.0          Mexico  2012            74.40
    101558  792.0          Turkey  2012            74.60
    
    [12863 rows x 4 columns]
    


```python
# Change column types
# Types: int, float, str, datetime
df_clean['ccode'] = df_clean['ccode'].astype(str)  # Convert ccode to string
df_clean['year'] = df_clean['year'].astype(int)  # Convert year to integer
df_recent = df_clean[df_clean['year'] >= 1900]  # Filter for years >= 1900
print(df_recent.head())
```

           ccode country name  year  life_expectancy
    79206   32.0    Argentina  1900            39.00
    79215  112.0      Belarus  1900            36.20
    79216   56.0      Belgium  1900            46.52
    79220   68.0      Bolivia  1900            26.00
    79223   76.0       Brazil  1900            29.00
    

You can also aggregate and group your data:


```python
# Calculate average life expectancy by country:
df_avg = df_recent.groupby("country name")["life_expectancy"].mean() # This creates a Series
print(df_avg.head(20)) # Display first 20 countries (not sorted)
```

    country name
    Afghanistan            42.663000
    Albania                68.503417
    Algeria                56.556863
    Angola                 39.204262
    Antigua and Barbuda    68.070833
    Argentina              66.313214
    Armenia                69.127750
    Australia              71.639457
    Austria                71.270464
    Azerbaijan             64.466500
    Bahamas                67.921167
    Bahrain                65.131667
    Bangladesh             54.104516
    Barbados               67.410583
    Belarus                69.245032
    Belgium                66.172056
    Belize                 66.812083
    Benin                  46.939250
    Bhutan                 45.805167
    Bolivia                50.594545
    Name: life_expectancy, dtype: float64
    


```python
# Sort countries by average life expectancy:
df_avg = df_avg.sort_values(ascending=False)
print(df_avg.head(20)) # Display Top 20 countries (sorted)
```

    country name
    Israel            74.617258
    New Zealand       74.058437
    Cyprus            72.087554
    Slovenia          71.932790
    Singapore         71.745750
    Ireland           71.730294
    Germany           71.690020
    Australia         71.639457
    Austria           71.270464
    Greece            70.716540
    Montenegro        70.364417
    Czech Republic    70.343263
    Canada            70.232913
    Qatar             70.040333
    Poland            70.022444
    Japan             70.009652
    Croatia           69.861000
    Slovakia          69.808000
    Sweden            69.701964
    Norway            69.603929
    Name: life_expectancy, dtype: float64
    

## 7. Common Data Operations

Here are some common data operations:


```python
# Rename columns
df_clean = df_clean.rename(columns={"country name": "country"})
print(df_clean.head())
```

           ccode         country  year  life_expectancy
    8702   826.0  United Kingdom  1543            33.94
    9692   826.0  United Kingdom  1548            38.82
    10682  826.0  United Kingdom  1553            39.59
    11672  826.0  United Kingdom  1558            22.38
    12662  826.0  United Kingdom  1563            36.66
    


```python
# Sort by columns
df_clean = df_clean.sort_values(by="life_expectancy", ascending=False)
print(df_clean)
```

            ccode   country  year  life_expectancy
    100865  392.0     Japan  2009           83.090
    101063  392.0     Japan  2010           82.900
    100667  392.0     Japan  2008           82.750
    101261  392.0     Japan  2011           82.700
    101259  380.0     Italy  2011           82.700
    ...       ...       ...   ...              ...
    94276   116.0  Cambodia  1976           14.491
    94078   116.0  Cambodia  1975           14.491
    94474   116.0  Cambodia  1977           14.491
    94672   116.0  Cambodia  1978           14.491
    94870   116.0  Cambodia  1979           14.491
    
    [12863 rows x 4 columns]
    


```python
# Create new columns
# Round life expectancy to 1 decimal
df_clean['life_expectancy_rounded'] = df_clean['life_expectancy'].round(1)
print(df_clean.head())
```

            ccode country  year  life_expectancy  life_expectancy_rounded
    100865  392.0   Japan  2009            83.09                     83.1
    101063  392.0   Japan  2010            82.90                     82.9
    100667  392.0   Japan  2008            82.75                     82.8
    101261  392.0   Japan  2011            82.70                     82.7
    101259  380.0   Italy  2011            82.70                     82.7
    


```python
# Apply a function to a column
df_clean['life_expectancy_category'] = df_clean['life_expectancy'].apply(lambda x: 'High' if x > 70 else 'Low')
print(df_clean)
```

            ccode   country  year  life_expectancy  life_expectancy_rounded  \
    100865  392.0     Japan  2009           83.090                     83.1   
    101063  392.0     Japan  2010           82.900                     82.9   
    100667  392.0     Japan  2008           82.750                     82.8   
    101261  392.0     Japan  2011           82.700                     82.7   
    101259  380.0     Italy  2011           82.700                     82.7   
    ...       ...       ...   ...              ...                      ...   
    94276   116.0  Cambodia  1976           14.491                     14.5   
    94078   116.0  Cambodia  1975           14.491                     14.5   
    94474   116.0  Cambodia  1977           14.491                     14.5   
    94672   116.0  Cambodia  1978           14.491                     14.5   
    94870   116.0  Cambodia  1979           14.491                     14.5   
    
           life_expectancy_category  
    100865                     High  
    101063                     High  
    100667                     High  
    101261                     High  
    101259                     High  
    ...                         ...  
    94276                       Low  
    94078                       Low  
    94474                       Low  
    94672                       Low  
    94870                       Low  
    
    [12863 rows x 6 columns]
    

## 8. Working with Dates

Since our example DataFrame only contains years, we'll add a new column with the date set to January 1st of each year:


```python
# Concatenate the `year` with January 1st ('-01-01') to create the column date
# Please take into account that year is an integer, so we need to convert it to string first
df_clean['date'] = pd.to_datetime(df_clean['year'].astype(str) + '-01-01', format='%Y-%m-%d')
print(df_clean)

```


    ---------------------------------------------------------------------------

    OverflowError                             Traceback (most recent call last)

    File pandas/_libs/tslibs/strptime.pyx:415, in pandas._libs.tslibs.strptime.array_strptime()
    

    OverflowError: Overflow occurred in npy_datetimestruct_to_datetime

    
    The above exception was the direct cause of the following exception:
    

    OutOfBoundsDatetime                       Traceback (most recent call last)

    Cell In[130], line 3
          1 # Concatenate the year with January 1st ('-01-01') to create the column date
          2 # Please take into account that year is an integer, so we need to convert it to string first
    ----> 3 df_clean['date'] = pd.to_datetime(df_clean['year'].astype(str) + '-01-01', format='%Y-%m-%d')
          4 print(df_clean)
    

    File c:\Users\thorc\miniconda3\envs\ds_env\Lib\site-packages\pandas\core\tools\datetimes.py:1068, in to_datetime(arg, errors, dayfirst, yearfirst, utc, format, exact, unit, infer_datetime_format, origin, cache)
       1066             result = arg.tz_localize("utc")
       1067 elif isinstance(arg, ABCSeries):
    -> 1068     cache_array = _maybe_cache(arg, format, cache, convert_listlike)
       1069     if not cache_array.empty:
       1070         result = arg.map(cache_array)
    

    File c:\Users\thorc\miniconda3\envs\ds_env\Lib\site-packages\pandas\core\tools\datetimes.py:249, in _maybe_cache(arg, format, cache, convert_listlike)
        247 unique_dates = unique(arg)
        248 if len(unique_dates) < len(arg):
    --> 249     cache_dates = convert_listlike(unique_dates, format)
        250     # GH#45319
        251     try:
    

    File c:\Users\thorc\miniconda3\envs\ds_env\Lib\site-packages\pandas\core\tools\datetimes.py:435, in _convert_listlike_datetimes(arg, format, name, utc, unit, errors, dayfirst, yearfirst, exact)
        433 # `format` could be inferred, or user didn't ask for mixed-format parsing.
        434 if format is not None and format != "mixed":
    --> 435     return _array_strptime_with_fallback(arg, name, utc, format, exact, errors)
        437 result, tz_parsed = objects_to_datetime64(
        438     arg,
        439     dayfirst=dayfirst,
       (...)    443     allow_object=True,
        444 )
        446 if tz_parsed is not None:
        447     # We can take a shortcut since the datetime64 numpy array
        448     # is in UTC
    

    File c:\Users\thorc\miniconda3\envs\ds_env\Lib\site-packages\pandas\core\tools\datetimes.py:469, in _array_strptime_with_fallback(arg, name, utc, fmt, exact, errors)
        458 def _array_strptime_with_fallback(
        459     arg,
        460     name,
       (...)    464     errors: str,
        465 ) -> Index:
        466     """
        467     Call array_strptime, with fallback behavior depending on 'errors'.
        468     """
    --> 469     result, tz_out = array_strptime(arg, fmt, exact=exact, errors=errors, utc=utc)
        470     if tz_out is not None:
        471         unit = np.datetime_data(result.dtype)[0]
    

    File pandas/_libs/tslibs/strptime.pyx:501, in pandas._libs.tslibs.strptime.array_strptime()
    

    File pandas/_libs/tslibs/strptime.pyx:418, in pandas._libs.tslibs.strptime.array_strptime()
    

    OutOfBoundsDatetime: Out of bounds nanosecond timestamp: 1583-01-01, at position 181. You might want to try:
        - passing `format` if your strings have a consistent format;
        - passing `format='ISO8601'` if your strings are all ISO8601 but not necessarily in exactly the same format;
        - passing `format='mixed'`, and the format will be inferred for each element individually. You might want to use `dayfirst` alongside this.


🤔 You might be wondering about this error... 

Well, I left it there on purpose. I just learned that `pandas`'s datetime type (`datetime[ns]`) only supports dates from September 21, 1677 onward.

A quick Google search brought up this explanation:

> The minimal datetime in pandas, represented by a `Timestamp` object, is accessed through `pandas.Timestamp.min`. This value is a fixed lower bound for the `datetime64[ns]` data type used by pandas for efficient date and time handling.
> Specifically, `pandas.Timestamp.min` corresponds to the date and time:

```
Timestamp('1677-09-21 00:12:43.145224193')
```

> This limitation arises because pandas stores timestamps as 64-bit integers representing nanoseconds since the Unix epoch, which limits the representable time span to approximately 584 years.

💡 **How to fix**:

1. Only use `datetime64[ns]` for years after 1677.
2. Reuse the `df_recent` DataFrame we created earlier, which already filters out years before 1900.


```python
# Try again
df_recent['date'] = pd.to_datetime(df_recent['year'].astype(str) + '-01-01', format='%Y-%m-%d')
print(df_recent)
```

            ccode    country name  year  life_expectancy       date
    79206    32.0       Argentina  1900            39.00 1900-01-01
    79215   112.0         Belarus  1900            36.20 1900-01-01
    79216    56.0         Belgium  1900            46.52 1900-01-01
    79220    68.0         Bolivia  1900            26.00 1900-01-01
    79223    76.0          Brazil  1900            29.00 1900-01-01
    ...       ...             ...   ...              ...        ...
    101360  792.0          Turkey  2011            74.60 2011-01-01
    101366  826.0  United Kingdom  2011            80.80 2011-01-01
    101367  840.0   United States  2011            78.70 2011-01-01
    101486  484.0          Mexico  2012            74.40 2012-01-01
    101558  792.0          Turkey  2012            74.60 2012-01-01
    
    [12057 rows x 5 columns]
    


```python
# Extract week and month name from the date
df_recent['week'] = df_recent['date'].dt.isocalendar().week
df_recent['month'] = df_recent['date'].dt.month_name()
print(df_recent)
```

            ccode    country name  year  life_expectancy       date  week    month
    79206    32.0       Argentina  1900            39.00 1900-01-01     1  January
    79215   112.0         Belarus  1900            36.20 1900-01-01     1  January
    79216    56.0         Belgium  1900            46.52 1900-01-01     1  January
    79220    68.0         Bolivia  1900            26.00 1900-01-01     1  January
    79223    76.0          Brazil  1900            29.00 1900-01-01     1  January
    ...       ...             ...   ...              ...        ...   ...      ...
    101360  792.0          Turkey  2011            74.60 2011-01-01    52  January
    101366  826.0  United Kingdom  2011            80.80 2011-01-01    52  January
    101367  840.0   United States  2011            78.70 2011-01-01    52  January
    101486  484.0          Mexico  2012            74.40 2012-01-01    52  January
    101558  792.0          Turkey  2012            74.60 2012-01-01    52  January
    
    [12057 rows x 7 columns]
    

## 9. Merging, Joining and Concatenating

Pandas makes it easy to combine datasets from different sources. Here's how to do it using basic examples:


```python
# DataFrame 1
df_teams = pd.DataFrame({
    'Team': ['Real Madrid', 'Bayern München', 'Manchester United'],
    'Country': ['Spain', 'Germany', 'England']
})

# DataFrame 2
df_titles = pd.DataFrame({
    'Team': ['Real Madrid', 'Bayern München', 'Manchester United'],
    'Champions League Titles': [14, 6, 3]
})
```


```python
# merge() - Merge on a common key
df_merged = pd.merge(df_teams, df_titles, on="Team")
print(df_merged)
```

                    Team  Country  Champions League Titles
    0        Real Madrid    Spain                       14
    1     Bayern München  Germany                        6
    2  Manchester United  England                        3
    

Use `how='left'`, `'right'`, `'outer'`, or `'inner'` to control the join type (default is `'inner'`).


```python
# concat() – Concatenate vertically or horizontally

df_extra = pd.DataFrame([
    {'Team': 'Juventus', 'Country': 'Italy'},
    {'Team': 'Ajax', 'Country': 'Netherlands'}
])

df_combined = pd.concat([df_teams, df_extra], ignore_index=True)
print(df_combined)
```

                    Team      Country
    0        Real Madrid        Spain
    1     Bayern München      Germany
    2  Manchester United      England
    3           Juventus        Italy
    4               Ajax  Netherlands
    

You can also concatenate horizontally by setting `axis=1`, for example when combining columns.

## 10. Exporting Data


```python
# Save to CSV and Excel files. index=False prevents writing row indices to the file
df_recent.to_csv("life_expectancy_recent.csv", index=False)
df_avg.to_excel("life_expectancy_average.xlsx", index=False)
```

## 💡Tips and Tricks

Use `.query()` for cleaner filtering:


```python
print(df_recent.query("`country name` == 'Germany' and year > 1960").head(10))
```

           ccode country name  year  life_expectancy       date  week    month
    91341  276.0      Germany  1961             69.7 1961-01-01    52  January
    91539  276.0      Germany  1962             69.9 1962-01-01     1  January
    91737  276.0      Germany  1963             70.0 1963-01-01     1  January
    91935  276.0      Germany  1964             70.5 1964-01-01     1  January
    92133  276.0      Germany  1965             70.5 1965-01-01    53  January
    92331  276.0      Germany  1966             70.6 1966-01-01    52  January
    92529  276.0      Germany  1967             70.8 1967-01-01    52  January
    92727  276.0      Germany  1968             70.4 1968-01-01     1  January
    92925  276.0      Germany  1969             70.3 1969-01-01     1  January
    93123  276.0      Germany  1970             70.6 1970-01-01     1  January
    

Select values with `.loc[]` and `.iloc[]`:


```python
print(df_recent.loc[91935, "country name"])     # label-based
print(df_recent.iloc[0, 1])                     # index-based
```

    Germany
    Argentina
    

## Final thoughts

Pandas is an essential tool for anyone working with data and Python. With just a few lines of code, you can load, clean, reshape, and analyze complex datasets like historical life expectancy.

Thank you for your interest!
