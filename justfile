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

ddmf_git_remote_name := "ddmf"
ddmf_git_remote_url := "git@github.com:luket411/ddmf.git"

[windows]
_setup-ddmf-git:
    if (-not (git remote | Select-String -Pattern "^{{ddmf_git_remote_name}}$" -Quiet)) { git remote add {{ddmf_git_remote_name}} {{ddmf_git_remote_url}}}
    if (-not (git remote get-url {{ddmf_git_remote_name}} | Select-String -Pattern "^{{ddmf_git_remote_url}}$" -Quiet)) { git remote set-url {{ddmf_git_remote_name}} {{ddmf_git_remote_url}}}
    if (git branch | Select-String "ddmf-migration" -Quiet) { git branch -d "ddmf-migration" }

[unix]
_setup-ddmf-git:
    if ! git remote | grep -q "^{{ddmf_git_remote_name}}$"; then git remote add {{ddmf_git_remote_name}} {{ddmf_git_remote_url}}; fi
    if ! git remote get-url {{ddmf_git_remote_name}} | grep -q "^{{ddmf_git_remote_url}}$"; then git remote set-url {{ddmf_git_remote_name}} {{ddmf_git_remote_url}}; fi

[confirm("Have any merge conflicts been resolved?")]
_finish-migration:
    git commit
    git push origin ddmf-migration

update-ddmf: _setup-ddmf-git && _finish-migration
    git fetch {{ddmf_git_remote_name}}
    git fetch origin

    git checkout main
    git pull
    git checkout -b ddmf-migration

    git merge {{ddmf_git_remote_name}}/ddmf-main --no-commit