Note: This is fork for my personal use as upstream seems bit abandoned. If you want to use it, fine, but don't blame me for problems.

# Matrix Webhook

Post a message to a matrix room with a simple HTTP POST

## Install

```
docker pull ghcr.io/fingon/matrix-webhook
```

## Start

Create a matrix user for the bot, and launch this app with the following arguments and/or environment variables
(environment variables update defaults, arguments take precedence):

```
matrix-webhook -h
# OR
python -m matrix_webhook -h
# OR
uv run matrix-webhook -h
# OR
docker run --rm -it ghcr.io/fingon/matrix-webhook -h
```

```
usage: python -m matrix_webhook [-h] [-H HOST] [-P PORT] [-u MATRIX_URL] -i MATRIX_ID (-p MATRIX_PW | -t MATRIX_TOKEN) -k API_KEY [-v]

Configuration for Matrix Webhook.

options:
  -h, --help            show this help message and exit
  -H HOST, --host HOST  host to listen to. Default: `''`. Environment variable: `HOST`
  -P PORT, --port PORT  port to listed to. Default: 4785. Environment variable: `PORT`
  -u MATRIX_URL, --matrix-url MATRIX_URL
                        matrix homeserver url. Default: `https://matrix.org`. Environment variable: `MATRIX_URL`
  -i MATRIX_ID, --matrix-id MATRIX_ID
                        matrix user-id. Required. Environment variable: `MATRIX_ID`
  -p MATRIX_PW, --matrix-pw MATRIX_PW
                        matrix password. Either this or token required. Environment variable: `MATRIX_PW`
  -t MATRIX_TOKEN, --matrix-token MATRIX_TOKEN
                        matrix access token. Either this or password required. Environment variable: `MATRIX_TOKEN`
  -k API_KEY, --api-key API_KEY
                        shared secret to use this service. Required. Environment variable: `API_KEY`
  -v, --verbose         increment verbosity level
```

## Dev

```
uv sync
python3 -m matrix_webhook
```

## Prod

A `docker-compose.yml` is provided:

- Use [Traefik](https://traefik.io/) on the `web` docker network, eg. with
  [proxyta.net](https://framagit.org/oxyta.net/proxyta.net)
- Put the configuration into a `.env` file
- Configure your DNS for `${CHATONS_SERVICE:-matrixwebhook}.${CHATONS_DOMAIN:-localhost}`

```
docker-compose up -d
```

### Healthcheck

For load balancers which require a healthcheck endpoint to validate the availability of the service, the `/health` path can be used.
The endpoint will return a **HTTP 200** status and a json document.

To the Healthcheck endpoint with Traefik and docker-compose, you can add:

```yaml
services:
  bot:
    labels:
      traefik.http.services.matrix-webhook.loadbalancer.healthcheck.path: /health
```

## Test / Usage

```
curl -d '{"body":"new contrib from toto: [44](http://radio.localhost/map/#44)", "key": "secret"}' \
  'http://matrixwebhook.localhost/!DPrUlnwOhBEfYwsDLh:matrix.org'
```

(or localhost:4785 without docker)

### For Github

Add a JSON webhook with `?formatter=github`, and put the `API_KEY` as secret

### For Grafana

Add a webhook with an URL ending with `?formatter=grafana&key=API_KEY`

### For Gitlab

At the group level, Gitlab does not permit to setup webhooks. A workaround consists to use Google
Chat or Microsoft Teams notification integration with a custom URL (Gitlab does not check if the url begins with the normal url of the service).

#### Google Chat

Add a Google Chat integration with an URL ending with `?formatter=gitlab_gchat&key=API_KEY`

#### Microsoft Teams

Add a Microsoft Teams integration with an URL ending with `?formatter=gitlab_teams&key=API_KEY`

#### Gitlab Webhook

At the project level, you can add a webhook with an URL ending with `?formatter=gitlab_webhook` and put your `API_KEY`
as secret token. Not yet as pretty as other formatters, contributions welcome !

### Github Release Notifier

To receiver notifications about new releases of projects hosted at github.com you can add a matrix webhook ending with `?formatter=grn&key=API_KEY` to [Github Release Notifier (grn)](https://github.com/femtopixel/github-release-notifier).

## Test room

[#matrix-webhook:tetaneutral.net](https://matrix.to/#/!DPrUlnwOhBEfYwsDLh:matrix.org)

## Unit tests

```
docker-compose -f test.yml up --exit-code-from tests --force-recreate --build
```
