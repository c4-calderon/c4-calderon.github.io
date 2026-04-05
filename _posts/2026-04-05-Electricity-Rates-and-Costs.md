---
title: "Analysis of Electricity Rates and Costs for the Colombian Regulated Market"
date: 2026-04-05
permalink: /posts/2026/04/electricity-rates/
tags:
  - Data Analysis
  - Python
  - Pandas
  - Numpy
  - Seaborn
  - Electricity Rates
  - Colombian Regulated Electricity Market
---

Analysis of Electricity Rates and Costs for the Colombian Regulated Market

## Introduction

This analysis explores the cost structure of the Colombian regulated electricity market, focusing on how different grid operators and voltage levels impact the final price for consumers. We'll analyze the [Electricity Rates and Costs for the Regulated Market](https://www.datos.gov.co/Minas-y-Energ-a/Tarifas-y-Costos-de-Energ-a-El-ctrica-para-el-Merc/ytme-6qnu/about_data), available via the [National Open Data Platform](https://www.datos.gov.co/).

### The Unitary Cost (CU) Formula

The final price paid by consumers is determined by the formula:
**CU = G + T + D + C + P + R**

Where:

- **G (Generation):** `buy_cost_gm_i` - Cost of purchasing energy from generators.
- **T (Transmission):** `transmission_charge_stn_tm` - High-voltage transport (STN).
- **D (Distribution):** `transmission_charge_sdl_dn_m` - Local low/medium voltage transport (SDL).
- **C (Commercialization):** `retail_margin_n_cvm` - Retail margin.
- **P (Losses):** `cost_g_t_loss_prn_m` - Energy lost during transport.
- **R (Restrictions):** `restrictions_rm` - Technical or operational constraints.

### Understanding Grid Levels

- **Level 1:** Low Voltage (B.T.) - Typically residential and small businesses.
- **Level 2 & 3:** Medium to High Voltage (M.T./A.T.) - Industrial and large commercial users.

> Note: At the time of this analysis, the dataset was last updated on **October 1st, 2025**, so the data may vary slightly when you access it. The datasource currently has 415 rows and 13 columns

