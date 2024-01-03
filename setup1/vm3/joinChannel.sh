export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/msp/tlscacerts/tlsca.neXt.com-cert.pem
export PEER0_SCN_CA=${PWD}/crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForPeer0SCN() {
    export CORE_PEER_LOCALMSPID="SCNMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SCN_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/SCN.neXt.com/users/Admin@SCN.neXt.com/msp
    export CORE_PEER_ADDRESS=localhost:11051

}

setGlobalsForPeer1SCN() {
    export CORE_PEER_LOCALMSPID="SCNMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SCN_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/SCN.neXt.com/users/Admin@SCN.neXt.com/msp
    export CORE_PEER_ADDRESS=localhost:12051

}

fetchChannelBlock() {
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0SCN

    # Replace localhost with your orderer's vm IP address
    peer channel fetch 0 ./channel-artifacts/$CHANNEL_NAME.block -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.neXt.com \
        -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# fetchChannelBlock

joinChannel() {
    setGlobalsForPeer0SCN
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    setGlobalsForPeer1SCN
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

}

# joinChannel

updateAnchorPeers() {
    setGlobalsForPeer0SCN

    # Replace localhost with your orderer's vm IP address
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.neXt.com \
        -c $CHANNEL_NAME -f ./../../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

}

# updateAnchorPeers

fetchChannelBlock
joinChannel
updateAnchorPeers
