CxDereverb: Room Model Measurement and Removal Toolkit
CxDereverb is a Matlab software developed for removing reverberation. Reverberation can cause unwanted listening experiences and is a barrier to speech recognition. Therefore, inverse filters have been proposed to cancel room impulse responses. The original audio convolved with an inverse filter creates several extremely large peaks in the audio signals. The largest peaks in the treated audio cause extremely small headroom. To avoid clipping, normalization reduces the average volume of audio pieces and makes it difficult to mask the ambient noise. In this paper, a method for enlarging the headroom in treated audio is discussed. The proposed method is compared with state-of-the-art algorithms, and exhibits competitive performance in the frequency and time domains. In a practical scenario, the direct reverberation ratio is increased by approximately 3.6 dB, and the spectral deviation decreases by more than 53%. The proposed method is developed considering audio quality but can be applied to smart speakers for preprocessing in speech recognition.

Requirements:
The current GUI version of CxDereverb is only supported for Windows operating systems.
The source code can be run on any operating system installed Matlab.

Installation:
The GUI can be launched by running “welcomePage.m” in CxDereverb_basic floder. The initial screen prompts users to select a stereo audio file. A demo audio file named “Default.wav” is included with the toolkit. After selecting the audio file, users are required to input the sampling frequency and specify the frequency range of their loudspeakers. They must also set the ridge parameter based on the ambient noise level. Upon pressing “Next,” the room impulse response and inverse filter are computed and saved as “ir.mat” and “inv.mat”, respectively. The final screen displays the result of the dereverberation process.

The “MyAppInstaller_web.exe” file in the Cx_Dereverb_exe folder is intended for users who do not have MATLAB installed.

Supported file formats
WAV: The only input file the user needs to provide is a stereo audio recording for room impulse response measurement. 

