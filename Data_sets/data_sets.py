import pandas as pd
import numpy as np
from faker import Faker

# Initialize Faker for generating random data
faker = Faker()


# Function to generate random data for CallOut dataset
def generate_callout_data(num_records):
    callout_data = []
    for _ in range(num_records):
        callout_data.append(
            {
                "CallOutID": faker.random_int(min=1, max=1000),
                "EmployeeID": faker.random_int(min=100, max=200),
                "RecognitionDate": faker.date_between(
                    start_date="-1y", end_date="today"
                ),
                "RecognitionType": faker.random_element(
                    elements=["Above and Beyond", "Teamwork", "Innovation"]
                ),
                "PointsAwarded": faker.random_int(min=5, max=15),
                "Comments": faker.sentence(),
            }
        )
    return pd.DataFrame(callout_data)


# Function to generate random data for TalentGuard dataset
def generate_talentguard_data(num_records):
    talentguard_data = []
    for _ in range(num_records):
        talentguard_data.append(
            {
                "TalentGuardID": faker.random_int(min=1, max=1000),
                "EmployeeID": faker.random_int(min=100, max=200),
                "SkillID": faker.random_int(min=1, max=100),
                "SkillName": faker.random_element(
                    elements=[
                        "Project Management",
                        "Java Programming",
                        "Python Programming",
                        "Data Analysis",
                    ]
                ),
                "SkillLevel": faker.random_element(
                    elements=["Beginner", "Intermediate", "Advanced"]
                ),
                "DateAcquired": faker.date_between(start_date="-2y", end_date="today"),
                "Comments": faker.sentence(),
            }
        )
    return pd.DataFrame(talentguard_data)


# Function to generate random data for Small Improvements dataset
def generate_small_improvements_data(num_records):
    small_improvements_data = []
    for _ in range(num_records):
        small_improvements_data.append(
            {
                "ReviewID": faker.random_int(min=1, max=1000),
                "EmployeeID": faker.random_int(min=100, max=200),
                "ReviewDate": faker.date_between(start_date="-1y", end_date="today"),
                "FeedbackType": faker.random_element(
                    elements=["Positive", "Constructive"]
                ),
                "Feedback": faker.sentence(),
                "ReviewerID": faker.random_int(min=200, max=300),
            }
        )
    return pd.DataFrame(small_improvements_data)


# Function to generate random data for Hall of Fame dataset
def generate_hall_of_fame_data(num_records):
    hall_of_fame_data = []
    for _ in range(num_records):
        hall_of_fame_data.append(
            {
                "HallOfFameID": faker.random_int(min=1, max=1000),
                "EmployeeID": faker.random_int(min=100, max=200),
                "AchievementDate": faker.date_between(
                    start_date="-2y", end_date="today"
                ),
                "AchievementType": faker.random_element(
                    elements=["Certification", "Community Contribution", "Award"]
                ),
                "Description": faker.sentence(),
            }
        )
    return pd.DataFrame(hall_of_fame_data)


# Generate datasets with 100 records each
callout_df = generate_callout_data(100)
talentguard_df = generate_talentguard_data(100)
small_improvements_df = generate_small_improvements_data(100)
hall_of_fame_df = generate_hall_of_fame_data(100)

# Display the dataframes
print("CallOut Dataset")
print(callout_df.head())

print("\nTalentGuard Dataset")
print(talentguard_df.head())

print("\nSmall Improvements Dataset")
print(small_improvements_df.head())

print("\nHall of Fame Dataset")
print(hall_of_fame_df.head())

# Save the dataframes to CSV files if needed
callout_df.to_csv("callout_data.csv", index=False)
talentguard_df.to_csv("talentguard_data.csv", index=False)
small_improvements_df.to_csv("small_improvements_data.csv", index=False)
hall_of_fame_df.to_csv("hall_of_fame_data.csv", index=False)
