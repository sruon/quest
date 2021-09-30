from invoke import task
from .conf import PORT


@task(default=True)
def run(ctx):
    ctx.run("npm start")


@task
def docker(ctx):
    ctx.run(f"docker run -it -p {PORT}:{PORT} tmp:latest")
