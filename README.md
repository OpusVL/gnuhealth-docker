# GNU Health

[https://en.wikibooks.org/wiki/GNU_Health](https://en.wikibooks.org/wiki/GNU_Health)

[https://www.gnuhealth.org/download.html](https://www.gnuhealth.org/download.html)

## Docker Container Set Build

The container set for the `docker-compose.yml` uses a build process from `./build`

### Service Components

Create the images using:

```shell
docker-compose build
docker-compose pull
```

#### gnuhealth

The build process uses the slim version of the python Docker image. It adds in the necessary components to run the `gnuhealth-setup` script - which takes care of the the remainder of the install.

By mounting the config file `trytond.conf` into the image we are able to set the necessary credentials for the service to access the `db` container.

Create a file `.password` owned/accessible by uid 1000 that contains the password for the admin user, eg.

```shell
echo SecretKey > .password
sudo chown 1000:1000 .password
```

The build process mimics the install [instructions](https://en.m.wikibooks.org/wiki/GNU_Health/Installation).

Bring up the container set and watch the logs.

```shell
docker-compose up -d && docker-compose logs -f
```

Initialise the database and admin user using:

```shell
docker-compose exec gnuhealth bash -c /home/gnuhealth/init.sh
```

By default this listens on TCP port 8000 for web and 8080 for webdav, according to the config file. I have exposed both ports and these are able to be mapped to using the `$PORTBASE` variable - by default I've set the it to `80` which maps the ports to the same as the container (8000 and 8080). This can be easily changes to anything within the TCP port range by setting the portbase, eg.

```shell
PORTBASE=123
```

Would result in the container being accessed via port 12300 and 12380 respectively.

#### db

This is a PostgreSQL v12 instance using the official `postgres:12-alpine` container.

The `init-db.sh` script creates the `gnuhealth` user/role sets the password and creates the `gnuhealth` database - owned by the new user.

## Install the Client Locally

Install and run the client.

```shell
pip3 install --user --upgrade gnuhealth-client
gnuhealth-client
```

Connect using the server name and port you specified (eg. `server:12300`) with the user `admin` and the password you put in the `.password` file.
