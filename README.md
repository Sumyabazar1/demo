## Prometheus & Grafana

```sh
docker run \
    -p 9090:9090 \
    -v /path/to/prometheus:/etc/prometheus \
    prom/prometheus:latest
```
`prometheus.yml`
```sh
  global:
    scrape_interval: 15s
    evaluation_interval: 15s

  # Load and evaluate rules in this file every 'evaluation_interval' seconds.
  rule_files:
    - 'record.geth.rules.yml'

  # A scrape configuration containing exactly one endpoint to scrape.
  scrape_configs:
    - job_name: 'go-ethereum'
      scrape_interval: 10s
      metrics_path: /debug/metrics/prometheus
      static_configs:
        - targets:
            - '127.0.0.1:6060'
          labels:
            chain: ethereum
```
`InfluxDB`
```sh
curl -tlsv1.3 --proto =https -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt update
sudo apt install influxdb -y
sudo systemctl enable influxdb
sudo systemctl start influxdb
sudo apt install influxdb-client```
```sh
curl -XPOST "http://localhost:8086/query" --data-urlencode "q=CREATE USER username WITH PASSWORD 'password' WITH ALL PRIVILEGES" # create user
influx -username 'username' -password 'password' # access shell to test

# database and user for Geth metrics 
create database geth
create user geth with password choosepassword

```
`Preparing Geth`
```sh
geth --metrics --metrics.influxdb --metrics.influxdb.endpoint "http://0.0.0.0:8086" --metrics.influxdb.username "geth" --metrics.influxdb.password "choosepassword"
```
`Setting up Grafana`
```sh
curl -tlsv1.3 --proto =https -sL https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```
Source Data
```sh
Name: InfluxDB
Query Language: InfluxQL
HTTP
  URL: http://localhost:8086
  Access: Server (default)
  Whitelisted cookies: None (leave blank)
Auth
  All options left as their default (switches off)
Custom HTTP Headers
  None
InfluxDB Details
  Database: geth
  User: <your-user-name>
  Password: <your-password>
  HTTP Method: GET
```
![Alt text](<docker/Screen Shot 2024-01-09 at 00.42.16.png>)
![Alt text](<docker/Screen Shot 2024-01-09 at 00.42.33.png>)






---------------------------------------------------------------
# Scipt
![Alt text](<Screen Shot 2024-01-09 at 05.05.30.png>)