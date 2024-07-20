# TASK2
# AWS IAM User Provisioning with Python

## Overview

This Python script (`iam_user.py`) demonstrates how to provision AWS IAM users, attach IAM policies, and enable AWS Management Console access using the `boto3` library.

## Prerequisites

- Python 3.x installed on your local machine.
- `boto3` library installed. Install it using pip:
 	- pip install boto3

## Script Functonality
 - Create IAM User: Creates a new IAM user with a specified username.
 - Attach Policy to User: Attaches an IAM policy to the newly created IAM user. 
 - Enable Console Access: Enables AWS Management Console access for the IAM user by setting a login profile with a password

## Execution
    python iam_user.py