You can download the data as JSON format using the API: [https://www.datos.gov.co/resource/ytme-6qnu.json](https://www.datos.gov.co/resource/ytme-6qnu.json)

## 1. Import libraries and load the data

We'll import `pandas` and `numpy`, then load our dataset. **Pandas** provides the `pandas.read_json()` function to read data in a JSON format:

```python
import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings('ignore', category=FutureWarning)
```

```python
df = pd.read_json('https://www.datos.gov.co/resource/ytme-6qnu.json')
df.head().round(2)
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
      <th>a_o</th>
      <th>periodo</th>
      <th>operador_de_red</th>
      <th>nivel</th>
      <th>cu_total</th>
      <th>costo_compra_gm_i</th>
      <th>cargo_transporte_stn_tm</th>
      <th>cargo_transporte_sdl_dn_m</th>
      <th>margen_comercializaci_n_cvm</th>
      <th>costo_g_t_p_rdidas_prn_m</th>
      <th>restricciones_rm</th>
      <th>cot</th>
      <th>cfm_j_fact</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>810.46</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>280.91</td>
      <td>24.86</td>
      <td>72.49</td>
      <td>3.71</td>
      <td>0.00</td>
      <td>9.81</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>787.37</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>257.82</td>
      <td>24.86</td>
      <td>72.49</td>
      <td>3.71</td>
      <td>0.00</td>
      <td>9.81</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>764.29</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>234.73</td>
      <td>24.86</td>
      <td>72.49</td>
      <td>3.71</td>
      <td>0.00</td>
      <td>9.81</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>NIVEL II</td>
      <td>691.89</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>168.80</td>
      <td>66.56</td>
      <td>24.32</td>
      <td>3.71</td>
      <td>41.70</td>
      <td>9.81</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>NIVEL III</td>
      <td>633.30</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>113.66</td>
      <td>63.79</td>
      <td>23.65</td>
      <td>3.71</td>
      <td>38.93</td>
      <td>9.81</td>
    </tr>
  </tbody>
</table>
</div>

## 2. Data Exploration

Before diving into the analysis, let's understand what each column represents.

Since the headers are in Spanish, I'll translate the name of all columns first, and then provide an explanation for each one of them:

```python
df.rename(columns={
    'a_o':'year',
    'periodo':'period',
    'operador_de_red':'grid_operator',
    'nivel':'grid_level',
    'cu_total':'total_c_kWh',
    'costo_compra_gm_i':'buy_cost_gm_i',
    'cargo_transporte_stn_tm':'transmission_charge_stn_tm',
    'cargo_transporte_sdl_dn_m':'transmission_charge_sdl_dn_m',
    'margen_comercializaci_n_cvm':'retail_margin_n_cvm',
    'costo_g_t_p_rdidas_prn_m':'cost_g_t_loss_prn_m',
    'restricciones_rm':'restrictions_rm',
    'cot':'otc',
    'cfm_j_fact':'fmc_j_bill'
}, inplace=True)
```

```python
df.head().round(2)
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
      <th>year</th>
      <th>period</th>
      <th>grid_operator</th>
      <th>grid_level</th>
      <th>total_c_kWh</th>
      <th>buy_cost_gm_i</th>
      <th>transmission_charge_stn_tm</th>
      <th>transmission_charge_sdl_dn_m</th>
      <th>retail_margin_n_cvm</th>
      <th>cost_g_t_loss_prn_m</th>
      <th>restrictions_rm</th>
      <th>otc</th>
      <th>fmc_j_bill</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>810.46</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>280.91</td>
      <td>24.86</td>
      <td>72.49</td>
      <td>3.71</td>
      <td>0.00</td>
      <td>9.81</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>787.37</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>257.82</td>
      <td>24.86</td>
      <td>72.49</td>
      <td>3.71</td>
      <td>0.00</td>
      <td>9.81</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>764.29</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>234.73</td>
      <td>24.86</td>
      <td>72.49</td>
      <td>3.71</td>
      <td>0.00</td>
      <td>9.81</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>NIVEL II</td>
      <td>691.89</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>168.80</td>
      <td>66.56</td>
      <td>24.32</td>
      <td>3.71</td>
      <td>41.70</td>
      <td>9.81</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2025</td>
      <td>Enero</td>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>NIVEL III</td>
      <td>633.30</td>
      <td>372.46</td>
      <td>56.03</td>
      <td>113.66</td>
      <td>63.79</td>
      <td>23.65</td>
      <td>3.71</td>
      <td>38.93</td>
      <td>9.81</td>
    </tr>
  </tbody>
</table>
</div>

Here's the explanation:

| variable                     | class  | description                                                                                                                                                                                      |
| ---------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| year                         | number | The year in which data on electricity tariffs and costs are recorded. Example: 2024                                                                                                              |
| period                       | text   | The specific month or period within the year to which the tariff or energy cost corresponds.                                                                                                     |
| grid_operator                | text   | The company responsible for the distribution of electricity in a specific area.                                                                                                                  |
| grid_level                   | text   | The category of electricity service, which may include different types of voltage such as Low Voltage (B.T.), Medium Voltage (M.T.), or High Voltage (A.T.).                                     |
| total_c_kWh                  | number | The total cost per kilowatt-hour (kWh) that users must pay for electricity, including all charges.                                                                                               |
| buy_cost_gm_i                | number | The price paid by the grid operator for electricity purchased from generators.                                                                                                                   |
| transmission_charge_stn_tm   | number | The cost associated with the transport of electricity through the National Transmission System (STN), which is the high-voltage network that carries electricity from generators to substations. |
| transmission_charge_sdl_dn_m | number | The cost associated with the transport of electricity in the Local Distribution System (SDL), which distributes electricity from substations to end users.                                       |
| retail_margin_n_cvm          | number | The additional cost that covers the marketing of electricity, including the operating and transaction expenses of the grid operator.                                                             |
| cost_g_t_loss_prn_m          | number | The costs associated with the generation, transmission, and losses of energy during its transport through the network, due to resistance and other factors.                                      |
| restrictions_rm              | number | Additional costs that arise due to technical or operational restrictions in the power grid.                                                                                                      |
| otc                          | number | The Operation and Transport Cost, which includes the operating and transport costs of electricity at different voltage levels.                                                                   |
| fmc_j_bill                   | number | The fixed monthly cost per bill that users must pay, regardless of the amount of electricity they consume.                                                                                       |

Now, we want to get familiar with the dataframe.
First, let's confirm the dataframe _shape_, _dtypes_ and _missing values_ using `df.info()`:

```python
print("--- Basic information: ---")
df.info()
```

    --- Basic information: ---
    <class 'pandas.DataFrame'>
    RangeIndex: 415 entries, 0 to 414
    Data columns (total 13 columns):
     #   Column                        Non-Null Count  Dtype
    ---  ------                        --------------  -----
     0   year                          415 non-null    int64
     1   period                        415 non-null    str
     2   grid_operator                 415 non-null    str
     3   grid_level                    415 non-null    str
     4   total_c_kWh                   415 non-null    float64
     5   buy_cost_gm_i                 415 non-null    float64
     6   transmission_charge_stn_tm    415 non-null    float64
     7   transmission_charge_sdl_dn_m  415 non-null    float64
     8   retail_margin_n_cvm           415 non-null    float64
     9   cost_g_t_loss_prn_m           415 non-null    float64
     10  restrictions_rm               415 non-null    float64
     11  otc                           415 non-null    float64
     12  fmc_j_bill                    415 non-null    float64
    dtypes: float64(9), int64(1), str(3)
    memory usage: 42.3 KB

It's also a good idea to check if we have empty strings ""

```python
print('--- Number of empty strings in each column: ---')
print(df[df == ""].sum())
```

    --- Number of empty strings in each column: ---
    year                            0.0
    period                            0
    grid_operator                     0
    grid_level                        0
    total_c_kWh                     0.0
    buy_cost_gm_i                   0.0
    transmission_charge_stn_tm      0.0
    transmission_charge_sdl_dn_m    0.0
    retail_margin_n_cvm             0.0
    cost_g_t_loss_prn_m             0.0
    restrictions_rm                 0.0
    otc                             0.0
    fmc_j_bill                      0.0
    dtype: object

Let’s find out the range of years covered in the dataset:

```python
years = df['year'].unique()
print(years)
print('Min year:', years.min())
print('Max year:', years.max())
```

    [2025 2024]
    Min year: 2024
    Max year: 2025

```python
print('--- Some descriptive statistics: ---')
display(df.describe().round(2))
```

    --- Some descriptive statistics: ---

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
      <th>year</th>
      <th>total_c_kWh</th>
      <th>buy_cost_gm_i</th>
      <th>transmission_charge_stn_tm</th>
      <th>transmission_charge_sdl_dn_m</th>
      <th>retail_margin_n_cvm</th>
      <th>cost_g_t_loss_prn_m</th>
      <th>restrictions_rm</th>
      <th>otc</th>
      <th>fmc_j_bill</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>415.00</td>
      <td>415.00</td>
      <td>415.00</td>
      <td>415.00</td>
      <td>415.00</td>
      <td>415.00</td>
      <td>415.00</td>
      <td>415.00</td>
      <td>415.00</td>
      <td>415.00</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>2024.42</td>
      <td>723.64</td>
      <td>318.13</td>
      <td>54.40</td>
      <td>197.68</td>
      <td>80.01</td>
      <td>50.38</td>
      <td>23.03</td>
      <td>22.41</td>
      <td>551.68</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.49</td>
      <td>106.81</td>
      <td>32.13</td>
      <td>3.47</td>
      <td>60.21</td>
      <td>57.25</td>
      <td>22.30</td>
      <td>16.45</td>
      <td>31.00</td>
      <td>2483.06</td>
    </tr>
    <tr>
      <th>min</th>
      <td>2024.00</td>
      <td>497.89</td>
      <td>265.06</td>
      <td>47.96</td>
      <td>87.79</td>
      <td>21.01</td>
      <td>18.33</td>
      <td>1.56</td>
      <td>0.00</td>
      <td>8.56</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>2024.00</td>
      <td>639.38</td>
      <td>295.82</td>
      <td>52.27</td>
      <td>154.11</td>
      <td>27.08</td>
      <td>26.06</td>
      <td>9.52</td>
      <td>0.00</td>
      <td>9.59</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>2024.00</td>
      <td>728.46</td>
      <td>307.43</td>
      <td>54.69</td>
      <td>206.70</td>
      <td>67.93</td>
      <td>56.85</td>
      <td>22.46</td>
      <td>0.00</td>
      <td>10.04</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2025.00</td>
      <td>789.30</td>
      <td>346.87</td>
      <td>56.76</td>
      <td>249.80</td>
      <td>100.11</td>
      <td>67.93</td>
      <td>37.14</td>
      <td>43.89</td>
      <td>15.74</td>
    </tr>
    <tr>
      <th>max</th>
      <td>2025.00</td>
      <td>1020.65</td>
      <td>394.58</td>
      <td>62.20</td>
      <td>305.19</td>
      <td>217.19</td>
      <td>87.34</td>
      <td>75.11</td>
      <td>101.40</td>
      <td>16064.00</td>
    </tr>
  </tbody>
</table>
</div>

How many grid operators do we have?

```python
df['grid_operator'].unique().tolist()
```

    ['ENEL Bogotá - Cundinamarca',
     'CELSIA Colombia - Valle del Cauca',
     'CELSIA Colombia - Tolima',
     'EMCALI - Cali',
     'CELSIA - Valle del Cauca',
     'CELSIA - Tolima']

Interestingly, we notice some redundancy... **grid operators** has some very similar names:

- CELSIA Colombia - Valle del Cauca <-> CELSIA - Valle del Cauca
- CELSIA Colombia - Tolima <-> CELSIA - Tolima

It doesn't make much sense two entries so similar for `CELSIA Valle del Cauca` and `CELSIA Tolima`.

Best course of action is to consolidate them into a single value. I'll do that a bit ahead.

And finally, let's confirm the contents of _`grid_levels`_:

```python
df['grid_level'].unique().tolist()
```

    ['Nivel 1 (Propiedad OR)',
     'Nivel 1 (Propiedad Compartida)',
     'Nivel 1 (Propiedad Cliente)',
     'NIVEL II',
     'NIVEL III',
     'Nivel 1 ( Propiedad OR )',
     'Nivel 1  (Propiedad Cliente)']

We've found some typos in the `grid_level` feature this time, which will be handled in the data cleaning step.

Since there are no more columns to review, we can proceed with cleaning our data.

## 3. Data Cleaning

```python
# remove the text " Colombia" from the contents of 'grid_operators'
df['grid_operator'] = df['grid_operator'].str.replace(' Colombia', '', regex=False)

# Then, correct the typos in 'grid_level'
df['grid_level'] = df['grid_level'].str.replace('  ', ' ', regex=False)
df['grid_level'] = df['grid_level'].str.replace('( Propiedad OR )', '(Propiedad OR)', regex=False)

# For consistency, change Nivel for lowercase
df['grid_level'] = df['grid_level'].str.replace('NIVEL III', 'Nivel 3', regex=False)
df['grid_level'] = df['grid_level'].str.replace('NIVEL II', 'Nivel 2', regex=False)

# Since the number of grid operators and grid levels are low, I'll convert to category:
df['grid_operator'] = df['grid_operator'].astype('category')
df['grid_level'] = df['grid_level'].astype('category')
```

Confirming the contents of `grid_operator` and `grid_level`:

```python
print('--- Contents of Grid Operator: ---')
display(df['grid_operator'].unique().tolist())

print('\n--- Contents of Grid Level: ---')
display(df['grid_level'].unique().tolist())
```

    --- Contents of Grid Operator: ---
    ['ENEL Bogotá - Cundinamarca',
     'CELSIA - Valle del Cauca',
     'CELSIA - Tolima',
     'EMCALI - Cali']

    --- Contents of Grid Level: ---
    ['Nivel 1 (Propiedad OR)',
     'Nivel 1 (Propiedad Compartida)',
     'Nivel 1 (Propiedad Cliente)',
     'Nivel 2',
     'Nivel 3']

## 4. Data Visualization

```python
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import seaborn as sns
```

```python
# 1. Apply the style first
plt.style.use('fivethirtyeight')

# 2. Refine fonts and colors (Added the missing comma)
plt.rcParams.update({
    'font.size': 10,
    'axes.titlesize': 12,
    'figure.facecolor': 'white', # <--- Added comma here
    'axes.facecolor': 'white',
    'savefig.facecolor': 'white',
    'grid.color': '#E6E6E6'
})
```

```python
# How many observations by grid operator do we have?
plt.figure(figsize=(6,3))
sns.countplot(data=df, y='grid_operator', stat='count')
plt.suptitle('Entries by Grid Operator')
plt.ylabel('')
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_31_0.png)

```python
# How many observations by grid level do we have?
plt.figure(figsize=(6,3))
sns.countplot(data=df, y='grid_level', stat='count')
plt.suptitle('Entries by Grid Level')
plt.ylabel('')
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_32_0.png)

