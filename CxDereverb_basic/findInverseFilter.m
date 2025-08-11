
raw_IRs = ir;
shelf_freq = 6000;

% Normalize impulse responses (each channel separately)
 segment = 0;
 index_range = 1;
 normalization_factor(segment+1) = max(max(abs(raw_IRs(:, index_range))));
 raw_IRs(:, index_range) = raw_IRs(:, index_range) ./ normalization_factor(segment+1);

% Apply window and truncate IRs to a specified length
window_func = blackmanharris(filterL);
window_func(1:filterL/2) = 1;

processed_IRs = zeros(filterL, 1);

processed_IRs(:, 1) = raw_IRs(1:filterL, 1) .* window_func;

freq_vector = (0:filterL-1) / filterL * fs;

normalized_IRs = processed_IRs(:, 1);
normalization_factor(end+1) = max(abs(normalized_IRs(:)));
normalized_IRs = normalized_IRs ./ normalization_factor(end);

% Frequency domain representation
frequency_IRs = fft(normalized_IRs, [], 1);

% Compute average frequency response across selected IRs
avg_response = sum(frequency_IRs, 2) / size(frequency_IRs, 2);

%% Create Bandpass Filter using FIR Windowing
stopband_attenuation = 60;
kaiser_beta = 0.1102 * (stopband_attenuation - 8.7);
kaiser_window = kaiser(filterL + 1, kaiser_beta);
bandpass_coeffs = fir1(filterL, [freq_low, freq_high] / (fs/2), kaiser_window);
bandpass_coeffs = bandpass_coeffs(2:end);
bandpass_fft = fft(bandpass_coeffs).';

%% Construct High-Shelf Filter for Regularization
shelf_freqs = [0 2000 shelf_freq fs/2] / (fs/2);
shelf_gains_db = [-20 -20 0 0];
shelf_gains_linear = 10.^(shelf_gains_db / 20);
highshelf_coeffs = fir2(50, shelf_freqs, shelf_gains_linear);
highshelf_coeffs = [highshelf_coeffs'; zeros(filterL - length(highshelf_coeffs), 1)];
highshelf_fft = fft(highshelf_coeffs);

% Inverse filter computation with regularization
inv_filter_fft = bandpass_fft .* conj(avg_response) ./ ...
                (avg_response .* conj(avg_response) + regularization_strength * highshelf_fft .* conj(highshelf_fft));

inv_filter_time = ifft(inv_filter_fft);

% Convolve original IRs with inverse filter
corrected_output = conv(raw_IRs, inv_filter_time);

save('ir.mat', 'raw_IRs');
save('inv.mat','inv_filter_time');
