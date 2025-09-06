# Rails + Python AI Integration Demo

This project demonstrates how to integrate a Ruby on Rails application with a Python AI service using a microservices architecture.

## Project Structure

- `rails_app/` - The Ruby on Rails web application
- `python_ai/` - The Python FastAPI AI service
- `docker-compose.yml` - Configuration to run all services together

## Prerequisites

- Docker and Docker Compose
- Ruby 3.x
- Python 3.10+
- Node.js (for Rails asset compilation)

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd ai_rails_project
```

### 2. Start the services

```bash
docker-compose up --build
```

This will start:
- Rails app on http://localhost:3000
- Python AI service on http://localhost:8000
- PostgreSQL database
- Redis server

### 3. Initialize the database

In a new terminal:

```bash
docker-compose run web rails db:create db:migrate
```

### 4. Access the application

Open your browser and visit: http://localhost:3000

## Development

### Running tests

```bash
# Run Rails tests
docker-compose run web rspec

# Run Python tests (from python_ai directory)
docker-compose run ai_service pytest
```

### Adding new AI endpoints

1. Add a new endpoint in `python_ai/main.py`
2. Create a corresponding method in `rails_app/app/services/ai_service.rb`
3. Add a route in `rails_app/config/routes.rb` if needed

## Deployment

### Environment Variables

Create a `.env` file in the project root with the following variables:

```
# Rails
DATABASE_URL=postgresql://postgres:postgres@db:5432/ai_rails_${RAILS_ENV:-development}
REDIS_URL=redis://redis:6379/1
SECRET_KEY_BASE=your-secret-key-base

# AI Service
AI_SERVICE_URL=http://ai_service:8000  # For Docker Compose
# AI_SERVICE_URL=http://localhost:8000  # For local development
```

### Production Deployment

1. Set up a production database
2. Configure environment variables
3. Build and deploy with Docker Compose or your preferred method

## Testing

### Running Tests

To run all tests (unit and integration tests):

```bash
# Run all tests except integration tests
./run_tests.sh

# Run all tests including integration tests (requires services to be running)
./run_tests.sh --integration
```

### Manual Testing

1. Start the services:
   ```bash
   docker-compose up --build
   ```

2. Access the web interface at http://localhost:3000

3. Test the API directly:
   ```bash
   # Test Python AI service directly
   curl -X POST http://localhost:8000/analyze \
     -H "Content-Type: application/json" \
     -d '{"text": "I love this application!"}'

   # Test Rails API endpoint
   curl -X POST http://localhost:3000/api/analyze \
     -H "Content-Type: application/json" \
     -d '{"text": "This is a test of the Rails API"}'
   ```

## Development

### Adding New AI Endpoints

1. Add a new endpoint in `python_ai/main.py`
2. Create a corresponding method in `rails_app/app/services/ai_service.rb`
3. Add a route in `rails_app/config/routes.rb` if needed
4. Write tests for the new functionality

### Debugging

- View Rails logs: `docker-compose logs -f web`
- View Python service logs: `docker-compose logs -f ai_service`
- Access Rails console: `docker-compose run web rails console`

## Deployment

### Environment Variables

Create a `.env` file in the project root with the following variables:

```
# Rails
DATABASE_URL=postgresql://postgres:postgres@db:5432/ai_rails_${RAILS_ENV:-development}
REDIS_URL=redis://redis:6379/1
SECRET_KEY_BASE=your-secret-key-base

# AI Service
AI_SERVICE_URL=http://ai_service:8000  # For Docker Compose
# AI_SERVICE_URL=http://localhost:8000  # For local development
```

### Production Deployment

1. Set up a production database
2. Configure environment variables
3. Build and deploy with Docker Compose or your preferred method

## License

MIT
