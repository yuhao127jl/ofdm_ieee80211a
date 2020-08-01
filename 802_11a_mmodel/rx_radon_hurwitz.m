function decoupled_syms = rx_radon_hurwitz(rh_syms, channel_est)

n_syms = size(rh_syms,2);

% remove the possible extra symbol
if rem(n_syms,2) ~= 0
   rh_syms(:,n_syms) = [];
   n_syms = n_syms - 1;
end

decoupled_syms = zeros(size(rh_syms));

decoupled_syms(:,1:2:n_syms) = repmat(conj(channel_est(:,1)),1, n_syms/2).*rh_syms(:,1:2:n_syms) + ...
   repmat(channel_est(:,2),1,n_syms/2).*conj(rh_syms(:,2:2:n_syms));

decoupled_syms(:,2:2:n_syms) = repmat(conj(channel_est(:,2)),1, n_syms/2).*rh_syms(:,1:2:n_syms) - ...
   repmat(channel_est(:,1),1,n_syms/2).*conj(rh_syms(:,2:2:n_syms));

