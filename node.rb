require './activation_functions'

class Node

	def initialize(id, activation, output_id, edge_state1, edge_state2)
		@id = id
		@activation = activation
		@input_id1 = nil
		@input_id2 = nil
		@output_id = output_id
		@edge_state1 = edge_state1
		@edge_state2 = edge_state2
		@init_edge_states = []
	end

	def activation
		if active?
			result = Act_Fns::AF[@activation][[@edge_state1, @edge_state2]]
			if result != nil
				#Clear edge states (from ALA)
				@edge_state1 = nil
				@edge_state2 = nil
			end
			return result
		else
			return nil
		end
	end

	def update_edge_state(id, value)
		@edge_state1 = value if id == @input_id1
		@edge_state2 = value if id == @input_id2
	end

	#packet = to, from, val
	def push_activation(event_queue)
		if active?
			event_queue << [@output_id, @id, activation]
		end
	end

	def active?
		@edge_state1 != nil && @edge_state2 != nil
	end

	def get_out_id
		@output_id
	end

	def not_full_inputs?
		@input_id1 == nil && @input_id2 == nil
	end

	def input1_taken?
		@input_id1 != nil
	end

	def set_input1(id)
		@input_id1 = id
	end

	def set_input2(id)
		@input_id2 = id
	end

	def get_id
		@id
	end

	def get_init_edge_states
		@init_edge_states
	end

	def to_gene
		[@activation, @output_id, @init_edge_states[0], @init_edge_states[1]]
	end
end