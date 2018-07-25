% AMP - Non-linear power amplifier
%
%       usage:[out,inPow,outPow,P3,P_I]=tx_power_amplifier(in,one_dB,G,R,s,N);
%             [out,inPow,outPow]=tx_power_amplifier(in,1,1,R,s,N,T);
%       
% in:     Input data stream
% one_dB: Output power at 1 db compression point for amplifier (dBW)
% G:      Linear Gain of the amplifier (dB)
% R:      Source Impedance
% s:      Knee sharpness of limiter
% N:      Number of samples in one period for power estimation
%
% out:    Output data stream
% inPow:  Estimate of input power. (dB)
% outPow: Estimate of output power (dB)
% P3:     Estimate of third order intermod products power (dB)
% PI:     Estimate of third order intercept power (dB)
function [out,inPow,outPow,P3,P_I]=amp(in,one_dB,G,R,s,N,T);
%
%  REFERENCES:
%
%  TARGET: 
%
%  REVISION HISTORY:
%    DATE       AUTHOR                  DESCRIPTION                       STR
%  02-28-97  John D Terry              Original Code
%
%*******************************************************************************
[r,q]=size(in);

if r>q
  in=in.';
  L=r;
else
  L=q;
end

if ~(r == 1 | q == 1)
  error('input must be a vector');
end
%
% Compute square of each sample
%
square=in.*conj(in);
%
% Group data into integral number of periods for power estimation
%
integral=reshape(square(1:N*floor(L/N)),N,floor(L/N));
%
% Compute power estimates
%
P_est=mean(integral');
%
% Compute average Input Power
%
P_avg=10*log10(mean(P_est'))-10*log10(R);
inPow=P_avg;
if nargin==6
   %
   % Linear Gain and correction for limiting amplifier's gain
   %
   G=G+20*log10(.7);
   k1=10^(G/20);
   %
   % Compute coefficient of cubic power needed to meet third order intercept point
   %
   k3=10^((30*log10(k1)-10*log10(17.33)-one_dB-10*log10(R))/10);
   %
   % Compute AM/AM modulation distortion for linear region
   %
   third_order=in*k1-k3*in.^3+1e-38;
   %
   % Compute AM/AM modulation distortion for linear region
   % 
   if inPow+G > one_dB + 2
     g1=10^((G-1)/20);
     third_order=g1*in+1e-38;
   end
   %
   % Third order intercept power dBW
   %
   P_I=10*log10(2/3*k1^3/k3/R);
   %
   % Third order intermod product power dBW
   %
   P3=3*P_avg-2*P_I;
   %
   % Asymptotic output level of limiter
   %
   LL=10^((one_dB+1)/20)*sqrt(R);
   %
   % Limiter Output
   %
   out=LL*sign(third_order)./(1+(.7*LL./abs(third_order)).^s).^inv(s);
elseif nargin==7
   %
   % Asymptotic output level of limiter
   %
   LL=10^((max(T(:,2))+4)/20)*sqrt(R);
   %
   % Spline Fit
   %
   T=((10*ones(size(T))).^(T/10)*R);
   PP=spline(T(:,1),(T(:,2)./T(:,1)));
   sqr=(conv(ones(1,N)/N,in.*conj(in)));
   out=(sqrt(ppval(PP,sqr(N/2:(N/2-1+length(in)))))).*(in+1e-15*max(in));
   %
   % Limiter Output
   %
   out=LL*sign(out)./(1+(LL./abs(out)).^s).^inv(s);
end
%
% Estimate Output Power
%
OP=out.*conj(out);
sum_out=reshape(OP(1:N*floor(L/N)),N,floor(L/N));
P_nat=mean(sum_out);
outPow=10*log10(mean(P_nat))-10*log10(R);
