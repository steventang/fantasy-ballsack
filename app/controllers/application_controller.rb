class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def solve_knapsack
	 
#	  items = [
#      Player.new(:name => 'map'                    , :value => 9   , :price => 150) , Player.new(:name => 'compass'             , :value => 13  , :price => 35)  , 
#      Player.new(:name => 'water'                  , :value => 153 , :price => 200) , Player.new(:name => 'sandwich'            , :value => 50  , :price => 160) , 
#      Player.new(:name => 'glucose'                , :value => 15  , :price => 60)  , Player.new(:name => 'tin'                 , :value => 68  , :price => 45)  , 
#      Player.new(:name => 'banana'                 , :value => 27  , :price => 60)  , Player.new(:name => 'apple'               , :value => 39  , :price => 40)  , 
#      Player.new(:name => 'cheese'                 , :value => 23  , :price => 30)  , Player.new(:name => 'beer'                , :value => 52  , :price => 10)  , 
#      Player.new(:name => 'suntan cream'           , :value => 11  , :price => 70)  , Player.new(:name => 'camera'              , :value => 32  , :price => 30)  , 
#      Player.new(:name => 't-shirt'                , :value => 24  , :price => 15)  , Player.new(:name => 'trousers'            , :value => 48  , :price => 10)  , 
#      Player.new(:name => 'umbrella'               , :value => 73  , :price => 40)  , Player.new(:name => 'waterproof trousers' , :value => 42  , :price => 70)  , 
#      Player.new(:name => 'waterproof overclothes' , :value => 43  , :price => 75)  , Player.new(:name => 'note-case'           , :value => 22  , :price => 80)  , 
#      Player.new(:name => 'sunglasses'             , :value => 7   , :price => 20)  , Player.new(:name => 'towel'               , :value => 18  , :price => 12)  , 
#      Player.new(:name => 'socks'                  , :value => 4   , :price => 50)  , Player.new(:name => 'book'                , :value => 30  , :price => 10)
#    ]

		items = @user.players.all

  	problem = KnapsackProblem.new(:items => items, :max_cost => current_user.budget, :max_count => current_user.team_size)

  	cost_matrix = dynamic_programming_knapsack problem

	  @message = 'Found solution: ' + get_list_of_used_items_names(problem, cost_matrix) +
	  ' with total value: ' + cost_matrix.last.last.last.to_s

	end

	def dynamic_programming_knapsack(problem)
	  num_items = problem.items.size
	  items = problem.items
	  max_cost = problem.max_cost
	  max_count = problem.max_count
	  cost_matrix = zeros(num_items, max_cost+1, max_count+1)

	  num_items.times do |i|
	    (max_cost + 1).times do |j|
	      (max_count + 1).times do |k|
	        if (items[i].price > j) or (1 > k)
	          cost_matrix[i][j][k] = cost_matrix[i-1][j][k]
	        else
	          cost_matrix[i][j][k] = [
	              cost_matrix[i-1][j][k],
	              items[i].value + cost_matrix[i-1][j-items[i].price][k-1]
	            ].max
	        end
	      end
	    end
	  end
	  cost_matrix
	end
	 
	def get_used_items(problem, cost_matrix)
	  itemIndex = problem.items.size - 1
	  currentCost = -1
	  currentmax_count = -1
	  marked = Array.new(cost_matrix.size, 0) 

	  # Locate the cell with the maximum value
	  bestValue = -1
	  (problem.max_cost + 1).times do |j|
	    (problem.max_count + 1).times do |k|
	      value = cost_matrix[itemIndex][j][k]
	      if (bestValue == -1) or (value > bestValue)
	        currentCost = j
	        currentmax_count = k
	        bestValue = value
	      end
	    end
	  end

	  # Trace path back to the start
	  while(itemIndex >= 0 && currentCost >= 0 && currentmax_count >= 0)
	    if (itemIndex == 0 && cost_matrix[itemIndex][currentCost][currentmax_count] > 0) or
	        (cost_matrix[itemIndex][currentCost][currentmax_count] != cost_matrix[itemIndex-1][currentCost][currentmax_count])
	      marked[itemIndex] = 1
	      currentCost -= problem.items[itemIndex].price
	      currentmax_count -= 1
	    end
	    itemIndex -= 1
	  end
	  marked
	end
	 
	def get_list_of_used_items_names(problem, cost_matrix)
	  items = problem.items
	  used_items = get_used_items(problem, cost_matrix)
	  puts "got used Items"
	  result = []
	 
	  used_items.each_with_index do |item,i|
	    if item > 0
	      result << items[i].name
	    end
	  end
	 
	  result.sort.join(', ')
	end
	 
	def zeros(rows, cols, count)
	  Array.new(rows) do |row|
	  	Array.new(cols) do |cols|
	    	Array.new(count, 0)
	    end
	  end
	end
	
end
