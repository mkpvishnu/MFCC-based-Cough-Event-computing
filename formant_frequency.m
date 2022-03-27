function formants = formant_frequency(feature_lpc,fs)     % fs=sampling frequency

feature_lpc(isnan(feature_lpc))=0;
    feature_lpc(isinf(feature_lpc))=0;  
    for i = 1:8
        if i == 1
           root_array(:,i)=roots(feature_lpc(:,i));
        end
        a = roots(feature_lpc(:,i));
         if i>=2
            if size(root_array(:,i-1),1)<size(a,1)
                for j = 1 : i-1
                   for d= 1 : size(a,1)-size(root_array(:,i-1),1)
                       root_array((size(root_array(:,i-1),1))+1,j) = 0;
                   end
                   clear d
                end
            end
                    
        if size(a,1) < size(root_array(:,(i-1)),1)
           for r = 1 : (size(root_array(:,(i-1)),1)-size(a(:,1),1))
              a((size(a(:,1),1))+1,1)=0;
           end       
        end     
         end
     root_array(:,i)=a;
       clear a 
   end
root_array = root_array(imag(root_array)>=0);
angz = atan2(imag(root_array),real(root_array));
[frqs,indices] = sort(angz.*(fs/(2*pi)));
bw = -1/2*(fs/(2*pi))*log(abs(root_array(indices)));
nn = 1;
for kk = 1:length(frqs)
    if (frqs(kk) > 90 && bw(kk) <400)
        formants(nn) = frqs(kk);
        nn = nn+1;
    end
end