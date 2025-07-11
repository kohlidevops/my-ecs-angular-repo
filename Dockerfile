# syntax=docker/dockerfile:1

# STAGE 1: Build the Angular project
FROM node:20 AS builder

# Install Angular CLI
RUN npm install -g @angular/cli@17

# Change my working directory to a custom folder created for the project
WORKDIR /my-project

# Copy everything from the current folder (except the ones in .dockerignore) 
# into my working directory on the image
COPY . .

# Install dependencies and build my Angular project
RUN npm install && ng build -c production


# STAGE 2: Build the final deployable image
FROM nginx:1.25

# Allow the HTTP port needed by the Nginx server for connections
EXPOSE 80

# Copy the generated static files from the builder stage
# to the Nginx server's default folder on the image
COPY --from=builder /my-project/dist/my-angular-project /usr/share/nginx/html
