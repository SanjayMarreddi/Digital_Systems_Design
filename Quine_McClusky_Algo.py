"""
This Contains full Implementation of the Quine Mc'Clusky Algorithm for simplifying Boolean functions.

Date	: 25-October-2020
Author  : Sanjay Marreddi ( Using Template provided by Neha Karanjkar, IIT Goa )
Roll No : 1904119
"""

# Importing Required Libraries
import copy
import itertools


# The Problem Instance is specified here :
variable_names=['X','Q3','Q2']
minterms=[4,6,7]
dont_cares=[]

N=len(variable_names)



"""
A function to check if the minterms and dont_cares lists are valid. The list should have no duplicates, be in ascending order, 
and each entry should be between 0 and 2^N -1.
"""
def check_problem_instance(N,minterms,dont_cares):

	print("Problem Instance:")
	print("---------------------------")
	print("Variables:",variable_names)
	print("Minterms:",minterms)
	print("Don't cares:",dont_cares)
	print("---------------------------")

	print("Checking problem instance...",end='')
	m1 = [x for x in sorted(set(minterms)) if (x>=0 and x<(2**N))]
	d1 = [x for x in sorted(set(dont_cares)) if (x>=0 and x<(2**N))]
	assert(minterms == m1), "ERROR: The minterm list is Invalid."
	assert(dont_cares == d1), "ERROR: The dont_cares list is invalid."
	assert (not (set(minterms)&set(dont_cares))), "ERROR: The minterms list and dont_cares list have some common elements."
	print("OK.")

check_problem_instance(N,minterms,dont_cares)



"""
Returns a List which is Binary Representation of given Integer
"""
def convert_to_binary(x,N):
	# convert x to binary (a list of 0s and 1s)
	# Example: convert_to_binary(6,5) returns [0,0,1,1,0]
	binary=[] 
	for i in range(0,N):
		bit = x&1
		binary.insert(0,bit) 
		x=x>>1
	return binary



class Term (object):
	"""
	A class to model each term in the QM algorithm.
	A term can be a minterm (eg. [1,0,1,1,])
	or a combined term (eg. [1,0,1,'-'])
	"""

	# Initializing a Term from a minterm (integer)
	def __init__(self, N, minterm):
		self.N=N 								 # number of variables
		self.minterms_covered=set([minterm]) 	 # the set of minterms that are covered by this term
		self.binary=convert_to_binary(minterm,N) # the binary representation of a term. Eg. [0,0,1,'-']
		self.was_combined=False 				 # a boolean variable indicating whether this Term was combined.

	def try_combining(self,other_term):
		# try combining this Term with another Term. 
		# If the two terms differ in at-most one bit (0/1, but not '-')
		# the function returns (True, combined_term) and sets 'was_combined=1' for both terms.
		# else returns (False, None)
		
		assert(self.N==other_term.N)
		a=self.binary
		b=other_term.binary
		combined_term = copy.deepcopy(self)
		combined_term.was_combined=False
		count=0	
		for i in range(0,len(a)):
			if (a[i]!=b[i]):
				if( (a[i]=='-') or (b[i]=='-')):
					# can't be combined as the '-' term is not matching
					return False, None
				else:
					count+=1
					combined_term.binary[i]='-'
				if count>1:
					#can't be combined as more than one bit is different
					return False, None 
		
		# a,b can be combined as only one (non '-') term differs
		combined_term.minterms_covered = self.minterms_covered.union(other_term.minterms_covered)
		self.was_combined=True
		other_term.was_combined=True
		return True, combined_term
	
	def __str__(self):
		# a function to print this term
		s = str(self.minterms_covered)+" "+ str(self.binary)
		if self.was_combined:
			s+=  u'\u2713' # print the tick-mark symbol
		return s


"""
Function to find all prime implicants 
"""
def find_prime_implicants(minterms, dont_cares,N):
	
	# we finally need to populate this list of prime implicants
	prime_implicants=[]

	# First, lets create a list G where we shall store 
	# the terms, grouped on the basis
	# of number of 1s contained in the term.
	G=[]
	for i in range (0,N+1):
		G.append([]) 
		#G[0] should contain all terms with no '1', 
		#G[1] should contain terms with exactly one '1' 
		#G[2] should contain terms with exactly two '1's 
		#and so on... 
	
	# similarly, lets have another list for storing the 
	# results of one pass, serving as input to the next pass
	G_NEXT=[]
	for i in range (0,N+1):
		G_NEXT.append([]) 


	print("Grouping the minterms and don't care terms based on the number of ones:")
	for m in (minterms + dont_cares):
		t= Term(N,m) # create a term
		num_of_ones = t.binary.count(1) # count the number of ones
		G[num_of_ones].append(t) # place each term in an appropriate group
	
	# print the group
	for i in range(0,len(G)):
		print("GROUP",i,"------------")
		for m in G[i]:
			print("\t",m)

			

	print("Combining terms in adjacent groups...")
	
	# One pass:
	converged=False
	iteration=0

	while(not converged):
		print("==============================")
		print("Pass:",iteration+1)
		print("==============================")
		
		#iterate over each group,
		#iterate over each element in grp
		#compare with each element in the adjacent group,
		# and see if they can be combined.
		# if they can be combined, add the combined term to the corresponding group in G_NEXT,
		# but check for DUPLICATE terms before adding!

		for g in range(len(G)-1):
			for t1 in range(len(G[g])):
				for t2 in range(len(G[g+1])):
					Bool,comb_term = Term.try_combining(G[g][t1],G[g+1][t2])
					if Bool == True :
						if comb_term.binary not in  [x.binary for x in  G_NEXT[g] ]:		
							G_NEXT[g].append(comb_term)



		# if any terms could not be combined in this pass,
		# they should be placed in the list of prime implicants
		# Check if no terms were combined in this pass.
		# If so, it means we've converged, no need for another pass.
		converged=True
		for grp in range (len(G)):
			for i in range(len(G[grp])):
				if not G[grp][i].was_combined:
					if G[grp][i] not in prime_implicants:
						prime_implicants.append(G[grp][i])
				else:
					converged=False

		# print the group
		for i in range(0,len(G)):
			print("GROUP",i,"------------")
			for m in G[i]:
				print("\t",m)

		print("\nPrime_implicants identified by the end of this phase:")
		for m in prime_implicants:
			print("\t",m)
		
		G,G_NEXT = G_NEXT,G
		# clear elements in G_NEXT 
		G_NEXT=[]
		for i in range(0,N+1):
			G_NEXT.append([])
		iteration+=1
		# Next pass...
	
	# Finally return the list of prime implicants
	return prime_implicants



