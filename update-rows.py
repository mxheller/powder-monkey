import os
import json
import mysql.connector

# Connect to database
mydb = mysql.connector.connect(
  host="35.237.166.166",
  user="root",
  passwd="sg5ycEoL6mrhMyaK",
  database="data_druid"
)
cursor = mydb.cursor()

for _, dirs, _ in os.walk('result'):
    data = []
    for dir in dirs:
        row_id = dir.split('row-')[1]
        if os.path.isfile('result/{}/error.txt'.format(dir)):
            print("ERRORED: {}".format(row_id))
            continue
        with open('result/{}/raw.json'.format(dir), 'r') as results_file:
            parsed = json.load(results_file)
            data.append((parsed["example_count"], parsed["invalid"], parsed["results"], row_id))

    cursor.executemany("UPDATE unprompted_log\
        SET example_count = %s, invalid = %s, results = %s\
        WHERE id = %s", data)
    mydb.commit()
    mydb.close()

    print("Updated {} rows!".format(len(data)))
    exit(0)