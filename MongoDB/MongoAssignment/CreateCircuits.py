import csv
#additional validators; requires pip isntall
import validators

from pymongo import MongoClient

#because this is going on github
username = input("Enter username: ")
password = input("Enter password: ")

uri = 'mongodb://'+username+':'+password+'@localhost:27017/?authSource=admin'
client = MongoClient(uri)

# Open the csv with 'r'
with open('circuits.csv', 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    data = [row for row in csv_reader]

mydb = client["Formula1"]

#making a huge array just for easy access to data and testing' and drop() clears out the data after each run to avoid clogging
mycol_embedded = mydb["Circuits_Embedded"]
mycol_embedded.drop()

#main circuits, but to avoid confussion its named direct oppsite of embedded :)
mycol_separate = mydb["Circuits_Separate"]
mycol_separate.drop()


separate_circuits = []

for row in data:
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

# Include separate_circuits in embedded_document
embedded_document = {"name": "Embedded Document Name", "circuits": separate_circuits}

# Insert embedded document
mycol_embedded.insert_one(embedded_document)

# Insert separate documents
mycol_separate.insert_many(separate_circuits)

client.close()
