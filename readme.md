# Docker-Discord Monitoring Framework

This repository contains a framework to make simple docker contains which can:
- Run regular jobs (ie monitoring, syncing)
- Handle logging and cleanup for those jobs
- Alerting if something has gone wrong via a discord notification

While running everything in docker is probably a little overkill, this framework provides advantages over a simpler raw solution:
- Portable - docker can run on many systems (ie develop on windows, run on unraid server)
- Embedding the cron jobs in the docker container allows me to version control my cron commands
- In the event of having to re-run any setup I've done, I can just spin up a new version of the docker container rather than having to re-remember cron commands which I probably got from claude anyway

## Quickstart guide

1. Add in any parameters which your container may need to the .env.tpl file
1. Add some functionality to the [`./build/job.sh'](./build/job.sh) script. See more in [writing-your-script](#writing-your-script)
    1. Optionally, install any extra software dependencies into the top lines of the [`Dockerfile`](./build/ddmf/Dockerfile)
1. Configure the `JOB_SCHEDULE` and `LOG_RETENTION` environment variables in the .env.tpl file
1. Run the container with `docker compose up -d --build`

### Writing your script

To help write your script, the framework provides a few interfaces for you to call

- `log <message>`
    - This is bash function which creates a date-stamped log file in your `/logs` file with 
- `send-warning <alert>`
    - This is another bash function to alert the discord channel with the message you provide

There is an example script in ['job.sh'](./build/job.sh) with a task to check if the minute is odd and notify if so.

## Container Structure
```text
/etc
└──environment

/app
├── ddmf/
│   ├── entrypoint.sh
│   ├── cleanup-log.sh
│   └── send-warning.sh
└── job.sh

/data
```

## Scopes

These containers have 3 main scopes for when information is available and implementations of the framework should take them into account

### Image build

- Stage should define software dependencies needed for the docker image (ie curl, rclone)
- Any changes to this stage should be placed in the [`Dockerfile`](./build/ddmf/Dockerfile)

### Container build

- Stage should define the volumes which the docker container needs to run (such as the log directory) 
- Stage should define any parameters that the scripts need to perform their regular job (ie IP addresses to ping, folders to scan)
- Any changes to this stage should be placed in the [`docker-compose.yaml`](./docker-compose.yaml) file or the [`entrypoint.sh`](./build/ddmf/entrypoint.sh) file

### Script Runtime

- Information about a particular instance of a script being run (ie date/time of the script needed for logging)
- Any changes to this stage should be put in the scripts themselves