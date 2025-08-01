# Drone-Audio-detection
## Drone Sound Detection Using MFCC and SVM

This project detects the presence of drone sounds using a machine learning pipeline that combines MFCC feature extraction with SVM classification. It also includes spectrogram and pitch analysis for enhanced audio understanding.

---

## Training Phase
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

## Recording and Preprocessing
- Audio is recorded using [`audio_record.m`](./audio_record.m).
- The recorded file is denoised using [`wavelet_denoising.m`](./wavelet_denoising.m)./ [`wiener.m`](./wiener.m)
- Output:
  - `recorded.wav`: Cleaned audio signal for prediction.

---

## Prediction Phase
- The denoised audio (`recorded.wav`) is passed to [`predictSVMFromAudio.m`](./predictSVMFromAudio.m).
- It loads the trained SVM model and classifies the input.
- Final Output:
  - `The prediction: DRONE` or `NOT DRONE` (displayed in the MATLAB console).

---

## Feature Extraction (Spectrogram and Pitch)

- The script [`STFT.m`](./STFT.m) is used to compute spectrograms of the training audio samples.
  - Spectrogram images are saved into:
    - `spectrogram_images_0` → from `Train_label_0` (NOT DRONE)
    - `spectrogram_images_1` → from `Train_label_1` (DRONE)

- Spectrograms can be used for further visual inspection or to train a CNN-based classifier.

---

## Analysis: Pitch Statistics

- The script [`analyzePitchStatistics.m`](./analyzePitchStatistics.m) analyzes the **fundamental frequency (pitch)** of training audio data.
- It provides insights into how drone and non-drone audio differ in pitch characteristics.
- Outputs:
  - `pitch_statistics.png`: Visualization of pitch distributions.
  - `pitch_statistics.mat`: Numerical pitch data (mean, variance, etc.).

---

## Requirements
- MATLAB (R2020 or later recommended)
- Signal Processing Toolbox
- Wavelet Toolbox
- Microphone for recording input audio

---

## How to Run

```matlab
% Step 1: Train the model
extractMFCCandTrainSVM

% Step 2: Record audio
audio_record

% Step 3: Denoise the audio
wavelet_denoising

% Step 4: Predict using trained SVM
predictSVMFromAudio

% Optional: Generate spectrograms
STFT

% Optional: Analyze pitch statistics
analyzePitchStatistics
