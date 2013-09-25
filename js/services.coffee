services = angular.module 'nonogram.services', []

services.factory 'Nonogram', ->
	randomInt = (min, max) ->
		unless max?
			max = min
			min = 0

		(Math.floor (Math.random() * (max - min + 1))) + min

	shuffle = (list) ->
		for i in [list.length - 1..1]
			rand = randomInt (i + 1)
			[list[i], list[rand]] = [list[rand], list[i]]

		list

	class Nonogram
		constructor: (options) ->
			@size = options.size
			@numSquares = @size * @size

			filledSquares = Math.round @numSquares * 0.5

			@squares = []

			for [1..filledSquares]
				@squares.push true

			for [1..@numSquares - filledSquares]
				@squares.push false

			@squares = shuffle @squares

			@grid = []
			for rowIndex in [0...@size]
				row = []
				for colIndex in [0...@size]
					row.push
						filled: @squares[rowIndex * @size + colIndex]
						state: 'blank'
				@grid.push row

			additionalCols = 1

			@rowNums = []
			for row, rowIndex in @grid
				nums = []
				num = 0
				for cell, colIndex in row
					if cell.filled
						++num
						if colIndex is @size - 1
							nums.push
								complete: false
								value: num
					else if num isnt 0
						nums.push
							complete: false
							value: num
						num = 0
				@rowNums.push nums
				if nums.length > additionalCols
					additionalCols = nums.length

			additionalRows = 1

			@colNums = []
			for row in [0...@size]
				nums = []
				num = 0
				for col in [0...@size]
					if @grid[col][row].filled
						++num
						if col is @size - 1
							nums.push
								complete: false
								value: num
					else if num isnt 0
						nums.push
							complete: false
							value: num
						num = 0
				@colNums.push nums
				if nums.length > additionalRows
					additionalRows = nums.length

		checkRowNums: (row) ->
			# Reset numbers
			for num in @rowNums[row]
				num.complete = false

			# Check if all numbers match
			segmentLength = 0
			currentSegments = []

			for cell, index in @grid[row]
				switch cell.state
					when 'on'
						++segmentLength
						if index is @grid[row].length - 1
							currentSegments.push segmentLength
					when 'off', 'blank'
						if segmentLength > 0
							currentSegments.push segmentLength
						segmentLength = 0

			allNumsMatch = @rowNums[row].every (num, index) ->
				num.value is currentSegments[index]

			if allNumsMatch
				for num in @rowNums[row]
					num.complete = true

				return


			# Check numbers going left to right
			segmentLength = 0
			currentSegments = []

			for cell, index in @grid[row]
				if cell.state is 'on'
					++segmentLength
				else if index is @grid[row].length - 1 and cell.state isnt 'blank'
					currentSegments.push segmentLength
				else if cell.state is 'off'
					if segmentLength > 0 and currentSegments.length < @rowNums[row].length - 1
						currentSegments.push segmentLength
					segmentLength = 0
				else
					break

			for num, index in @rowNums[row]
				if num.value is currentSegments[index]
					num.complete = true
				else
					break

			# Check numbers going right to left
			segmentLength = 0
			currentSegments = []

			for cell, index in @grid[row] by -1
				if cell.state is 'on'
					++segmentLength
				else if index is 0 and cell.state isnt 'blank'
					currentSegments.push segmentLength
				else if cell.state is 'off'
					if segmentLength > 0 and currentSegments.length < @rowNums[row].length - 1
						currentSegments.push segmentLength
					segmentLength = 0
				else
					break

			for num, index in @rowNums[row] by -1
				if num.value is currentSegments[@rowNums[row].length - index - 1]
					num.complete = true
				else
					break

		checkColNums: (col) ->
			for num in @colNums[col]
				num.complete = false




		
	Nonogram

services.factory 'Draw', ->
	direction: null
	position:
		x: null
		y: null
	startPosition:
		x: null
		y: null
	state: false