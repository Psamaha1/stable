export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/msp/tlscacerts/tlsca.neXt.com-cert.pem
export PEER0_Clemson_CA=${PWD}/crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForPeer0Clemson() {
    export CORE_PEER_LOCALMSPID="ClemsonMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_Clemson_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/Clemson.neXt.com/users/Admin@Clemson.neXt.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1Clemson() {
    export CORE_PEER_LOCALMSPID="ClemsonMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_Clemson_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/Clemson.neXt.com/users/Admin@Clemson.neXt.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

}

fetchChannelBlock() {
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Clemson
    # Replace localhost with your orderer's vm IP address
    peer channel fetch 0 ./channel-artifacts/$CHANNEL_NAME.block -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.neXt.com \
        -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# fetchChannelBlock

joinChannel() {
    setGlobalsForPeer0Clemson
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    setGlobalsForPeer1Clemson
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

}

# joinChannel

updateAnchorPeers() {
    setGlobalsForPeer0Clemson
    # Replace localhost with your orderer's vm IP address
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.neXt.com \
        -c $CHANNEL_NAME -f ./../../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

}

updateAnchorPeers

# fetchChannelBlock
# joinChannel
# updateAnchorPeers
