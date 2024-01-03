
chmod -R 0755 ./crypto-config
# Delete existing artifacts
rm -rf ./crypto-config
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

echo $CHANNEL_NAME

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for FFMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./FFMSPanchors.tx -channelID $CHANNEL_NAME -asOrg FFMSP

echo "#######    Generating anchor peer update for ClemsonMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./ClemsonMSPanchors.tx -channelID $CHANNEL_NAME -asOrg ClemsonMSP

echo "#######    Generating anchor peer update for SCNMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./SCNMSPanchors.tx -channelID $CHANNEL_NAME -asOrg SCNMSP