#!/bin/bash

export PATH=$PATH:/opt/zimbra/bin

echo zimbra config

if [[ "$ZIMBRA_HOST" == "zimbra-82" ]] && [[ "$ZIMBRA_DOMAIN" = "bring.out.ba" ]] ; then

zmprov mcf zimbraMtaSmtpdClientPortLogging yes
zmprov mcf zimbraMtaMyHostname zimbra.bring.out.ba
zmprov mcf zimbraMtaRelayHost smtp-ext-gw.bring.out.ba

postfix reload

else
   echo nothing to configure
fi