According to the features descriptions, the `total_c_kWh` feature should be highly correlated to the other variables related to the cost structure. Let's check if it is true with a correlation heatmap

```python
correl_matrix = df.select_dtypes(include=['int64', 'float64']).corr()
plt.figure(figsize=(12,5))
sns.heatmap(correl_matrix, annot=True, cmap='coolwarm')
```

    <Axes: >

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_34_1.png)

A few features are highly correlated to `total_c_kWh`:

- (0.77) transmission_charge_sdl_dn_m
- (0.61) retail_margin_n_cvm
- (0.89) cost_g_t_loss_prn_m
- (0.44) otc

I want to create a **pairplot** to quickly visualize distributions and relations of these highly correlated features:

```python
# create the list of features
features = [
    'year',
    'transmission_charge_stn_tm',
    'retail_margin_n_cvm',
    'cost_g_t_loss_prn_m',
    'otc',
    'total_c_kWh'
]

# 1. Map columns to readable names
rename_map = {
    'transmission_charge_stn_tm': 'Trans. Charge',
    'retail_margin_n_cvm': 'Retail Margin',
    'cost_g_t_loss_prn_m': 'G&T Loss Cost',
    'otc': 'OTC',
    'total_c_kWh': 'Total c/kWh'
}

# Apply renaming to a temporary plotting dataframe
plot_df = df[features].rename(columns=rename_map)

# 2. Enhanced Pairplot
g = sns.pairplot(
    data=plot_df,
    hue='year',
    corner=True,              # Removes the redundant upper triangle
    diag_kind='kde',          # Smooth distribution curves
    palette='Dark2',        # Better for sequential data like years
    plot_kws={
        'alpha': 0.5,         # Transparency to handle overplotting
        's': 15,              # Smaller marker size
        'linewidth': 0        # Remove borders from dots for cleaner look
    }
)

# 3. Final Polish
g.figure.suptitle('Analysis of Cost Features over Years', y=1.02, fontsize=16)
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_37_0.png)

## 5. Data Analysis

I have prepared the following questions for our data analysis step. Let's see if we can answer them.

### 1. What is the **average Total Unit Cost (total_c_kWh)** by grid level across the entire period?

```python
total_cost_by_grid_level = df.groupby('grid_level')['total_c_kWh'].mean().reset_index()
print("Total cost by grid level: \n",total_cost_by_grid_level.round(2))

