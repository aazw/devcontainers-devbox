# DevContainers with Devbox

Pre-built Docker images for Dev Containers using Devbox as the package manager.

See also: https://github.com/aazw/devcontainers (previous version)


## Motivations

- Centralize devcontainer configurations that are duplicated across projects (DRY principle)
- Reduce build time by providing pre-built images that can be pulled when needed
- Ensure build reliability by catching build failures in CI rather than during local development


## Images

| Docker Hub | Source | Includes |
|------------|--------|----------|
| [devcontainers-devbox-base](https://hub.docker.com/r/aazw/devcontainers-devbox-base)     | [images/base](./images/base/)     | Base image |
| | | |
| [devcontainers-devbox-go](https://hub.docker.com/r/aazw/devcontainers-devbox-go)         | [images/go](./images/go/)         | Base + Go |
| [devcontainers-devbox-python](https://hub.docker.com/r/aazw/devcontainers-devbox-python) | [images/python](./images/python/) | Base + Python |
| [devcontainers-devbox-rust](https://hub.docker.com/r/aazw/devcontainers-devbox-rust)     | [images/rust](./images/rust/)     | Base + Rust |
| [devcontainers-devbox-java](https://hub.docker.com/r/aazw/devcontainers-devbox-java)     | [images/java](./images/java/)     | Base + Java |
| [devcontainers-devbox-swift](https://hub.docker.com/r/aazw/devcontainers-devbox-swift)   | [images/swift](./images/swift/)   | Base + Swift |
| [devcontainers-devbox-js](https://hub.docker.com/r/aazw/devcontainers-devbox-js)         | [images/js](./images/js/)         | Base + JavaScript |


## References

### Dev Container

* Development Containers | Reference  
  https://containers.dev/implementors/json_reference/
* GitHub | Development Containers Images  
  https://github.com/devcontainers/images
* Visual Studio Code | Dev Container CLI  
  https://code.visualstudio.com/docs/devcontainers/devcontainer-cli

### DevBox

* Portable, Isolated Dev Environments on any Machine  
  https://www.jetify.com/devbox
* Instant, easy, and predictable development environments  
  https://github.com/jetify-com/devbox
* Devbox docs  
  https://www.jetify.com/docs/devbox
* Nix Packages collection & NixOS  
  https://github.com/NixOS/nixpkgs
* NixOS Search - Packages  
  https://search.nixos.org/packages
* Nixhub.io | Find the Right Nix Package for your Project   
  https://www.nixhub.io/
  
### Renovate

* Renovate | Custom Manager Support using Regex | Advanced Capture  
  https://docs.renovatebot.com/modules/manager/regex/#advanced-capture
* Renovate | Self-Hosted configuration  
  https://docs.renovatebot.com/self-hosted-configuration/
* Renovate | Configuration Options | group  
  https://docs.renovatebot.com/configuration-options/#group
