Class {
	#name : #PokemonType,
	#superclass : #Object,
	#instVars : [
		'typeName',
		'weakAgainst',
		'resistantTo',
		'vulnerableTo',
		'strongAgainst'
	],
	#category : #PokemonAnalysis
}

{ #category : #'as yet unclassified' }
PokemonType class >> readTypesFromCSV: fileDesc [

	| stream reader splitAndTrim |
	stream := fileDesc asFileReference readStream.
	reader := NeoCSVReader on: stream.
	splitAndTrim := [ :l | (l splitOn: ',') collect: [ :s | s trim ] ].
	^ reader
		  separator: Character tab;
		  recordClass: self;
		  skipHeader;
		  addField: #typeName:;
		  addField: #strongAgainst: converter: splitAndTrim;
		  addField: #weakAgainst: converter: splitAndTrim;
		  addField: #resistantTo: converter: splitAndTrim;
		  addField: #vulnerableTo: converter: splitAndTrim;
		  upToEnd
]

{ #category : #accessing }
PokemonType class >> start [

	<script>
	| pokemonTypes canvas shapes highlightable pokemonDictionary sortedPokemonTypes |
	pokemonTypes := self readTypesFromCSV:
		                'pharo-local/iceberg/fuhrmanator/PokemonAnalysis/src/Relationships.csv'.

	sortedPokemonTypes := pokemonTypes asSortedCollection: [ :a :b | 
		                      a asString <= b asString ].

	pokemonDictionary := Dictionary new.
	pokemonTypes do: [ :t | pokemonDictionary at: t asString put: t ].

	canvas := RSCanvas new.
	shapes := RSCircle models: sortedPokemonTypes.
	shapes
		size: 50;
		color: Color white.

	shapes @ RSLabeled middle.
	shapes @ RSHighlightable green.
	highlightable := RSHighlightable new.
	highlightable highlightColor: Color red translucent.
	highlightable withOutgoingShapes.
	shapes @ highlightable.
	canvas addAll: shapes.
	RSLineBuilder line
		color: Color gray translucent;
		width: 3;
		withBorderAttachPoint;
		shapes: shapes;
		connectToAll: [ :t | 
			t vulnerableTo collect: [ :v | pokemonDictionary at: v asString ] ];
		connectToAll: [ :t | 
			t weakAgainst collect: [ :v | pokemonDictionary at: v asString ] ].
	"first node should be at top (12 o'clock)"
	RSCircleLayout new
		initialAngleInDegree: -90;
		on: shapes.
	canvas @ RSCanvasController.
	canvas open
]

{ #category : #converting }
PokemonType >> asString [
	^ typeName
]

{ #category : #accessing }
PokemonType >> resistantTo [

	^ resistantTo
]

{ #category : #accessing }
PokemonType >> resistantTo: aCollection [ 
	resistantTo := aCollection.
]

{ #category : #accessing }
PokemonType >> strongAgainst [

	^ strongAgainst
]

{ #category : #accessing }
PokemonType >> strongAgainst: aCollection [ 
	strongAgainst := aCollection 
]

{ #category : #'var accessors' }
PokemonType >> typeName: aString [ 
	typeName := aString
]

{ #category : #accessing }
PokemonType >> vulnerableTo [
	^ vulnerableTo
]

{ #category : #accessing }
PokemonType >> vulnerableTo: aCollection [ 
	vulnerableTo := aCollection
]

{ #category : #accessing }
PokemonType >> weakAgainst [

	^ weakAgainst
]

{ #category : #accessing }
PokemonType >> weakAgainst: aCollection [ 
	weakAgainst := aCollection
]
