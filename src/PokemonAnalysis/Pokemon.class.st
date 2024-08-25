Class {
	#name : 'Pokemon',
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
Pokemon class >> readPokemonsFromCSV: fileDesc [

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
Pokemon >> attack [

	^ attack
]

{ #category : 'accessing' }
Pokemon >> attack: anObject [

	attack := anObject
]

{ #category : 'accessing' }
Pokemon >> buddyDistance [

	^ buddyDistance
]

{ #category : 'accessing' }
Pokemon >> buddyDistance: anObject [

	buddyDistance := anObject
]

{ #category : 'accessing' }
Pokemon >> chargedMoveCost [

	^ chargedMoveCost
]

{ #category : 'accessing' }
Pokemon >> chargedMoveCost: anObject [

	chargedMoveCost := anObject
]

{ #category : 'accessing' }
Pokemon >> chargedMoves [

	^ chargedMoves
]

{ #category : 'accessing' }
Pokemon >> chargedMoves: anObject [

	chargedMoves := anObject
]

{ #category : 'accessing' }
Pokemon >> cp [

	^ cp
]

{ #category : 'accessing' }
Pokemon >> cp: anObject [

	cp := anObject
]

{ #category : 'accessing' }
Pokemon >> defense [

	^ defense
]

{ #category : 'accessing' }
Pokemon >> defense: anObject [

	defense := anObject
]

{ #category : 'accessing' }
Pokemon >> dex [

	^ dex
]

{ #category : 'accessing' }
Pokemon >> dex: anObject [

	dex := anObject
]

{ #category : 'accessing' }
Pokemon >> fastMove [

	^ fastMove
]

{ #category : 'accessing' }
Pokemon >> fastMove: anObject [

	fastMove := anObject
]

{ #category : 'accessing' }
Pokemon >> level [

	^ level
]

{ #category : 'accessing' }
Pokemon >> level: anObject [

	level := anObject
]

{ #category : 'accessing' }
Pokemon >> name [

	^ name
]

{ #category : 'accessing' }
Pokemon >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
Pokemon >> rank [

	^ rank
]

{ #category : 'accessing' }
Pokemon >> rank: anObject [

	rank := anObject
]

{ #category : 'accessing' }
Pokemon >> stamina [

	^ stamina
]

{ #category : 'accessing' }
Pokemon >> stamina: anObject [

	stamina := anObject
]

{ #category : 'accessing' }
Pokemon >> statProduct [

	^ statProduct
]

{ #category : 'accessing' }
Pokemon >> statProduct: anObject [

	statProduct := anObject
]

{ #category : 'accessing' }
Pokemon >> types [

	^ types
]

{ #category : 'accessing' }
Pokemon >> types: anObject [

	types := anObject
]
