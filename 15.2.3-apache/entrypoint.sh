PRODUCTION=${PRODUCTION:-NO}
REINSTALL_MODULES=${REINSTALL_MODULES:-NO}

NG_CONFIGURATION=${NG_CONFIGURATION:-development}
NG_REBUILD=${NG_REBUILD:-NO}

DEFAULT_FILE_CONTENT="<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Angular</title>
</head>
<body>
    <h1>Empty Project</h1>
    <p>Your project folder still empty. Use <a href=\"https://angular.io/cli\">Angular CLI</a> to generate new angular project</p>
</body>
</html>"

if [ ! -f "angular.json" ]; then
    if [ ! -d "dist" ]; then
        if [ $PRODUCTION == "YES" ]; then sudo mkdir -p dist; else mkdir -p dist; fi
    fi

    if [ ! -f "dist/index.html" ]; then
        if [ $PRODUCTION == "YES" ]; then sudo echo "${DEFAULT_FILE_CONTENT}" > dist/index.html; else echo "${DEFAULT_FILE_CONTENT}" > dist/index.html; fi
    fi
fi

if [ -d "./.docker" ]; then
    if [ -f "./.docker/before_build.js" ]; then
        if [ $PRODUCTION == "YES" ]; then sudo node ./.docker/before_build.js; else node ./.docker/before_build.js; fi
    fi
fi

if [[ -f "angular.json" && -f "package.json" ]]; then
    if [[ ! -d "node_modules" || $REINSTALL_MODULES == "YES" ]]; then
        if [ $PRODUCTION == "YES" ]; then sudo npm install; else npm install; fi
    fi

    if [[ ! -d "dist" || $NG_REBUILD == "YES" ]]; then
        if [ $PRODUCTION == "YES" ]; then
            sudo ng build --configuration $NG_CONFIGURATION --output-path=dist/
        else
            ng build --configuration $NG_CONFIGURATION --output-path=dist/
        fi
    fi
fi

if [ -d "./.docker" ]; then
    if [ -f "./.docker/after_build.js" ]; then
        if [ $PRODUCTION == "YES" ]; then sudo node ./.docker/after_build.js; else node ./.docker/after_build.js; fi
    fi
fi

sudo /usr/sbin/httpd -DFOREGROUND