## Uncomment the following if you want to visualize the mean costs:
# total_cost_by_grid_level.sort_values().plot(kind='barh', color='orange')
# plt.xlabel('Average Total Cost ($/kWh)')
# plt.ylabel('')
# plt.title('Average Cost by Grid Level')

# plt.tight_layout()
# plt.show()
```

    Total cost by grid level:
                            grid_level  total_c_kWh
    0     Nivel 1 (Propiedad Cliente)       759.23
    1  Nivel 1 (Propiedad Compartida)       790.24
    2          Nivel 1 (Propiedad OR)       821.25
    3                         Nivel 2       659.22
    4                         Nivel 3       588.28

```python
# What's the difference between the rates payed by residential and industrial users?

# 1. Isolate and average the Nivel 1 categories
nivel_1_mean = total_cost_by_grid_level[
    total_cost_by_grid_level['grid_level'].str.contains('Nivel 1')
]['total_c_kWh'].mean()

print(f"Mean cost for Nivel 1: {nivel_1_mean:.2f}")

# 2. Filter for Nivel 2 and 3
nivel_2_3 = total_cost_by_grid_level[
    total_cost_by_grid_level['grid_level'].isin(['Nivel 2', 'Nivel 3'])
].copy()

# 3. Calculate absolute and percentage deviation
nivel_2_3['deviation'] = nivel_2_3['total_c_kWh'] - nivel_1_mean
nivel_2_3['pct_deviation'] = (nivel_2_3['deviation'] / nivel_1_mean) * 100

print("\nDeviation from Nivel 1 Mean:")
print(nivel_2_3[['grid_level', 'total_c_kWh', 'deviation', 'pct_deviation']].round(2))
```

    Mean cost for Nivel 1: 790.24

    Deviation from Nivel 1 Mean:
      grid_level  total_c_kWh  deviation  pct_deviation
    3    Nivel 2       659.22    -131.02         -16.58
    4    Nivel 3       588.28    -201.97         -25.56

> There is a significant difference in rates payed by residential and industrial users:
>
> - `Nivel 2` users pay approximately 16% less than `Nivel 1` users
> - `Nivel 3` users pay approximately 25% less than `Nivel 1` users
>
> We'll further investigate what could be the reason residential users pay much more.

> 💡 Tip: You can add `.reset_index()` at the end of your command to return a stardard Dataframe

### 2. How are the records distributed among the different grid operators? Which operator has the most entries in the dataset?

```python
df['grid_operator'].value_counts().reset_index()
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
      <th>grid_operator</th>
      <th>count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>105</td>
    </tr>
    <tr>
      <th>1</th>
      <td>EMCALI - Cali</td>
      <td>105</td>
    </tr>
    <tr>
      <th>2</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>105</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CELSIA - Tolima</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>

### 3. What is the **average Monthly Fixed Charge (Cfm,j)** and how does it vary between operators and voltage levels?

```python
df.groupby(['grid_operator', 'grid_level'])['fmc_j_bill'].agg('mean').round(2).reset_index()
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
      <th>grid_operator</th>
      <th>grid_level</th>
      <th>fmc_j_bill</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>CELSIA - Tolima</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>513.53</td>
    </tr>
    <tr>
      <th>1</th>
      <td>CELSIA - Tolima</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>513.53</td>
    </tr>
    <tr>
      <th>2</th>
      <td>CELSIA - Tolima</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>513.53</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CELSIA - Tolima</td>
      <td>Nivel 2</td>
      <td>513.53</td>
    </tr>
    <tr>
      <th>4</th>
      <td>CELSIA - Tolima</td>
      <td>Nivel 3</td>
      <td>513.53</td>
    </tr>
    <tr>
      <th>5</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>780.35</td>
    </tr>
    <tr>
      <th>6</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>780.35</td>
    </tr>
    <tr>
      <th>7</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>780.35</td>
    </tr>
    <tr>
      <th>8</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>Nivel 2</td>
      <td>780.35</td>
    </tr>
    <tr>
      <th>9</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>Nivel 3</td>
      <td>780.35</td>
    </tr>
    <tr>
      <th>10</th>
      <td>EMCALI - Cali</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>437.16</td>
    </tr>
    <tr>
      <th>11</th>
      <td>EMCALI - Cali</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>437.16</td>
    </tr>
    <tr>
      <th>12</th>
      <td>EMCALI - Cali</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>437.16</td>
    </tr>
    <tr>
      <th>13</th>
      <td>EMCALI - Cali</td>
      <td>Nivel 2</td>
      <td>437.16</td>
    </tr>
    <tr>
      <th>14</th>
      <td>EMCALI - Cali</td>
      <td>Nivel 3</td>
      <td>437.16</td>
    </tr>
    <tr>
      <th>15</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>473.87</td>
    </tr>
    <tr>
      <th>16</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>473.87</td>
    </tr>
    <tr>
      <th>17</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>473.87</td>
    </tr>
    <tr>
      <th>18</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 2</td>
      <td>473.87</td>
    </tr>
    <tr>
      <th>19</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 3</td>
      <td>473.87</td>
    </tr>
  </tbody>
</table>
</div>

> The Monthly Fixed Charge (Cfm,j) doesn't vary by grid level, only by Operator. It seems this cost is fixed administratively, regardless of voltage.
>
> **EMCALI - Cali** has the lowest average Monthly Fixed Charges (437.16), while **CELSIA - Valle del Cauca** has the highest (780.35).

```python
## Since the cost average is the same across every grid level, let's plot by operator:

# Sort the data
data = df.groupby('grid_operator')['fmc_j_bill'].mean().sort_values()

