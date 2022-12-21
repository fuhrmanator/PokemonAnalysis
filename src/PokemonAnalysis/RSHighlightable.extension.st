Extension { #name : #RSHighlightable }

{ #category : #'*PokemonAnalysis' }
RSHighlightable >> withOutgoingShapes [

	self highlightShapes: [ :s | 
		s outgoingLines collect: [ :aLine | aLine to ] as: RSGroup].
]
