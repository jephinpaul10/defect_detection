## Hardware Implementation of Neural Networks for Concrete Crack Detection

This repository contains a hardware implementation of a defect detection system using Verilog HDL. 
The design includes neural network components and image preprocessing logic suitable for FPGA and digital design simulation.

## Key Features

- Hardware-implemented 2-layer fully connected neural network
- 8-bit fixed-point weight representation
- Pretrained in TensorFlow, deployed in Verilog
- Image preprocessing using threshold-based binarization
- Fully synthesizable FPGA-friendly design
- Simulation-ready testbench with waveform validation

## Dataset and Pre-processing

Dataset link: https://www.kaggle.com/datasets/arunrk7/surface-crack-detection

The collected dataset contains 5,000 images of concrete surfaces in which 2,500 are positive (with cracks) and 2,500 are negative (without cracks) with 227x227 pixels. 
The images were compressed to 64x64 pixels and was converted into array format of pixel intensities and then stored as .hex file.
The python script used to convert the images into csv and label them, and then convert them to hex format is also provided in the repo.

## Technical Specifications

| Component | Details |
|-----------|----------|
| Input Size | 64x64 (4096 pixels) |
| Network Type | Fully Connected (2 layers) |
| Activation | ReLU (hidden), Sigmoid (output) |
| Data Format | 8-bit Fixed Point |
| Training Framework | TensorFlow |
| Deployment | Verilog HDL |
| Output | 1 (Crack) / 0 (No Crack) |

## System Architecture
<img width="6127" height="123" alt="image" src="https://github.com/user-attachments/assets/894d4bba-2bd3-4ea3-8200-5ec76d8011a9" />

The images are preprocessed using a threshold filter which classifies pixels as either 1 or 0 based on their intensity and a previously set threshold. This makes it easier for the neural network to detect edges in the image and make better predictions. This can be easily achieved using comparators.
As it is not feasible to execute backpropagation efficiently in hardware implementations, pretrained weights are used. This eliminates the need for dynamic memory and repeated iterations which are not efficient on hardware. The training is done using TensorFlow and the weights are exported to the Verilog implementation.
For the neural network, a fully connected architecture of 2 layers is used. The model weights and activations are fixed point representation based on 8-bit integers. Modules are created for each layer, which uses ReLU activation function using conditional statements. The output layer has a sigmoid activation gives a binary inference.

A top level module is used to ensure smooth transition between different stages in the execution. It takes in the image data, preprocesses it, feed it into the network and give the final output as 1 or 0 for ‘Crack detected’ or ‘No crack detected’ respectively.

## How to run this code?
 1. Clone the repository
 2. Open the project in your simulator (Vivado / ModelSim)
 3. Set top_level.v as the top module.
 4. Run top_level_tb.v testbench.
 5. Observe inference_output in the waveform viewer.

## Training Results (TensorFlow)

Training Accuracy: 91.57%
Validation Accuracy: 88.9%
Test Accuracy: 85.5%
    
## Simulation Screenshots
Inputs images (input as hex files)
<img width="6043" height="105" alt="image" src="https://github.com/user-attachments/assets/af47411c-1962-417c-aff5-61845a098701" />
<img width="355" height="355" alt="image" src="https://github.com/user-attachments/assets/d130a1ef-6fe5-4e01-9557-ffbc2bd54768" />

Ouput Waveform
<img width="1674" height="797" alt="image" src="https://github.com/user-attachments/assets/87b418ef-6cd4-4378-9d5e-baa261cd14d0" />

## Limitations

- Only inference is implemented in hardware (training done in TensorFlow).
- Fully connected network limits scalability for larger images.
- No hardware optimization techniques (pipelining, parallel MAC arrays) applied yet.

## Future Improvements

- Implement CNN architecture in hardware
- Add pipelined MAC units for higher throughput
- Optimize fixed-point precision for better accuracy
