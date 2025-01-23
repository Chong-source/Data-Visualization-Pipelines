import pandas as pd
import csv

def create_csv(new_csv_name: str, input_file_names: list[str]):
    with open(f"{new_csv_name}", "w") as file:
        writer = csv.writer(file)
        writer.writerow(["gene_name", "light/dark", "value", "stdev"])
        
        # Loop through each file_name in the list
        for file_name in input_file_names:
            df = pd.read_csv(file_name)
            column_name = "mscarlet"
            
            # Extract the mean and the standard deviations from each file
            if column_name in df.columns:
                average_value = df[column_name].mean()
                stdev_value = df[column_name].std()
                print(f"The average of the column '{column_name}' is: {average_value}")
                print(f"The standard deviation of the column '{column_name}' is: {stdev_value}")
            else:
                print(f"Column '{column_name}' not found in the CSV file.")
            
            # Extract the gene name from the file name
            gene_name = file_name[:-4] # Remove the .csv extension
            
            # Assuming the file contains either + or -
            if "+" in file_name:
                light_or_dark = "Light"
            else:
                light_or_dark = "Dark"
            
            # Write the data to the CSV file
            writer.writerow([gene_name, light_or_dark, average_value, stdev_value])
