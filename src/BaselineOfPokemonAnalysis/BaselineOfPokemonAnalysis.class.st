Class {
	#name : 'BaselineOfPokemonAnalysis',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPokemonAnalysis',
	#package : 'BaselineOfPokemonAnalysis'
}

{ #category : 'baselines' }
BaselineOfPokemonAnalysis >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Needs NeoCSV and NeoJSON"
		self neoCSV: spec.
		self neoJSON: spec.
		"Packages"
		spec package: 'PokemonAnalysis' ]
]

{ #category : 'as yet unclassified' }
BaselineOfPokemonAnalysis >> neoCSV: spec [
	spec baseline: 'NeoCSV' with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
]

{ #category : 'as yet unclassified' }
BaselineOfPokemonAnalysis >> neoJSON: spec [

	spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

]

{ #category : 'baselines' }
BaselineOfPokemonAnalysis >> projectClass [
	^ MetacelloCypressBaselineProject
]
