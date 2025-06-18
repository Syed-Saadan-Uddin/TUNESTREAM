import os

# Set the path to your folder
folder_path = 'songs'

# Set the path for the output text file
output_file = 'filenames.txt'

# List all files in the folder
filenames = [f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f))]

# Write the filenames to the text file
with open(output_file, 'w') as f:
    for filename in filenames:
        f.write(filename + '\n')

print(f"Saved {len(filenames)} filenames to '{output_file}'")
