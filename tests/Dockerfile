FROM matrixdotorg/synapse

ENV SYNAPSE_CONFIG_DIR=/srv SYNAPSE_DATA_DIR=/srv SYNAPSE_SERVER_NAME=tests SYNAPSE_REPORT_STATS=no

WORKDIR $SYNAPSE_CONFIG_DIR
RUN chown -R 991:991 . \
 && /start.py generate \
 && sed -i 's=/data=/srv=;s=8008=80=;s=#sup=sup=;' homeserver.yaml \
 && echo "" >> homeserver.yaml \
 && echo "rc_message:" >> homeserver.yaml \
 && echo "  burst_count: 1000" >> homeserver.yaml \
 && echo "rc_registration:" >> homeserver.yaml \
 && echo "  burst_count: 1000" >> homeserver.yaml \
 && echo "rc_registration_token_validity:" >> homeserver.yaml \
 && echo "  burst_count: 1000" >> homeserver.yaml \
 && echo "rc_login:" >> homeserver.yaml \
 && echo "  address:" >> homeserver.yaml \
 && echo "    burst_count: 1000" >> homeserver.yaml \
 && echo "  account:" >> homeserver.yaml \
 && echo "    burst_count: 1000" >> homeserver.yaml \
 && echo "  failed_attempts:" >> homeserver.yaml \
 && echo "    burst_count: 1000" >> homeserver.yaml \
 && echo "rc_joins:" >> homeserver.yaml \
 && echo "  burst_count: 1000" >> homeserver.yaml \
 && python -m synapse.app.homeserver --config-path homeserver.yaml --generate-keys

RUN pip install --no-cache-dir markdown matrix-nio httpx coverage

WORKDIR /app

CMD ./tests/start.py -vvv
