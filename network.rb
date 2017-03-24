require './node'

#Gene [act_id, out_id, init_value1, init_value2]
#Id_range is the max number of genes in a chromosome (genome)
class Network
	def initialize(num_nodes=0, id_range = 100, num_act_fns=5)
		@nodes = {}
		for i in 0..num_nodes-1
			@nodes[i] = Node.new(i, rand(num_act_fns), rand(id_range), rand_weight, rand_weight)
		end

		setup_state
	end

	def setup_state
		@edges = []

		connect_nodes

		@event_queue = []
		@logging = false
		@log = []
		@timesteps = 0
	end

	def turn_off_logging
		@logging = false
	end

	def rand_weight
		n = rand(3)
		if n == 0
			return 0
		elsif n == 1
			return 1
		else
			return nil
		end
	end

	def connect_nodes
		@nodes.each do |id, n|
			out_id = n.get_out_id
			n2 = @nodes[out_id]
			if n2 != nil
				if n2.not_full_inputs?
					if n2.input1_taken?
						n2.set_input1 id
						@edges << [id, n2.get_id]
					else
						n2.set_input2 id
						@edges << [id, n2.get_id]
					end
				end
			end
		end
	end

	def push_events
		@nodes.each do |id, node|
			node.push_activation(@event_queue)
		end
	end

	def process_event(packet)
		to = packet[0]
		from = packet[1]
		val = packet[2]

		@nodes[to].update_edge_state from, val if @nodes[to]
	end

	def pop_events
		if !@event_queue.empty?
			until @event_queue.empty?
				process_event(@event_queue.pop)
			end
			return false
		else
			return true
		end
	end

	def timestep
		push_events
		@log << Array.new(@event_queue) if @logging
		out = pop_events
		@timesteps+=1
		out
	end

	def reset
		@nodes.each do |id, n|
			n.reset
		end
	end

	def simulate(max_timesteps=100)
		i = 0
		stopped = false
		until i == max_timesteps || stopped
			stopped = timestep
			i+=1
		end
		reset
		i
	end

	def dump_log
		puts "LOG DUMP"
		@log.each_with_index do |row, i|
			puts "TIMESTEP: " + i.to_s
			print row.to_s + "\n"
		end
	end

	def to_genes
		genes = []
		n = nodes[0].to_gene.length
		for i in 0..n-1
			genes << []
		end
		for i in 0..nodes.length-1
			nodes[i].to_gene.each_with_index do |dna, j|
				genes[j] << dna
			end
		end
		genes
	end

	def from_genes(genes)
		genes.transpose.each_with_index do |gene, i|
			@nodes[i] = Node.new(i, gene[0], gene[1], gene[2], gene[3])
		end
		setup_state
		self
	end

	def nodes
		@nodes
	end

	def edges
		@edges
	end

	def event_queue
		@event_queue
	end

end