# Create the plot and define the 'ax'
plt.figure(figsize=(7, 3))
ax = data.plot(kind='barh', color='orange')

# 4. Add labels
ax.bar_label(ax.containers[0], padding=3, fmt='%.2f')

# 5. Aesthetics
ax.set_xlim(right=ax.get_xlim()[1] * 1.15)
plt.xlabel('Average Monthly Fixed Charge ($)')
plt.ylabel('')
plt.title('Monthly Fixed Charge by Grid Operator')

plt.tight_layout()
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_49_0.png)

### 4. What percentage of the **Total Unit Cost (total_c_kWh)** does each main component represent on average (Cost of Purchase, STN Transport Charge, SDL Transport Charge, Commercialization Margin, etc.), globally and by operator?

```python
# Global calculation
print('--- Global cost by component: ---')

# Define a list of features to loop over
features = [
    'buy_cost_gm_i',
    'transmission_charge_stn_tm',
    'transmission_charge_sdl_dn_m',
    'retail_margin_n_cvm',
    'cost_g_t_loss_prn_m',
    'restrictions_rm'
]

# print the percentage of each component
for feature in features:
    percentage = df[feature].sum() / df['total_c_kWh'].sum()
    print(f'The % of {feature} is: {percentage:.3%}')

```

    --- Global cost by component: ---
    The % of buy_cost_gm_i is: 43.963%
    The % of transmission_charge_stn_tm is: 7.517%
    The % of transmission_charge_sdl_dn_m is: 27.318%
    The % of retail_margin_n_cvm is: 11.057%
    The % of cost_g_t_loss_prn_m is: 6.962%
    The % of restrictions_rm is: 3.182%

```python
print('--- Average cost by component and operator: ---')

# 1. Group by operator and sum the specific features + the denominator
calc_df = df.groupby('grid_operator')[features + ['total_c_kWh']].sum()

# 2. Divide the feature columns by the 'total_c_kWh' column
# axis=0 ensures the division happens row by row
percentage_df = calc_df[features].div(calc_df['total_c_kWh'], axis=0)

# 3. Apply the 3-decimal percentage formatting for a beautiful display
percentage_df.reset_index().style.format({
    col: '{:.2%}' for col in features
})
```

    --- Average cost by component and operator: ---

<div class="table-container">
<style type="text/css">
</style>
<table id="T_22346">
  <thead>
    <tr>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_22346_level0_col0" class="col_heading level0 col0" >grid_operator</th>
      <th id="T_22346_level0_col1" class="col_heading level0 col1" >buy_cost_gm_i</th>
      <th id="T_22346_level0_col2" class="col_heading level0 col2" >transmission_charge_stn_tm</th>
      <th id="T_22346_level0_col3" class="col_heading level0 col3" >transmission_charge_sdl_dn_m</th>
      <th id="T_22346_level0_col4" class="col_heading level0 col4" >retail_margin_n_cvm</th>
      <th id="T_22346_level0_col5" class="col_heading level0 col5" >cost_g_t_loss_prn_m</th>
      <th id="T_22346_level0_col6" class="col_heading level0 col6" >restrictions_rm</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_22346_level0_row0" class="row_heading level0 row0" >0</th>
      <td id="T_22346_row0_col0" class="data row0 col0" >CELSIA - Tolima</td>
      <td id="T_22346_row0_col1" class="data row0 col1" >38.52%</td>
      <td id="T_22346_row0_col2" class="data row0 col2" >6.83%</td>
      <td id="T_22346_row0_col3" class="data row0 col3" >24.26%</td>
      <td id="T_22346_row0_col4" class="data row0 col4" >19.53%</td>
      <td id="T_22346_row0_col5" class="data row0 col5" >7.91%</td>
      <td id="T_22346_row0_col6" class="data row0 col6" >2.95%</td>
    </tr>
    <tr>
      <th id="T_22346_level0_row1" class="row_heading level0 row1" >1</th>
      <td id="T_22346_row1_col0" class="data row1 col0" >CELSIA - Valle del Cauca</td>
      <td id="T_22346_row1_col1" class="data row1 col1" >45.04%</td>
      <td id="T_22346_row1_col2" class="data row1 col2" >7.60%</td>
      <td id="T_22346_row1_col3" class="data row1 col3" >26.22%</td>
      <td id="T_22346_row1_col4" class="data row1 col4" >11.37%</td>
      <td id="T_22346_row1_col5" class="data row1 col5" >6.58%</td>
      <td id="T_22346_row1_col6" class="data row1 col6" >3.19%</td>
    </tr>
    <tr>
      <th id="T_22346_level0_row2" class="row_heading level0 row2" >2</th>
      <td id="T_22346_row2_col0" class="data row2 col0" >EMCALI - Cali</td>
      <td id="T_22346_row2_col1" class="data row2 col1" >47.74%</td>
      <td id="T_22346_row2_col2" class="data row2 col2" >8.08%</td>
      <td id="T_22346_row2_col3" class="data row2 col3" >29.57%</td>
      <td id="T_22346_row2_col4" class="data row2 col4" >4.46%</td>
      <td id="T_22346_row2_col5" class="data row2 col5" >6.74%</td>
      <td id="T_22346_row2_col6" class="data row2 col6" >3.41%</td>
    </tr>
    <tr>
      <th id="T_22346_level0_row3" class="row_heading level0 row3" >3</th>
      <td id="T_22346_row3_col0" class="data row3 col0" >ENEL Bogotá - Cundinamarca</td>
      <td id="T_22346_row3_col1" class="data row3 col1" >45.11%</td>
      <td id="T_22346_row3_col2" class="data row3 col2" >7.64%</td>
      <td id="T_22346_row3_col3" class="data row3 col3" >29.56%</td>
      <td id="T_22346_row3_col4" class="data row3 col4" >7.94%</td>
      <td id="T_22346_row3_col5" class="data row3 col5" >6.54%</td>
      <td id="T_22346_row3_col6" class="data row3 col6" >3.21%</td>
    </tr>
  </tbody>
</table>
</div>

