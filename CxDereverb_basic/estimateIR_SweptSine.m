% The funciton is modified from part of Matlab built-in funciton https://de.mathworks.com/help/audio/ref/impzest.html
% Farina, Angelo. "Advancements in Impulse Response Measurements by Sine Sweeps." Presented at the Audio Engineering Society 122nd Convention, Vienna, Austria, 2007.

function ir = estimateIR_SweptSine(excitation, rec, endSilenceLen)
%% Estimate impulse response for Swept Sine excitation
% Find minimum FFT length, and increase it if it has any large prime
% factors.
irMeasures = mean3cg(rec);
L = 2*size(irMeasures,1);
while max(factor(L)) > 7
    L = L + 1;
end
assert(L <= 4*size(irMeasures,1)); % codegen: worst case is next power of 2

% Inverse filtering and compensation for lower HF energy of ESS
% 
% We need to apply the inverse power of the exponential-sweep.
% If we use only the theoretical gain, the result is not as
% good as it could be, because the sweep can never be a perfect
% exponential-sweep. However, if we blindly apply the inverse
% power of the actual sweep, we end up with an erroneously high
% gain outside the sweep range, which will amplify any noise
% present in the recording. The approach being used here is a
% compromise to get the best results possible in the sweep
% range, without adding too much gain outside the sweep range.
% 
% Create the "epsilon" (ec) required for the Kirkeby algorithm
% as described in an AES paper by A. Farina, "Advancements in
% impulse response measurements by sine sweeps". First step is
% to produce a flat version of the sweep's spectrum and use it
% to construct the gain limit (ec). Use movmean filtering to
% reduce the bandwidth of the correction. As described in the
% paper, set a low value in the sweep range and higher value
% outside. These constants were tuned to get a good trade-off
% between perfect numerics in the noiseless case and clean
% results with noisy measurements.
Fo = fft(excitation, L);
L1 = L+rem(L,2);
t = (0:L1/2)';
Xflat = abs(Fo(t+1)).*sqrt(t);
Xflat = min(movmean(Xflat,[1000,10]),movmean(Xflat,[10,1000]));
mflat = max(Xflat,[],'all');
ec = max(1e-4*mflat, .38*mflat-Xflat);

% Make the frequency-domain compensation filter using the "ec"
% factor to limit gain. This is part of the Kirkeby algorithm.
C = coder.nullcopy(Fo);
C(t+1) = conj(Fo(t+1))./(conj(Fo(t+1)).*Fo(t+1) + ec);
C(end:-1:L-L1/2+2) = conj(C(2:L1/2));

% Apply the inverse filter C to the recordings
h = ifftshift(ifft(bsxfun(@times,fft(irMeasures,L),C)),1);

% Return useful part of impulse response (with IR gain applied)
ir = h(L1/2+1:L1/2+endSilenceLen,:);

function mx = mean3cg(x)
%% Compute mean(x,3) with codegen compatibility
if isempty(coder.target)
    mx = mean(x,3);
else % codegen:
    mx = x(:,:,1);
    N = size(x,3);
    if N > 1
        for ii = 2:N
            mx = mx + x(:,:,ii);
        end
        mx = mx/N;
    end

end
