require "babel_bridge"

class TuringParser < BabelBridge::Parser
	# Will allow whitespace between expression/statements
	ignore_whitespace
	
	# Memory storage, creates arrays
	def store
		@store||=[]
	end

	rule :statements, many(:statement,";"), match?(";") do
		def evaluate
			ret = nil
			statement.each do |s|
				ret = s.evaluate
			end
			ret
		end
	end

	# Rule for the 'if' statement.
	rule :statement, "if", :statement, "then", :statements, :else_clause?, "end" do
		def evaluate
			if statement[0].evaluate
				statement[1].evaluate
	   		else
	    			else_clause.evaluate if else_clause
	   		end
	  	end
	end
	# Rule for executing else statements
	rule :else_clause, "else", :statements

	rule :statement, "while", :statement, "do", :statements, "end" do
		def evaluate
			while statement.evaluate
				statements.evaluate
			end
		end	
	end


	# Use for performing calculations and comparisons
	binary_operators_rule :statement, :operand, [[:/, :*], [:+, :-], [:<, :<=, :>, :>=, :==]] do
		def evaluate
                     	res = left.evaluate.send operator, right.evaluate
	  		case operator
	    			when :<, :<=, :>, :==
	     				res ? 1 : nil
	    			else
                        		res
	    		end
	   	end
	end
	 
	# Rule for writing to memory
	rule :operand, "[", :statement, "]", "=", :statement do
		def evaluate
			parser.store[statement[0].evaluate] = statement[1].evaluate
		end
	end

	# Rule for reading from memory
	rule :operand, "[", :statement, "]" do
		def evaluate
			parser.store[statement.evaluate]
		end
	end

	# Rule for perform nested operations
	rule :operand, "(", :statement, ")"
	rule :operand, /[-]?[0-9]+/ do
		def evaluate
			to_s.to_i
		end
	end

	rule :statement, "quit" do
		def evaluate
			exit!
		end
	end

	rule :statement, "exit" do
		def evaluate
			exit!
		end
	end
end

BabelBridge::Shell.new(TuringParser.new).start
