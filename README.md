
# ANN-Based Characterization of Wrinkling Instabilities in Soft Active Materials

This repository contains an Artificial Neural Network (ANN) based model to predict breakdown voltage in 3M VHB dielectric elastomers under different stretch ratios and membrane thickness conditions. The model captures nonlinear electromechanical behavior and provides fast predictions compared to FEM or experimental testing.

## Overview

Soft dielectric elastomers experience wrinkling and electrical breakdown when stretched and subjected to high voltage. This project uses an ANN to predict:

* Breakdown Voltage (V)
* Effect of stretch ratios (λ1, λ2)
* Influence of membrane thickness (t)

The trained model can generate 2D and 3D maps and helps in soft actuator and material design.

## Key Features

* ANN based regression model
* Fast and accurate breakdown voltage prediction
* Physics-informed feature engineering
* MATLAB implementation
* Visualization tools (2D, 3D, contour plots)
* High accuracy (R2 ≈ 0.98)

## Input Features

Input to ANN:

* λ1 (Stretch ratio in X-direction)
* λ2 (Stretch ratio in Y-direction)
* t (Membrane thickness)
* λ2 / λ1 (Aspect ratio)
* λ1 × t (Effective stretched thickness)

Output:

* Breakdown Voltage (V)

## Repository Structure

ANN-Wrinkling-Characterization
│ README.md
│ vhb_breakdown_ann_simple.m
│ vhb_breakdown_predict.m
│ vhb_ann_simple.mat
│ VHB_breakdown_dataset.xlsx
└── plots/

## Methodology

ANN Architecture:

* Feedforward neural network
* Hidden Layer 1: 64 neurons (ReLU)
* Hidden Layer 2: 32 neurons (ReLU)
* Output layer: 1 neuron
* Optimizer: Adam
* Epochs: 100
* Train/Test Split: 70/30

Evaluation Metrics:

* RMSE
* MAE
* R2 Score

## How to Run

1. Train the Model
   Run the script:
   run("vhb_breakdown_ann_simple.m")

This generates:

* Trained ANN
* Performance metrics
* Saved model (vhb_ann_simple.mat)

2. Predict Breakdown Voltage
   Run:
   run("vhb_breakdown_predict.m")

Enter values for λ1, λ2, and thickness.
The script returns predicted Breakdown Voltage (V).

## Results Summary

* Breakdown voltage increases with membrane thickness
* Breakdown voltage decreases with increasing stretch
* ANN predictions closely match experimental data
* Includes 2D line plots, contour plots, 3D voltage surfaces, and predicted vs true comparison

## Experimental Setup Overview

* 3M VHB elastomer film
* PLA/PET stretching frame
* Pre-stretching for 24 hours
* Carbon grease and copper electrodes
* High-voltage DC power supply
* Breakdown observed through wrinkling and failure

## Applications

* Soft robotics
* Artificial muscles
* Wearable and stretchable electronics
* Adaptive optical devices
* High-strain dielectric actuators

## References

1. Aman Khurana et al., Electromechanical stability of wrinkled dielectric elastomers
2. Srivastava and Basu, Mechanics of reversible wrinkling
3. Gangwar et al., Wrinkling stability in soft dielectric elastomers
4. Khurana et al., Energy-based model of dielectric elastomers
5. Godaba et al., Instabilities in dielectric elastomers
6. Gour et al., Graded dielectric elastomers

## Authors

Khushi Kumari (220003046)
Raja (220005041)
B.Tech Mechanical Engineering
Indian Institute of Technology Indore

Supervisor: Dr. Aman Khurana

