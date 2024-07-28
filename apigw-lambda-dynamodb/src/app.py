# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

import boto3
import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb_client = boto3.client('dynamodb')

def lambda_handler(event, context):
  table = os.environ.get('DDB_TABLE')
  logging.info(f"## Loaded table name from environemt variable DDB_TABLE: {table}")
  if event["body"]:
      item = json.loads(event["body"])
      logging.info(f"## Received payload: {item}")
      Hospital = str(item["Hospital"])
      Name = str(item["Name"])
      Last Name = str(item["Last Name"])
      Data of Birth = int(item["Date of Birth"])
      Symptoms = str(item["Symptoms"])
      dynamodb_client.put_item(TableName=table,Item={"Hospital": {'S':Hospital}, "Name": {'S':Name}, "Last Name": {'S':Last Name}, "Date of Birth": {'N':Date of Birth}, "Symptoms": {'S':Symptoms}})
      message = "Successfully inserted data!"
      return {
          "statusCode": 200,
          "headers": {
              "Content-Type": "application/json"
          },
          "body": json.dumps({"message": message})
      }
  else:
      logging.info("## Received request without a payload")
      dynamodb_client.put_item(TableName=table,Item={"Hospitals": {'S':'Hospital A'}, "Name": {'S':'Jane'}, "Last Name": {'S':'Doe'}, "Date of Birth": {'N':'01011983'}, "Symptoms": {'S':'Fever'}})
      message = "Successfully inserted data!"
      return {
          "statusCode": 200,
          "headers": {
              "Content-Type": "application/json"
          },
          "body": json.dumps({"message": message})
      }
