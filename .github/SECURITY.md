# Security Policy

## Supported Versions

OEDC is currently maintained on the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| 0.x.x   | :x:                |

Security fixes are generally applied to the latest maintained release.

## Reporting a Vulnerability

If you discover a security vulnerability in OEDC, please report it responsibly rather than opening a public issue.

Please contact us at [zouariomar20@gmail.com](mailto:zouariomar20@gmail.com) with:

1. A clear description of the vulnerability.
2. The affected OEDC version or commit, if known.
3. Steps required to reproduce the issue.
4. The potential security impact.
5. A proof of concept or relevant logs, where available.
6. Any suggested mitigation, if known.

We aim to acknowledge vulnerability reports within **48 hours** and will work with the reporter to investigate and address confirmed issues.

Please avoid including passwords, API keys, database credentials, personal information, or other sensitive data in vulnerability reports.

## Security Practices

OEDC is a Docker-based Oracle Database Enterprise Edition deployment. Security considerations include:

### 1. Credential Management

Database configuration values, including `ORACLE_PWD`, are provided through environment variables and should be stored in a local `.env` file.

- Never commit `.env` files containing real credentials.
- Use strong, unique database passwords.
- Treat `.env` files and container environment variables as sensitive.
- Rotate credentials if they are accidentally exposed.

### 2. Database Persistence

OEDC uses the `oracle_data` Docker volume to persist Oracle database files.

Because the database persists across container recreation:

- Protect access to the Docker host and Docker volumes.
- Do not assume that removing the container removes database data.
- Changing initialization credentials or database settings may not affect an already-initialized database.
- Back up important database data according to your operational requirements.

### 3. Network Exposure

By default, the Oracle listener port (`1521`) is not published to the host by the Compose configuration.

This limits database access to services that can reach the Docker Compose network.

If host access is required, publishing `1521:1521` increases the database's network exposure. Only expose the port to trusted networks and restrict access using appropriate host or network firewall rules.

### 4. Initialization Scripts

Files placed in `./init-script` are mounted into the Oracle container and executed during container startup.

Initialization scripts should:

- Be reviewed before execution.
- Never contain hardcoded production credentials or secrets.
- Avoid destructive operations unless explicitly intended.
- Be written to be idempotent where possible, because startup scripts can execute on every container start.
- Be treated as trusted code with the same care as application source code.

### 5. Container and Image Security

OEDC uses Oracle's official Enterprise Edition container image:

`container-registry.oracle.com/database/enterprise:latest`

For production or security-sensitive deployments:

- Prefer a specific, reviewed image version rather than relying on a mutable `latest` tag.
- Keep Docker and the Oracle container image up to date.
- Obtain images from trusted registries.
- Review image changes before deploying updates.
- Avoid running unrelated workloads in the same container.

### 6. Source and Secret Management

Do not commit sensitive information to the repository, including:

- Database passwords
- API keys
- Private keys
- Access tokens
- Production configuration containing secrets
- Credentials embedded in SQL or shell initialization scripts

Use environment-specific secret-management mechanisms where appropriate.

### 7. Host Security

Docker provides isolation, but container security depends on the security of the underlying host.

Keep the following components appropriately secured and updated:

- Operating system
- Docker Engine
- Docker Compose
- Oracle Database container image
- Host filesystem and Docker volumes

Access to the Docker daemon should be restricted to trusted users because Docker access can provide extensive control over the host system.

## Security Contributions

Contributors can help improve OEDC security by:

- Avoiding hardcoded credentials and secrets.
- Reviewing Docker and Compose configuration changes for unintended exposure.
- Reviewing initialization scripts for unsafe database operations.
- Keeping dependencies and container images up to date.
- Testing security-sensitive changes before submitting pull requests.
- Reporting vulnerabilities privately through the process described above.

Please do not include real credentials or other sensitive information in commits, issues, or pull requests.

## Scope

This security policy covers the OEDC repository and its Docker-based Oracle database deployment configuration.

Vulnerabilities in Oracle Database itself, Docker, Docker Compose, or third-party components should generally be reported to the respective upstream project or vendor when the issue is not specific to OEDC's configuration or integration.

## Resources

For additional security guidance:

- [OWASP Secure Coding Practices Checklist](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Coding_Practices_Checklist.html)
- [CWE Top 25 Most Dangerous Software Weaknesses](https://cwe.mitre.org/top25/)
- [Docker Security Documentation](https://docs.docker.com/engine/security/)
- [Oracle Container Registry](https://container-registry.oracle.com/)

Thank you for helping keep OEDC secure and protecting users who deploy it.
