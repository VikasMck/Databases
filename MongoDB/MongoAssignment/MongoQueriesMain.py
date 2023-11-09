#separate file for running all the interesting queries

from pymongo import MongoClient

#because this is going on github
# Set environment variables
username = input("Enter MongoDB username: ")
password = input("Enter MongoDB password: ")


uri = f'mongodb://{username}:{password}@localhost:27017/?authSource=admin'
client = MongoClient(uri)

mydb = client["Formula1"]
query_collection = mydb["Circuits_Separate"]



#query to find everything

# query_result = query_collection.find({})

# for document in query_result:
#     print(document)


#query to check for altitudes which are more than 500 and are in coordinates array

# query = {
#     "coordinates.alt": {"$gt": 500}
# }

# result = query_collection.find(query)

# for document in result:
#     print(document)


#check which ones were error values in the <alt>

# query = {
#     "coordinates.alt": {"$eq": 0}
# }

# result = query_collection.find(query)

# for document in result:
#     print(document)


#this query makes a projection which blocks the id, whole coordinates array and the url

# projection = {
#     "_id": 0,
#     "coordinates": 0, 
#     "url": 0
# }

# query_result = query_collection.find({}, projection)

# for document in query_result:
#     print(document)



# client.close()
