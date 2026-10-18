[![Contributors](https://img.shields.io/badge/CONTRIBUTORS-01-blue?style=plastic)](https://github.com/ZouariOmar/dot-files/graphs/contributors)
[![Forks](https://img.shields.io/badge/FORKS-00-blue?style=plastic)](https://github.com/ZouariOmar/dot-files/network/members)
[![Stargazers](https://img.shields.io/badge/STARS-01-blue?style=plastic)](https://github.com/ZouariOmar/dot-files/stargazers)
[![Issues](https://img.shields.io/badge/ISSUES-00-blue?style=plastic)](https://github.com/ZouariOmar/dot-files/issues)
[![GPL License](https://img.shields.io/badge/LICENSE-GPL3.0-blue?style=plastic)](LICENSE)
[![Linkedin](https://img.shields.io/badge/Linkedin-7.2k-blue?style=plastic)](https://www.linkedin.com/in/zouari-omar)

<h1 align="center">
  <a href="https://github.com/zouari-oss/oedc"><img src="res/img/logo.png" alt="oedc"></a>
  OEDC
</h1>

<h4 align="center">Oracle Enterprise Database Container</h4>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"></a>
  <a href="#"><img src="https://img.shields.io/badge/oracle_enterprise-F80000?style=for-the-badge&logo=oracle&logoColor=white" alt="Oracle Enterprise"></a>
  <a href="#"><img src="https://img.shields.io/badge/ords-F80000?style=for-the-badge&logo=oracle&logoColor=white" alt="Oracle REST Data Services"></a>
  <a href="#"><img src="https://img.shields.io/badge/Open%20Source-3DA639?style=for-the-badge&logo=opensourceinitiative&logoColor=white" alt="Open Source"></a>
</p>

- [Features](#features)
- [Requirements](#requirements)
- [Quickstart](#quickstart)
  - [Start the Full Setup](#start-the-full-setup)
  - [Start Only Oracle Database](#start-only-oracle-database)
- [Emailware](#emailware)
- [License](#license)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

## Features

- **Oracle Enterprise Database**
  - Runs Oracle Database Enterprise using Oracle's official container image.
  - Configurable Oracle SID, PDB name, character set, and archive logging.
  - Persistent database storage using a Docker volume.

- **Oracle REST Data Services (ORDS)**
  - Dedicated ORDS container for exposing database schemas through REST APIs.
  - Automatically waits for the Oracle database to become healthy.
  - Configurable database host, port, service name, and ORDS settings.
  - Accessible on port `8080`.

- **Dynamic ORDS Schema Mapping**
  - Automatically enables ORDS for the configured database schema.
  - Supports custom URL mappings such as `/ords/app/v1`.
  - Supports multiple administrative users through `ORDS_USERS`.

- **Temporary Security Privileges**
  - Grants the required `INHERIT PRIVILEGES` permissions during ORDS configuration.
  - Automatically revokes temporary privileges after configuration.
  - Performs privilege cleanup if ORDS configuration fails.

- **Database Initialization**
  - Supports custom `.sql` and `.sh` scripts through the Oracle startup directory.
  - Provides an automated database initialization workflow.

- **Health Checks**
  - Monitors Oracle Database using `checkDBStatus.sh`.
  - Verifies ORDS through the `/ords/sql-developer` endpoint.
  - Starts ORDS only after Oracle Database becomes healthy.

- **Persistent Storage**
  - `oracle_data` persists Oracle database files.
  - `ords_config` persists ORDS configuration.

- **Environment-Based Configuration**
  - Database and ORDS settings can be customized through environment variables.

> [!IMPORTANT]
> Startup scripts run on _every_ container start, not just the first,
> make them idempotent. Because `oracle_data` persists, changing
> `ORACLE_PWD` or `ORACLE_SID` later has no effect unless the volume is removed;
> the database is only created once.

## Requirements

- [Git](https://github.com/git/git)
- [Docker](https://github.com/docker)

## Quickstart

### Start the Full Setup

To start the full `oedc` setup with ORDS enabled, set `ORDS_USERS` when starting
the stack:

```bash
ORDS_USERS=user_1,user_2 docker compose up
```

Alternatively, uncomment `ORDS_USERS` in the `oracle-db` service in
[docker-compose.yml](docker-compose.yml), then run:

```bash
docker compose up
```

### Start Only Oracle Database

If you only need the Oracle Database without ORDS:

```bash
docker compose up oracle-db
```

> [!IMPORTANT]
> The ORDS configuration is applied to the configured PDB and exposes the `app`
> schema using the `v1` URL mapping.

## Emailware

oedc is an [emailware](https://en.wiktionary.org/wiki/emailware). Meaning, if you liked using this repository or it has helped you in any way, I'd like you to send me an email at <zouariomar20@gmail.com> about anything you'd want to say about this repository. I'd really appreciate it!

## License

This repository is licensed under the **GPL License**. You are free to use, modify, and distribute the content. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or suggestions, feel free to reach out:

- **GitHub**: [ZouariOmar](https://github.com/ZouariOmar)
- **Email**: [zouariomar20@gmail.com](mailto:zouariomar20@gmail.com)
- **LinkedIn**: [Zouari Omar](https://www.linkedin.com/in/zouari-omar)

## Acknowledgments

Built with ❤️ for the open-source community.
