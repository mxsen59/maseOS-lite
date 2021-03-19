import sys

inputFile = sys.argv[1]
outputFile = sys.argv[2]

def convToFlp():
    print("Converting .bin to .flp...\n")
    with open(inputFile, 'rb') as infile:
        binData = infile.read()
        with open(outputFile, "wb") as outfile:
            print(outfile.write(binData))
            print("Done converting.")

convToFlp()
            
