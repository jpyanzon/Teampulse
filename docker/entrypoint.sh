#!/bin/bash
# Compose espera a PostgreSQL; la app migra y siembra solo la primera vez.
set -euo pipefail

export POSTGRES_HOST="${POSTGRES_HOST:-postgres}"
export POSTGRES_PORT="${POSTGRES_PORT:-5432}"
export POSTGRES_DB="${POSTGRES_DB:-teampulse}"
export POSTGRES_USER="${POSTGRES_USER:-teampulse}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-teampulse}"
export POSTGRES_SSLMODE="${POSTGRES_SSLMODE:-disable}"
export DEBUG="${DEBUG:-False}"
export ALLOWED_HOSTS="${ALLOWED_HOSTS:-*}"
export PYTHONPATH="/app${PYTHONPATH:+:$PYTHONPATH}"

cd /app
echo ">> Migraciones"
python manage.py migrate --noinput
echo ">> Seed (solo si esta base todavía no fue sembrada)"
python /app/docker/seed_if_needed.py

echo ">> TeamPulse en http://0.0.0.0:8000"
exec "$@"
