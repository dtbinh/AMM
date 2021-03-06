fprintf('testing light source\n')


%{
DD= 'data/data_1113/';
fns =dir(DD);fns(1:2)=[];
f0 = 500;
for fid=1:numel(fns)
    fn = fns(fid).name;
    DD_f = [DD fn];
    T_1113
end
% 07_21 (right hand side)
DD_f = '../0916/data/struct_0721/100Hz_1000fps_ex_990us_l.avi';fs=100;
num_f = 200;f0=1000;ran={190:220,900:930};fid=1;fn='test 0721';
f0=1000;T_1113;

% 10_10 (left hand side)
DD_f = 'data/data_1010/100_500_s';fs=100;f0=500;
num_f = 100;f0=500;ran={190:220,120:150};fid=1;fn='test 1010';
T_1113;

% 11_11
DD_f = 'data/data_1111/50Hz_500fps_a1_s';fs=100;f0=500;
%DD_f = 'data/data_1111/0Hz_500fps';fs=100;f0=500;
num_f = 600;ran={205:230,130:160};fid=1;fn='test 1111';
num_f = 2000;ran={55:80,130:160};fid=1;fn='test 1111';
T_1113;

% 11_14
DD_f = 'data/data_1114/100Hz_500fps_a1_t';fs=100;f0=500;
%DD_f = 'data/data_1114/0Hz_500fps';fs=100;f0=500;
fid=1;fn='test 1111';
num_f = 600;
num_f = 2000;
%ran={55:80,130:160};
ran={205:230,130:160};
T_1113;
%}

if strcmp(DD_f(end-2:end),'avi')
    vid0 = VideoReader(DD_f);
    vid = squeeze(vid0.read([1,num_f]));
    vid = im2single(vid);
    sz = size(vid);
    tmp_im = vid(:,:,1);
else
    ims = dir([DD_f '/*.tif']);
    %num_f = numel(ims);
    %ran= {1:sz(1),1:sz(2)};
    tmp_im = imread(fullfile(DD_f,ims(1).name));
    sz = size(tmp_im);
    
    vid = zeros([sz(1:2) num_f]);
    fprintf('1.load data\n');
    parfor i =1:num_f
        tmp = im2single(imread(fullfile(DD_f, ims(i).name)));
        vid(:,:,i) = tmp(:,:,1);
    end
end
%%
fprintf('2.app avg\n');
figure(fid)
vid = vid(ran{1},ran{2},:);
filt_w = 5;
filt_freq = [60 120 240 20 100 140];

tmp_vid= repmat(reshape(vid,[numel(ran{1}) numel(ran{2}) 1 num_f]),[1,1,3,1]);
for filt = setdiff(filt_freq,fs)
    tmp_vid = U_remove120(tmp_vid,filt-filt_w,filt+filt_w,f0);
end
vid1 = squeeze(tmp_vid(:,:,1,:));

%figure(1),clf,imagesc(vid1(:,:,1))
%figure(1),clf,imagesc(tmp_im(:,:,1))

signal = mean(reshape(vid,[],num_f));
signal2 = mean(reshape(vid1,[],num_f));
figure(2)
subplot(221),plot(signal)
subplot(222),tmp=U_fft(signal,f0);[~,a]=max(tmp);
subplot(223),plot(signal2)
subplot(224),tmp=U_fft(signal2,f0);[~,a]=max(tmp);
title(sprintf([fn ': peak @ %.1f'],a/num_f*f0));
