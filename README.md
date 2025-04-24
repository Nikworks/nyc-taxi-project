# NYC Taxi Data Ingestion Project

This project sets up a PostgreSQL database using Docker and loads it with NYC taxi trip data for analysis.

## Project Overview

The project creates a containerized PostgreSQL database and pgAdmin interface, then loads NYC Yellow Taxi trip data into it. It demonstrates a simple data pipeline for data engineering tasks.

## Prerequisites

- Docker and Docker Compose
- Python 3.9+
- Git (optional, for version control)

## Setup Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/nyc-taxi-project.git
cd nyc-taxi-project
```

### Step 2: Start the Database Services

```bash
# Create a Docker network
docker network create pg-network

# Start PostgreSQL and pgAdmin
docker-compose up -d
```

### Step 3: Build the Data Ingestion Container

```bash
# Build the Docker image for data ingestion
docker build -t taxi_ingest:v001 .
```

### Step 4: Run the Data Ingestion

```bash
# Download and ingest NYC Yellow Taxi data
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}
```

### Step 5: Load Taxi Zone Data

```bash
# Install Python dependencies
pip install -r requirements.txt

# Run the zone data upload script
python upload_zones.py
```

## Accessing the Data

### Using pgAdmin

1. Open your browser and navigate to: http://localhost:8080
2. Login with:
   - Email: admin@admin.com
   - Password: root
3. Set up a connection to the PostgreSQL server:
   - Host: pgdatabase
   - Port: 5432
   - Username: root
   - Password: root
   - Database: ny_taxi

### Example Query

```sql
SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    total_amount,
    CONCAT(zpu."Borough", ' | ', zpu."Zone") AS "pickup_loc",
    CONCAT(zdo."Borough", ' | ', zdo."Zone") AS "dropoff_loc"
FROM 
    yellow_taxi_trips t
JOIN 
    zones zpu ON t."PULocationID" = zpu."LocationID"
JOIN
    zones zdo ON t."DOLocationID" = zdo."LocationID"
LIMIT 100;
```

## Project Structure

- `docker-compose.yaml` - Docker Compose configuration for PostgreSQL and pgAdmin
- `Dockerfile` - Creates the data ingestion container
- `ingest_data.py` - Script to download and load taxi trip data
- `upload_zones.py` - Script to load taxi zone lookup data
- `requirements.txt` - Python dependencies

## Shutting Down

```bash
# Stop and remove containers
docker-compose down

# Remove the network
docker network rm pg-network
```

## Resources

- [NYC TLC Trip Record Data](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Documentation](https://docs.docker.com/)

## License

MIT