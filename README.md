# Docker TOR relay

A tor relay in docker build from scratch image.

## Disclaimer

Before running a tor relay make sure you understand what you are doing by reading this: https://community.torproject.org/relay/

## Usage

Build the image

```bash
docker-compose build tor-relay
```

Run the relay

```bash
docker-compose up -d
```

## Configuration

The `torrc` config file is configured to be runned as an entry/middle relay.

By default the relay listen on port 9001. So you need to open that port on your firewall's router.

You need to modify at least the following sections to make it working:

- `Address example.com`

This is a domain or ip address that resolves to the server. You can comment this line if you don't know.

- `Nickname such_nickname`

A nickname for your relay.

- `ContactInfo John DOE <john@doe.com>`

Contact info so if something's wrong, someone can tell you.

## License

This project is licensed under the WTFPL license.
