# Django with Docker and PostgreSQL

A production-ready Django application setup with Docker and PostgreSQL database.

## Project Structure

```
PROJECT_X/
├── app/                          # Django application
│   ├── config/                   # Django project settings
│   ├── manage.py
│   └── requirements.txt
├── docker/                       # Docker configuration
│   └── app/
│       ├── Dockerfile.dev        # Development Dockerfile
│       └── Dockerfile.prod       # Production Dockerfile
├── docs/                         # Documentation files
├── docker-compose.yml            # Docker Compose file
├── .env.dev                      # Development environment variables
├── .env.prod                     # Production environment variables
├── .env.example                  # Environment variables template
├── .dockerignore
├── .gitignore
└── README.md
```

## Quick Start

### Development

1. **Start the development environment:**

```bash
docker-compose --env-file .env.dev up -d --build
```

2. **Access the application:**
   - Django App: [http://localhost:8000](http://localhost:8000)

3. **Run Django management commands:**

```bash
# Create migrations
docker-compose exec web python manage.py makemigrations

# Apply migrations
docker-compose exec web python manage.py migrate

# Create superuser
docker-compose exec web python manage.py createsuperuser

# Collect static files
docker-compose exec web python manage.py collectstatic --noinput
```

4. **View logs:**

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f web
```

5. **Stop the environment:**

```bash
docker-compose down
```

### Production

1. **Configure environment:**

   Edit `.env.prod` and update:
   - `DJANGO_ALLOWED_HOSTS` - Allowed hosts (your domain)
   - `POSTGRES_PASSWORD` - Strong database password
   - `WEB_PORT` - External port for Django (default: 8000)

2. **Start the production environment:**

```bash
docker-compose --env-file .env.prod up -d --build
```

3. **Run initial setup:**

```bash
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
docker-compose exec web python manage.py collectstatic --noinput
```

## Configuration

### Environment Variables

The application uses environment files for configuration:

- `.env.dev` - Development settings
- `.env.prod` - Production settings
- `.env.example` - Template for custom configurations

Key variables:

| Variable | Description | Default (Dev) |
|----------|-------------|---------------|
| `ENVIRONMENT` | Environment type (dev/prod) | `dev` |
| `DEBUG` | Django debug mode | `1` |
| `DJANGO_ALLOWED_HOSTS` | Allowed hosts | `localhost,127.0.0.1` |
| `POSTGRES_USER` | Database username | `django_user` |
| `POSTGRES_PASSWORD` | Database password | `django_password` |
| `POSTGRES_DB` | Database name | `django_db` |
| `WEB_PORT` | Django web port | `8000` |
| `WEB_COMMAND` | Web server command | `python manage.py runserver 0.0.0.0:8000` |

## Services

### Web (Django)

- **Development**: Django development server with hot-reload
- **Production**: Gunicorn WSGI server
- **Port**: 8000 (configurable via `WEB_PORT`)

### Database (PostgreSQL)

- **Image**: postgres:15-alpine
- **Port**: 5432 (internal only)
- **Data**: Persisted in Docker volume `postgres_data`

## Docker Commands

### Build and start services

```bash
# Development
docker-compose --env-file .env.dev up -d --build

# Production
docker-compose --env-file .env.prod up -d --build
```

### Stop services

```bash
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### View logs

```bash
docker-compose logs -f [service_name]
```

### Execute commands in containers

```bash
docker-compose exec web python manage.py [command]
docker-compose exec db psql -U django_user -d django_db
```

### Rebuild specific service

```bash
docker-compose build web
docker-compose up -d web
```

## Security Notes

### Production Checklist

- [ ] Update `POSTGRES_PASSWORD` in `.env.prod`
- [ ] Update `DJANGO_ALLOWED_HOSTS` in `.env.prod`
- [ ] Set `DEBUG=0` in `.env.prod`
- [ ] Review and update SECRET_KEY in Django settings
- [ ] Configure firewall rules for your web port
- [ ] Set up regular database backups
- [ ] Consider using a reverse proxy (nginx, Caddy) for SSL/TLS in production
- [ ] Ensure static files are properly served

## Troubleshooting

### Cannot connect to database

Wait for PostgreSQL to be ready. The web service depends on the database health check.

### Cannot access the application

Check that:
1. All services are running: `docker-compose ps`
2. Port 8000 is not already in use
3. Firewall allows connections on the configured port

### Permission denied errors

Ensure correct file permissions:
```bash
chmod +x app/manage.py
```

## Additional Resources

- [Django Documentation](https://docs.djangoproject.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## License

See LICENSE file for details.
