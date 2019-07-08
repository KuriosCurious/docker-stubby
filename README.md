# Docker-Stubby

Stubby is an application by GetDNS that acts as a local DNS proxy of-sorts. It receives unencrypted DNS traffic over port 53 and forwards it to the upstream resolver via DNS-over-TLS, port 453.

Docker-Stubby is simply a docker image with Stubby. It is hardcoded to utilize Quad9's secure DNS services.

For more info on Stubby, please see their [documentation page](https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby).


## Small footprint

The final image, which is based on Alpine, is under 10mb. This was easily achieved by carefully utilizing multi-stage build and moving only the bare essentials to the final image.


## Getting Started

### Prerequisites

- Docker
- Port 53 available. You can get around this but if you know how, you probably don't need this README

### Run container

The following command will instruct docker to run `kurioscurious/docker-stubby` image with port 53 made available on the host. The container will be named `stubby` so you can easily remember and it's set to restart automatically unless you explicitly stopped it

Pulling the image should not be necessary as Docker will automatically pull if the image isn't already available locally.

```sh
docker run -d --name stubby -p 53/tcp --restart=unless-stopped kurioscurious/docker-stubby@latest
```

### Use as local DNS server

- Set up your DHCP server to publish the Docker's host IP as your DNS server.
- For the sake of resiliency, I recommend leaving your current DNS server as the secondary.
- Block port 53 **outbound** from all clients on your firewall. This will force all devices to use your published DNS server as the local DNS resolver. Especially those pesky Google devices that come hardcoded with Google's DNS.
- If you need to take down the container for whatever reason, re-open port 53 on the firewall so your devices can begin using your secondary server.

## Why Quad9?

Quad9 utilizes cyber threat intelligence feeds about malicious domains and blocks access to those domains. They also provide DNSSEC validation, which means that, for domains that implement DNSSEC, Quad9 will ensure the response provided matches what was intended by the domain operator. DNSSEC validation can get pretty slow if you're taking on that burden locally so I prefer to offload that to Quad9 as they can do it much faster.  

For more info on Quad9, please visit their [FAQ](https://www.quad9.net/faq/) page.

## Built With

- [Alpine](https://alpinelinux.org/) - Base image
- [Stubby](https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby) - DNS encryption daemon
- [Quad9](https://www.quad9.net/) - Upstream DNS resolver

## Versioning

The image tags will follow the same version number as Stubby. `@latest` will always be, well, latest.

## Acknowledgements

- Thanks to GetDNS for a great little tool. It does 1 thing and it does it well!
- Thanks to anyone else whose code was also used
- Thanks to folks in [Operation Code](https://operationcode.org/) for answering questions about Docker and Dockefile's