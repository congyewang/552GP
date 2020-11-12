% Kieran Molloy Submission for MMU Year 3: Digital Communications & Sound
% Processing Coursework Part 2

clear; clc; clf
% Read File
readFilename='cutsignal.wav';
[s,fs]=audioread(readFilename);

% Number of Samples
N=length(s);  
% Sampling Interval
T=1/fs;       
% Length of Signal
P=N*T;        
% T vector
t=0:T:P-T;  
% f0 Value
f0=1/P;

% Discrete Fourier Transform 
F=fft(s)/N; 

% Folding Logic
M=(N-1)/2;
foldedF=fold(F,M,N);
% Outline x-axis domain
freq=-M*f0:f0:M*f0;
% Remove Frequences higher than abs(alpha)hz 
alpha=5000;
Index=find(abs(freq) > alpha); 
indexedF=foldedF;
indexedF(Index)=0;


% Return to time domain but reorder F before taking its IDFT.
newF=unfold(indexedF,M,N);

% Inverse Discrete Fourier Transform 
sfilt=N*real(ifft(newF));

% Difference between original \& filtered
sdiff = s'-sfilt;

% Write to file
writeFilename = 'filteredSignal.wav';
audiowrite(writeFilename,sfilt,fs);

% //////////
% PLOTTING
% //////////

% Figure 1 - Spectral Analysis Comparisons
figure(1)
% Subplot 1 - Original Spectral Analysis
subplot(4,1,1),stem(abs(F),'.-');   % plot the absolute value against index number
title("Amplitude Spectrum of 'cutsignal.wav'",'interpreter','latex');
xlabel('index $n$','interpreter','latex');
ylabel('$\left|Fn\right|$','interpreter','latex');
% Subplot 2 -  Folded Aamplitude Spectrum
subplot(4,1,2),stem(freq,abs(foldedF),'.-');
title("Folded Amplitude Spectrum",'interpreter','latex');
xlabel('index $n$','interpreter','latex');
ylabel('$\left|Fn\right|$','interpreter','latex');
% Subplot 3 - Filtered + Folded Amplitude Spectrum
subplot(4,1,3),stem(freq,abs(indexedF),'.-');
title("Filtered Spectrum of Folded Signal",'interpreter','latex');
xlabel('index $n$','interpreter','latex');
ylabel('$\left|Fn\right|$','interpreter','latex');
% Subplot 4 - Filtered + UnFolded Amplitude Spectrum
subplot(4,1,4),stem(freq,abs(newF),'.-');
title("Unfolded Amplitude Spectrum of 'cutsignal.wav'",'interpreter','latex');
xlabel('index $n$','interpreter','latex');
ylabel('$\left|Fn\right|$','interpreter','latex');

% Figure 2 - Full Signal Comparison
figure(2)
% Subplot 1 - Original cutsignal.wav
subplot(3,1,1),plot(t,s,'b')
axis([0 1.65 -0.4 0.4])
title('Un-Filtered (Original) Signal','interpreter','latex')
xlabel('Time (s)','interpreter','latex')
ylabel('Ampltitude (khz)','interpreter','latex')

% Subplot 2 - Filtered cutsignal.wav
subplot(3,1,2),plot(t,sfilt,'r'); 
axis([0 1.65 -0.4 0.4])
title('Filtered Signal','interpreter','latex')
xlabel('Time (s)','interpreter','latex')
ylabel('Ampltitude (khz)','interpreter','latex')

% Subplot 3 - Filtered cutsignal.wav
subplot(3,1,3),plot(t,sdiff,'g'); 
axis([0 1.65 -0.4 0.4])
title('Residual Signal','interpreter','latex')
xlabel('Time (s)','interpreter','latex')
ylabel('Ampltitude (khz)','interpreter','latex')

% ////////////////////
% AUXILLARY FUNCTIONS
% ////////////////////

function y=fold(x,M,N)
    y=zeros(1,N);
    y(1:M)=x(M+2:N);
    y(M+1)=x(1);
    y(M+2:N)=x(2:M+1);
end

function y=unfold(x,M,N)
    y(1)=x(M+1);
    y(2:M+1)=x(M+2:N);
    y(M+2:N)=x(1:M);
end