minterms_covered_by_EPI = []
"""
find_essential_prime_implicants -> Function to return the set of essential prime implicants
Input : List
Output: list,list
"""
def find_essential_prime_implicants(prime_implicants):
	
	counter = dict()
	essential_prime_implicants = []
	non_essential_prime_implicants = []
	global minterms_covered_by_EPI

	for i in minterms:
		counter[i] = []
		for term in prime_implicants:
			if i in term.minterms_covered :
				counter[i].append(term)


	for key,values in counter.items():
		if len(values) == 1 :
			essential_prime_implicants.append(values[0])

	
	for pi in prime_implicants :
		if pi not in essential_prime_implicants :
			non_essential_prime_implicants.append(pi)				

	for EPI in essential_prime_implicants:
		minterms_covered_by_EPI += list(EPI.minterms_covered)

	minterms_covered_by_EPI = list(set(minterms_covered_by_EPI))

	return essential_prime_implicants, non_essential_prime_implicants


"""				
Function to print the implicants using their variable names.
"""
def print_implicants(PI,N,variable_names):
	for i in range(len(PI)):
		for j in range(N):
			if PI[i].binary[j]==1:
				print(variable_names[j],end='')
			if PI[i].binary[j]==0:
				print(variable_names[j]+"'",end='')
		if (i<len(PI)-1):
			print("  ",end='')
	print("")

		

PI = find_prime_implicants(minterms, dont_cares,N)
print("\nPrime Implicants are: ",end='')
print_implicants(PI,N,variable_names)

EPI,NPI = find_essential_prime_implicants(PI)
print("Essential Prime Implicants are:  ",end='')
print_implicants(EPI,N,variable_names)
print("Non-Essential Prime Implicants are:  ",end='')
print_implicants(NPI,N,variable_names)



"""
PI_Chart -> It creates a Prime Implicant Chart and returns it.
Usual symbol 'X' in the Chart is represented as '1'. Empty entries are represented as '0'

Imput :	List, List
Output : List of lists
"""
def PI_Chart(remaining_minterms,non_essential_prime_implicants):
	
	remaining_minterms = sorted(remaining_minterms)	
	chart= []
	for i in range(len(non_essential_prime_implicants)):
		temp =[]
		for j in range(len(remaining_minterms)):
			temp.append(0)
		chart.append(temp)


	for t in range(len(non_essential_prime_implicants)) :
		for m in range(len(remaining_minterms)):
			# If a Min term is covered by the PI we are placing '1' 
			if remaining_minterms[m] in non_essential_prime_implicants[t].minterms_covered :
				chart[t][m] = 1 
		
	return chart


"""
Multiply -> It takes two Boolean Variables(say P,Q) and returns the Product
Input : list, list
Output: list 
"""
def Multiply(P, Q):
    product = []

    if len(P) == 0 and len(Q)== 0:
        return product
  
    elif len(P)==0:
        return Q
   
    elif len(Q)==0:
        return P

    else:
        for i in P:
            for j in Q:
                if i == j:
                    product.append(i)
                else:
                    product.append(list(set(i+j)))

        product.sort()

		# Removing redundant lists
        return list(product for product,_ in itertools.groupby(product))



"""
Petrick_Method -> This Function just Implements the Petricks Methodolgy for Finding the Smallest set of Non-Essential Prime Implicants for covering the remaining minterms.
Input : List of lists 
Output : List of lists 
"""
def Petrick_Method(Chart):
    
    P = []
    for column in range(len(Chart[0])):
        temp =[]
        for row in range(len(Chart)):
            if Chart[row][column] == 1:
                temp.append([row])
        P.append(temp)

    # Performing Multiplication of all elements of P taking two at a time.
    for k in range(len(P)-1):
        P[k+1] = Multiply(P[k],P[k+1])

	
    P = sorted(P[len(P)-1],key=len)

    P_final = []
    
	# Find the terms with min length (literals Indirectly). As we have sorted, We use P[0]
    for j in P:
        if len(j) == len(P[0]): 
            P_final.append(j)
        else:
            break

    return P_final




# Final Calculation
remaining_minterms = []
for i in minterms:
	if i not in minterms_covered_by_EPI :
		remaining_minterms.append(i)

print("Remaining minterms which are not covered by Essential PI",remaining_minterms)

if len(remaining_minterms) != 0 : 
	result = Petrick_Method(PI_Chart(remaining_minterms,NPI))
	print("Smallest set of Non-Essential Prime Implicants for covering the remaining minterms are:\n\n "  ,end='') 

	# Converting the given list of Minterms into Terms and passing it to print_implicants function.
	for x in result:
		Small_set= []
		for t in x:
			Small_set.append(NPI[t])	
		
		print_implicants(Small_set,N,variable_names)
		print("\t or")	
	
