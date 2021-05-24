Yet Another Postgres Docker Backup to Backblaze B2

## Usage

Docker:
```sh
$ docker run -e B2_KEY_ID=keyId -e B2_KEY=key -e B2_BUCKET=b2-bucket -e POSTGRES_DATABASE=dbname -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_HOST=localhost iacapuca/pg-backup-b2
```

Docker Compose:
```yaml
postgres:
  image: postgres
  environment:
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password

pg-backup:
  image: iacapuca/pg-backup-b2
  links:
    - postgres
  environment:
    SCHEDULE: '@daily'
    B2_KEY_ID: keyId
    B2_KEY: key
    B2_BUCKET: my-bucket
    POSTGRES_DATABASE: dbname
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
    POSTGRES_EXTRA_OPTS: '--schema=public --blobs'
```

### Automatic Periodic Backups

You can additionally set the `SCHEDULE` environment variable like `-e SCHEDULE="@daily"` to run the backup automatically.

More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).
