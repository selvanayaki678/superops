import boto3
user_name="test123"
policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
user_password="Password@123"
iam = boto3.client('iam')
###create user
user_response = iam.create_user(UserName=user_name)
print(user_response)
###assign permissions to the user
policy_assign_response=iam.attach_user_policy(UserName=user_name,PolicyArn=policy_arn)
print(policy_assign_response)
###Enabling Console access
console_access_response = iam.create_login_profile(UserName=user_name,Password=user_password,PasswordResetRequired=True)
print(console_access_response)
