controllers = angular.module 'nonogram.controllers', []

controllers.controller 'BoardCtrl', ($scope, Nonogram, Draw) ->
	nonogram = new Nonogram
		size: 10

	$scope.grid = nonogram.grid
	$scope.rowNums = nonogram.rowNums
	$scope.colNums = nonogram.colNums

	$scope.handleClick = (cell, colIndex, rowIndex, e) ->
		do e.preventDefault
		switch e.button
			# Left click
			when 0
				switch cell.state
					when 'on'
						Draw.state = 'on-blank'
						cell.state = 'blank'
					when 'blank'
						Draw.state = 'on'
						cell.state = 'on'

			# Right click
			when 2
				switch cell.state
					when 'off'
						Draw.state = 'off-blank'
						cell.state = 'blank'

					when 'blank'
						Draw.state = 'off'
						cell.state = 'off'

		Draw.startPosition =
			x: colIndex
			y: rowIndex

		nonogram.checkRowNums rowIndex

	$scope.handleDrag = (cell, colIndex, rowIndex) ->
		draw = (cell) ->
			switch Draw.state
				when 'on'
					if cell.state isnt 'off'
						cell.state = 'on'
				when 'off'
					if cell.state isnt 'on'
						cell.state = 'off'
				when 'off-blank'
					if cell.state is 'off'
						cell.state = 'blank'
				when 'on-blank'
					if cell.state is 'on'
						cell.state = 'blank'


		if Draw.startPosition.x? and Draw.startPosition.y?
			unless Draw.direction? or (colIndex is Draw.startPosition.x and rowIndex is Draw.startPosition.y)
					if colIndex isnt Draw.startPosition.x
						Draw.direction = 'horizontal'
					else if rowIndex isnt Draw.startPosition.y
						Draw.direction = 'vertical'

			switch Draw.direction
				when 'horizontal'
					for col in [Draw.startPosition.x..colIndex]
							draw $scope.grid[Draw.startPosition.y][col]
				when 'vertical'
					for row in [Draw.startPosition.y..rowIndex]
							draw $scope.grid[row][Draw.startPosition.x]


			nonogram.checkRowNums rowIndex

		Draw.position =
			x: colIndex
			y: rowIndex

	$scope.endDrawMode = ->
		Draw.direction = null
		Draw.startPosition =
			x: null
			y: null
		Draw.state = false

	$scope.boardLeave = ->
		do $scope.endDrawMode
		Draw.position =
			x: null
			y: null

	$scope.preventDefault = (e) ->
		do e.preventDefault

	$scope.getCellClass = (cell) ->
		off: cell.state is 'off'
		on: cell.state is 'on'

	$scope.getColNumsClass = (index) ->
		highlight: index is Draw.position.x

	$scope.getRowNumsClass = (num, index) ->
		complete: num.complete
		highlight: index is Draw.position.y
