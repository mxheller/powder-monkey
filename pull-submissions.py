import json
import sys
import mysql.connector
import os

# Connect to database
mydb = mysql.connector.connect(
  host="35.237.166.166",
  user="root",
  passwd="sg5ycEoL6mrhMyaK",
  database="data_druid"
)
cursor = mydb.cursor()

if len(sys.argv) < 2:
    print("Usage: python3 pull-submissions.py <Assignment ID> <Tool>(optional)")
    exit(1)

# Ensure directory structure exists
if not os.path.isdir("corpus"):
    os.makedirs("corpus")
if not os.path.isdir("corpus/impls"):
    os.makedirs("corpus/impls")
if not os.path.isdir("corpus/predicates"):
    os.makedirs("corpus/predicates")

assignment = sys.argv[1]
tool = sys.argv[2] if len(sys.argv) == 3 else None

# Pull rows
query = 'SELECT id, submission FROM unprompted_log WHERE assignment_id="{}"'.format(assignment)
if tool: query += ' AND tool="{}"'.format(tool)
cursor.execute(query)
rows = cursor.fetchall()

for row in rows:
    f = open("corpus/impls/row-{}".format(row[0]), "w")
    split = row[1].split("# DO NOT CHANGE ANYTHING ABOVE THIS LINE")
    content = 'include file("tests.arr")\n# DO NOT CHANGE ANYTHING ABOVE THIS LINE\n' + split[-1]
    f.write(content)
    f.close()