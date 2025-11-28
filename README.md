Production-ready Mautic 5 stack running under Docker.\
Uses MariaDB, Redis, and a custom Mautic image that loads secrets at
runtime from `/run/secrets/mautic`.

------------------------------------------------------------------------

## 📁 Directory Structure

    /
    ├── compose.yaml
    ├── Dockerfile
    └── docker-entrypoint-mautic.sh

-   **compose.yaml** -- Defines all services (Mautic, MariaDB, Redis),
    volumes, networks, Traefik labels, and secret mounts.
-   **Dockerfile** -- Extends `mautic/mautic:5-apache`, adds PHP Redis
    extension, and installs the custom entrypoint.
-   **docker-entrypoint-mautic.sh** -- Loads secrets from
    `/run/secrets/mautic` and passes control to Mautic's upstream
    entrypoint.

------------------------------------------------------------------------

## 🏗️ Stack Components

### **Mautic**

-   Custom image (`Dockerfile`) based on `mautic/mautic:5-apache`
-   Loads secrets at runtime:
    -   `MAUTIC_DB_PASSWORD`
    -   `MAUTIC_MAILER_DSN`
-   Persists:
    -   `/var/www/html/var`
    -   `/var/www/html/media`
    -   `/var/www/html/config`
-   Uses Redis Messenger DSN: `redis://redis:6379/messages`

### **MariaDB 10.11**

-   Static (non-secret) database name: `mautic_db`
-   Static database user: `webadmin_db`
-   Loads passwords via:
    -   `MARIADB_PASSWORD_FILE=/run/secrets/mautic/mautic_db_password`
    -   `MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mautic/mautic_db_root_password`
-   Persists data in `db_data`

### **Redis**

-   Local Redis instance
-   Used exclusively for Mautic's Messenger queue
-   Data stored in `redis_data`

------------------------------------------------------------------------

## 🔧 Configuration Notes

### Mautic

-   Loads secrets only at runtime
-   DB password and mailer DSN never appear in `compose.yaml`
-   Writes final configuration into `mautic_config` volume

### MariaDB

-   DB name/user defined statically inside compose
-   Passwords loaded from mounted files via `*_FILE`

### Redis

-   AOF enabled
-   Local-only, not exposed externally

------------------------------------------------------------------------

## 🔒 Security Considerations

**Secrets are safe from:** - `docker-compose.yaml` - Git commits -
`docker inspect` output

**Secrets are accessible to:** - Processes inside the container
(expected) - Anyone with `docker exec` access - Anyone with host
filesystem access to `/run/secrets/mautic`

Lock down: - SSH access - Membership in the `docker` group - Permissions
on `/run/secrets/mautic`

------------------------------------------------------------------------

## 📌 Requirements

-   Docker 24+
-   Docker Compose V2
-   External Traefik stack (`infra-traefik`)
-   External network: `bounded-net`
