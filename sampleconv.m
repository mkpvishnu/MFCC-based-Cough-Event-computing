function [y] = sampleconv(signal,fs,sr)
    [P,Q]=rat(sr/fs);
    y=resample(signal,P,Q);
end

