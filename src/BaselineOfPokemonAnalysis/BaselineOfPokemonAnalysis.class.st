Class {
	#name : #BaselineOfPokemonAnalysis,
	#superclass : #BaselineOf,
	#category : #BaselineOfPokemonAnalysis
}

{ #category : #baselines }
BaselineOfPokemonAnalysis >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		"Needs NeoCSV"
		self neoCSV: spec.
		"Packages"
		spec package: 'PokemonAnalysis' ]
]

{ #category : #'as yet unclassified' }
BaselineOfPokemonAnalysis >> neoCSV: spec [
	spec baseline: 'NeoCSV' with: [ spec repository: 'github://svenvc/NeoCSV/repository' ].
]

{ #category : #baselines }
BaselineOfPokemonAnalysis >> projectClass [
	^ MetacelloCypressBaselineProject
]
