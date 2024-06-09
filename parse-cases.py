import pandas as pd 
import matplotlib.pyplot as plt
import re #oh boy it's time for regexes

#total stats per day per dhb
#last 90 days per dhb
#national total per day
#7 day rolling average national
#7 day rolling average per dhb
#add esr wastewater
#add esr variant type
#Report Date     Sex Age group               District Overseas travel Infection status  Number of cases reported
#Case Status
#infection number: First, Reinfection (< 90 days), Reinfection

casesfile = pd.read_csv("covid-case-counts.csv", header=0)
pd.set_option('display.max_rows', None)
#print(casesfile)
#list of CDHBS At the border, "District"
dhbs = ['Auckland', 'Bay of Plenty', 'Canterbury/West Coast', 'Capital & Coast/Hutt', 'Counties Manukau', 'Hawke\'s Bay', 'Lakes', 'MidCentral','Nelson Marlborough','Northland','South Canterbury','Southern','Tairawhiti','Taranaki','Unknown','Waikato','Wairarapa','Waitemata','Whanganui']
#print(casesfile.columns)
##print(casesfile["Report Date"])
#print(casesfile["District"]["Number of cases reported"])
imagesdir = "images/"
uniqueddates = casesfile['Report Date'].unique()
#print(casesfile)
def national_total_per_day(casescsv):
    for day in uniqueddates:
            daycount = 0 #reset this for each unique day
            #returnedrows = casescsv[casescsv["Report Date"] == day]
            #print("numberofcases", returnedrows["Number of cases reported"])
            #daycount = daycount + returnedrows["Number of cases reported"]
            #print("daycount", daycount)
            #print("day ", day, "count ", daycount)

def cmstoinches(cm):
      #fuck this inches bullshit
      return(cm*2.54) #fuck you inches

#national_total_per_day(casesfile)
def allnationalcases(incases):
    totalnationalcases = getdailytotals(incases)
    print(totalnationalcases)
    makegraph(totalnationalcases,"alltimecases.jpg")

def getdailytotals(incases): #take in a full column dataform and return just date,datetotal
     totaldailycases = incases.groupby("Report Date")["Number of cases reported"].sum()
     return totaldailycases

def getinfectionstatusdailytotals(incases,status): #take in a full column dataform and return just date,datetotal
     totaldailycases = incases.groupby(["Report Date", "Infection status"]).sum()
     return(totaldailycases)
     

def getsevendayavg(incases): #moving seven day average of "Number of cases reported" input, but totals!
    sevendayavg = incases.rolling(7).mean()
    print(sevendayavg)
    return sevendayavg

def makegraph(incases, filename): #pass in a final dataform and output the filename graph
     plotter = incases.plot(figsize=(cmstoinches(20),cmstoinches(10)))
     plotter.set_ylim(ymin=0) #so the bottom of the graph starts at 0
     plotter.figure.savefig(filename)
     plt.close("all")

def getdistrict(incases, district): #return a dataframe of just "district" numbers. (unfiltered)
    #we assume the district exists
    districtdf = incases[incases["District"] == district]
    return districtdf

def runalldistricts(incases, days=None): #graph all district totals since forever
    for districtin in dhbs:
        districtdf = getdistrict(incases,districtin)
        districtdfdaily = getdailytotals(districtdf)
        districtdfseven = getsevendayavg(districtdfdaily)
        
        if days is None: #oop
            graphfilename = imagesdir + re.sub("[^A-Za-z]", "", districtin) + "totals.jpg" #hnngggh, dhbs have bad filename/path characters
            districtdftotals = pd.merge(districtdfdaily,districtdfseven, on="Report Date")
        else:
            graphfilename = imagesdir + re.sub("[^A-Za-z]", "", districtin) + "-" + str(days) + "-" + "totals.jpg" #hnngggh, dhbs have bad filename/path characters     
            districtdftotals = pd.merge(getlastxdays(districtdfdaily,days),getlastxdays(districtdfseven,days), on="Report Date") #ew
        
        makegraph(districtdftotals,graphfilename)

def getlastxdays(incases, days): #get the last x days of numbers, useful as testing % has fallen off. Remember to get sumed data.
     return(incases.tail(days))

allnationalcases(casesfile)
sevendayavg = getsevendayavg(casesfile.groupby("Report Date")["Number of cases reported"].sum())
totalnationalcases = casesfile.groupby("Report Date")["Number of cases reported"].sum()
nationalcasesandsevendayavg = pd.merge(totalnationalcases,sevendayavg, on="Report Date")
print(nationalcasesandsevendayavg)
natsevengdayavgplot = nationalcasesandsevendayavg
makegraph(nationalcasesandsevendayavg, "allnationaltotals.jpg")

#runalldistricts(casesfile)
#runalldistricts(casesfile, 90)
#runalldistricts(casesfile, 180)
#runalldistricts(casesfile, 365)

reinfectionstuff = getinfectionstatusdailytotals(casesfile,"First")
print(reinfectionstuff["Number of cases reported"])


