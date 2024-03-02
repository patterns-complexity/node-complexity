![Docker Version](https://img.shields.io/badge/docker-24.0.6-blue)
![Make Version](https://img.shields.io/badge/make-4.3-blue)

# Node Complexity
A skeleton for dockerizing and automating the development of a Node.js application.

## Who is this for?
If you (just like me) are tired of setting up the same `Dockerfile`, `entrypoint` scripts, and `Makefile` for every Node.js application you develop, then this project is for you.

## What does it do?
This project is meant to quick-start the dockerization of a Node.js application. It includes a `Dockerfile` with two targets, `dev` and `prod`, as well as `entrypoint.*.sh` scripts for running the application in development and production modes. The `Makefile` contains a set of targets for building, starting, stopping, and cleaning up the project.

Everything is ready out of the box.

Head over to the [Installation](#installation) section to get started!

## Features
- Quick-start the dockerization of a Node.js application.
- Includes a `Dockerfile` with two targets, `dev` and `prod`.
- Includes `entrypoint.*.sh` scripts for running the application in development and production modes.
- Includes a `Makefile` with a set of targets for building, starting, stopping, and cleaning up the project.
- Everything is ready out of the box for your Node.js application.

## Dependencies
Make sure you have the following dependencies installed on your system:

| Dependency | Tested on version | Will it work with other versions? |
|------------|---------|------------------------------------|
| Docker     | 24.0.6  | Most likely |
| Make       | 4.3     | Most likely |


As stated above - it will most likely work with other versions, but these are the versions it was tested on.

## Installation

### 1. Clone this repository:
    
```bash
git clone <this-repository-url>
cd node-complexity
```
### 2. Create the Makefile
Rename or copy `example.Makefile` to `Makefile`:
    
```bash
cp example.Makefile Makefile
```

**OPTIONAL:** Edit the `Makefile` to match your automation requirements.

### 3. Start the installation process
Start the installation process by running the following command:
```bash
# This will copy the example files to the actual configuration files
# WARNING: This also copies .env (if it exists) to .env.backup and after its done, it restores .env from .env.backup.
# Double check the .env file if you recently pulled from the repository and ran this command again.
make install
```
### 4. Edit the configuration files to match your environment and application requirements.

Configuration files:
- `.env`
- `Dockerfile` (with two targets, `dev` and `prod`)
- `entrypoint.dev.sh`
- `entrypoint.prod.sh`.

Refer to [example files](#example-files) to see the default values.

### 5. Running on default values

The project is specifically designed to run on defaults, but as your project evolves, you will most likely need to modify the configuration files to match your environment and application requirements.

### 6. **(OPTIONAL)** Place your existing Node.js application code in the `src` directory.
Either place your existing Node.js application code in the `src` directory, or start developing it there from scratch.

Your application doesn't work?

Refer to the [common issues](#common-issues) section for more information.

## Production use
Do **NOT** trust any production images or containers that are built from this project. They are only meant for testing and simulating a production environment. Always build your own production images and containers.

## Usage

After you have successfully completed the [installation](#installation) process, you can use the following commands to build, start, stop, and clean up the project:

### Development Mode

```bash
# Build the project for development
make build
```

```bash
# Start the project in development mode
make start

# By default, the application you place in the src directory will be accessible at http://localhost:3000.
```

```bash
# Stop the running project
make stop

# Or, alternatively, you can restart the project
make restart
```

```bash
# If you make any changes in any of the configuration files, you can rebuild the project
make rebuild

# This will clean up the project, removing containers and images, and then build the project for development.
```

### Simulating a Production Environment

```bash
# If you want to build the project to simulate a production environment, you can use the following command
make build-prod

# And then start the project in production mode
make start-prod
```

```bash
# You can also rebuild the project for production
make rebuild-prod
```

**WARNING!**

Do not use the included production image for actual production use!

Refer to the [production use](#production-use) section for more information.


## Makefile Targets

The `Makefile` contains a set of targets for building, starting, stopping, and cleaning up the project. Here is a table explaining each target:

| Target        | Description                                    |
|---------------|------------------------------------------------|
| build         | Build the project for development.             |
| build-prod    | Build the project for production.              |
| start         | Start the project in development mode.         |
| start-prod    | Start the project in production mode.          |
| stop          | Stop the running project.                      |
| restart       | Restart the project.                           |
| logs          | Show the logs of the running project.          |
| clean         | Clean up the project, removing containers and images. |
| rebuild       | Clean and rebuild the project for development. |
| rebuild-prod  | Clean and rebuild the project for production.   |

Refer to the [example.Makefile](example.Makefile) file for more information.

## Environment Variables Explanation
The `.env` file contains environment variables that are essential for configuring the application. Here is a table explaining each variable:

| Variable     | Description                                    | Example Value |
|--------------|------------------------------------------------|---------------|
| CNT_NAME     | Container name for the Docker container        | node          |
| IMG_NAME     | Image name for the Docker build                | node-complexity |
| IMG_TAG      | Tag for the Docker image                       | latest        |
| PORT_OUT     | Outer port for accessing the application       | 3000          |
| PORT_IN      | Inner port within the Docker container         | 3000          |
| PORT_OUT_SSL | Outer port for accessing the application over SSL | 3001       |
| PORT_IN_SSL | Inner port within the Docker container for SSL | 3443          |
| UID          | User ID for the Docker container               | 1000          |
| GID          | Group ID for the Docker container              | 1000          |
| UNAME        | User name for the Docker container             | node          |

Please replace example values with the actual values you wish to use in your environment.

Refer to the [example.env](./dist/example.env) to see the default values.

## Example files
The following files are included in the project both as examples and as the source of truth for the [installation](#installation) process:

- [example.Makefile](./example.Makefile)
- [example.env](./dist/example.env)
- [example.Dockerfile](./dist/example.Dockerfile)
- [example.entrypoint.dev.sh](./dist/example.entrypoint.dev.sh)
- [example.entrypoint.prod.sh](./dist/example.entrypoint.prod.sh)

## Common issues

### Application is not running
**Q:** I followed the installation instructions, but the application is not running. What's wrong?

**A:** This project does **NOT** contain any actual Node.js application code! This is a skeleton project that is meant to quick-start the dockerization and automation of developing a Node.js application. You are supposed to place **YOUR OWN** Node.js application code in the `src` directory. If your application is more complex, it will almost certainly require modifications to the `Dockerfile` and `entrypoint.*.sh` scripts.

### Port already in use
**Q:** I'm trying to start the project, but I'm getting an error that the port is already in use. What's wrong?

**A:** The port you are trying to use is already in use by another application. You can either stop the application that is using the port, or change the port in the `.env` file to a different value.

### The production image is unstable on my server
**Q:** I built the project for production and deployed it to my server, but it is unstable. What's wrong?

**A:** The production image is only meant for testing and simulating a production environment. It is not meant for actual production use. Always build your own images and containers for production.

### Cleaning up the project doesn't work
**Q:** I tried to clean up the project, but I am getting this error:
```bash
Error response from daemon: conflict: unable to remove repository reference "node-complexity:latest" (must force) - container 0b7e7f25256f is using its referenced image e22e6e3ff920
```

**A:** This error occurs when the container is still running. You need to stop the running container with `make stop` before you can clean up the project.


**-- More common issues will be added as they are discovered. --**

## License
This project is licensed under the MIT License. This means it is free to use, modify, and distribute with the only requirement being to include the original license and copyright notice with any substantial portion of the work.

Refer to the [LICENSE.MD](LICENSE.MD) file for more information.
