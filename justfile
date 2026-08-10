set default-list := true
set unstable

[cache(inputs=".env.tpl", outputs=".env")]
[script]
setup: 
    if [ ! -f .env ]; then cp .env.tpl .env ; fi

stop:
    docker compose down

build: setup
    docker compose up -d --build

run $args: build
    docker exec -it nas-uptime-monitor {{args}}
