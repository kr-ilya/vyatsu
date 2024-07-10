import os
from dotenv import load_dotenv

env_loaded = load_dotenv()
if not env_loaded:
    print(".env file not found")
    exit(1)

db_host = os.environ.get('DB_HOST')
db_port = os.environ.get('DB_PORT')
db_user = os.environ.get('DB_USER')
db_pass = os.environ.get('DB_PASS')
db_base = os.environ.get('DB_BASE')

if [x for x in (db_host, db_port, db_user, db_pass, db_base) if x is None]:
    print("Some environment variables are not defined")
    exit(1)