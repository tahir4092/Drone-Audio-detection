# Drone-Audio-detection
# Drone Sound Detection Using MFCC and SVM

##  Training Phase
- Labeled audio datasets:
  - `Train_label_0`: NOT DRONE
  - `Train_label_1`: DRONE
- The script [`extractMFCCandTrainSVM.m`](./extractMFCCandTrainSVM.m):
  - Extracts MFCC features.
  - Trains an SVM classifier.
- Outputs:
  - `mfcc_mfcc_features.mat`: Extracted MFCC features.
  - `svm_model_mfcc.mat`: Trained SVM model.

---
##  Recording and Preprocessing
- Audio is recorded using [`audio_record.m`](./audio_record.m).
- The recorded file is denoised using [`wavelet_denoising.m`](./wavelet_denoising.m).
- Output:
  - `recorded.wav`: Cleaned audio signal for prediction.

---
##  Prediction Phase
- The denoised audio (`recorded.wav`) is passed to [`predictSVMFromAudio.m`](./predictSVMFromAudio.m).
- It loads the trained SVM model and classifies the input.
- Final Output:
  - `The prediction: DRONE` or `NOT DRONE` displayed in the console.

---

## Requirements
- MATLAB (R2020 or later recommended)
- Signal Processing Toolbox
- Wavelet Toolbox
- Microphone for recording input audio

---

## 🚀 How to Run

```matlab
% Step 1: Train the model
extractMFCCandTrainSVM

% Step 2: Record audio
audio_record

% Step 3: Denoise the audio
wavelet_denoising

% Step 4: Predict using trained SVM
predictSVMFromAudio
