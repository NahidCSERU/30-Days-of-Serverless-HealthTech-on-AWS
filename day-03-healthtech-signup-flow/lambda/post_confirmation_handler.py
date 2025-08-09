import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('health_users')

def lambda_handler(event, context):
    user_attributes = event['request']['userAttributes']
    
    user_id = str(uuid.uuid4())
    email = user_attributes.get('email')
    name = user_attributes.get('name', 'Unknown')
    user_type = user_attributes.get('custom:user_type', 'Patient')  # custom attribute

    # Save to DynamoDB
    table.put_item(
        Item={
            'user_id': user_id,
            'email': email,
            'name': name,
            'user_type': user_type,
        }
    )
    
    # Add to group in Cognito
    cognito = boto3.client('cognito-idp')
    cognito.admin_add_user_to_group(
        UserPoolId=event['userPoolId'],
        Username=event['userName'],
        GroupName=user_type  # Group name same as user_type (e.g., Patient, Doctor)
    )
    
    return event
