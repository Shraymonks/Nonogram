directives = angular.module 'nonogram.directives', []

directives.directive 'disableContextMenu', ->
	(scope, elem, attrs) ->
		elem.bind 'contextmenu', (e) ->
			do e.preventDefault