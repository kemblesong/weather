require 'matrix'


class Regression
  POLYNOMIAL_MAX_DEGREE = 10
  
	def initialize(x_array, y_array)
		@x_array = x_array
		@y_array = y_array
	end
	
	def linear
		coefficient_array, mse = polynomial_with_degree(1)

    PolynomialEquation.new(coefficient_array)
	end
	
	def polynomial
		best_coefficient_array = []
		best_mse = 0
		first_time = true
		
		# regress with polynomial degree from 2 until $polynomial_max_degree
		# pick the one with the least mean squared error
		(2..POLYNOMIAL_MAX_DEGREE).each do |i|
			if first_time
				best_coefficient_array, best_mse = polynomial_with_degree(i)
				first_time = false
			else
				current_coefficient_array, current_mse = polynomial_with_degree(i)
				if current_mse < best_mse
					# found a better equation
					best_coefficient_array = current_coefficient_array
					best_mse = current_mse
				end
			end
		end

    PolynomialEquation.new(best_coefficient_array)
	end
	
	# calculate equation of best fit for a given degree
	# return coefficient_array and MSE
	# uses least squares method
	def polynomial_with_degree(degree)
		# create matrix of x and y
		# reference: Project 1 - Getting To Grips With Ruby(2).pdf (the project specifications)
		x_i_array = @x_array.map { |x_i| (0..degree).map { |pow| x_i**pow } }
		x_matrix = Matrix.rows(x_i_array)
		y_matrix = Matrix.column_vector(@y_array)
		
		coefficient_array = ((x_matrix.transpose * x_matrix).inverse * x_matrix.transpose * y_matrix).transpose.round(2).to_a[0]

		return coefficient_array, calculate_mse(PolynomialEquation.new(coefficient_array))
			
	end
	
	# perform least squares fitting logarithmic regression
	def logarithmic
		# formula from http://mathworld.wolfram.com/LeastSquaresFittingLogarithmic.html
		sum_y_lnx = 0
		sum_lnx = 0
		sum_square_of_lnx = 0
		sum_y = 0
		n = @x_array.size
		
		n.times do |i|
			lnx = ln(@x_array[i])
			sum_y_lnx += @y_array[i]*lnx
			sum_lnx += lnx
			sum_square_of_lnx += lnx**2
			sum_y += @y_array[i]
		end
		
		# y = a + b ln x
		b = ((n*sum_y_lnx-sum_y*sum_lnx)/(n*sum_square_of_lnx-sum_lnx**2)).round(2)
		a = ((sum_y - b*sum_lnx)/n).round(2)

    LogarithmicEquation.new(a,b)
	end
	
	# perform least squares fitting exponential regression
	def exponential
		# equation 3 and 4 from http://mathworld.wolfram.com/LeastSquaresFittingExponential.html
		sum_lny = 0
		sum_x2 = 0
		sum_x = 0
		sum_x_lny = 0
		n = @x_array.size
		
		@x_array.each_with_index do |x, i|
			y = @y_array[i]
			ln_y = ln(y)
			sum_lny += ln_y
			sum_x2 += x**2
			sum_x += x
			sum_x_lny += x*ln_y
		end
		
		# y = A e^(Bx)
		# B = b, A = exp(a)
		a = (sum_lny*sum_x2 - sum_x*sum_x_lny) / (n*sum_x2 - sum_x**2)
		exp_a = Math.exp(a).round(2)
		b = ((n*sum_x_lny - sum_x*sum_lny) / (n*sum_x2 - sum_x**2)).round(2)

		if @evaluate_MSE
			# determine MSE
			print_MSE(calculate_mse(lambda { |x| y=exp_a*Math.exp(b*x) }))
		end

    ExponentialEquation.new(exp_a,b)
		
	end
	
	# compute the natural log
	# return Nan if Math::DomainError is thrown (when trying to compute ln(x) where x <= 0)
	def ln(x)
		begin
			return Math.log(x)
		rescue Math::DomainError
			return Float::NAN
		end
	end
	
	# calculate the mean squared error for a given equation
	def calculate_mse(equation)
		result = 0
		@y_array.each_with_index do |y, i|
			f = equation.calculate(@x_array[i])
			result += (f-y)**2
		end
		result /= @y_array.size
    result.round(2)
	end
  
  def get_equation_with_least_mse
    methods = [method(:linear), method(:polynomial), method(:logarithmic), method(:exponential)]
    
    equation = nil
    best_mse = Float::INFINITY
    
    methods.each do |m|
      curr_eq = m.call
      curr_mse = calculate_mse curr_eq
      
      if curr_mse < best_mse
        # found a better equation
        best_mse = curr_mse
        equation = curr_eq
      end
    end
    return equation, best_mse
  end
end


class Equation
  def calculate(x)
  end
end

class PolynomialEquation < Equation
  def initialize(coefficient_array)
    @coefficient_array = coefficient_array
  end
  
  def calculate x
    x_i = 1
    y = @coefficient_array[0]
    1.upto(@coefficient_array.size-1) do |i|
      x_i *= x
      y += @coefficient_array[i]*x_i
    end
    y
  end
end


class LogarithmicEquation < Equation
  # y = a + b ln x
  def initialize(a, b)
    @a = a
    @b = b
  end
  
  def calculate x
    @a + @b*Math.log(x)
  end
end

class ExponentialEquation < Equation
  # y = A e^(Bx)  y=exp_a*Math.exp(b*x)
  def initialize(a, b)
    @a = a
    @b = b
  end
  
  def calculate x
    @a * Math.exp(@b*x)
  end
end
  
  