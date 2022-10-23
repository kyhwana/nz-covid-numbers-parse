echo "Downloading new stats"
curl https://raw.githubusercontent.com/minhealthnz/nz-covid-data/main/cases/covid-cases.csv -o covid-cases.csv
curl https://raw.githubusercontent.com/minhealthnz/nz-covid-data/main/cases/covid-case-counts.csv -o covid-case-counts.csv
echo "Grepping"
grep -f nidhb.txt covid-cases.csv >nidhb.csv
grep -f sidhb.txt covid-cases.csv >sidhb.csv
grep -f wellydhb.txt covid-cases.csv >wellydhb.csv
grep -f aucklanddhb.txt covid-cases.csv >aucklanddhb.csv
grep -f chchdhb.txt covid-cases.csv >chchdhb.csv
#this isn't catching all the reinfections, as the count can be >1 per line
grep -f reinfectiondhb.txt covid-case-counts.csv >reinfection.csv
#cat aucklanddhb.csv | sort | awk -F "," '{ print $1 }' >aucklanddates
#cat nidhb.csv | sort | awk -F "," '{ print $1 }' >nidates
#cat sidhb.csv | sort | awk -F "," '{ print $1 }' >sidates
echo "Doing auckland dhbs"
cat aucklanddhb.csv | sort | awk -F "," '{ print $1 }' >aucklanddates
cat aucklanddates | uniq | xargs -I DA grep -c DA aucklanddates >aucklandnumbers
cat aucklanddates | sort | uniq >aucklanddates2
paste -d "," aucklanddates2 aucklandnumbers  >auckland-covid.csv
echo "doing welly dhbs"
cat wellydhb.csv | sort | awk -F "," '{ print $1 }' >wellydates
cat wellydates | uniq | xargs -I DA grep -c DA wellydates >wellynumbers
cat wellydates | sort | uniq >wellydates2
paste -d "," wellydates2 wellynumbers  >wellington-covid.csv
echo "doing ni dhbs"
cat nidhb.csv | sort | awk -F "," '{ print $1 }' >nidates
cat nidates | uniq | xargs -I DA grep -c DA nidates >ninumbers
cat nidates | sort | uniq >nidates2
paste -d "," nidates2 ninumbers  >ni-covid.csv
echo "doing si dhbs"
cat sidhb.csv | sort | awk -F "," '{ print $1 }' >sidates
cat sidates | uniq | xargs -I DA grep -c DA sidates >sinumbers
cat sidates | sort | uniq >sidates2
paste -d "," sidates2 sinumbers  >si-covid.csv
echo "Doing chch"
cat chchdhb.csv | sort | awk -F "," '{ print $1 }' >chchdates
cat chchdates | uniq | xargs -I DA grep -c DA chchdates >chchnumbers
cat chchdates | sort | uniq >chchdates2
paste -d "," chchdates2 chchnumbers  >chch-covid.csv
echo "Doing all of NZ"
cat covid-cases.csv | sort | awk -F "," '{ print $1 }' >nzdates
cat nzdates | uniq | xargs -I DA grep -c DA nzdates >nznumbers
cat nzdates | sort | uniq >nzdates2
paste -d "," nzdates2 nznumbers | grep -v "Report" >nz-covid.csv
#MOH isn't counting border cases anymore
#echo "Doing border" 
#cat borderdhb.csv | sort | awk -F "," '{ print $1 }' >borderdates
#cat borderdates | uniq | xargs -I DA grep -c DA borderdates >bordernumbers
#cat borderdates | sort | uniq >borderdates2
#paste -d "," borderdates2 bordernumbers | grep -v "Report" >border-covid.csv
#TODAY=$(date +%F --date="1 day ago")
#cat borderdhb.csv  | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
echo "Doing reinfections"
#cat reinfection.csv  | sort | awk -F "," '{ print $1 }' | xargs -I DA grep -c DA | awk -F "," '{ sum+=$8;} END{print sum;}'
cat reinfection.csv | sort | awk -F "," '{ print $1 }' >reinfectiondates
cat reinfectiondates | uniq | xargs -I DA grep -c DA reinfectiondates >reinfectionnumbers
cat reinfectiondates | sort | uniq >reinfectiondates2
paste -d "," reinfectiondates2 reinfectionnumbers | grep -v "Report" >reinfection-covid.csv
echo "Todays reinfections:"
TODAY=$(date +%F --date="1 day ago")
cat reinfection.csv  | grep $TODAY | awk -F "," '{ sum+=$8;} END{print sum;}'
