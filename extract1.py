import pandas as pd

csv_file = 'sampled_dataset.csv'
data = pd.read_csv(csv_file)

row = data.iloc[2502]
pixels = row[:-1]
label = row[-1]

hex_pixels = [format(int(pixel), '02X') for pixel in pixels]

hex_label = format(int(label), '02X')
hex_pixels.append(hex_label)

with open('test_image2.hex', 'w') as hex_file:
    for hex_value in hex_pixels:
        hex_file.write(hex_value + '\n')

print("Hex file created with pixel values and label.")
