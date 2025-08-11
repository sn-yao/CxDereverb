function reverbTime = estimateT60(ir, fs)
% estimateT60 estimates the reverberation time (T60) of an impulse response.
% Inputs:
%   ir - Impulse response vector
%   fs - Sampling rate in Hz
% Outputs:
%   reverbTime - Estimated T60 time in milliseconds
%   decayCurve - Integrated decay curve

% Ensure row vector
if size(ir, 2) == 1
    ir = ir.';
end

% Analysis window start (after 50 ms)
startIdx = round(fs * 0.05);

% Limit analysis to 1.5 seconds max
if length(ir) / fs < 1.5
    endIdx = length(ir);
    warning('Impulse response is shorter than 1.5 seconds.');
else
    endIdx = round(fs * 1.5);
end

% Compute integrated squared energy (backwards integration)
decayCurve = cumsum(ir(end:-1:1).^2);
decayCurve = decayCurve(end:-1:1); % Flip back

% Normalize decay and convert to dB
decaySegment = decayCurve(1:endIdx);
decay_dB = 10 * log10(decaySegment / max(abs(decaySegment)));

% Time axis in milliseconds
time_ms = linspace(1, (endIdx / fs) * 1000, endIdx);

% Prepare data for linear regression
x = time_ms;
y = decay_dB;
N = 1:length(x);
sum_xy = cumsum(x .* y);
sum_x = cumsum(x);
sum_y = cumsum(y);

num = (sum_xy - (sum_x .* sum_y) ./ N).^2;
den_x = cumsum(x.^2) - (sum_x.^2) ./ N;
total_ss = cumsum(y.^2) - (sum_y.^2) ./ N;

regressionSS = num(startIdx:endIdx) ./ den_x(startIdx:endIdx);
rsq = regressionSS ./ total_ss(startIdx:endIdx);

% Find optimal regression segment
[~, peakIdx] = max(rsq);
fitEnd = startIdx + peakIdx - 1;

% Perform final linear regression on optimal segment
xFit = x(1:fitEnd);
yFit = y(1:fitEnd);

mean_x = mean(xFit); mean_y = mean(yFit);
slope = (mean(xFit .* yFit) - mean_x * mean_y) / ...
        (mean(xFit.^2) - mean_x^2);
intercept = mean_y - slope * mean_x;

% Estimate T60 time
reverbTime = round(abs(60 / slope) - intercept);

% Adjust decay curve for plotting
targetLength = reverbTime * fs / 1000;
t = linspace(1, reverbTime, targetLength);
if length(y) < length(t)
    y = [y, nan(1, length(t) - length(y))];
else
    y = y(1:length(t));
end

end

