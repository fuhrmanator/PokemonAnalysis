Class {
	#name : 'RankedPokemon',
	#superclass : 'Object',
	#instVars : [
		'name',
		'rank',
		'dex',
		'types',
		'attack',
		'defense',
		'stamina',
		'statProduct',
		'level',
		'cp',
		'fastMove',
		'chargedMoves',
		'buddyDistance',
		'chargedMoveCost'
	],
	#category : 'PokemonAnalysis',
	#package : 'PokemonAnalysis'
}

{ #category : 'as yet unclassified' }
RankedPokemon class >> readPokemonsFromCSV: fileDesc [

	| stream reader joinTypeFields joinChargedMoves movesDict |
	stream := fileDesc asFileReference readStream.
	reader := NeoCSVReader on: stream.
	"splitAndTrim := [ :l | (l splitOn: ',') collect: [ :s | s trim ] ]."
	joinTypeFields := [ :type1 |
	                  | type2 |
	                  reader readSeparator.
	                  type2 := reader readField.
	                  type2 = 'none'
		                  ifTrue: [ { type1 } ]
		                  ifFalse: [
			                  {
				                  type1.
				                  type2 } ] ].
	"Converts four fields to an array of moves"
	joinChargedMoves := [ :move1 |
	                  | move1Count move2 move2Count |
	                  (reader readSeparator) ifFalse: [Error new messageText: 'separator not found.'].
	                  move2 := reader readField.
	                  (reader readSeparator) ifFalse: [Error new messageText: 'separator not found.'].
	                  move1Count := reader readField "asInteger".
	                  (reader readSeparator) ifFalse: [Error new messageText: 'separator not found.'].
	                  move2Count := reader readField "asInteger".
	                  movesDict := Dictionary new.
	                  movesDict at: move1 put: move1Count.
	                  move2 ifNotNil: [
		                  movesDict at: move2 put: move2Count ].
	                  movesDict ].
	^ reader
		  separator: $,;
		  recordClass: self;
		  skipHeader;
		  addField: #name:;
		  addFloatField: #rank:;
		  addIntegerField: #dex:;
		  addField: #types: converter: joinTypeFields;
		  addFloatField: #attack:;
		  addFloatField: #defense:;
		  addIntegerField: #stamina:;
		  addIntegerField: #statProduct:;
		  addIntegerField: #level:;
		  addIntegerField: #cp:;
		  addField: #fastMove:;
		  addField: #chargedMoves: converter: joinChargedMoves;
		  addIntegerField: #buddyDistance:;
		  addIntegerField: #chargedMoveCost:;
		  upToEnd
]

{ #category : 'accessing' }
RankedPokemon >> asString [

	^ self name
]

{ #category : 'accessing' }
RankedPokemon >> attack [

	^ attack
]

{ #category : 'accessing' }
RankedPokemon >> attack: anObject [

	attack := anObject
]

{ #category : 'accessing' }
RankedPokemon >> buddyDistance [

	^ buddyDistance
]

{ #category : 'accessing' }
RankedPokemon >> buddyDistance: anObject [

	buddyDistance := anObject
]

{ #category : 'accessing' }
RankedPokemon >> chargedMoveCost [

	^ chargedMoveCost
]

{ #category : 'accessing' }
RankedPokemon >> chargedMoveCost: anObject [

	chargedMoveCost := anObject
]

{ #category : 'accessing' }
RankedPokemon >> chargedMoves [

	^ chargedMoves
]

{ #category : 'accessing' }
RankedPokemon >> chargedMoves: anObject [

	chargedMoves := anObject
]

{ #category : 'accessing' }
RankedPokemon >> cp [

	^ cp
]

{ #category : 'accessing' }
RankedPokemon >> cp: anObject [

	cp := anObject
]

{ #category : 'accessing' }
RankedPokemon >> defense [

	^ defense
]

{ #category : 'accessing' }
RankedPokemon >> defense: anObject [

	defense := anObject
]

{ #category : 'accessing' }
RankedPokemon >> dex [

	^ dex
]

{ #category : 'accessing' }
RankedPokemon >> dex: anObject [

	dex := anObject
]

{ #category : 'accessing' }
RankedPokemon >> fastMove [

	^ fastMove
]

{ #category : 'accessing' }
RankedPokemon >> fastMove: anObject [

	fastMove := anObject
]

{ #category : 'accessing' }
RankedPokemon >> level [

	^ level
]

{ #category : 'accessing' }
RankedPokemon >> level: anObject [

	level := anObject
]

{ #category : 'accessing' }
RankedPokemon >> moves [
	"Transcript show: 'moves: '; 
		show: fastMove; 
		show: ', ';
		show: chargedMoves keys first;
		show: ', ';
		show: chargedMoves keys second."

	^ chargedMoves keys size = 1
		  ifTrue: [
			  {
				  fastMove.
				  chargedMoves keys first } ]
			ifFalse: [
			  {
				  fastMove.
				  chargedMoves keys first.
				  chargedMoves keys second } ]

]

{ #category : 'accessing' }
RankedPokemon >> name [

	^ name
]

{ #category : 'accessing' }
RankedPokemon >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
RankedPokemon >> rank [

	^ rank
]

{ #category : 'accessing' }
RankedPokemon >> rank: anObject [

	rank := anObject
]

{ #category : 'accessing' }
RankedPokemon >> stamina [

	^ stamina
]

{ #category : 'accessing' }
RankedPokemon >> stamina: anObject [

	stamina := anObject
]

{ #category : 'accessing' }
RankedPokemon >> statProduct [

	^ statProduct
]

{ #category : 'accessing' }
RankedPokemon >> statProduct: anObject [

	statProduct := anObject
]

{ #category : 'accessing' }
RankedPokemon >> types [

	^ types
]

{ #category : 'accessing' }
RankedPokemon >> types: anObject [

	types := anObject
]
