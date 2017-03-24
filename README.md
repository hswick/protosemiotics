#Protosemiotics

Experiments with semi-async logic gates and genetic algorithms

Logic gates are fired throughout the network via a fifo stack for each timestep
This makes it concurrent, but not completely asynchronous

Test network class out by running: `ruby proto.rb`
Test genetic algo by running `ruby breed_networks.rb`

Turning up population count makes this an absolute memory hog
For population count of 200 needs 30 gb of memory to be safe