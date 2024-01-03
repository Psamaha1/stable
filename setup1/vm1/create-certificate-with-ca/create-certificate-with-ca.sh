createcertificatesForFF() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/FF.neXt.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.FF.neXt.com --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-FF-neXt-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-FF-neXt-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-FF-neXt-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-FF-neXt-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.FF.neXt.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.FF.neXt.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.FF.neXt.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.FF.neXt.com --id.name FFadmin --id.secret FFadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  mkdir -p ../crypto-config/peerOrganizations/FF.neXt.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com
  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.FF.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/msp --csr.hosts peer0.FF.neXt.com --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/msp/config.yaml
  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.FF.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls --enrollment.profile tls --csr.hosts peer0.FF.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/server.key
  mkdir ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/msp/tlscacerts/ca.crt
  mkdir ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/tlsca/tlsca.FF.neXt.com-cert.pem
  mkdir ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer0.FF.neXt.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/ca/ca.FF.neXt.com-cert.pem

  # ------------------------------------------------------------------------------------------------
  # Peer1
  mkdir -p ../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com
  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.FF.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/msp --csr.hosts peer1.FF.neXt.com --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/msp/config.yaml
  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.FF.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/tls --enrollment.profile tls --csr.hosts peer1.FF.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/peers/peer1.FF.neXt.com/tls/server.key

  # --------------------------------------------------------------------------------------------------
  # Admin
  mkdir -p ../crypto-config/peerOrganizations/FF.neXt.com/users
  mkdir -p ../crypto-config/peerOrganizations/FF.neXt.com/users/User1@FF.neXt.com
  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.FF.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/users/User1@FF.neXt.com/msp --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  mkdir -p ../crypto-config/peerOrganizations/FF.neXt.com/users/Admin@FF.neXt.com
  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://FFadmin:FFadminpw@localhost:7054 --caname ca.FF.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/users/Admin@FF.neXt.com/msp --tls.certfiles ${PWD}/fabric-ca/FF/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/FF.neXt.com/users/Admin@FF.neXt.com/msp/config.yaml

}

createcertificatesForFF
