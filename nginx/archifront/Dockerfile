FROM nginx:1.24@sha256:1f4e248813821b9d534d4b43366c10e67eb2ac3ca4040585d36fc4805be07f3f

ENV NGINX_HOST archifront_nginx
ENV ARCHIFRONT_AUTHENTICATION_HOST archifront_authentication
ENV ARCHIFRONT_HOMEPAGE_HOST archifront_homepage

RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./archifront.conf /etc/nginx/archifront.tmpl
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
