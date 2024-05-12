import time
import sys

while True:
    if "--name" in sys.argv:
        name_index = sys.argv.index("--name") + 1
        if name_index < len(sys.argv):
            print(f"I received a --name argument! Hello {sys.argv[name_index]}")
        else:
            print("--name command, but no name provided!")
    elif "--filename" in sys.argv:
        filename_index = sys.argv.index("--filename") + 1
        if filename_index < len(sys.argv):
            try:
                with open(sys.argv[filename_index], 'r') as file:
                    contents = file.read()
                    print(f"I received --filename command. The file contents I read are: {contents}")
            except FileNotFoundError:
                print("I received --filename command. CANNOT FIND the file inside container!")
        else:
            print("No filename provided!")
    else:
        print("Working without any arguments.")
    
    time.sleep(2)