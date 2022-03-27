clc;
clear all;
close all;

path='C:\Users\mkpvi\Desktop\vit\set\Matlab\test'; 
obj=dir(path);

sr=8000; %sampling freq
n=256; 


    filename=fullfile(path,obj(3).name);
    [audioIn,fs]=audioread(filename);
    signal=sampleconv(audioIn,fs,sr);
    
    figure
    plot(signal)  
    title('speech signal');
    xlabel('Number of samples');
    ylabel('Pitch');
    
    
    
    audioIn = filter ([1 -.95], 1, signal);
    figure
    plot(audioIn)
    title('Filter');
    xlabel('Number of samples');
    ylabel('Pitch');
    
    
    for k = 1 : size(audioIn,2)
        frames{k} = buffer(audioIn(:,k),n,128); 
    end
    figure
    plot(frames{k})
    title('Framed Signal');
    xlabel('Samples');
    ylabel('Amplitude');
    
    
     window=0.42 - 0.5*cos(2.0*pi*(1:n)'/(n+1))+0.08*cos(4.0*pi*(1:n)'/(n+1)); %blackman
     windowed_frames=frames{k}.*window;
     
     figure
     plot(windowed_frames)
     title('BlackMann Window');
     xlabel('Samples');
      ylabel('Amplitude');
      
      
     fftx=fft(windowed_frames);
     fftx=abs(fftx);
     figure
     plot(fftx)
     title('Fourier transform of the signal');
  
     m = melfb(20, n, fs);
    figure;
    plot(linspace(0, (16000/2), 129), melfb(20, n, 8000)')
    title('Mel-spaced filterbank'), xlabel('Frequency (Hz)');
    n2 = 1 + floor(n / 2);
    z = m * abs(fftx(1:n2, :)).^2;
    Feature = dct(log(z));
    figure;
    plot(Feature)
     title('Extracted MFCC FEATURE COEFFICIENTS')
     
     
     [felpc,variance]=lpc(windowed_frames,8); 
     feature{1} = felpc;
     figure
     plot(feature{1})
     title('LPC Coefficients');
     feature{2} = spectralCentroid(audioIn,fs, ...
                            'Window',blackman(round(0.032*fs)), ...
                            'OverlapLength',round(0.016*fs));
     figure
     plot(feature{2})
     title('Spectral Centroid');
     
     
     feature{3} = spectralFlatness(audioIn,fs, ...
                              'Window',blackman(round(0.032*fs)), ...
                              'OverlapLength',round(0.016*fs));
     figure
     plot(feature{3})    
     title('Spectral Flatness');
     
     
%      feature{4,x-2} = mfcc(fftx,sr,"LogEnergy","Ignore"); 
     
     feature{5} = formant_frequency(felpc,sr);
     figure
     plot(feature{5})  
     title('Formant Frequencies');
%      
     feature{6} = sum(abs(diff(windowed_frames>0)))/length(windowed_frames);
     figure
     plot(feature{6})
     title('Zero Crossing Rate');