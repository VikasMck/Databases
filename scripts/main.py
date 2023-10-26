import psycopg2, getpass, pandas as pd
from psycopg2 import Error
try:
    connection = psycopg2.connect(
        host="localhost",  user = "vikas",
        password=getpass.getpass(),
        port="5432", database="postgres")

    cursor = connection.cursor()
    postgreSQL_select_Query = 'select * from b2_customer'
    cursor.execute(postgreSQL_select_Query)
    df = pd.DataFrame(
        cursor.fetchall(),
        columns=['CustomerId', 'Name', 'Address'])
    print(df)
except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
    else:
        print("Terminating")
