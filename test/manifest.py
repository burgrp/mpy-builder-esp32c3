import os

### Freeze application files

modules = []

for file in os.listdir("."):
    if file.endswith(".py") and file != "manifest.py":
        modules.append(file)

freeze(".", modules)


### Freeze external dependencies from requirements directory

REQ_DIR="requirements"

modules = []

for package in os.listdir(REQ_DIR):
    if package != "test":
        for file in os.listdir(REQ_DIR + "/" + package):
            if file.endswith(".py"):
                modules.append(package + "/" + file)

freeze(REQ_DIR, modules)

