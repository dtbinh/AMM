function [E,freq,amp]=T_freqId(tmp_vr,fs)
if size(tmp_vr,3)==3
    tmp_vr = U_r2g(tmp_vr);
end
tmp_vr = squeeze(im2single(tmp_vr));
tmp_vr2= bsxfun(@minus,tmp_vr,mean(tmp_vr,3));
tmp_vr3=fft(tmp_vr2,[],3);

num_f = size(tmp_vr,3);
nq_f = floor(num_f/2);
amp =  abs(tmp_vr3(:,:,1:nq_f));
[E,freq]= max(amp,[],3); 
freq = freq/num_f*fs;

%{
figure(1),V_feat(cat(3,E,freq))
figure(2),plot((1:nq_f)/num_f*fs,mean(reshape(amp,[],nq_f),1))
keyboard
%}