```python
# Let's create a stacked bar chart showing cost components by operator
# First, group by operator only (collapse grid_level)
operator_pct = percentage_df.groupby('grid_operator').mean()

# Create the stacked bar chart
fig, ax = plt.subplots(figsize=(10, 5))
operator_pct.plot(kind='barh', stacked=True, ax=ax)

ax.set_xlabel('Percentage of Total Cost')
ax.set_ylabel('')
ax.set_title('Cost Components by Grid Operator (% of Total)')
ax.legend(title='Components', bbox_to_anchor=(1.05, 1), loc='upper left', fontsize=9)
ax.xaxis.set_major_formatter(mtick.PercentFormatter(1.0, decimals=0))

plt.tight_layout()
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_53_0.png)

- **Buy Cost (buy_cost_gm_i - Teal)**: This is the largest component for all operators, accounting for roughly 40% to 50% of the total cost. Interestingly, EMCALI - Cali has the highest percentage dedicated to buying energy, while CELSIA - Tolima has the lowest relative share.

- **Transmission (transmission_charge_sdl_dn_m - Pink)**: This is the second-largest piece of the pie. It remains relatively consistent across all operators, taking up about 25% to 30% of the total.

**Retail Margin (retail_margin_n_cvm - Green)**: This is where the operators differ most significantly.

- **CELSIA - Tolima** has a much larger green section compared to the others.

- **EMCALI - Cali** has a very thin green slice, suggesting they operate on much tighter commercial margins.

### 5. How has the **Total Unit Cost (total_c_kWh)** evolved month by month from January 2024 to September 2025? Is there any upward or downward trend?

```python
# We can't use the period column right away because is a categorical type, and Python
# will sort it alphabetically

# 1. Create the Spanish to Month Number map
month_map = {
    'Enero': 1, 'Febrero': 2, 'Marzo': 3, 'Abril': 4,
    'Mayo': 5, 'Junio': 6, 'Julio': 7, 'Agosto': 8,
    'Septiembre': 9, 'Octubre': 10, 'Noviembre': 11, 'Diciembre': 12
}

# 2. Map the names to numbers
df['month'] = df['period'].map(month_map)

# 3. Create a real datetime column (e.g., using the first day of the month)
df['date'] = pd.to_datetime(df[['year', 'month']].assign(day=1))

# 4. Sort the dataframe by the new date column
df = df.sort_values('date')
```

```python
data = df.groupby(['date'])['total_c_kWh'].mean().reset_index()

plt.figure(figsize=(8,4))
sns.lineplot(data=data, x='date', y='total_c_kWh', marker='o')

plt.title('Total cost evolution $/kWh (2024-2025)')
plt.xticks(rotation=45)
plt.xlabel('')
plt.ylabel('$/kWh')
plt.grid(True, alpha=0.5)
plt.tight_layout() # Prevents the legend from being cut off
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_57_0.png)

> The line chart shows the evolution of the Total Unit Cost (kWh). It doesn't follow a steady upward or downward trend. The price fluctuates between 680 and ~770, showing signs of volatility over months.

```python
data = df.groupby(['date', 'grid_operator'])['total_c_kWh'].mean().reset_index()

plt.figure(figsize=(8,5))
sns.lineplot(data=data, x='date', y='total_c_kWh',hue='grid_operator' ,marker='o')

plt.title('Total cost evolution $/kWh (2024-2025)')
plt.xticks(rotation=45)
plt.xlabel('')
plt.ylabel('$/kWh')
plt.grid(True, alpha=0.5)
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', title='Operator', fontsize='small')
plt.tight_layout() # Prevents the legend from being cut off
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_59_0.png)

> If we break down the line by operator, we find something very interesting: Only `CELSIA Tolima` has a sharp incrementing cost over time. Other operators show a price drop from May/2024.

### 6. Which **network operator** has the **highest** and **lowest average CU Total** (total_c_kWh) for Low Voltage (B.T. = Nivel 1) users? (relevant for residential customers)

```python
data = df[df['grid_level'].str.startswith('Nivel 1')]
data.groupby(['grid_operator', 'grid_level'])['total_c_kWh'].agg('mean').sort_values().round(2).reset_index()
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
      <th>grid_operator</th>
      <th>grid_level</th>
      <th>total_c_kWh</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>EMCALI - Cali</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>720.23</td>
    </tr>
    <tr>
      <th>1</th>
      <td>EMCALI - Cali</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>736.30</td>
    </tr>
    <tr>
      <th>2</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>739.19</td>
    </tr>
    <tr>
      <th>3</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>745.41</td>
    </tr>
    <tr>
      <th>4</th>
      <td>EMCALI - Cali</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>752.37</td>
    </tr>
    <tr>
      <th>5</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>763.08</td>
    </tr>
    <tr>
      <th>6</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>780.45</td>
    </tr>
    <tr>
      <th>7</th>
      <td>ENEL Bogotá - Cundinamarca</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>786.96</td>
    </tr>
    <tr>
      <th>8</th>
      <td>CELSIA - Valle del Cauca</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>815.50</td>
    </tr>
    <tr>
      <th>9</th>
      <td>CELSIA - Tolima</td>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>835.73</td>
    </tr>
    <tr>
      <th>10</th>
      <td>CELSIA - Tolima</td>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>885.68</td>
    </tr>
    <tr>
      <th>11</th>
      <td>CELSIA - Tolima</td>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>935.64</td>
    </tr>
  </tbody>
</table>
</div>

> - `EMCALI - Cali` has the lowest cost: 720.23
> - `CELSIA - Tolima` has the highest cost: 935.64

### 7. To what extent do **losses (Cost G, T, Losses)** and **restrictions (Rm)** contribute to the final cost? Does this contribution vary by voltage level?

```python
print('--- Contribution of LOSSES and RESTRICTIONS to total cost, by Grid Level: ---')

features = [
    'buy_cost_gm_i',
    'transmission_charge_stn_tm',
    'transmission_charge_sdl_dn_m',
    'retail_margin_n_cvm',
    'cost_g_t_loss_prn_m',
    'restrictions_rm'
]

# 1. Group by operator and sum the specific features + the denominator
calc_df = df.groupby(['grid_operator', 'grid_level'])[features + ['total_c_kWh']].sum()

# 2. Divide the feature columns by the 'total_c_kWh' column
# axis=0 ensures the division happens row by row
percentage_df = calc_df[features].div(calc_df['total_c_kWh'], axis=0)

# 3. Apply the 3-decimal percentage formatting for a beautiful display
percentage_df[['cost_g_t_loss_prn_m', 'restrictions_rm']].style.format("{:.2%}")
```

    --- Contribution of LOSSES and RESTRICTIONS to total cost, by Grid Level: ---

