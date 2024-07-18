version: '3.9'

x-default-opts:
  &default-opts
  logging:
    options:
      max-size: "10m"

networks:
  keycloak-network:
    driver: overlay

services:
  keycloak:
    <<: *default-opts
    image: bitnami/keycloak:${image_tag}
    environment:
      KC_DB: postgres
      KC_DB_URL_HOST: ${db_host}
      KC_DB_URL_DATABASE: ${db_name}
      KC_DB_USERNAME: ${db_username}
      KC_DB_PASSWORD: ${db_password}
      KC_DB_SCHEMA: public
      KEYCLOAK_ADMIN: ${admin_user}
      KEYCLOAK_ADMIN_PASSWORD: ${admin_user_password}
      KEYCLOAK_ENABLE_HEALTH_ENDPOINTS: 'true'
      KEYCLOAK_ENABLE_STATISTICS: 'true'
      KC_HOSTNAME: ${trusted_domain}
      KC_PROXY: edge
      KC_PROXY_ADDRESS_FORWARDING: 'true'
      KC_HTTP_ENABLED: 'true'
    networks:
      - keycloak-network
    ports:
      - "8080:8080"
    healthcheck:
      test: timeout 10s bash -c ':> /dev/tcp/127.0.0.1/8080' || exit 1
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 90s
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints:
          - node.role == manager
      resources:
        limits:
          cpus: '1.55'
          memory: 6G
        reservations:
          cpus: '0.55'
          memory: 2G
