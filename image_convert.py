import os
import random
import numpy as np
import pandas as pd
from PIL import Image

positive_folder = 'extracted_images/Positive'
negative_folder = 'extracted_images/Negative'

sample_size = 2500

def image_to_array(image_path):
    image = Image.open(image_path).convert('L') 
    image = image.resize((64, 64))
    return np.array(image).flatten()

positive_images = random.sample(os.listdir(positive_folder), sample_size)
negative_images = random.sample(os.listdir(negative_folder), sample_size)

data = []
labels = []

for image_name in positive_images:
    image_path = os.path.join(positive_folder, image_name)
    data.append(image_to_array(image_path))
    labels.append(1)

for image_name in negative_images:
    image_path = os.path.join(negative_folder, image_name)
    data.append(image_to_array(image_path))
    labels.append(0)

df = pd.DataFrame(data)
df['label'] = labels

df.to_csv('sampled_dataset.csv', index=False)

print("CSV file created with 5,000 labeled images.")
