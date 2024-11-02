# Data_cleaning file for flow cytometry
# Created by: Chong Wan, 2024-10-10

import csv
import pprint

path = 'data.csv'
data_dict = {}

# Helper method to add items to dict
def add_to_dict(data_dict: dict, key: str, value: list) -> None:
    # Check if the key is already in the dictionary
    if key not in data_dict:
        # If not, create a new entry with the key and initialize the list with the value
        data_dict[key] = [value]
    else:
        # If the key is already in the dictionary, append the value to the list
        data_dict[key].append(value)

# Helper method to further split the data into QC and EX
def split_data_gene(data_dict: dict) -> None:
    keys = data_dict.keys()
    for key in keys:
        gene_data = data_dict[key]
        new_dict = {}
        new_dict["QC"] = []
        new_dict["EX"] = []
        for data in gene_data:
            if 'QC' in data[0]:
                new_dict["QC"].append(data[:3])
            else:
                new_dict["EX"].append(data[:3])
        data_dict[key] = new_dict

# Helper method to further split the data into light and dark
def split_data_light_dark(data_dict: dict[str, list[str]]) -> None:
        for key in data_dict.keys():
            qc_light_gfp = [x[1] for x in data_dict[key]['QC'] if 'Light' in x[0]]
            qc_light_mscarlet = [x[2] for x in data_dict[key]['QC'] if 'Light' in x[0]]
            qc_dark_gfp = [x[1] for x in data_dict[key]['QC'] if 'Dark' in x[0]]
            qc_dark_mscarlet = [x[2] for x in data_dict[key]['QC'] if 'Dark' in x[0]]
        
            ex_light_gfp = [x[1] for x in data_dict[key]['EX'] if 'Light' in x[0]]
            ex_light_mscarlet = [x[2] for x in data_dict[key]['EX'] if 'Light' in x[0]]
            ex_dark_gfp = [x[1] for x in data_dict[key]['EX'] if 'Dark' in x[0]]
            ex_dark_mscarlet = [x[2] for x in data_dict[key]['EX'] if 'Dark' in x[0]]
        
            data_dict[key] = {"qc_light_gfp": sum(qc_light_gfp)/len(qc_light_gfp), "qc_light_mscarlet": sum(qc_light_mscarlet)/len(qc_light_mscarlet), 
                              "qc_dark_gfp": sum(qc_dark_gfp)/len(qc_dark_gfp), "qc_dark_mscarlet": sum(qc_dark_mscarlet)/len(qc_dark_gfp), 
                              "ex_light_gfp": sum(ex_light_gfp)/len(ex_light_gfp), "ex_light_mscarlet": sum(ex_light_mscarlet)/len(ex_light_mscarlet), 
                              "ex_dark_gfp": sum(ex_dark_gfp)/len(ex_dark_gfp), "ex_dark_mscarlet": sum(ex_dark_mscarlet)/len(ex_dark_gfp)}

# Open the CSV file
with open(path, mode='r') as file:
    # Create a CSV reader object
    csv_reader = csv.reader(file)
    
    # Skip the header
    next(csv_reader)
    
    # Iterate over the rows in the CSV file
    for row in csv_reader:
        row[1] = float(row[1])
        row[2] = float(row[2].replace(',', '.'))
        key = row[0][0:12]  # Assuming the first item is the key
        value = row  # The rest of the row is the value
        
        # Add the key-value pair to the dictionary
        add_to_dict(data_dict, key, value)
        
    # Split the data into QC and EX
    split_data_gene(data_dict)
    
    # Split the data into light and dark
    split_data_light_dark(data_dict)
    
    # pprint.pprint(data_dict['JL701 pRS316']['EX'])
    # print(data_dict.keys())
    # print(len(data_dict.keys()))
    # print(data_dict['SC031 pRS316'])
    
with open("gfp_data_grouped.csv", "w") as file:
    # Columns: gene_name, QC/EX, light/dark, fluorescence, value
    writer = csv.writer(file)
    keys = data_dict.keys()
    # Write the header
    writer.writerow(["gene_name", "QC/EX light/dark", "value"])
    # Write the data
    for key in keys:
        gene_data = data_dict[key]
        # Write the rows for QC
        writer.writerow([key, "QC Light", gene_data["qc_light_gfp"]])
        writer.writerow([key, "QC Dark", gene_data["qc_dark_gfp"]])
        # Write the rows for EX
        writer.writerow([key, "EX Light", gene_data["ex_light_gfp"]])
        writer.writerow([key, "EX Dark", gene_data["ex_dark_gfp"]])

with open("ymScarlet_data_grouped.csv", "w") as file:
    # Columns: gene_name, QC/EX, light/dark, fluorescence, value
    writer = csv.writer(file)
    keys = data_dict.keys()
    # Write the header
    writer.writerow(["gene_name", "QC/EX light/dark", "value"])
    # Write the data
    for key in keys:
        gene_data = data_dict[key]
        # Write the rows for QC 
        writer.writerow([key, "QC Light", gene_data["qc_light_mscarlet"]])
        writer.writerow([key, "QC Dark", gene_data["qc_dark_mscarlet"]])
        # Write the rows for EX
        writer.writerow([key, "EX Light", gene_data["ex_light_mscarlet"]])
        writer.writerow([key, "EX Dark", gene_data["ex_dark_mscarlet"]])
        
with open("gfp_data_ungrouped.csv", "w") as file:
    # Columns: gene_name, QC/EX, light/dark, fluorescence, value
    writer = csv.writer(file)
    keys = data_dict.keys()
    # Write the header
    writer.writerow(["gene_name", "QC/EX light/dark", "value"])
    # Write the data
    for key in keys:
        gene_data = data_dict[key]
        # Write the rows for QC
        writer.writerow([key + " QC", "Light", gene_data["qc_light_gfp"]])
        writer.writerow([key + " QC", "Dark", gene_data["qc_dark_gfp"]])
        # Write the rows for EX
        writer.writerow([key + " EX", "Light", gene_data["ex_light_gfp"]])
        writer.writerow([key + " EX", "Dark", gene_data["ex_dark_gfp"]])
        
with open("ymScarlet_data_ungrouped.csv", "w") as file:
    # Columns: gene_name, QC/EX, light/dark, fluorescence, value
    writer = csv.writer(file)
    keys = data_dict.keys()
    # Write the header
    writer.writerow(["gene_name", "QC/EX light/dark", "value"])
    # Write the data
    for key in keys:
        gene_data = data_dict[key]
        # Write the rows for QC 
        writer.writerow([key + " QC", "Light", gene_data["qc_light_mscarlet"]])
        writer.writerow([key + " QC", "Dark", gene_data["qc_dark_mscarlet"]])
        # Write the rows for EX
        writer.writerow([key + " EX", "Light", gene_data["ex_light_mscarlet"]])
        writer.writerow([key + " EX", "Dark", gene_data["ex_dark_mscarlet"]])
        
# GFP signal over noise data
with open("gfp_signal_over_noise.csv", "w") as file:
    writer = csv.writer(file)
    keys = data_dict.keys()
    # Write the header
    writer.writerow(["gene_name", "value"])
    for key in keys:
        gene_data = data_dict[key]
        signal_over_noise = gene_data["ex_dark_gfp"] / gene_data["ex_light_gfp"]
        writer.writerow([key, signal_over_noise])