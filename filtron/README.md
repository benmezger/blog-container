# docker-filtron

This docker image runs the reverse filtering proxy [filtron](https://github.com/asciimoo/filtron/) by [asciimoo](https://github.com/asciimoo). 
The original purpose of this program was to defend [searx](https://asciimoo.github.com/searx/), but it can be used to guard any web application.

## Quick Start
Run the filtron docker image:
``docker run dasmaeh/docker-filtron -l my-webapp:app``

## Environment variables
- `APP_PORT` sets the target port, so the port the protected webapp is listening on
- `RULES_FILE` the rule set to use. See [https://github.com/asciimoo/filtron/](https://github.com/asciimoo/filtron/) how to create rules. Defaults to [`example_rules.json`](https://github.com/asciimoo/filtron/blob/master/example_rules.json).

## Volumes
You might want to mount a host directory to `/etc/filtron`, so you can edit rulesets from the host system.

## Link the app
Filtron wil proxy any requests to `app:APP_PORT` so you need to link your app to `app`

## docker-compose
I'm using this filtron image to protect my searx instance as defined in the follwing `docker-compose.yml`
```
version: '2'

services:
    filtron:
        image: dasmaeh/docker-filtron
        container_name: filtron
        domainname: mydomain.tld
        hostname: searx
        networks:
            - inside
            - outside
        environment:
            VIRTUAL_HOST: "searx.mydomain.tld"
            VIRTUAL_PORT: 4004
            LETSENCRYPT_HOST: "searx.mydomain.tld"
            LETSENCRYPT_EMAIL: "admin@mydomain.tld"
            APP_PORT: 8888
        volumes:
            - /data/searx/filtron:/etc/filtron
        links:
            - searx:app

    searx:
        image: wonderfall/searx
        container_name: searx
        networks:
            - inside

networks:
    inside:
    outside:
        external:
            name: proxy-tier
```
The environment variables `VIRTUAL_HOST`, `VIRTUAL_PORT`, `LETSENCRYPT_HOST` and `LETSENCRYPT_EMAIL` are needed by the [nginx letsencrypt proxy](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) taking care of tls encryption.
