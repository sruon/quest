from invoke import task
from .conf import REGISTRY, REGION


@task(default=True)
def build(ctx):
    branch = ctx.run("git rev-parse --abbrev-ref HEAD", hide="out").stdout
    hash = ctx.run("git rev-parse --short HEAD", hide="out").stdout
    ctx.run(f"docker build . -t {REGISTRY}:{branch}")


@task()
def push(ctx):
    branch = ctx.run("git rev-parse --abbrev-ref HEAD", hide="out").stdout
    creds = ctx.run(f"aws ecr get-login-password --region {REGION}", hide="out").stdout.rstrip().lstrip()
    ctx.run(f"docker login --username AWS --password {creds} {REGISTRY}")
    ctx.run(f"docker push {REGISTRY}:{branch}")
