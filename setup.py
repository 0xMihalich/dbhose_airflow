import shutil
from setuptools import (
    find_packages,
    setup,
)


shutil.rmtree("build", ignore_errors=True)
shutil.rmtree("pgpack.egg-info", ignore_errors=True)

with open(file="README.md", encoding="utf-8") as f:
    long_description = f.read()

setup(
    name="dbhose_airflow",
    version="0.0.0.1",
    packages=find_packages(),
    author="0xMihalich",
    author_email="bayanmobile87@gmail.com",
    description=(
        "airflow class for exchanging data between "
        "DBMSs in native binary formats."
    ),
    url="https://github.com/0xMihalich/dbhose",
    long_description=long_description,
    long_description_content_type="text/markdown",
    zip_safe=False,
)
