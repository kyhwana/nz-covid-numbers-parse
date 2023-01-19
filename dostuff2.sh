# sort NI and SI
echo "Downloading new stats"
#curl https://raw.githubusercontent.com/minhealthnz/nz-covid-data/main/cases/covid-cases.csv -o covid-cases.csv
curl https://raw.githubusercontent.com/minhealthnz/nz-covid-data/main/cases/covid-case-counts.csv -o covid-cases-counts.csv
#curl https://enf.tracing.covid19.govt.nz/api/pages/stats -o btstats.json
echo "Grepping 2 days ago"
TODAY=$(date +%F --date="2 day ago")
ni() {
    grep -f nidhb.txt covid-cases-counts.csv >nidhb.csv
    echo "doing ni dhbs"
    cat nidhb.csv | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
    echo "NI dhbs done"
}
si() {
    grep -f sidhb.txt covid-cases-counts.csv >sidhb.csv
    echo "doing si dhbs"
    cat sidhb.csv | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
    echo "SI dhbs done"
}
wellington() {
    grep -f wellydhb.txt covid-cases-counts.csv >wellydhb.csv
    echo "doing welly dhbs"
    cat wellydhb.csv | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
    echo "wellington dhbs done"
}
auckland() {
    grep -f aucklanddhb.txt covid-cases-counts.csv >aucklanddhb.csv
    echo "Doing auckland dhbs"
    cat aucklanddhb.csv | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
    echo "auckland dhbs done"
}
chch() {
    grep -f chchdhb.txt covid-cases-counts.csv >chchdhb.csv
    echo "Doing chch"
    cat chchdhb.csv | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
    #paste -d "," chchdates2 chchnumbers  >chch-covid.csv
    echo "chch done"
}
reinfections() {
    grep -f reinfectiondhb.txt covid-cases-counts.csv >reinfection.csv
    echo "Doing reinfections"
    #cat reinfection.csv  | sort | awk -F "," '{ print $1 }' | xargs -I DA grep -c DA | awk -F "," '{ sum+=$8;} END{print sum;}'
    cat reinfection.csv | sort | awk -F "," '{ print $1 }' >reinfectiondates
    cat reinfectiondates | uniq | xargs -I DA grep -c DA reinfectiondates >reinfectionnumbers
    cat reinfectiondates | sort | uniq >reinfectiondates2
    paste -d "," reinfectiondates2 reinfectionnumbers | grep -v "Report" >reinfection-covid.csv
    echo "Todays reinfections:"
    cat reinfection.csv  | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
}
nz() {
    echo "Doing all of NZ"
    cat covid-cases-counts.csv | sort | awk -F "," '{ print $1 }' >nzdates
    cat covid-cases-counts.csv  | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
    echo "all of nz done"
}
wellington
chch
auckland
ni
si
nz
reinfections
echo "Grepping 1 day ago"
TODAY=$(date +%F --date="1 day ago")
wellington
chch
auckland
ni
si
nz
reinfections
#this isn't catching all the reinfections, as the count can be >1 per line
#cat aucklanddhb.csv | sort | awk -F "," '{ print $1 }' >aucklanddates
#cat nidhb.csv | sort | awk -F "," '{ print $1 }' >nidates
#cat sidhb.csv | sort | awk -F "," '{ print $1 }' >sidates






#MOH isn't counting border cases anymore
#echo "Doing border"
#cat borderdhb.csv | sort | awk -F "," '{ print $1 }' >borderdates
#cat borderdates | uniq | xargs -I DA grep -c DA borderdates >bordernumbers
#cat borderdates | sort | uniq >borderdates2
#paste -d "," borderdates2 bordernumbers | grep -v "Report" >border-covid.csv
#TODAY=$(date +%F --date="1 day ago")
#cat borderdhb.csv  | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
