import subprocess
from data_cleaning import create_csv

if __name__ == "__main__":
    try:
        file_name = input("Please enter the file name, for example data.csv: ")
        create_csv(file_name)
        # Run the R script
        subprocess.run(["Rscript", "plotting.R"])
    except Exception as e:
        print(f"An error occurred: {e}")