import psycopg2
import getpass
import pandas as pd

try:
    connection = psycopg2.connect(
        host="localhost",
        user="vikas",
        password=getpass.getpass("Enter database password: "),
        port="5432",
        database="postgres"
    )
    cursor = connection.cursor()

    postgreSQL_select_Query = "SET search_path TO 'TU857_3'"
    cursor.execute(postgreSQL_select_Query)

    #variables
    bikeid = input('Enter bike id: ')
    newstatus = input('Enter new status [R, F, C]: ')

    #call the procedure
    cursor.execute("CALL update_bike_status(%s, %s)", (bikeid, newstatus))
    connection.commit()

    #display whole a_bike table as a fetch
    cursor.execute("SELECT * FROM a_bike")
    df = pd.DataFrame(
        cursor.fetchall(),
        #iterate though each collum and get their names
        columns=[desc.name for desc in cursor.description]
    )
    print(df)

except (Exception, psycopg2.Error) as error:
    print("Error while connecting to PostgreSQL:", error)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
    else:
        print("Terminating")
