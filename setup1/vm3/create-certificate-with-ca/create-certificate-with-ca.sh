createcertificatesForSCN() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/SCN.neXt.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.SCN.neXt.com --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-SCN-neXt-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-SCN-neXt-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-SCN-neXt-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-SCN-neXt-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.SCN.neXt.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.SCN.neXt.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.SCN.neXt.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.SCN.neXt.com --id.name SCNadmin --id.secret SCNadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/SCN.neXt.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.SCN.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/msp --csr.hosts peer0.SCN.neXt.com --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.SCN.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls --enrollment.profile tls --csr.hosts peer0.SCN.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/tlsca/tlsca.SCN.neXt.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer0.SCN.neXt.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/ca/ca.SCN.neXt.com-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p ../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.SCN.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/msp --csr.hosts peer1.SCN.neXt.com --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.SCN.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/tls --enrollment.profile tls --csr.hosts peer1.SCN.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/peers/peer1.SCN.neXt.com/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/SCN.neXt.com/users
  mkdir -p ../crypto-config/peerOrganizations/SCN.neXt.com/users/User1@SCN.neXt.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.SCN.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/users/User1@SCN.neXt.com/msp --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/SCN.neXt.com/users/Admin@SCN.neXt.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://SCNadmin:SCNadminpw@localhost:10054 --caname ca.SCN.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/users/Admin@SCN.neXt.com/msp --tls.certfiles ${PWD}/fabric-ca/SCN/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/SCN.neXt.com/users/Admin@SCN.neXt.com/msp/config.yaml

}

createcertificatesForSCN

