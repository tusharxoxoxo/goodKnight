MacOS application, added .csv into duckdb and running queries on that, and creating charts of that

-> I have not included the .csv file, it was > 100 MB, for that i need to git lfs, that's why i have ignored uploading it to the github repo, i have excluded it in the .gitignore file

-> I have harded the exact location of .csv file in my machine, so for running this, u have update this https://github.com/tusharxoxoxo/goodKnight/blob/main/goodKnight/ExoplanetStore.swift line 161.

-> I've built a macOS application that uses DuckDB to query data from a local CSV file and generate charts. I based this application on the example iOS app provided in the DuckDB repository, which retrieves and visualizes exoplanetary data from an API.


![image](https://github.com/user-attachments/assets/7a6786ea-8aaa-473f-86d8-7e9b0caaecb4)


-> While the example app works correctly, I'm encountering an issue when adapting it to query my local CSV file. When I run queries against the DuckDB database created from the CSV, I receive an unexpected error. I've searched online resources and the DuckDB documentation, but haven't found a solution. I suspect this might be a bug in DuckDB itself. To further debug this, I plan to contact the DuckDB team and potentially create an issue on their issue tracker.


![image](https://github.com/user-attachments/assets/d8689b0b-7d48-4e84-b6b6-21f07c70cb99)
