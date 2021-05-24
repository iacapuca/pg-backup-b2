#! /bin/sh

set -e
set -o pipefail

if [ "${B2_KEY_ID}" = "**None**" ]; then
  echo "You need to set the B2_KEY_ID environment variable."
  exit 1
fi

if [ "${B2_KEY}" = "**None**" ]; then
  echo "You need to set the B2_KEY environment variable."
  exit 1
fi

if [ "${B2_BUCKET}" = "**None**" ]; then
  echo "You need to set the B2_BUCKET environment variable."
  exit 1
fi

if [ "${POSTGRES_DATABASE}" = "**None**" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ "${POSTGRES_HOST}" = "**None**" ]; then
  if [ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ "${POSTGRES_USER}" = "**None**" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ "${POSTGRES_PASSWORD}" = "**None**" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

# env vars needed for aws tools
export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

remoteFilename="${DB_DATABASE}_$(date '+%Y-%m-%d_%Hh%M').sql.gz"
remoteFilePath="${DB_DATABASE}/$(date '+%Y')/$(date '+%B')/$(date '+%d')/${remoteFilename}"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip > dump.sql.gz

echo "Authenticating with Backblaze"
b2 authorize-account $B2_KEY_ID $B2_KEY

echo "Uploading dump to $B2_BUCKET"

b2 upload-file $B2_BUCKET dump.sql.gz $remoteFilePath

echo "SQL backup uploaded successfully"