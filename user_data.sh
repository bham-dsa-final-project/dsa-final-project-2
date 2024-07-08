#!/bin/bash

# Update the system
yum update -y

# Install necessary packages
yum install -y git python3
pip3 install pymysql

# Clone the GitHub repository
git clone https://github.com/bham-dsa-final-project/dsa-final-project-2 /home/ec2-user/your-project

# Configure environment variables
echo "export RDS_HOST='${rds_endpoint}'" >> /home/ec2-user/.bash_profile
echo "export RDS_USER='${rds_username}'" >> /home/ec2-user/.bash_profile
echo "export RDS_PASSWORD='${rds_password}'" >> /home/ec2-user/.bash_profile
echo "export RDS_DB='recognitiondb'" >> /home/ec2-user/.bash_profile
source /home/ec2-user/.bash_profile

# Upload data to RDS
cat <<EOT >> /home/ec2-user/upload_data.py
import pymysql
import os
import csv

# Database settings from environment variables
rds_host = os.environ.get('RDS_HOST')
rds_user = os.environ.get('RDS_USER')
rds_password = os.environ.get('RDS_PASSWORD')
rds_db = os.environ.get('RDS_DB')

# Connect to the database
connection = pymysql.connect(host=rds_host, user=rds_user, password=rds_password, db=rds_db)

def upload_data(file_path, table_name):
    try:
        with connection.cursor() as cursor:
            with open(file_path, 'r') as file:
                reader = csv.reader(file)
                headers = next(reader)
                for row in reader:
                    cursor.execute(f"INSERT INTO {table_name} ({', '.join(headers)}) VALUES ({', '.join(['%s'] * len(row))})", row)
            connection.commit()
    except Exception as e:
        print(f"Error: {str(e)}")
    finally:
        connection.close()

if __name__ == "__main__":
    upload_data('/home/ec2-user/your-project/data/callout_data.csv', 'CallOut')
    upload_data('/home/ec2-user/your-project/data/hall_of_fame_data.csv', 'HallOfFame')
    upload_data('/home/ec2-user/your-project/data/small_improvements_data.csv', 'SmallImprovements')
    upload_data('/home/ec2-user/your-project/data/talentguard_data.csv', 'TalentGuard')
EOT

# Make the Python script executable and run it
chmod +x /home/ec2-user/upload_data.py
/usr/bin/python3 /home/ec2-user/upload_data.py

# Create and run the data fetch script
cat <<EOT >> /home/ec2-user/fetch_data.py
import pymysql
import os

# Database settings from environment variables
rds_host = os.environ.get('RDS_HOST')
rds_user = os.environ.get('RDS_USER')
rds_password = os.environ.get('RDS_PASSWORD')
rds_db = os.environ.get('RDS_DB')

# Connect to the database
connection = pymysql.connect(host=rds_host, user=rds_user, password=rds_password, db=rds_db)

def fetch_data():
    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM CallOut"  # Example query
            cursor.execute(sql)
            result = cursor.fetchall()
            for row in result:
                print(row)
    
    except Exception as e:
        print(f"Error: {str(e)}")
    
    finally:
        connection.close()

if __name__ == "__main__":
    fetch_data()
EOT

# Make the Python script executable and run it
chmod +x /home/ec2-user/fetch_data.py
/usr/bin/python3 /home/ec2-user/fetch_data.py

# Schedule infrastructure destruction after 30 minutes
echo "30 * * * * root /usr/local/bin/terraform destroy -auto-approve -var 'db_password=${db_password}'" >> /etc/crontab
