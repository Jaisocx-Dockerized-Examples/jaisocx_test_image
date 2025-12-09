# Test image. Alpine image alpine:3.21.3

Testing support for multiplatform builds of a docker image.



## Groups and Users

Groups and users set in .env

## Passwords
The password for the root user is stored in the ROOT_HASHED_PWD variable.

```
mkpasswd -m sha-512 "plaintext_password"
```



## Build docker image

```
./command/docker/image/image_new_tag.sh .
```

## Publish docker image

```
./command/docker/image/image_new_tag.sh --push
```



## Enter dockerized service

```
docker compose exec app bash
$: whoami
user

docker compose exec -u login app bash
$: whoami
login
```

