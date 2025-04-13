function [out] = get_system_response(input, Ts)

N = length(input);
stop_time = Ts*(N - 1);
t = 0:Ts:stop_time;

in = Simulink.SimulationInput("model");


simin = struct();
simin.time = t;
simin.signals.values = input;

in = in.setVariable('simin', simin);
in = in.setVariable('rnd_var', 0.01);

set_param('model', 'StopTime', string(stop_time));

result = sim(in);

out = result.simout;


end

