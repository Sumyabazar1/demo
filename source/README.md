## Run a Sepolia node on Bare-Metal linux From Source
### 1. Install

Personal Package Archive or PPA — a software repository — to get Geth.
```sh
# install go 1.20
wget  https://go.dev/dl/go1.20.2.linux-amd64.tar.gz # download go package
sudo tar -xvf go1.20.2.linux-amd64.tar.gz   # extract package
sudo mv go /usr/local  # move as executable
# download & install ethereum
git clone https://github.com/ethereum/go-ethereum.git
cd go-ethereum
make geth

#This will download the Prysm client and make it executable.
curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && chmod +x prysm.sh 

## beacon node and execution node needs to be authenticated using a JWT token
./prysm.sh beacon-chain generate-auth-secret

# install Consensus clients

```
### 2. Run an execution node
```sh

curl -O https://raw.githubusercontent.com/eth-clients/merge-testnets/main/sepolia/genesis.ssz # Sepolia genesis state

geth --authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts localhost --authrpc.jwtsecret jwt.hex #connect to a consensus client
./prysm.sh beacon-chain --execution-endpoint=http://localhost:8551 --sepolia --jwt-secret=jwt.hex --genesis-state=genesis.ssz --checkpoint-sync-url=https://sepolia.beaconstate.info --genesis-beacon-api-url=https://sepolia.beaconstate.info #Syncing
```
Later try this one:
https://github.com/metanull-operator/eth2-ubuntu/blob/master/v2/setup.md

## issue
```sh
# on GETH sometimes
Served engine_newPayloadV2               conn=127.0.0.1:51848 reqid=2 duration=10.062452ms err="Invalid parameters" errdata="{Error:non-nil withdrawals pre-shanghai}"
# on Prysm
[2024-01-09 04:32:21]  WARN initial-sync: Skip processing batched blocks error=beacon node doesn't have a parent in db with root: 0xb2f489a95fc5fcb785d8e11c5e8b12363485c652ea7d2ebd31e76bb4f40f2dd3 (in processBatchedBlocks, slot=4084257)
related: https://github.com/ethereum/go-ethereum/issues/27812
```
![Alt text](<Screen Shot 2024-01-09 at 04.31.53.png>)





/usr/local/bin/geth --sepolia --syncmode full --http --http.api net,eth,personal,web3,engine,admin --authrpc.vhosts=localhost --authrpc.jwtsecret=/home/soc/source/jwt.hex --http.addr 0.0.0.0 --http.port 8545 --http.vhosts * --http.corsdomain * --ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.api net,eth,personal,web3 --ws.origins *








geth --sepolia --syncmode full --http --http.api net,eth,personal,web3,engine,admin --authrpc.vhosts=localhost --authrpc.jwtsecret=/home/soc/source/jwt.hex --http.addr 0.0.0.0 --http.port 8545 --http.vhosts * --http.corsdomain * --ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.api net,eth,personal,web3 --ws.origins *