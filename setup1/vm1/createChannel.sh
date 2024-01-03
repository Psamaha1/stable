export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/msp/tlscacerts/tlsca.neXt.com-cert.pem
export PEER0_FF_CA=${PWD}/crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForPeer0FF(){
    export CORE_PEER_LOCALMSPID="FFMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FF_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/FF.neXt.com/users/Admin@FF.neXt.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1FF(){
    export CORE_PEER_LOCALMSPID="FFMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FF_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/FF.neXt.com/users/Admin@FF.neXt.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
}

createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0FF
    
    # Replace localhost with your orderer's vm IP address
    peer channel create -o 34.16.131.165:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.neXt.com \
    -f ./../../artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

# createChannel

joinChannel(){
    setGlobalsForPeer0FF
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer1FF
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
}

# joinChannel

updateAnchorPeers(){
    setGlobalsForPeer0FF
    # Replace localhost with your orderer's vm IP address
    peer channel update -o 34.16.131.165:7050 --ordererTLSHostnameOverride orderer.neXt.com -c $CHANNEL_NAME -f ./../../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

createChannel
joinChannel
updateAnchorPeers