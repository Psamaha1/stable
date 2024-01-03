export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/msp/tlscacerts/tlsca.neXt.com-cert.pem
export PEER0_FF_CA=${PWD}/crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/ca.crt
export PEER0_Clemson_CA=${PWD}/../vm2/crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/ca.crt
export PEER0_SCN_CA=${PWD}/../vm3/crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/


export CHANNEL_NAME=mychannel

setGlobalsForPeer0FF() {
    export CORE_PEER_LOCALMSPID="FFMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FF_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/FF.neXt.com/users/Admin@FF.neXt.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1FF() {
    export CORE_PEER_LOCALMSPID="FFMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FF_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/FF.neXt.com/users/Admin@FF.neXt.com/msp
    export CORE_PEER_ADDRESS=localhost:8051

}

# setGlobalsForPeer0Clemson() {
#     export CORE_PEER_LOCALMSPID="ClemsonMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_Clemson_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/../../artifacts/channel/crypto-config/peerOrganizations/Clemson.neXt.com/users/Admin@Clemson.neXt.com/msp
#     export CORE_PEER_ADDRESS=localhost:9051

# }

# setGlobalsForPeer1Clemson() {
#     export CORE_PEER_LOCALMSPID="ClemsonMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_Clemson_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/../../artifacts/channel/crypto-config/peerOrganizations/Clemson.neXt.com/users/Admin@Clemson.neXt.com/msp
#     export CORE_PEER_ADDRESS=localhost:10051

# }

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./../../artifacts/src/github.com/fabcar/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
#presetup

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./../../artifacts/src/github.com/fabcar/go"
CC_NAME="fabcar"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0FF
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.FF ===================== "
}
#packageChaincode

installChaincode() {
    setGlobalsForPeer0FF
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.FF ===================== "

}

#installChaincode

queryInstalled() {
    setGlobalsForPeer0FF
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.FF on channel ===================== "
}

#queryInstalled

approveForMyFF() {
    setGlobalsForPeer0FF
    # set -x
    # Replace localhost with your orderer's vm IP address
    peer lifecycle chaincode approveformyorg -o 34.16.131.165:7050 \
        --ordererTLSHostnameOverride orderer.neXt.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

#queryInstalled
#approveForMyFF

checkCommitReadyness() {
    setGlobalsForPeer0FF
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0FF
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.neXt.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_FF_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_Clemson_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_SCN_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required
}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0FF
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

# presetup
# packageChaincode
# installChaincode
# queryInstalled
# approveForMyFF
# checkCommitReadyness
# approveForMyClemson
# checkCommitReadyness
# commitChaincodeDefination
# queryCommitted
# chaincodeInvokeInit
# sleep 5
# chaincodeInvoke
# sleep 3
# chaincodeQuery
