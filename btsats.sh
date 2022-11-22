curl https://enf.tracing.covid19.govt.nz/api/pages/stats -o btstats.json
echo "BT stats"
jq ".generated,.dashboardItems[][].value" btstats.json | sed 's/\"//g' | sed 's/,//g' | paste -sd',' >>btstatslatest.txt
