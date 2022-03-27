%Automatic Cough Segmentation from Non-Contact Sound
% % Recordings in Pediatric Wards
clc
close all
clear all
D = 'D:\Samples';
S = dir(fullfile(D,'*.wav'));
signal=[];
P=zeros(length(S),1);
for k = 1:numel(S)
     F= fullfile(D,S(k).name);
    [signal,fs] = audioread(F);
    info=audioinfo(F);
    P(k)=info.Duration;
    T=length(signal)./fs;
    %     figure
    %     plot(signal)
    %     xlabel('No of samples')
    %     ylabel('Pitch')
    %     title('sample')
%Noise reduction through filters    
%HPF
    fc=10;
    [b,a] = butter(4,fc/(fs/2),'high'); %Butterworth FOHPF 
    %   freqz(b,a)
    filteredSignal = filter(b, a, signal);
    %     figure
    %     plot(filteredSignal)
    
%HPF+PSS
    IS = 0.3; %replace with your value
    FS=fs;
    S=filteredSignal;
    OUTPUT = SSBoll79(S, FS, IS);
    s=OUTPUT;
    %    figure
    %    plot(OUTPUT);
 
%Generating Data sub blocks        
%framing
frame_step = 0.020;% The time for each frame
N = 882; %number of samples in one frame
Number_of_frames_without_overlapping = round(P(k).*fs/N);% recording time= 16sec  
for K = 1 : size(s,2)
    y{K} = buffer(s(:,K),N,100); %number of sample(N=882), 100 is the overlapping samples
end
%     figure
% plot(y{K})
% title('Framing is done');
% xlabel('Samples');
% ylabel('Amplitude');

%windowing (Hamming)
 x = y{K};
 h=0.54 - 0.46*cos(2.0*pi*(1:N)'/(N+1));%Hamming window
%  y=x.*h;
 v= diag(h)*x;
% figure
% plot(v)
% title('Hamming Window');
% xlabel('Samples');
% ylabel('Amplitude');  

%Feature extraction
%MFCC
 [coeffs] = mfcc(v,fs,'WindowLength',882,'OverlapLength',100); 
 

end