<style type="text/css">
</style>
<table id="T_06018">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_06018_level0_col0" class="col_heading level0 col0" >cost_g_t_loss_prn_m</th>
      <th id="T_06018_level0_col1" class="col_heading level0 col1" >restrictions_rm</th>
    </tr>
    <tr>
      <th class="index_name level0" >grid_operator</th>
      <th class="index_name level1" >grid_level</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_06018_level0_row0" class="row_heading level0 row0" rowspan="5">CELSIA - Tolima</th>
      <th id="T_06018_level1_row0" class="row_heading level1 row0" >Nivel 1 (Propiedad Cliente)</th>
      <td id="T_06018_row0_col0" class="data row0 col0" >10.01%</td>
      <td id="T_06018_row0_col1" class="data row0 col1" >2.82%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row1" class="row_heading level1 row1" >Nivel 1 (Propiedad Compartida)</th>
      <td id="T_06018_row1_col0" class="data row1 col0" >9.44%</td>
      <td id="T_06018_row1_col1" class="data row1 col1" >2.66%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row2" class="row_heading level1 row2" >Nivel 1 (Propiedad OR)</th>
      <td id="T_06018_row2_col0" class="data row2 col0" >8.94%</td>
      <td id="T_06018_row2_col1" class="data row2 col1" >2.52%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row3" class="row_heading level1 row3" >Nivel 2</th>
      <td id="T_06018_row3_col0" class="data row3 col0" >5.29%</td>
      <td id="T_06018_row3_col1" class="data row3 col1" >3.37%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row4" class="row_heading level1 row4" >Nivel 3</th>
      <td id="T_06018_row4_col0" class="data row4 col0" >4.37%</td>
      <td id="T_06018_row4_col1" class="data row4 col1" >3.71%</td>
    </tr>
    <tr>
      <th id="T_06018_level0_row5" class="row_heading level0 row5" rowspan="5">CELSIA - Valle del Cauca</th>
      <th id="T_06018_level1_row5" class="row_heading level1 row5" >Nivel 1 (Propiedad Cliente)</th>
      <td id="T_06018_row5_col0" class="data row5 col0" >8.34%</td>
      <td id="T_06018_row5_col1" class="data row5 col1" >3.07%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row6" class="row_heading level1 row6" >Nivel 1 (Propiedad Compartida)</th>
      <td id="T_06018_row6_col0" class="data row6 col0" >7.97%</td>
      <td id="T_06018_row6_col1" class="data row6 col1" >2.93%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row7" class="row_heading level1 row7" >Nivel 1 (Propiedad OR)</th>
      <td id="T_06018_row7_col0" class="data row7 col0" >7.63%</td>
      <td id="T_06018_row7_col1" class="data row7 col1" >2.80%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row8" class="row_heading level1 row8" >Nivel 2</th>
      <td id="T_06018_row8_col0" class="data row8 col0" >3.97%</td>
      <td id="T_06018_row8_col1" class="data row8 col1" >3.44%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row9" class="row_heading level1 row9" >Nivel 3</th>
      <td id="T_06018_row9_col0" class="data row9 col0" >3.93%</td>
      <td id="T_06018_row9_col1" class="data row9 col1" >3.99%</td>
    </tr>
    <tr>
      <th id="T_06018_level0_row10" class="row_heading level0 row10" rowspan="5">EMCALI - Cali</th>
      <th id="T_06018_level1_row10" class="row_heading level1 row10" >Nivel 1 (Propiedad Cliente)</th>
      <td id="T_06018_row10_col0" class="data row10 col0" >8.21%</td>
      <td id="T_06018_row10_col1" class="data row10 col1" >3.18%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row11" class="row_heading level1 row11" >Nivel 1 (Propiedad Compartida)</th>
      <td id="T_06018_row11_col0" class="data row11 col0" >8.04%</td>
      <td id="T_06018_row11_col1" class="data row11 col1" >3.11%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row12" class="row_heading level1 row12" >Nivel 1 (Propiedad OR)</th>
      <td id="T_06018_row12_col0" class="data row12 col0" >7.86%</td>
      <td id="T_06018_row12_col1" class="data row12 col1" >3.05%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row13" class="row_heading level1 row13" >Nivel 2</th>
      <td id="T_06018_row13_col0" class="data row13 col0" >4.24%</td>
      <td id="T_06018_row13_col1" class="data row13 col1" >3.75%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row14" class="row_heading level1 row14" >Nivel 3</th>
      <td id="T_06018_row14_col0" class="data row14 col0" >4.33%</td>
      <td id="T_06018_row14_col1" class="data row14 col1" >4.20%</td>
    </tr>
    <tr>
      <th id="T_06018_level0_row15" class="row_heading level0 row15" rowspan="5">ENEL Bogotá - Cundinamarca</th>
      <th id="T_06018_level1_row15" class="row_heading level1 row15" >Nivel 1 (Propiedad Cliente)</th>
      <td id="T_06018_row15_col0" class="data row15 col0" >8.59%</td>
      <td id="T_06018_row15_col1" class="data row15 col1" >3.09%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row16" class="row_heading level1 row16" >Nivel 1 (Propiedad Compartida)</th>
      <td id="T_06018_row16_col0" class="data row16 col0" >8.32%</td>
      <td id="T_06018_row16_col1" class="data row16 col1" >2.99%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row17" class="row_heading level1 row17" >Nivel 1 (Propiedad OR)</th>
      <td id="T_06018_row17_col0" class="data row17 col0" >8.07%</td>
      <td id="T_06018_row17_col1" class="data row17 col1" >2.90%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row18" class="row_heading level1 row18" >Nivel 2</th>
      <td id="T_06018_row18_col0" class="data row18 col0" >3.22%</td>
      <td id="T_06018_row18_col1" class="data row18 col1" >3.43%</td>
    </tr>
    <tr>
      <th id="T_06018_level1_row19" class="row_heading level1 row19" >Nivel 3</th>
      <td id="T_06018_row19_col0" class="data row19 col0" >3.46%</td>
      <td id="T_06018_row19_col1" class="data row19 col1" >3.79%</td>
    </tr>
  </tbody>
</table>

