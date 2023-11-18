import csv
#additional validators; requires pip isntall
import validators
from datetime import datetime

from pymongo import MongoClient

#because this is going on github
username = input("Enter username: ")
password = input("Enter password: ")

uri = 'mongodb://'+username+':'+password+'@localhost:27017/?authSource=admin'
client = MongoClient(uri)

#a different way that I learned with creating collections from csvs; prefer this than what is done during class/labs

# opening the csv with reading
with open('circuits.csv', 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    circuit_data = [row for row in csv_reader]

with open('races.csv', 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    races_data = [row for row in csv_reader]

mydb = client["Formula1"]

#making a huge array just for easy access to data and testing
mycol_cir_embedded = mydb["Circuits_Embedded"]
mycol_cir_embedded.drop()

#main circuits, but to avoid confussion its named direct oppsite of embedded :)
mycol_cir_separate = mydb["Circuits_Separate"]
mycol_cir_separate.drop()

#huge array for this now
mycol_race_embedded = mydb["Races_Embedded"]
mycol_race_embedded.drop()

#main races collection
mycol_race_separate = mydb["Races_Separate"]
mycol_race_separate.drop()

#lists for separata data
separate_circuits = []
separate_races = []

#collection that shows 1:M relationship
mycol_years = mydb["Races_By_Year"]
mycol_years.drop()


for row in races_data:
    #there are a lot of \N values and the correct values are meant to be data therefore I need fancy functions to make it sure the values are kept as it is
    def parse_date(value):
        try:
            #split the date into the regex format, and parse it - if it works great, else if the value is None or \N return None
            return datetime.strptime(value, '%y-%m-%d').date() if value and value != '\\N' else None
        except ValueError:
            return None

    #check if the time is not None or is equal to \N - if so return None or keep the original value
    def parse_time(value):
        return value if value and value != '\\N' else None

    fp1_date = parse_date(row['fp1_date'])
    fp1_time = parse_time(row['fp1_time'])

    fp2_date = parse_date(row['fp2_date'])
    fp2_time = parse_time(row['fp2_time'])

    fp3_date = parse_date(row['fp3_date'])
    fp3_time = parse_time(row['fp3_time'])

    quali_date = parse_date(row['quali_date'])
    quali_time = parse_time(row['quali_time'])

    sprint_date = parse_date(row['sprint_date'])
    sprint_time = parse_time(row['sprint_time'])

    time = parse_time(row['time'])


    #unnecessary but for the sake of assignment
    url = row['url']
    if url and not validators.url(url):
        url = "unavailable url"

    #variables kept to be same as in csv
    races_entry = {
    "raceId": int(row['raceId']),
    "year": row['year'],
    "round": row['round'],
    "circuitId": row['circuitId'],
    "name": row['name'],
    "date": row['date'],
    "time": time,
    "url": row['url'],
    #array for dates with embedded sections
    "dates": {
        "fp1":{
            "fp1_date": fp1_date,
            "fp1_time": fp1_time,
        },
        "fp2":{
            "fp2_date": fp2_date,
            "fp2_time": fp2_time,
        },
        "fp3":{
            "fp3_date": fp3_date,
            "fp3_time": fp3_time,
        },
        "quali":{
            "quali_date": quali_date,
            "quali_time": quali_time,
        },
        "sprint":{
            "sprint_date": sprint_date,
            "sprint_time": sprint_time,
        }
    },
    
}
    #append to a separate list
    separate_races.append(races_entry)

#making both embedded and separate collections
embedded_race_document = {"name": "Embedded Document", "races": separate_races}

mycol_race_embedded.insert_one(embedded_race_document)

mycol_race_separate.insert_many(separate_races)
    


for row in circuit_data:
    #I noticed <alt> has \N values which the reader does not like at all, hence this fixes it
    alt = int(row['alt']) if row['alt'] and row['alt'] != '\\N' and row['alt'].isdigit() else 0
    #unnecessary but for the sake of assignment
    url = row['url']
    if url and not validators.url(url):
        url = "unavailable url"

    #variables kept to be same as in csv
    circuit_entry = {
    "circuitId": int(row['circuitId']),
    "circuitRef": row['circuitRef'],
    "name": row['name'],
    "location": row['location'],
    "country": row['country'],
    #array for coords
    "coordinates": {
        "lat": float(row['lat']),
        "lng": float(row['lng']),
        "alt": alt,
    },
    "url": row['url']
}
    separate_circuits.append(circuit_entry)

#making both embedded and separate collections

embedded_cir_document = {"name": "Embedded Document", "circuits": separate_circuits}

mycol_cir_embedded.insert_one(embedded_cir_document)

mycol_cir_separate.insert_many(separate_circuits)



#inserting the values into 1:M collection
races_by_year = {}

for row in separate_races:
    year = row["year"]
    
    #append existing or..
    if year in races_by_year:
        races_by_year[year].append(row)
    #make new value in the dict
    else:
        races_by_year[year] = [row]


for year, races in races_by_year.items():
    year_entry = {"year": year, "races": races}
    mycol_years.insert_one(year_entry)



client.close()
