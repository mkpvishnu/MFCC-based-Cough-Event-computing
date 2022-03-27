function y1 = snfft(y,sr)
L=length(y);
f=linspace(0,sr/2,L/2)
    y1=(fft(y)/160);
    y1=y1(1:L/2); 
    figure
    plot(f,y1)
end

%linspae command divides the starting balue 0 and ending value sr/2 into
%l/2 divisions.according the nyquist criteria the maximum frequncy the
%signal can  contain is half the sampling rate. so sr/2.
%y is the actual spectrum and y1 is single sided or one sided spectrum
%because after the middle value L/2 the spectrum mirror itself.
%The fft is divided by 160 because the highest value among the ten samples
%which i took was found to 162.
% so to normalize or bring everything to a maximum of 1, i divided it with
% 160.