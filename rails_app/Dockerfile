FROM ruby:3.2.2-slim-bullseye

# Install essential system dependencies for Rails
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libpq-dev \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Set environment variables for Bundler
ENV BUNDLE_PATH /bundle

# Add the gems' binary path to the shell's PATH. This is the critical fix.
ENV PATH="/bundle/bin:${PATH}"

# Copy the Gemfile and Gemfile.lock to install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application's code into the container
COPY . .

# Expose port 3000 to allow external traffic to the container
EXPOSE 3000

# The main command to run when the container starts.
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"]
