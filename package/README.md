## Run a Sepolia node on Bare-Metal linux From package
### 1. Install
Personal Package Archive or PPA — a software repository — to get Geth.
```sh
mkdir ethereum   # prep 
cd ethereum && mkdir consensus && mkdir execution  # prep 
cd consensus && curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && chmod +x prysm.sh # This will download the Prysm client and make it executable.
./prysm.sh beacon-chain generate-auth-secret # generate this JWT token
# install Geth
sudo add-apt-repository -y ppa:ethereum/ethereum # add eth package to ubuntu 
sudo apt-get update # update package list
sudo apt-get install geth ( I only want Geth suite not Complete Ethereum since I dont much space) # install eth
```
### 2. Run an execution client
```sh
cd ~/ethereum/
cd consensus && curl -O https://raw.githubusercontent.com/eth-clients/merge-testnets/main/sepolia/genesis.ssz 
./prysm.sh beacon-chain --execution-endpoint=http://localhost:8551 --mainnet --jwt-secret=../jwt.hext --sepolia --suggested-fee-recipient=0x85b32CcFd4A0ba21c4caA8801327b1Cf0679B2c1  --genesis-state=/home/ec2-user/ethereum/consensus/genesis.ssz #test
```

## geth.service /Setting up geth as a service under systemd/
```sh
[Unit]
Description=Ethereum Go Client Service
After=syslog.target network.target

[Service]
User=soc
Environment=HOME=/home/soc/ethereum
Type=simple
ExecStart=/usr/bin/geth --http --http.port 8545 --http.addr 0.0.0.0 --http.api eth,net,web3,admin --http.vhosts "*" --http.corsdomain "*" --sepolia --authrpc.jwtsecret /home/soc/ethereum/jwt.hex --authrpc.vhosts "*" --override.terminaltotaldifficulty 17000000000000000
KillMode=process
KillSignal=SIGINT
TimeoutStopSec=90
Restart=on-failure
RestartSec=10s


[Install]
WantedBy=multi-user.target
```
```sh
systemctl start geth && systemctl enable geth  # start service when boot
```
## prysm.service /Setting up prysm as a service under systemd/
```sh

[Unit]
Description=Prysm Beacon Chain
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/home/soc/ethereum/consensus/prysm.sh beacon-chain --jwt-secret=/home/soc/ethereum/jwt.hex --execution-endpoint=http://localhost:8551 --sepolia --suggested-fee-recipient=0x85b32CcFd4A0ba21c4caA8801327b1Cf0679B2c1 --genesis-state=/home/soc/ethereum/consensus/genesis.ssz
[Install]
WantedBy=multi-user.target
```
```sh
systemctl start prysm && systemctl enable prysm # start service when boot
```

### 3. check
```sh
systemctl status prysm
```
![Alt text](<Screen Shot 2024-01-09 at 02.22.28.png>)
```sh
systemctl status geth
```
![Alt text](<Screen Shot 2024-01-09 at 01.20.58.png>)

### Node sync
![Alt text](<Screen Shot 2024-01-09 at 02.49.35.png>)


/usr/local/bin/geth --sepolia --syncmode full --override.terminaltotaldifficulty 17000000000000000 --metrics --metrics.addr=<metrics_port> --http --http.api net,eth,personal,web3,engine,admin --authrpc.vhosts=localhost --authrpc.jwtsecret=/path/to/jwt.hex --http.addr 0.0.0.0 --http.port 8545 --http.vhosts * --http.corsdomain * --ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.api net,eth,personal,web3 --ws.origins * --datadir /path/to/database --authrpc.jwtsecret=/path/to/jwt.hex



###
issue
```sh
1. Post-merge network, but no beacon client seen. Please launch one to follow the chain!
2. unable to start beacon node: database contract is 0x00000000219ab540356cbb839cbe05303d7705fa but tried to run with 0x7f02c3e3c98b133055b8b348b2ac625669ed295d. This likely means you are trying to run on a different network than what the database contains. You can run once with '--clear-db' to wipe the old database or use an alternative data directory with '--datadir'
```










/home/soc/ethereum/consensus/prysm.sh beacon-chain --accept-terms-of-use --sepolia -execution-endpoint=http://localhost:8551 --genesis-state=/home/soc/ethereum/consensus/genesis.ssz --jwt-secret=/home/soc/ethereum/jwt.hex --datadir=/home/soc/ethereum/consensus/ --terminal-total-difficulty-override 17000000000000000