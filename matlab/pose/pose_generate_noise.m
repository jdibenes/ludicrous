
function noise_all = pose_generate_noise(poses, f)
N = size(poses, 1);
noise_all = cell(N, 1);

for index = 1:N  
    n = size(poses{index}, 1);
    noise = zeros(n, 10);
    for k = 1:n, noise(k, :) = f(1, 10); end
    noise_all{index} = noise;
end
end
