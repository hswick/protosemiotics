def crossover(a, b, n1, n2)
	a1 = a.slice(0, n1)
	a2 = a.slice(n1, a.length)
	b1 = b.slice(0, n2)
	b2 = b.slice(n2, b.length)
	[a1.concat(b2), b1.concat(a2)]
end

def crossover_gene_matrices(a, b)
	a_out = []
	b_out = []
	n1 = rand(a[0].length)
	n2 = rand(b[0].length)
	for i in 0..a.length-1
		new_genes = crossover(a[i], b[i], n1, n2)
		a_out << new_genes[0]
		b_out << new_genes[1]
	end
	[a_out, b_out]
end

#This is assuming gene is a vector
def mutation!(gene)
	n = rand(gene.length)
	if n < gene.length - 1
		tmp = gene[n]
		gene[n] = gene[n+1]
		gene[n+1] = tmp
	else
		tmp = gene[n]
		gene[n] = gene[0]
		gene[0] = tmp
	end
end