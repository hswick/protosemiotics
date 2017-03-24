#Protosemiotics

Experiments with semi-async logic gates and genetic algorithms

Logic gates are fired throughout the network via a fifo stack for each timestep
This makes it concurrent, but not completely asynchronous

Test network class out by running: `ruby proto.rb`
Test genetic algo by running `ruby breed_networks.rb`