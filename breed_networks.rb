require './network'
require './genetic_algorithm'
require 'Set'

def init_population(n)
	population = []
	for i in 0..n
		population << Network.new(10, 100)#exponential time increases
	end
	population
end

def test_fitness(network)
	[network.simulate, network.nodes.length]#Returns number of timesteps organism survived
	#network.edges.length
end

#Should pass in net index not net to save memory
#Would later have to reconstruct it from index
def test_population_fitness(population)
	population.map.with_index {|net, i| [test_fitness(net), i]}
end

#Optimization of population_mixture
def pop_mix_optimized(population)
	n = population.length
	n2 = n
	output = []
	for i in 0..n-1
		for j in i..n2-1
			if i != j
				result = crossover_gene_matrices(population[i].to_genes, population[j].to_genes)
				output << birth(result[0])
				output << birth(result[1])
			end
		end
		n2-=1
	end
	output
end

def birth(genes)
	if rand(100) >= 4#0.01 probability because 4 values of genes
		mutation!(genes[rand(genes.length)])
	end
	Network.new.from_genes(genes)
end

#Always breeds two offspring, byproduct of crossover
def breed(a, b)
	offspring = crossover_gene_matrices(a.to_genes, b.to_genes)
	[birth(offspring[0]), birth(offspring[1])]
end

def mean(nums)
	sum = 0.0
	nums.each do |n|
		sum += n
	end
	sum/nums.length
end

population_count = 200#exponential time increase

population = init_population(population_count)

puts "Initial population average fitness " + mean(test_population_fitness(population).map{|x|x[0][0]}).to_s

start = Time::now
for i in 0..20#linear time increase
	new_population = pop_mix_optimized(population)

	fitness_net_tuples = test_population_fitness(new_population)

	fitnesses = fitness_net_tuples.sort_by { |fitness_net| 
		[-fitness_net[0][0], fitness_net[0][1]]#Default sorting ascending
	}.slice(0, population_count)

	simulation_scores = fitnesses.map {|fitness_net| fitness_net[0][0]}

	population = fitnesses.map {|fitness_net| new_population[fitness_net[1]]}

	puts "Finished generation " + i.to_s
	puts "Average simulation score " + mean(simulation_scores).to_s
	puts "Average node count " + mean(population.map{|n|n.nodes.length}).to_s
	puts "Average edge count " + mean(population.map{|n|n.edges.length}).to_s
end

# puts "Average performance: " + mean(test_population_fitness(population).map{|x|x[0][0]}).to_s

finish = Time::now
puts "Time processing " + (finish-start).to_s