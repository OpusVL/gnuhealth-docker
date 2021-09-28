#!/bin/bash

source .gnuhealthrc

sed --in-place 's/^uri/#&/' ${GNUHEALTH_DIR}/tryton/server/config/trytond.conf

cd ${GNUHEALTH_DIR}/tryton/server/${TRYTOND}/bin
./trytond-admin --all --database=gnuhealth --email=${GNUHEALTH_ADMIN_EMAIL}
