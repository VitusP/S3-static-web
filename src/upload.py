import os
import sys
import boto3
from dotenv import load_dotenv
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load variables from .env file
load_dotenv()

bucket_name=os.getenv("S3_BUCKET_NAME")

def upload_folder_to_s3(bucket_name, folder_path):
    s3_client = boto3.client('s3')
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            local_path = os.path.join(root, file)
            relative_path = os.path.relpath(local_path, folder_path)
            s3_path = os.path.join(os.path.basename(folder_path), relative_path)
            s3_client.upload_file(local_path, bucket_name, s3_path)
            logger.info(f"Uploaded {local_path} to S3://{bucket_name}/{s3_path}")

if __name__ == "__main__":
    # Check if the correct number of arguments is provided
    if len(sys.argv) != 2:
        print("Usage: python upload_to_s3.py <folder_path>")
        sys.exit(1)

    # Retrieve bucket name and folder path from command-line arguments
    folder_path = sys.argv[1]

    # Validate if the specified folder exists
    if not os.path.isdir(folder_path):
        print(f"The specified folder '{folder_path}' does not exist.")
        sys.exit(1)

    # Call the upload function
    upload_folder_to_s3(bucket_name, folder_path)
