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

{ #category : #accessing }
PokemonType class >> start [

	<script>
	| stream reader splitAndTrim pokemonTypes canvas shapes highlightable pokemonDictionary sortedPokemonTypes |
	stream := 'pharo-local/iceberg/PokemonAnalysis/src/Relationships.csv' asFileReference readStream.
	reader := NeoCSVReader on: stream.
	splitAndTrim := [ :l | (l splitOn: ',') collect: [ :s | s trim ] ].
	pokemonTypes := reader
		                separator: Character tab;
		                recordClass: self;
		                skipHeader;
		                addField: #typeName:;
		                "Name"addField: #strongAgainst:
		                converter: splitAndTrim;
		                "strengths"addField: #weakAgainst:
		                converter: splitAndTrim;
		                "weaknesses"addField: #resistantTo:
		                converter: splitAndTrim;
		                "resistances"addField: #vulnerableTo:
		                converter: splitAndTrim;
		                "vulnerabilities"upToEnd.

	sortedPokemonTypes := pokemonTypes asSortedCollection: [ :a :b | 
		                      a asString <= b asString ].

	pokemonDictionary := Dictionary new.
	pokemonTypes do: [ :t | pokemonDictionary at: t asString put: t ].

	canvas := RSCanvas new.
	shapes := RSCircle models: sortedPokemonTypes.
	shapes
		size: 30;
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
			t vulnerableTo collect: [ :v | pokemonDictionary at: v asString ] ].
	RSCircleLayout new
		initialAngleInDegree: -90;
		"first node should be at top 12 o'clock"on: shapes.
	canvas @ RSCanvasController.
	canvas open
]

{ #category : #converting }
PokemonType >> asString [
	^ typeName
]

{ #category : #accessing }
PokemonType >> resistantTo: aCollection [ 
	resistantTo := aCollection.
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
PokemonType >> weakAgainst: aCollection [ 
	weakAgainst := aCollection
]
