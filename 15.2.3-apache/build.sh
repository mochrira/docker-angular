PRODUCTION=${PRODUCTION:-NO}
REINSTALL_MODULES=${REINSTALL_MODULES:-NO}

NG_CONFIGURATION=${NG_CONFIGURATION:-development}
NG_REBUILD=${NG_REBUILD:-NO}

if [ $PRODUCTION == "YES" ]; then
    if [ -d "./.docker" ]; then
        if [ -f "./.docker/before_build.js" ]; then sudo -E node ./.docker/before_build.js; fi
    fi

    if [ -f "package.json" ]; then
        if [ $REINSTALL_MODULES == "YES" ]; then sudo npm install; fi
        if [ $NG_REBUILD == "YES" ]; then sudo ng build --configuration $NG_CONFIGURATION --output-path=dist/; fi
    fi

    if [ -d "./.docker" ]; then
        if [ -f "./.docker/after_build.js" ]; then sudo -E node ./.docker/after_build.js; fi
    fi

    if [ -d "dist/" ]; then
        sudo cp -R dist/* /var/www/html;
    fi
fi

if [ $PRODUCTION == "NO" ]; then
    if [ -d "./.docker" ]; then
        if [ -f "./.docker/before_build.js" ]; then node ./.docker/before_build.js; fi
    fi

    if [ ! -d "dist" ]; then mkdir -p dist; fi
    if [ -f "package.json" ]; then
        if [ $REINSTALL_MODULES == "YES" ]; then npm install; fi
        if [ $NG_REBUILD == "YES" ]; then ng build --configuration $NG_CONFIGURATION --output-path=dist/; fi
    fi

    if [ -d "./.docker" ]; then
        if [ -f "./.docker/after_build.js" ]; then node ./.docker/after_build.js; fi
    fi
fi