Class {
	#name : 'PokemonTeam',
	#superclass : 'Object',
	#instVars : [
		'pokemons'
	],
	#category : 'PokemonAnalysis',
	#package : 'PokemonAnalysis'
}

{ #category : 'accessing' }
PokemonTeam >> add: pokemon [

	self pokemons add: pokemon.
]

{ #category : 'accessing' }
PokemonTeam >> moves [

	^ (self pokemons flatCollect: [ :p | p moves ]) asSet.
]

{ #category : 'accessing' }
PokemonTeam >> pokemons [
	pokemons ifNil: [ pokemons := OrderedCollection new ].
	^ pokemons
]

{ #category : 'accessing' }
PokemonTeam >> pokemons: anObject [

	pokemons := anObject
]

{ #category : 'accessing' }
PokemonTeam >> size [

	^ self pokemons size
]

{ #category : 'accessing' }
PokemonTeam >> types [

	^ (self pokemons flatCollect: [ :p | p types ]) asSet.
]
