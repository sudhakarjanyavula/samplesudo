class Api::SudokuController < ApplicationController
	def create
		begin
			d = eval(params[:data])
		rescue
			d = params[:data]
		end

		if solve_sudoku(d,0,0)
			render json: {solution: d}
		else
			render json: {error: ["not a valid sudoku"]}
		end
	end

	def validate_sudoku(data, row, col, num)
		for i in 0...9
			if data[row][i] == num
				return false
			end
		end
		for i in 0...9
			if data[i][col] == num
				return false
			end
		end
		start_row = row - row % 3
		start_col = col - col % 3
		for i in 0...3
			for j in 0...3
				if data[i +  start_row][j + start_col] == num
					return false
				end
			end
		end
		return true
	end

	def solve_sudoku(data, row, col)
		n = 9
		if row == n - 1  && col == n
			return true
		end

		if col == n
			row = row + 1
			col = 0
		end

		if !data[row][col].blank?    # handle nil value  which is mention null in params input array
			return solve_sudoku(data, row, col + 1)
		end

		for num in 1..n
			if validate_sudoku(data,row,col,num)
				data[row][col] = num
				if solve_sudoku(data,row,col+1)
					return true
				end
			end
			data[row][col] = nil
		end
		return false
	end
end
