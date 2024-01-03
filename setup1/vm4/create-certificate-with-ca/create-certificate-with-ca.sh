createCretificateForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/neXt.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/neXt.com

  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/neXt.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer2"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer3"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/neXt.com/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/neXt.com/orderers/neXt.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/msp --csr.hosts orderer.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls --enrollment.profile tls --csr.hosts orderer.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/msp/tlscacerts/tlsca.neXt.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/neXt.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/msp/tlscacerts/tlsca.neXt.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com

  echo
  echo "## Generate the orderer2 msp"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/msp --csr.hosts orderer2.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/msp/config.yaml

  echo
  echo "## Generate the orderer2-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/tls --enrollment.profile tls --csr.hosts orderer2.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer2.neXt.com/msp/tlscacerts/tlsca.neXt.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com

  echo
  echo "## Generate the orderer3 msp"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/msp --csr.hosts orderer3.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/msp/config.yaml

  echo
  echo "## Generate the orderer3-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/tls --enrollment.profile tls --csr.hosts orderer3.neXt.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/neXt.com/orderers/orderer3.neXt.com/msp/tlscacerts/tlsca.neXt.com-cert.pem
  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/neXt.com/users
  mkdir -p ../crypto-config/ordererOrganizations/neXt.com/users/Admin@neXt.com

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/neXt.com/users/Admin@neXt.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/neXt.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/neXt.com/users/Admin@neXt.com/msp/config.yaml

}

createCretificateForOrderer