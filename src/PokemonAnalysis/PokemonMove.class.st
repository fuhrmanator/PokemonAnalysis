Class {
	#name : 'PokemonMove',
	#superclass : 'Object',
	#instVars : [
		'moveId',
		'name',
		'abbreviation',
		'type',
		'power',
		'energy',
		'energyGain',
		'cooldown',
		'buffs',
		'buffTarget',
		'buffApplyChance',
		'archetype'
	],
	#category : 'PokemonAnalysis',
	#package : 'PokemonAnalysis'
}

{ #category : 'as yet unclassified' }
PokemonMove class >> readMovesFromJSON: url [

	| response jsonContent reader |
	response := ZnClient new
		            url: url;
		            get.
	jsonContent := response contents.

	"Assuming the content is JSON, you can parse it using NeoJSON"
	reader := NeoJSONReader on: jsonContent readStream.

	^ reader
		mapInstVarsFor: self;
		for: #ArrayOfMoves
			customDo: [ :mapping | mapping listOfElementSchema: PokemonMove ];
		nextAs: #ArrayOfMoves.
]

{ #category : 'accessing' }
PokemonMove class >> start [

	<script>
	| pokemonMoves |
	pokemonMoves := self readMovesFromJSON:
		                'https://raw.githubusercontent.com/pvpoke/pvpoke/master/src/data/gamemaster/moves.json'.
	^ pokemonMoves
]

{ #category : 'accessing' }
PokemonMove >> abbreviation [

	^ abbreviation
]

{ #category : 'accessing' }
PokemonMove >> abbreviation: anObject [

	abbreviation := anObject
]

{ #category : 'accessing' }
PokemonMove >> archetype [

	^ archetype
]

{ #category : 'accessing' }
PokemonMove >> archetype: anObject [

	archetype := anObject
]

{ #category : 'accessing' }
PokemonMove >> cooldown [

	^ cooldown
]

{ #category : 'accessing' }
PokemonMove >> cooldown: anObject [

	cooldown := anObject
]

{ #category : 'accessing' }
PokemonMove >> energy [

	^ energy
]

{ #category : 'accessing' }
PokemonMove >> energy: anObject [

	energy := anObject
]

{ #category : 'accessing' }
PokemonMove >> energyGain [

	^ energyGain
]

{ #category : 'accessing' }
PokemonMove >> energyGain: anObject [

	energyGain := anObject
]

{ #category : 'accessing' }
PokemonMove >> moveId [

	^ moveId
]

{ #category : 'accessing' }
PokemonMove >> moveId: anObject [

	moveId := anObject
]

{ #category : 'accessing' }
PokemonMove >> name [

	^ name
]

{ #category : 'accessing' }
PokemonMove >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PokemonMove >> power [

	^ power
]

{ #category : 'accessing' }
PokemonMove >> power: anObject [

	power := anObject
]

{ #category : 'accessing' }
PokemonMove >> type [

	^ type
]

{ #category : 'accessing' }
PokemonMove >> type: anObject [

	type := anObject
]
