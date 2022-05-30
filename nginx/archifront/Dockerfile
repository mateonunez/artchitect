FROM nginx:latest

ENV NGINX_FPM_HOST architect_nginx_archifront
ENV ARCHIFRONT_AUTHENTICATION_HOST architect_frontend_archifront_authentication
ENV ARCHIFRONT_HOMEPAGE_HOST architect_frontend_archifront_homepage

RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./archifront.conf /etc/nginx/archifront.tmpl
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
