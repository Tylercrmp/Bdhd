# Stage 1: build frontend
FROM node:18-alpine AS build
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production || npm install

# Copy source and build (Vite)
COPY . .
# Ensure build script exists; if not, build will be skipped but we'll still copy files
RUN if [ -f package.json ] && grep -q "\"build\"" package.json; then npm run build; else echo "No build script, skipping build"; fi

# Stage 2: runtime
FROM node:18-alpine
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

# Copy app files from build stage
COPY --from=build /app /app

# Install production dependencies (if package-lock present, npm ci will be faster)
RUN if [ -f package-lock.json ]; then npm ci --only=production || npm install --only=production; else npm install --only=production; fi

EXPOSE 8080

CMD ["node", "server.js"]
