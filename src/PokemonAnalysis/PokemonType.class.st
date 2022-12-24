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
	| pokemonTypes canvas shapes hl1 hl2 hl3 hl4 pokemonDictionary sortedPokemonTypes legend l from to win |
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

	shapes @ RSPopup.
	shapes @ RSLabeled middle.

	hl1 := RSHighlightable new.
	hl1 highlightColor: Color red translucent.
	hl1 highlightShapes: [ :aShape | 
		shapes select: [ :w | 
			aShape model vulnerableTo includes: w model asString ] ].
	shapes @ hl1.

	hl2 := RSHighlightable new.
	hl2 highlightColor: Color orange translucent.
	hl2 highlightShapes: [ :aShape | 
		shapes select: [ :w | 
			aShape model weakAgainst includes: w model asString ] ].
	shapes @ hl2.

	hl3 := RSHighlightable new.
	"hl3 highlightColor: Color blue translucent."
	hl3 highlightBorder: (RSBorder new
			 width: 3;
			 color: Color blue translucent).
	hl3 highlightShapes: [ :aShape | 
		shapes select: [ :w | 
			aShape model resistantTo includes: w model asString ] ].
	shapes @ hl3.

	hl4 := RSHighlightable new.
	hl4 highlightColor: Color green.
	hl4 withOutgoingLinesOnly.
	shapes @ hl4.

	canvas addAll: shapes.

	RSLineBuilder line
		color: Color transparent;
		width: 1;
		withBorderAttachPoint;
		shapes: shapes;
		connectToAll: [ :t | 
			t strongAgainst collect: [ :n | pokemonDictionary at: n ] ].
	"first node should be at top (12 o'clock)"
	RSCircleLayout new
		initialAngleInDegree: -90;
		on: shapes.

	legend := RSLegend new.
	legend container: canvas.
	legend title: 'Legend (mouse over a type)'.
	legend text: 'Vulnerable to' withCircleColor: Color red translucent.
	legend text: 'Weak against' withCircleColor: Color orange translucent.
	legend text: 'Resistant to' withShape: (RSCircle new
			 size: 15;
			 color: Color white;
			 borderColor: Color blue translucent).

	from := RSBox new size: 0.
	to := RSBox new size: 0.
	l := RSLine new
		     color: Color green;
		     from: from;
		     to: to.
	to translateBy: 15 @ 8.
	legend text: 'Strong against' withShape: l.
	legend build.

	canvas @ RSCanvasController.
	win := canvas openWithTitle: 'Pokemon Type Relationships'
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

	^ strongAgainst ifNotNil: [ strongAgainst ] ifNil: [ #() ] 
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
