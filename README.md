# GLPI Dockerized

[![Docker Image CI](https://github.com/emadruida/glpi/actions/workflows/main.yml/badge.svg)](https://github.com/emadruida/glpi/actions/workflows/main.yml)

Docker container that serves GLPI in its own subdomain on Apache

## How to use this image

A sample configuration using compose could be the following `docker-compose.yml` file:

```yml
version: '3.9'

services:
  glpi:
    container_name: glpi
    image: emadruida/glpi
    ports:
      - "80:80"
    volumes:
      - ./glpi/files:/var/www/html/glpi/files
      - ./glpi/config:/var/www/html/glpi/config
      - ./glpi/plugins:/var/www/html/glpi/plugins
      - ./glpi/marketplace:/var/www/html/glpi/marketplace
  
  db:
    image: mysql
    container_name: db
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=mysupersecurepassword
      - MYSQL_DATABASE=glpi
    volumes:
      - ./mysql/data:/var/lib/mysql
```

In the same folder as the `docker-compose.yml` file, create the following directories:

- `glpi/files`
- `glpi/config`
- `glpi/plugins`
- `glpi/marketplace`

For the mysql container, create the `mysql/data` directory in the same folder where the
`docker-compose.yml` file is located.

Execute docker compose up:

```bash
docker compose up -d
```

In this example we mount as bind volumes the directories used by GLPI both for
configuration and user data.

These directories are thus saved between GLPI installations, allowing us to upgrade
to newer versions of GLPI without loosing our data.
