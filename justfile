set default-list := true
set unstable


set dotenv-filename := ".env"
discord_bot_identifier := env('DISCORD_BOT_IDENTIFIER', "")

[unix]
set shell := ["/bin/bash", "-cu"]

[windows]
set shell := ["powershell"]

[unix]
setup: 
    if [ ! -f .env ]; then cp .env.tpl .env ; fi

[windows]
setup:
    if (!(Test-Path .env)) { Copy-Item .env.tpl .env }

stop:
    docker compose down

build:
    docker compose up -d

run-job: build
    docker exec -it {{discord_bot_identifier}} ./job.sh

check-container-running:
    docker ps -a --filter "name=^{{discord_bot_identifier}}$"