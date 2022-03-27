clc;
clear all;
close all;
path='C:\Users\mkpvi\Desktop\vit\set\Matlab\Cough dataset'; %path to the cough samples
obj=dir(path);
sr=8000;
n=256; 
obj=orderfields(obj);
for x = 3:numel(obj)
    filename=fullfile(path,obj(x).name);
    [signal,fs]=audioread(filename);
    audioIn=sampleconv(signal,fs,sr); 
    for k = 1 : size(audioIn,2)
        frames{k} = buffer(audioIn(:,k),n,128); 
    end
     window=blackman(n,"periodic"); 
     windowed_frames=frames{k}.*window;
     fftx=fft(windowed_frames);
     fftx=abs(fftx);
     
     
     
     
     [felpc,variance]=lpc(windowed_frames,8); 
     feature{1,x-2} = felpc.';
     feature{2,x-2} = spectralCentroid(audioIn,fs, ...
                            'Window',blackman(round(0.032*fs)), ...
                            'OverlapLength',round(0.016*fs));
     feature{3,x-2} = spectralFlatness(audioIn,fs, ...
                              'Window',blackman(round(0.032*fs)), ...
                              'OverlapLength',round(0.016*fs));
                        
     feature{4,x-2} = mfcc(fftx,sr,"LogEnergy","Ignore");                     
     feature{5,x-2} = formant_frequency(felpc,sr);
     feature{6,x-2} = sum(abs(diff(windowed_frames>0)))/length(windowed_frames);
     feature{7,x-2} = wentropy(windowed_frames,'shannon');
     feature{8,x-2} = gtcc(fftx,sr,"LogEnergy","Ignore");
     
     clear root_array angz bw formants
     
end

