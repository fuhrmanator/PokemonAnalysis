Class {
	#name : 'PokemonType',
	#superclass : 'Object',
	#instVars : [
		'typeName',
		'weakAgainst',
		'resistantTo',
		'vulnerableTo',
		'strongAgainst'
	],
	#category : 'PokemonAnalysis',
	#package : 'PokemonAnalysis'
}

{ #category : 'accessing' }
PokemonType class >> browse [

	<script>
	| pokemonTypes canvas shapes hl1 hl2 hl3 hl4 pokemonDictionary sortedPokemonTypes legend l1 l2 from to win |
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
	hl1 highlightColor: Color red.
	hl1 withIncomingLinesOnly.
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

	RSLineBuilder directedSelfLoopBezier
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
	legend text: 'Weak against' withCircleColor: Color orange translucent.
	legend text: 'Resistant to' withShape: (RSCircle new
			 size: 15;
			 color: Color white;
			 borderColor: Color blue translucent).

	from := RSBox new size: 0.
	to := RSBox new size: 0.
	l1 := RSArrowedLine new
		      color: Color green;
		      from: from;
		      to: to.
	to translateBy: 15 @ 8.
	legend text: 'Strong against (Super effective attacks)' withShape: l1.

	l2 := RSArrowedLine new
		      color: Color red;
		      from: from;
		      to: to.
	"to translateBy: 15 @ 8."
	legend text: 'Vulnerable to (Super effective attacks)' withShape: l2.
	legend build.

	canvas @ RSCanvasController.
	win := canvas openWithTitle: 'Pokemon Type Relationships'
]

{ #category : 'as yet unclassified' }
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

{ #category : 'accessing' }
PokemonType class >> start [

	<script>
	| pokemonTypes canvas shapes hlVulnerableTo hlWeakAgainst hlResistantTo hlStrongAgainst pokemonDictionary sortedPokemonTypes legend sl vl from to win len |
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
	"RSGroup doesn't understand border:"
	shapes do: [ :s | 
		s border: (RSBorder new
			width: 1;
			color: (Color gray translucent)) ].

	"shapes @ RSPopup."
	shapes @ RSLabeled middle.

	hlVulnerableTo := RSHighlightable new.
	hlVulnerableTo highlightColor: Color red translucent.
	"withIncomingLinesOnly doesn't exist, so we make it"
	hlVulnerableTo highlightShapes: [ :s |
		| list |
		list := s incomingLines collect: #yourself as: RSGroup.
		"list addAll: (s outgoingLines collect: #to)."
		"Add shape if its vulnerable to itself"
		(s model vulnerableTo includes: s model asString) ifTrue: [ list add: s ].
		list ].
	shapes @ hlVulnerableTo.

	hlWeakAgainst := RSHighlightable new.
	hlWeakAgainst highlightColor: Color orange translucent.
	hlWeakAgainst highlightShapes: [ :aShape |
		shapes select: [ :w |
			aShape model weakAgainst includes: w model asString ] ].
	shapes @ hlWeakAgainst.

	hlResistantTo := RSHighlightable new.
	"hl3 highlightColor: Color blue translucent."
	hlResistantTo highlightBorder: (RSBorder new
			 width: 3;
			 color: Color blue translucent).
	hlResistantTo highlightShapes: [ :aShape |
		shapes select: [ :w |
			aShape model resistantTo includes: w model asString ] ].
	shapes @ hlResistantTo.

	hlStrongAgainst := RSHighlightable new.
	hlStrongAgainst highlightColor: Color green translucent.
	hlStrongAgainst withOutgoingLinesOnly.
	shapes @ hlStrongAgainst.

	canvas addAll: shapes.
	len := 4.

	RSLineBuilder line
		color: Color transparent;
		width: len * 2;
		markerEnd: (RSShapeFactory arrow size: len * 4; color: Color transparent);
		attachPoint: (RSBorderAttachPoint new endOffset: len);
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

	from := RSBox new size: 0.
	to := RSBox new size: 0.
	sl := RSLine new
				width: 2;
				color: Color green translucent;
				from: from;
				to: to.
	to translateBy: 15 @ 8.
	legend text: 'Strong against' withShape: sl.

	from := RSBox new size: 0.
	to := RSBox new size: 0.
	vl := RSLine new
				width: 2;
				color: Color red translucent;
				from: from;
				to: to.
	to translateBy: 15 @ 8.
	legend text: 'Vulnerable to' withCircleColor: Color red translucent; text: '' withShape: vl.
	legend text: 'Weak against' withCircleColor: Color orange translucent.
	legend text: 'Resistant to' withShape: (RSCircle new
			 size: 15;
			 color: Color white;
			 borderColor: Color blue translucent).

	legend build.

	canvas @ RSCanvasController.
	win := canvas openWithTitle: 'Pokemon Type Relationships'
]

{ #category : 'converting' }
PokemonType >> asString [
	^ typeName
]

{ #category : 'accessing' }
PokemonType >> resistantTo [

	^ resistantTo
]

{ #category : 'accessing' }
PokemonType >> resistantTo: aCollection [ 
	resistantTo := aCollection.
]

{ #category : 'accessing' }
PokemonType >> strongAgainst [

	^ strongAgainst ifNotNil: [ strongAgainst ] ifNil: [ #() ] 
]

{ #category : 'accessing' }
PokemonType >> strongAgainst: aCollection [

		strongAgainst := aCollection
]

{ #category : 'var accessors' }
PokemonType >> typeName: aString [ 
	typeName := aString
]

{ #category : 'accessing' }
PokemonType >> vulnerableTo [
	^ vulnerableTo
]

{ #category : 'accessing' }
PokemonType >> vulnerableTo: aCollection [ 
	vulnerableTo := aCollection
]

{ #category : 'accessing' }
PokemonType >> weakAgainst [

	^ weakAgainst
]

{ #category : 'accessing' }
PokemonType >> weakAgainst: aCollection [ 
	weakAgainst := aCollection
]
