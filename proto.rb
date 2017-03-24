#Genes
#Activation Path
#Cycle Path 1
#Cycle Path 2 (allows for cross connections) also redundant or surplus value of code
#Initial states (initial edge weights) dependent on cycle paths (also surplus value)
#Edge weight can be nil, 0, or 1
#Output_ids represented as binary numbers (or as digit with max length of nodes list)
#Limitation of this design is id_number is limited since no way to increase it (even with binary)
#Could increase the id_length

#gene = [activation_id, output_id, output_value]
#output_value gets converted to edge_weight upon initiation of network

#Order will matter upon initial reading of activations
#Side effect of this will be important init actions are at beginning of gene sequence
#Acceptable side effect

#Node may output to node that doesn't exist
#This surplus value is okay, allows for growth and future interesting things

require './network'
require './genetic_algorithm'
require './node'

@net = Network.new(10)

def output_event_queue
	print @net.event_queue.to_s + "\n"
end

@net2 = Network.new(10, 10)

#print @net.to_genes.to_s + "\n"
# print @net2.to_genes.to_s + "\n"

#print crossover_gene_matrices(@net.to_genes, @net2.to_genes).to_s

puts @net2.simulate