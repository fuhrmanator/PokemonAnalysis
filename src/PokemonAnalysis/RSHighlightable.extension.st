Extension { #name : #RSHighlightable }

{ #category : #'*PokemonAnalysis' }
RSHighlightable >> withOutgoingLinesOnly [

	self highlightShapes: [ :s | 
		| list |
		list := s outgoingLines collect: #yourself as: RSGroup.
		"list addAll: (s outgoingLines collect: #to)."
		list ]
]

{ #category : #'*PokemonAnalysis' }
RSHighlightable >> withOutgoingShapes [

	self highlightShapes: [ :s | 
		s outgoingLines collect: [ :aLine | aLine to ] as: RSGroup].
]
