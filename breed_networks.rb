require './network'
require './genetic_algorithm'
require 'Set'

def init_population(n)
	population = []
	for i in 0..n
		population << Network.new(10, 10)
	end
	population
end

def test_fitness(network)
	n = network.simulate#Returns number of timesteps organism survived
	n
	#network.edges.length
end

def test_population_fitness(population)
	population.map {|net| [test_fitness(net), net]}
end

def population_mixture(population, &fn)
	output = []
	mix_set = Set.new
	population.each do |p1|
		population.each do |p2|
			if !mix_set.include?([p2, p1]) && !mix_set.include?([p1, p2])
				output << fn.call(p1, p2)
				mix_set << [p1, p2]
			end
		end
	end
	output
end

def birth(genes)
	if rand(100) == 0#0.01 probability
		mutation!(genes[rand(genes.length)])
	end
	Network.new.from_genes(genes)
end

#Always breeds two offspring, byproduct of crossover
def breed(a, b)
	offspring = crossover_gene_matrices(a.to_genes, b.to_genes)
	[birth(offspring[0]), birth(offspring[1])]
end

def untwinify(twins)
	output = []
	twins.each do |twin|
		output << twin[0]
		output << twin[1]
	end
	output
end

def mean(nums)
	sum = 0.0
	nums.each do |n|
		sum += n
	end
	sum/nums.length
end

population_count = 50

population = init_population(population_count)

for i in 0..10
	new_population = population_mixture(population) do |net1, net2| 
		breed(net1, net2)
	end	

	new_population = untwinify(new_population)

	fitness_net_tuples = test_population_fitness(new_population)	

	population = fitness_net_tuples.sort_by { |fitness_net| 
		fitness_net[0]
	}.reverse.slice(0, population_count).map {|fitness_net|
		fitness_net[1]
	}
end

population.each {|net| print net.edges.length.to_s + "\n"}