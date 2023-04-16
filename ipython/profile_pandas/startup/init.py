"""
IPython pandas profile
"""

import numpy as np
import pandas as pd
#import matplotlib.pyplot as plt

def load_titanic():
    """Return an instance of DataFrame from a CSV file"""
    return pd.read_csv("data/titanic.csv")

def load_air_quality():
    """Return an instance of DataFrame from a CSV file"""
    return pd.read_csv("data/air_quality_no2.csv", index_col=0, parse_dates=True)
