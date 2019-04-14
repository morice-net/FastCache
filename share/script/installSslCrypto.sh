#!/bin/bash

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    # 64-bit
    if [ ! -f "/usr/lib64/libssl.1.0.0" ]; then sudo install ../lib/libssl.so /usr/lib64/libssl.so.1.0.0; fi
    if [ ! -f "/usr/lib64/libcrypto.1.0.0" ]; then sudo install ../lib/libssl.so /usr/lib64/libcrypto.so.1.0.0; fi
else
    # 32-bit stuff here
    if [ ! -f "/usr/lib/libssl.1.0.0" ]; then sudo install ../lib/libssl.so /usr/lib/libssl.so.1.0.0; fi
    if [ ! -f "/usr/lib/libcrypto.1.0.0" ]; then sudo install ../lib/libssl.so /usr/lib/libcrypto.so.1.0.0; fi
fi
