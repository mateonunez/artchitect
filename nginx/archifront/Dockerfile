FROM nginx:1.23@sha256:2ab30d6ac53580a6db8b657abf0f68d75360ff5cc1670a85acb5bd85ba1b19c0

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
