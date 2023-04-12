FROM nginx:1.24@sha256:22cb51c7e9e05724dd1c46789e15cdb78617d1904c7c78a2829c8550c6b46e40

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
