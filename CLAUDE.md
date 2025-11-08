# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a self-hosted AI homelab package that combines n8n (workflow automation), Supabase (database/auth/storage), Open WebUI (chat interface), LiteLLM (LLM proxy), and Nextcloud (file storage) into a unified Docker Compose stack. The repository is organized with all services in `vps-config/` directory.

## Project Structure

- **Root**: Contains only git metadata and `vps-config/` directory
- **vps-config/**: All project files including Docker Compose configs, environment examples, and service configurations
- **vps-config/supabase/**: Dynamically cloned Supabase repository (sparse checkout of docker/ folder only)
- **vps-config/n8n/backup/**: Pre-configured n8n workflows for RAG AI agents
- **vps-config/n8n_pipe.py**: Open WebUI integration for n8n (allows n8n agents to be called from Open WebUI chat)
- **vps-config/shared/**: Mounted volume accessible to n8n at `/data/shared` for local file operations

## Common Commands

### Starting Services

```bash
# Start with CPU only (default)
python vps-config/start_services.py --profile cpu

# Start with NVIDIA GPU support
python vps-config/start_services.py --profile gpu-nvidia

# Start for private network (exposes all ports, default)
python vps-config/start_services.py --profile cpu --environment private

# Start for public deployment (only ports 80/443 exposed)
python vps-config/start_services.py --profile cpu --environment public
```

The `start_services.py` script:
1. Clones/updates Supabase repo (sparse checkout of docker/ only)
2. Copies root `.env` to `supabase/docker/.env`
3. Stops existing containers for project "homelab"
4. Starts Supabase services first
5. Waits 10 seconds for Supabase initialization
6. Starts local AI services (n8n, Open WebUI, LiteLLM, Nextcloud)

All services run under the Docker Compose project name "homelab" for unified management in Docker Desktop.

### Managing Services

```bash
# Stop all services
docker compose -p homelab -f vps-config/docker-compose.yml down

# View logs for specific service
docker compose -p homelab logs -f n8n
docker compose -p homelab logs -f open-webui

# Restart specific service
docker compose -p homelab restart n8n

# Upgrade all services (pull latest images)
docker compose -p homelab -f vps-config/docker-compose.yml pull
docker compose -p homelab -f vps-config/supabase/docker/docker-compose.yml pull
```

## Architecture

### Docker Compose Stack

The project uses a multi-file Docker Compose setup:

1. **vps-config/docker-compose.yml**: Main compose file that includes Supabase compose file and defines:
   - n8n-import: One-time container that imports pre-configured workflows
   - n8n: Main workflow automation service, uses Supabase Postgres as database
   - open-webui: ChatGPT-like UI for interacting with LLMs and n8n agents
   - litellm: Unified LLM proxy gateway
   - nextcloud: File storage with S3 backend support

2. **vps-config/docker-compose.override.private.yml**: Private deployment (all ports exposed)
3. **vps-config/docker-compose.override.public.yml**: Public deployment (only 80/443 via Caddy)
4. **vps-config/supabase/docker/docker-compose.yml**: Supabase stack (included via `include:`)

### Service Communication

- All services share the same Docker network (from Supabase compose)
- n8n connects to Postgres at host `db` (Supabase container name)
- n8n credentials use internal service names:
  - Ollama: `http://ollama:11434`
  - Qdrant: `http://qdrant:6333`
  - Postgres: host=`db`, port=`5432`
- Open WebUI calls n8n via webhook URLs (configured in `n8n_pipe.py`)

### Data Persistence

Volumes defined in `vps-config/docker-compose.yml`:
- `n8n_storage`: n8n workflows and credentials
- `open-webui`: Open WebUI data
- `nextcloud_data`: Nextcloud files (can use S3 backend)

Supabase volumes managed by its own compose file.

## Environment Configuration

Required `.env` setup in `vps-config/`:

1. Copy `.env.example` to `.env`
2. Generate secure values for:
   - `N8N_ENCRYPTION_KEY` and `N8N_USER_MANAGEMENT_JWT_SECRET`: Use `openssl rand -hex 32`
   - Supabase secrets: Follow https://supabase.com/docs/guides/self-hosting/docker
   - `POSTGRES_PASSWORD`: Database password (avoid special chars like '@')
   - `JWT_SECRET`, `ANON_KEY`, `SERVICE_ROLE_KEY`: Supabase JWT keys
   - `NEO4J_AUTH`: Format `username/password`
   - LiteLLM credentials: `LITELLM_MASTER_KEY`, `LITELLM_SALT_KEY`, etc.

For production deployment, also configure Caddy hostnames:
- `N8N_HOSTNAME`, `WEBUI_HOSTNAME`, `SUPABASE_HOSTNAME`, etc.
- `LETSENCRYPT_EMAIL`: For SSL certificates

## Service URLs (Private Mode)

- n8n: http://localhost:5678
- Open WebUI: http://localhost:3000
- Supabase Studio: http://localhost:3000 (via Kong gateway)
- LiteLLM: http://localhost:4040
- Nextcloud: http://localhost:8082

## Important Notes

### n8n Workflow Integration

- Pre-configured workflows are automatically imported on first startup via `n8n-import` container
- Workflows are located in `vps-config/n8n/backup/workflows/`
- The local filesystem path `/data/shared` in n8n maps to `vps-config/shared/` on host

### Open WebUI + n8n Integration

To connect Open WebUI to n8n agents:
1. Activate n8n workflow and copy the production webhook URL
2. In Open WebUI: Workspace → Functions → Add Function
3. Paste code from `vps-config/n8n_pipe.py`
4. Configure `n8n_url` valve to the webhook URL
5. Toggle function on - it will appear in model dropdown

### Supabase Special Characters

Avoid '@' and other special characters in `POSTGRES_PASSWORD` as they can cause connection issues with Kong gateway. If using special chars, they must be percent-encoded in connection strings.

### Public Deployment

When using `--environment public`:
- Configure firewall: `ufw enable && ufw allow 80 && ufw allow 443 && ufw reload`
- Set DNS A records for all configured hostnames
- Note: UFW doesn't block Docker-published ports; ensure all traffic routes through Caddy on port 443

### Supabase Database Schema

The Postgres schemas include: `public`, `storage`, `graphql_public`, `nextcloud`
- n8n uses `public` schema by default
- Nextcloud has its own schema for isolation
