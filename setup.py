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
    version="0.1.0.3",
    packages=find_packages(),
    author="0xMihalich",
    author_email="bayanmobile87@gmail.com",
    description=(
        "airflow class for exchanging data between "
        "DBMSs in native binary formats."
    ),
    url="https://github.com/0xMihalich/dbhose_airflow",
    long_description=long_description,
    long_description_content_type="text/markdown",
    include_package_data=True,
    zip_safe=False,
    project_urls={
        "Homepage": "https://github.com/0xMihalich/dbhose_airflow",
        "Documentation": "https://0xmihalich.github.io/dbhose_airflow/",
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Database",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Programming Language :: Python :: 3.13",
        "Programming Language :: Python :: 3.14",
        "Framework :: Apache Airflow",
        "Operating System :: OS Independent",
    ],
    keywords="airflow, database, etl, clickhouse, postgresql, greenplum",
    install_requires=[
        "apache-airflow>=2.4.3",
        "native-dumper==0.3.5.0",
        "pgpack-dumper==0.3.5.0",
        "dbhose-utils==0.0.2.5",
    ],
    python_requires=">=3.10",
)
