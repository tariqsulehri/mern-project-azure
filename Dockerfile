# --- STAGE 1: Build & Dependencies ---
FROM ubuntu:22.04 AS builder

# Set shell to bash for better error handling
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Node installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy package files for caching
COPY package*.json ./

# Install ALL dependencies (including devDependencies if needed for build steps)
RUN npm ci

# Copy the rest of the application code
COPY . .

# --- STAGE 2: Production Release ---
FROM ubuntu:22.04 AS production

ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_ENV=production

# Install only the Node runtime for the final image
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends \
    nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security
RUN groupadd -r nodejs && useradd -r -g nodejs -s /bin/false nodejs

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy application code from builder stage
COPY --from=builder /app/src ./src

# Ensure the nodejs user owns the app directory
RUN chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose the application port
EXPOSE 5000

# Use tini or a similar init system if possible, but for a simple node app, this works:
CMD ["node", "src/index.js"]
