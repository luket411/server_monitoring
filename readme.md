# Docker-Discord Monitoring Framework

This repository contains a framework to make simple docker contains which can:
- Run regular jobs (ie monitoring, syncing)
- Handle logging and cleanup for those jobs
- Alerting if something has gone wrong via a discord notification

While running everything in docker is probably a little overkill, this framework provides advantages over a simpler raw solution:
- Portable - docker can run on many systems (ie develop on windows, run on unraid server)
- Embedding the cron jobs in the docker container allows me to version control my cron commands
- In the event of having to re-run any setup I've done, I can just spin up a new version of the docker container rather than having to re-remember cron commands which I probably got from claude anyway

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