```python
plt.figure(figsize=(8,5))

ax = sns.barplot(
    data=percentage_df,
    y='grid_level', x='cost_g_t_loss_prn_m',
    hue='grid_operator')

plt.title('Loss by Grid Level')
plt.ylabel('')
plt.xlabel('')
ax.xaxis.set_major_formatter(mtick.PercentFormatter(1.0, decimals=1))

plt.tight_layout()
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_66_0.png)

> **Loss** (cost_g_t_loss_prn_m) contributes to Total Cost (total_c_kWh) **around 4% to 10%**, clearly variating by `grid level`

```python
plt.figure(figsize=(8,5))

ax = sns.barplot(
    data=percentage_df,
    y='grid_level', x='restrictions_rm',
    hue='grid_operator')

plt.title('Restrictions by Grid Level')
plt.ylabel('')
plt.xlabel('')
ax.xaxis.set_major_formatter(mtick.PercentFormatter(1.0, decimals=1))
plt.legend(bbox_to_anchor=(0.25, -0.25), loc='lower center', borderaxespad=0.1, ncol=2)
plt.tight_layout()
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_68_0.png)

> **Restrictions** (restrictions_rm) contributes to Total Cost (total_c_kWh) **around 2.5% to 4%**, but slighly varies by grid level

### 8. Compare the **Commercialization Margin** across operators: Are there significant differences? Which operator has the highest margin?

```python
# Let's answer this with a boxplot
plt.figure(figsize=(8,5))
sns.boxplot(data=df, x='retail_margin_n_cvm', y='grid_operator')
plt.title('Distribution of Commercialization Margins by Grid Operator')
plt.xticks(rotation=45)
plt.ylabel('')
plt.xlabel('')
plt.tight_layout()
plt.show()
```

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_71_0.png)

> CELSIA - Tolima has much more higher and dispersed Margin cost than the other operators.
>
> EMCALI - Cali, on the other hand, has a very low variability of margin costs, centered at around 25, and a couple of outliers.

### 9. How does the **voltage level** impact the **Transport Charges (STN and SDL)**? Is transport much more expensive at Low Voltage?

```python
df.groupby('grid_level')[['transmission_charge_stn_tm', 'transmission_charge_sdl_dn_m']].mean().reset_index()
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
      <th>grid_level</th>
      <th>transmission_charge_stn_tm</th>
      <th>transmission_charge_sdl_dn_m</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Nivel 1 (Propiedad Cliente)</td>
      <td>54.399759</td>
      <td>208.046265</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Nivel 1 (Propiedad Compartida)</td>
      <td>54.399759</td>
      <td>239.058916</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Nivel 1 (Propiedad OR)</td>
      <td>54.399759</td>
      <td>270.070964</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Nivel 2</td>
      <td>54.399759</td>
      <td>165.151325</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Nivel 3</td>
      <td>54.399759</td>
      <td>106.095422</td>
    </tr>
  </tbody>
</table>
</div>

> **Voltage Levels** have no impact over the cost associated with the transport of electricity through the **National Transmission System (STN)**, remaining constant at an average value of **54.40**.
>
> On the other hand, there is a **difference** in the cost associated with the transport of electricity in the **Local Distribution System (SDL)**, much lower in average for `Nivel 3` grid level = **106.10**, in comparison with `Nivel 1`, with a value up to **270**.
>
> `Nivel 3` pays **~2.5x** less for SDL than `Nivel 1`.

> We've found an explanation on why do residential users pay higher unit costs than industrial users. Their SDL costs are much higher.

### 10. Is there a **correlation** between the **Cost of Purchase (Gm,i)** and the **CU Total (total_c_kWh)**? In which months or periods does the purchase cost best explain the final price?

```python
# If we go back to the correlation heatmap, we can see there's a coefficient of 0.15 of correlation
# between the 2 variables, so correlation is minimal. However, let's visualize:

# First, let's plot both variables using a scatter plot
plt.figure(figsize=(8,3))
sns.scatterplot(data=df, x='buy_cost_gm_i', y='total_c_kWh',
                hue='grid_operator', alpha=0.7)
plt.title('Cost of Purchase (Gm,i) vs Total Cost (kWh/u)')
plt.xlabel('Cost of Purchase (COP)')
plt.legend(bbox_to_anchor=(0.5, -0.4), loc='lower center', borderaxespad=0.1, ncol=4)
plt.ylabel('Total Cost ($/kWh)')
```

    Text(0, 0.5, 'Total Cost ($/kWh)')

![png]({{site.url}}/images/posts/electricity-rates/2026-04-05-Electricity-Rates-and-Costs_77_1.png)

> **CELSIA - Tolima** has `Cost of Purchase` values with much less spread than the other operators. The Purchase Cost ranges from ~290 to ~315. It's unclear why it is significantly more stable than the others.
>
> The other operators have a greater spread of Cost of Purchase, from ~265 to ~395.

If we discard **CELSIA - Tolima**, how does it affect the correlation?

```python
data = df[df['grid_operator'] != 'CELSIA - Tolima']
correl_matrix = data.select_dtypes(include=['int64', 'float64']).corr()
round(correl_matrix.loc['total_c_kWh', 'buy_cost_gm_i'], 3)
```

    np.float64(0.306)

> The correlation does increase from ~0.15 to ~0.30, though it's still a weak relationship between the two variables.

## Conclusions

This analysis of Colombian regulated electricity tariffs shows that the final consumer price is shaped by more than just the raw purchase cost of energy.

- Residential users pay 15-25% more than industrial users due to higher SDL costs.

- The dataset reveals clear operator-level differences: `CELSIA - Tolima` has higher and more dispersed commercialization margins, while `EMCALI - Cali` shows much lower margin variability and a tighter cost profile.

- `CELSIA - Tolima` is the only grid operator with incrementing prices for the period of analysis. All other operators have decrementing prices, with few peaks over the first quarter of 2024 and 2025.

- Transport costs behave differently by system: the National Transmission System (STN) is relatively stable across voltage levels, but the Local Distribution System (SDL) is noticeably more expensive for `Nivel 1` than for `Nivel 3`.

- The relationship between `purchase cost (Gm,i)` and `total cost (CU Total)` is weak: overall correlation is only around **0.15**, and even after excluding **CELSIA - Tolima** it rises to only about **0.30**.

- This means the final tariff depends heavily on other components — retail margins, transmission/distribution charges, losses, and operator-specific structure — rather than just the wholesale purchase price.
