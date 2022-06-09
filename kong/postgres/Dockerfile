FROM postgres:9.6

COPY ./docker-entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]