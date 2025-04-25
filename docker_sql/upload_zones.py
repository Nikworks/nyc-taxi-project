import pandas as pd
from sqlalchemy import create_engine
import os
import urllib.request

# Create database connection
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')

# Download zones data
print("Downloading taxi zone lookup data...")
url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"
urllib.request.urlretrieve(url, "taxi_zone_lookup.csv")
# Alternative using os.system:
# os.system(f"wget {url}")

# Read and upload to database
print("Reading CSV file...")
df_zones = pd.read_csv("taxi_zone_lookup.csv")
print("Uploading to database...")
df_zones.to_sql(name='zones', con=engine, if_exists='replace')
print("Zones data loaded successfully!")