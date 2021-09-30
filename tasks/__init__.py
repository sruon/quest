from invoke import Collection
from tasks import run, build

ns = Collection()
ns.add_collection(Collection.from_module(run))
ns.add_collection(Collection.from_module(build))
