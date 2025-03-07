import sys
import zipfile
if len(sys.argv) < 2:
    print("Usage: unzip <filename>")
    sys.exit()
#a = input("Please input file");
with zipfile.ZipFile(sys.argv[1], 'r') as zip_ref:
    print("Extracting all to "+sys.argv[1][:-4]+'/')
    zip_ref.extractall(sys.argv[1][:-4]+'/')
    print("Extracted all")
