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

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./../../artifacts/src/github.com/fabcar/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./../../artifacts/src/github.com/fabcar/go"
CC_NAME="fabcar"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0Clemson
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.Clemson ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0Clemson
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.Clemson ===================== "

}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0Clemson
    peer lifecycle chaincode queryinstalled >&log.txt

    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.Clemson on channel ===================== "
}

# queryInstalled

approveForMyClemson() {
    setGlobalsForPeer0Clemson

    # Replace localhost with your orderer's vm IP address
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.neXt.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from org 2 ===================== "
}
# queryInstalled
# approveForMyClemson

checkCommitReadyness() {

    setGlobalsForPeer0Clemson
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_Clemson_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness
