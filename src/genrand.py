#!/bin/env python

# --- This script chooses a pseudo-random background,
# --- taking a seed as an argument (this uses the amount
# --- of days since the Unix epoch as the seed).


import sys
import pathlib
from time import time
import random

currentFile = pathlib.Path(__file__).absolute() # current file's absolute path (slideday/src/genrand.py)
backgroundsDir = pathlib.Path(currentFile).parent.parent.joinpath("backgrounds") # directory where backgrounds are located (slideday/backgrounds)

# Create a list of backgrounds in backgrounds directory
backgroundsList = []
for picture in backgroundsDir.iterdir():
    backgroundsList.append(picture.name)

seed = int(sys.argv[1]) # set the seed to the first argument passed to the script (usually days since Unix epoch)

random.seed(seed)
chosenBackground = random.choice(backgroundsList)

print(chosenBackground) # prints the background to stdout
