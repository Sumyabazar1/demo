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
1 . ( started Geth in mainnet mode but Prysm on the Testnet)
 engine_newPayloadV2               conn=127.0.0.1:51848 reqid=2 duration=10.062452ms err="Invalid parameters" errdata="{Error:non-nil withdrawals pre-shanghai}"
 ```
## Resolved
![Alt text](<Screen Shot 2024-01-09 at 18.20.05.png>)
Commands:
```sh
geth --sepolia --syncmode full  -datadir "/home/soc/source/dist/data/" --authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts localhost --authrpc.jwtsecret=/home/soc/source/jwt.hex
./prysm.sh beacon-chain --execution-endpoint=http://localhost:8551 --sepolia --jwt-secret=/home/soc/source/jwt.hex --genesis-state=/home/soc/source/genesis.ssz --checkpoint-sync-url=https://sepolia.beaconstate.info --genesis-beacon-api-url=https://sepolia.beaconstate.info --datadir=/home/soc/source/dist/data/
```