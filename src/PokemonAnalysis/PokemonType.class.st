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

{ #category : 'as yet unclassified' }
PokemonType class >> resistantColor [
	^ Color blue translucent
]

{ #category : 'accessing' }
PokemonType class >> start [

	<script>
	| pokemonTypes canvas shapes hlVulnerableTo hlWeakAgainst hlResistantTo hlStrongAgainst pokemonDictionary sortedPokemonTypes legend sl vl wl rl win len legendBezierPoints toBox fromBox vShapes vCompositeShape wCompositeShape vCircle vFromBox vToBox wShapes |
	pokemonTypes := self readTypesFromCSV:
		                'pharo-local/iceberg/fuhrmanator/PokemonAnalysis/src/Relationships.csv'.

	sortedPokemonTypes := pokemonTypes asSortedCollection: [ :a :b |
		                      a asString <= b asString ].

	pokemonDictionary := Dictionary new.
	pokemonTypes do: [ :t | pokemonDictionary at: t asString put: t ].

	legendBezierPoints := {
		                      (0 @ 0).
		                      (6 @ -1).
		                      (10 @ 16).
		                      (15 @ 15) }.

	Transcript
		show: 'legendBezierPoints first: ';
		show: legendBezierPoints first;
		cr.
	Transcript
		show: 'legendBezierPoints last: ';
		show: legendBezierPoints last;
		cr.

	canvas := RSCanvas new.
	shapes := RSCircle models: sortedPokemonTypes.
	shapes
		size: 50;
		color: Color white.
	"RSGroup doesn't understand border:"
	shapes do: [ :s |
		s border: (RSBorder new
				 width: 1;
				 color: Color gray translucent) ].

	"shapes @ RSPopup."
	shapes @ RSLabeled middle.

	"Strong against (opposite of Vulnerable to)"
	hlStrongAgainst := RSHighlightable new.
	hlStrongAgainst highlightColor: self strongColor.
	"Don't include outgoing Beziers"
	hlStrongAgainst highlightShapes: [ :s |
		| list |
		list := (s outgoingLines select: [ :l | l class name = 'RSLine' ])
			        as: RSGroup.
		list ].
	shapes @ hlStrongAgainst.

	"Vulnerable to (opposite of Strong against)"
	hlVulnerableTo := RSHighlightable new.
	hlVulnerableTo highlightColor: self vulnerableColor.

	"withIncomingLinesOnly doesn't exist, so we make it"
	hlVulnerableTo highlightShapes: [ :s |
		| list |
		"only collect regular lines -- beziers are another type of incoming"
		list := (s incomingLines select: [ :l | l class name = 'RSLine' ])
			        as: RSGroup.
		"list addAll: (s outgoingLines collect: #to)."
		"Add shape if its vulnerable to itself"
		(s model vulnerableTo includes: s model asString) ifTrue: [
			list add: s ].
		list ].
	shapes @ hlVulnerableTo.

	"Weak against (opposite of Resistant to)"
	hlWeakAgainst := RSHighlightable new.
	hlWeakAgainst highlightColor: self weakColor.
	hlWeakAgainst highlightShapes: [ :s |
		| list |
		"collect the RSBezier outgoing lines"
		list := (s outgoingLines select: [ :l | l class name ~= 'RSLine' ])
			        as: RSGroup.

		"Add shape if its weakAgainst itself"
		(s model weakAgainst includes: s model asString) ifTrue: [
			list add: s ].

		list ].

	shapes @ hlWeakAgainst.

	"Resistant to (opposite of weak against)"
	hlResistantTo := RSHighlightable new.
	hlResistantTo highlightColor: self resistantColor.

	hlResistantTo highlightShapes: [ :s |
		| list |
		"collect the RSBezier outgoing lines"
		list := (s incomingLines select: [ :l | l class name ~= 'RSLine' ])
			        as: RSGroup.

		"Add shape if its resistant to itself"
		"(s model resistantTo includes: s model asString) ifTrue: [
			list add: s ]."
		list ].

	shapes @ hlResistantTo.

	canvas addAll: shapes.
	len := 4.

	"make lines for relationships"

	"strongAgainst/vulnerableTo"
	RSLineBuilder line
		color: Color transparent;
		width: len * 2;
		markerEnd: (RSShapeFactory arrow
				 size: len * 4;
				 color: Color transparent);
		attachPoint: (RSBorderAttachPoint new endOffset: len);
		shapes: shapes;
		connectToAll: [ :t |
		t strongAgainst collect: [ :n | pokemonDictionary at: n ] ].

	"weakAgainst/resistantTo"
	RSLineBuilder directedBezier
		color: Color transparent;
		width: len / 2;
		markerEnd: (RSShapeFactory arrow
				 size: len;
				 color: Color transparent);
		attachPoint: (RSBorderAttachPoint new endOffset: len);
		shapes: shapes;
		connectToAll: [ :t |
		t weakAgainst collect: [ :n | pokemonDictionary at: n ] ].



	"first node should be at top (12 o'clock)"
	RSCircleLayout new
		initialAngleInDegree: -90;
		on: shapes.

	legend := RSLegend new.
	legend container: canvas.
	legend title: 'Legend (mouse over a type)'.

	toBox := RSBox new size: 0.
	fromBox := toBox copy.
	sl := RSLine new
		      width: 4;
		      color: self strongColor;
		      from: fromBox;
		      to: toBox. "legendBezierPoints first" "legendBezierPoints last"
	toBox translateBy: legendBezierPoints last.
	"sl inspect."
	legend text: 'Strong against' withShape: sl.

	rl := RSBezier new
		      width: 2;
		      color: self resistantColor;
		      controlPoints: legendBezierPoints.
	legend text: 'Resistant to' withShape: rl.


	vShapes := RSGroup new.
	vShapes add: (RSCircle new
			 radius: 8;
			 color: self vulnerableColor).
	vShapes add: (RSBezier new
			 width: 4;
			 color: self vulnerableColor;
			 controlPoints: {legendBezierPoints first . legendBezierPoints last}).
	RSGridLayout new
		gapSize: 0;
		lineItemsCount: 1;
		on: vShapes.
	vCompositeShape := RSComposite new
		                   shapes: vShapes;
		                   yourself.

	legend text: 'Vulnerable to' withShape: vCompositeShape.

	wShapes := RSGroup new.
	wl := RSBezier new
		      width: 2;
		      color: self weakColor;
		      controlPoints: legendBezierPoints.
	wShapes add: (RSCircle new radius: 8; color: self weakColor).
	wShapes add: wl.
	RSGridLayout new
		gapSize: 0;
		lineItemsCount: 1;
		on: wShapes.
	wCompositeShape := RSComposite new
		                   shapes: wShapes;
		                   yourself.
	legend
		text: 'Weak against' withShape: wCompositeShape.

	legend build.

	canvas @ RSCanvasController.
	win := canvas openWithTitle: 'Pokemon Type Relationships'
]

{ #category : 'as yet unclassified' }
PokemonType class >> strongColor [ 

	^ Color green translucent
]

{ #category : 'as yet unclassified' }
PokemonType class >> vulnerableColor [ 

	^ Color red translucent
]

{ #category : 'as yet unclassified' }
PokemonType class >> weakColor [ 

	^ Color orange translucent
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
