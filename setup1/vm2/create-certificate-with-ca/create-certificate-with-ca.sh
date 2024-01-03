createCertificateForClemson() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/Clemson.neXt.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.Clemson.neXt.com --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-Clemson-neXt-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-Clemson-neXt-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-Clemson-neXt-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-Clemson-neXt-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.Clemson.neXt.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.Clemson.neXt.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.Clemson.neXt.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.Clemson.neXt.com --id.name Clemsonadmin --id.secret Clemsonadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  mkdir -p ../crypto-config/peerOrganizations/Clemson.neXt.com/peers
  mkdir -p ../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.Clemson.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/msp --csr.hosts peer0.Clemson.neXt.com --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/msp/config.yaml
  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.Clemson.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls --enrollment.profile tls --csr.hosts peer0.Clemson.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/server.key
  mkdir ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/msp/tlscacerts/ca.crt
  mkdir ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/tlsca/tlsca.Clemson.neXt.com-cert.pem
  mkdir ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer0.Clemson.neXt.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/ca/ca.Clemson.neXt.com-cert.pem

  # --------------------------------------------------------------------------------
  #  Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.Clemson.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/msp --csr.hosts peer1.Clemson.neXt.com --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/msp/config.yaml
  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.Clemson.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/tls --enrollment.profile tls --csr.hosts peer1.Clemson.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/peers/peer1.Clemson.neXt.com/tls/server.key

  # -----------------------------------------------------------------------------------
  # Admin
  mkdir -p ../crypto-config/peerOrganizations/Clemson.neXt.com/users
  mkdir -p ../crypto-config/peerOrganizations/Clemson.neXt.com/users/User1@Clemson.neXt.com
  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.Clemson.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/users/User1@Clemson.neXt.com/msp --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  mkdir -p ../crypto-config/peerOrganizations/Clemson.neXt.com/users/Admin@Clemson.neXt.com
  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://Clemsonadmin:Clemsonadminpw@localhost:8054 --caname ca.Clemson.neXt.com -M ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/users/Admin@Clemson.neXt.com/msp --tls.certfiles ${PWD}/fabric-ca/Clemson/tls-cert.pem
  cp ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/Clemson.neXt.com/users/Admin@Clemson.neXt.com/msp/config.yaml

}

createCertificateForClemson