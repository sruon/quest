import os

REGISTRY = "749738151927.dkr.ecr.us-east-2.amazonaws.com/rearc-prd"
PORT = os.environ.get("PORT", "3000")
REGION = os.environ.get("REGION", "us-east-2")
