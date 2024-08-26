Class {
	#name : 'PokemonTeamBuilder',
	#superclass : 'Object',
	#instVars : [
		'moves',
		'rankedPokemons'
	],
	#category : 'PokemonAnalysis',
	#package : 'PokemonAnalysis'
}

{ #category : 'as yet unclassified' }
PokemonTeamBuilder >> findBalancedTeams [

	| teams pokemonsToIgnore team teamMoveTypes pokemonMoveTypes |
	teams := OrderedCollection new.

	pokemonsToIgnore := { 'Registeel' }.

	team := PokemonTeam new.

	Transcript
		show: 'Team size is ' , team size asString;
		cr.

	self rankedPokemons do: [ :p |
		team size < 3 ifTrue: [
			Transcript
				show: 'Pokemon: ' , p name;
				cr.

			teamMoveTypes := team moves collect: [ :m | "get the type of the move"
				                 self typeOf: m ].
			Transcript show: 'teamMoveTypes: '.
			teamMoveTypes do: [ :t |
				Transcript
					show: ' ' , t;
					cr ].
			pokemonMoveTypes := p moves collect: [ :m | "get the type of the moved"
				                    self typeOf: m ].

			Transcript show: 'pokemonMoveTypes: '.
			pokemonMoveTypes do: [ :t |
				Transcript
					show: ' ' , t;
					cr ] ].
		"Don't add the pokemon to the team unless its types aren't already in the team"
		((((team types includesAny: p types) or:
			   (teamMoveTypes includesAny: pokemonMoveTypes)) or: team size > 2)
			 or: (pokemonsToIgnore includes: p name)) ifFalse: [
			team add: p.
			Transcript
				show: 'Adding ' , p name;
				cr ] ].

	teams add: team.

	^ teams
]

{ #category : 'initialization' }
PokemonTeamBuilder >> initialize [

	moves := PokemonMove readMovesFromJSON: self movesURL.
	rankedPokemons := RankedPokemon readPokemonsFromCSV:
		                  self rankedPokemonsFileSpec.
]

{ #category : 'accessing' }
PokemonTeamBuilder >> moves [

	^ moves
]

{ #category : 'accessing' }
PokemonTeamBuilder >> moves: anObject [

	moves := anObject
]

{ #category : 'as yet unclassified' }
PokemonTeamBuilder >> movesURL [

^ 'https://raw.githubusercontent.com/pvpoke/pvpoke/master/src/data/gamemaster/moves.json'
]

{ #category : 'accessing' }
PokemonTeamBuilder >> rankedPokemons [

	^ rankedPokemons
]

{ #category : 'accessing' }
PokemonTeamBuilder >> rankedPokemons: anObject [

	rankedPokemons := anObject
]

{ #category : 'as yet unclassified' }
PokemonTeamBuilder >> rankedPokemonsFileSpec [
	^ 'pharo-local/iceberg/fuhrmanator/PokemonAnalysis/src/cp1500_all_overall_rankings.csv'
]

{ #category : 'private' }
PokemonTeamBuilder >> typeOf: move [

	^ (self moves detect: [ :globalMove | globalMove name = move ]) type
]
