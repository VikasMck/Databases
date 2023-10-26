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

    # Create a cursor to perform database operations
    cursor = connection.cursor()

    postgreSQL_select_Query = "set search_path to 'TU857_3'"
    cursor.execute(postgreSQL_select_Query)
    cursor = connection.cursor()
    sid = input('Enter sale id: ')
    sno = input('Enter staff id: ')
    sdale = input ('Enter quantity: ')
    cursor.callproc('add_proc_sale',(sid, sno, sdale,))
    connection.commit()

    df = pd.DataFrame(
        cursor.fetchall(),
        columns=['st_name'])
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
