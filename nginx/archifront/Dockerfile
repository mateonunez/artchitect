FROM nginx:1.24@sha256:fc6ecdf9b653238a3f37e6f41dfdf8eddc99c38b0949ecd2995bc4fa5f31ec61

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
