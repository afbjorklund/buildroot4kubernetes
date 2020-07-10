import sys
import os

import matplotlib.pyplot as plt

images = open(sys.argv[1]).read().splitlines()
sizes = open(sys.argv[2]).read().splitlines()

output = sys.argv[3]


def parse(string):
    if string.endswith("GB"):
        return float(string.replace("GB", "")) * (1 << 30)
    elif string.endswith("MB"):
        return float(string.replace("MB", "")) * (1 << 20)
    elif string.endswith("kB"):
        return float(string.replace("kB", "")) * (1 << 10)
    else:
        return float(string)

def format(number):
    if number > (1 << 30):
        return "%.2fGB" % (float(number) / (1 << 30))
    elif number > (1 << 20):
        return "%.2fMB" % (float(number) / (1 << 20))
    elif number > (1 << 10):
        return "%.2fkB" % (float(number) / (1 << 10))
    else:
        return str(number)

total = 0

values = []
labels = []
for i in range(len(images)):
    image = os.path.basename(images[i])
    label = "%s (%s)" % (image, sizes[i])
    size = parse(sizes[i])
    labels.append(label)
    values.append(size)
    total += size

plt.figure(figsize=(12.0, 9.0))
plt.pie(values, labels=labels,
        autopct='%1.1f%%', shadow=True, startangle=0)
# Set aspect ratio to be equal so that pie is drawn as a circle.
plt.axis('equal')

plt.suptitle("Virtual size per image", fontsize=24)
plt.subplots_adjust(left=0.25, right=0.75, top=0.85)
plt.title("Total virtual size: " + format(total), fontsize=14)

plt.savefig(output)
