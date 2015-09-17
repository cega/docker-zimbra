#!/bin/bash

zimbra_keystrokes() {

if [[ $ZIMBRA_VER =~ ^8\.6.* ]] ; then  
# Don't install zimbra-dnscache
touch /tmp_data/installZimbra-keystrokes
cat <<EOF >/tmp_data/installZimbra-keystrokes
y
n
y
y
y
n
y
y
y
y
y
y
y
y
EOF

return
fi


if [[ $ZIMBRA_VER =~ ^8\.0.* ]] ; then  
touch /tmp_data/installZimbra-keystrokes
cat <<EOF >/tmp_data/installZimbra-keystrokes
y
y
y
y
y
y
y
y
y
y
y
y
y
EOF

return
fi


}



