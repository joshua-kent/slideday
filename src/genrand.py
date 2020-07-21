#!/bin/env python

# This script chooses a pseudo-random background,
# taking a seed as an argument (this uses the amount
# of days since the Unix epoch as the seed).


import sys
import pathlib
from time import time
import random

currentDir = pathlib.Path(__file__).absolute()
backgroundsDir = pathlib.Path(currentDir).parent.parent.joinpath("backgrounds")

backgroundsList = []
for picture in backgroundsDir.iterdir():
    backgroundsList.append(picture.name)

seed = int(sys.argv[1])

random.seed(seed)
chosenBackground = random.choice(backgroundsList)
print(chosenBackground)