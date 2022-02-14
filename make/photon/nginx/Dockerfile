ARG harbor_base_image_version
ARG harbor_base_namespace
FROM build-harbor.alauda.cn/devops/harbor-nginx-base:${harbor_base_image_version}

VOLUME /var/cache/nginx /var/log/nginx /run

STOPSIGNAL SIGQUIT

HEALTHCHECK CMD curl --fail -s http://127.0.0.1:8080 || exit 1

USER nginx

CMD ["nginx", "-g", "daemon off;"]
