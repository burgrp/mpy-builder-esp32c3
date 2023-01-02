import os


def freeze(dir, modules):
    print(dir, modules)

# Freeze application files


modules = []

for file in os.listdir('.'):
    if file.endswith('.py') and file != 'manifest.py':
        modules.append(file)

freeze('.', modules)


# Freeze external packages

PACKAGES_DIR = 'packages'

modules = []

for root, dirs, files in os.walk(PACKAGES_DIR):
    if '__init__.py' in files:
        root_parts = root.split('/')
        d = root_parts[-1:][0]
        freeze('/' + '/'.join(root_parts[:-1]), [d + "/" + f for f in files])
