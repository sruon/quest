from invoke import task


@task(default=True)
def unit(ctx):
    raise NotImplementedError


@task
def integration(ctx):
    raise NotImplementedError


@task
def e2e(ctx):
    raise NotImplementedError
