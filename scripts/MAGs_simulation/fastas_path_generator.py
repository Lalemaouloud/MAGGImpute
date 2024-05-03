import os
# Function to generate file paths within a folder 
def generate_file_paths(folder_path, output_file):
    with open(output_file, 'w') as f:
        for root, dirs, files in os.walk(folder_path):
            for file_name in files:
                file_path = os.path.join(root, file_name)
                f.write(file_path + '\n')

folder_path = input("Enter the folder path: ")

if os.path.isdir(folder_path):
    output_file = "file_paths.txt"
    generate_file_paths(folder_path, output_file)
    print(f"File paths generated successfully in '{output_file}'.")
else:
    print("Invalid folder path. Please provide a valid path.")

