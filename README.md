# Drone Composer

This is a [drone](https://drone.io/) plugin used to download PHP dependencies using Composer.

You can download private repositories using this image without sharing socket of `ssh-agent`.
Instead, you provide your RSA private key to achieve the goal. The default entrypoint run composer with
`--ignore-platform-reqs` option, to ignore your project's platform requirements such as PHP version,
extensions, etc.

## Example

```yaml
steps:
- name: vendor
  image: jerray/drone-composer:latest
  settings:
    git_private_key:
      from_secret: git_private_key
    git_server_hosts:
    - github.com
    composer_auth:
      from_secret: composer_auth_json
    composer_repo_packagist:
```

## Settings

* `git_private_key` RSA private key used to download private repositories through SSH.
* `git_server_hosts` Git site domain list where your private repositories are located at.
* `composer_auth` Contents of [`auth.json`](https://getcomposer.org/doc/articles/http-basic-authentication.md). You can also provide a GitHub OAuth token to avoid GitHub's request rate limit.
* `composer_repo_packagist` Packagist URL.
* `chdir` Change to a sub directory to run the composer command.
