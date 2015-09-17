#!/bin/bash

export PATH=$PATH:/opt/zimbra/bin

echo zimbra config

zmprov mcf zimbraMtaSmtpdClientPortLogging yes
zmprov mcf zimbraMtaMyHostname zimbra.bring.out.ba
zmprov mcf zimbraMtaRelayHost smtp-ext-gw.bring.out.ba

postfix reload
