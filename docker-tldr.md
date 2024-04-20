## TLDR:

> clone this repo and run:

```shell
docker compose --profile download up --build
# wait until its done, then:
docker compose --profile [ui] up --build -d
# where [ui] is one of: invoke | auto | auto-cpu | comfy | comfy-cpu
```

> ...if you don't know which ui to choose, invoke or auto are a good start.

### Then access from http://localhost:7860/
