# Docker Angular

This repository provides to you docker images for developing apps with angular. It has 2 server flavor (nginx and apache). It also available for production use. Available environment variables are:

```
PRODUCTION=YES|NO (Default: NO)
REINSTALL_MODULES=YES|NO (Default: NO)
NG_CONFIGURATION=production|development (Default: development)
NG_REBUILD=YES|NO (Default: NO)
```

Available tags

```
mochrira/angular:15.2.3-apache
mochrira/angular:15.2.3-nginx
```

For more tags, point to :

[Our Angular Hub](https://hub.docker.com/r/mochrira/angular)

## Production

If you set PRODUCTION=YES, then htdocs are placed at `/var/www/html` instead of `/home/node/app/dist`. To reach zero down time while your container still compiling you can mount volume into `/var/www/html` directory. Here is yaml configuration examples

```
...
services:
    <your service name>:
        ...
        volumes:
        - my_project_htdocs:/var/www/html
        ...
    ...
...

volumes:
    my_project_htdocs:
        name: my_project_htdocs
...
```