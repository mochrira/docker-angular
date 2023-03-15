PROJECT_NAME=${PROJECT_NAME:-default-angular}
NG_CONFIGURATION=${NG_CONFIGURATION:-development}
PRODUCTION=${PRODUCTION:-NO}

if [ ! -f "angular.json" ];
then
    ng new $PROJECT_NAME --directory . --defaults true --skip-git true --style scss
fi

if [ ! -d "node_modules" ];
then
    npm install
fi

if [ ! -d "dist"];
then
    mkdir -p dist
fi

if [ $PRODUCTION == "NO" ]; then
    ng build --configuration $NG_CONFIGURATION --output-path=dist/ --watch &> /dev/stdout &
else
    ng build --configuration $NG_CONFIGURATION --output-path=dist/
fi

/home/node/local/apache2/bin/apachectl -DFOREGROUND