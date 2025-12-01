# Use the official MySQL base image
FROM mysql:8.4.7

# Set environment variables for the root password and a new user
ENV MYSQL_ROOT_PASSWORD=root123
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin123
ENV MYSQL_DATABASE=accounts

# Copy custom SQL scripts to initialize the database (optional)
# For example, to create a user and grant permissions, or import a schema
COPY init.sql /docker-entrypoint-initdb.d/

# Expose the default MySQL port
EXPOSE 3306