MAFileModel subclass: MAFileModelStub [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>
]



Grease.GRPackage class extend [

    magritteTestsModel [
	<category: '*magritte-tests-model'>
	^(self new)
	    name: 'Magritte-Tests-Model';
	    description: 'Unit tests for the Magritte metamodel.';
	    addDependency: 'Magritte-Model';
	    url: #magritteUrl;
	    yourself
    ]

]



TestCase subclass: MAAdaptiveModelTest [
    | scaffolder |
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Models'>

    descriptions [
	<category: 'accessing'>
	^self scaffolder magritteDescription children
    ]

    scaffolder [
	<category: 'accessing'>
	^scaffolder
    ]

    setUp [
	<category: 'running'>
	scaffolder := MAAdaptiveModel new.
	(scaffolder magritteDescription)
	    add: MAStringDescription new;
	    add: MANumberDescription new.
	scaffolder write: 'foo' using: self descriptions first.
	scaffolder write: 123 using: self descriptions second
    ]

    testRead [
	<category: 'tests'>
	self assert: (self scaffolder readUsing: self descriptions first) = 'foo'.
	self assert: (self scaffolder readUsing: self descriptions second) = 123
    ]

    testWrite [
	<category: 'tests'>
	self scaffolder write: 'bar' using: self descriptions first.
	self scaffolder write: 321 using: self descriptions second.
	self assert: (self scaffolder readUsing: self descriptions first) = 'bar'.
	self assert: (self scaffolder readUsing: self descriptions second) = 321
    ]
]



TestCase subclass: MAConditionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Utility'>

    testConjunctive [
	<category: 'tests'>
	| condition |
	condition := (MACondition selector: #isInteger) 
		    & (MACondition selector: #positive).
	self assert: (condition value: 1).
	self deny: (condition value: 1.5).
	self deny: (condition value: -1).
	self deny: (condition value: -1.5)
    ]

    testDisjunctive [
	<category: 'tests'>
	| condition |
	condition := (MACondition selector: #isInteger) 
		    | (MACondition selector: #positive).
	self assert: (condition value: 1).
	self assert: (condition value: 1.5).
	self assert: (condition value: -1).
	self deny: (condition value: -1.5)
    ]

    testNegation [
	<category: 'tests'>
	| condition |
	condition := (MACondition selector: #isInteger) not.
	self assert: (condition value: 0.6).
	self deny: (condition value: 1)
    ]

    testReceiverSelector [
	<category: 'tests'>
	| condition |
	condition := MACondition receiver: 1 selector: #=.
	self assert: (condition value: 1).
	self deny: (condition value: 0)
    ]

    testSelector [
	<category: 'tests'>
	| condition |
	condition := MACondition selector: #isInteger.
	self assert: (condition value: -1).
	self assert: (condition value: 1).
	self deny: (condition value: 0.5)
    ]

    testSelectorArgument [
	<category: 'tests'>
	| condition |
	condition := MACondition selector: #< argument: 5.
	self assert: (condition value: 1).
	self deny: (condition value: 5)
    ]
]



TestCase subclass: MADerivedDescriptions [
    | baseModel derivedModel |
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Utility'>

    setUp [
	<category: 'running'>
	super setUp.
	baseModel := MAMockAddress new.
	derivedModel := MAMockAddress2 new
    ]

    testContainer [
	<category: 'tests'>
	self 
	    assert: (baseModel magritteDescription hasProperty: #addressContainerBase).
	self assert: (derivedModel magritteDescription 
		    hasProperty: #addressContainerDerived)
    ]

    testDescription [
	<category: 'tests'>
	| baseDescription derivedDescription |
	baseDescription := baseModel magritteDescription 
		    detect: [:each | each accessor selector = #street].
	self assert: baseDescription isRequired not.
	derivedDescription := derivedModel magritteDescription 
		    detect: [:each | each accessor selector = #street].
	self assert: derivedDescription isRequired
    ]
]



TestCase subclass: MADescriptionBuilderTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Utility'>

    descriptionContainer [
	<category: 'acessing-magritte'>
	<magritteContainer>
	^super descriptionContainer label: 'mock'
    ]

    descriptionContainer: aDescription [
	<category: 'acessing-magritte'>
	<magritteContainer>
	^aDescription
	    propertyAt: #bar put: nil;
	    yourself
    ]

    descriptionContainerFoo: aDescription [
	<category: 'acessing-magritte'>
	<magritteContainer>
	^aDescription
	    propertyAt: #foo put: nil;
	    yourself
    ]

    descriptionDescription [
	<category: 'acessing-magritte'>
	<magritteDescription>
	^(MAToOneRelationDescription new)
	    label: 'foo';
	    accessor: MADictionaryAccessor new;
	    yourself
    ]

    descriptionDescription: aDescription [
	<category: 'acessing-magritte'>
	<magritteDescription: #descriptionDescription>
	^aDescription
	    propertyAt: #foo put: nil;
	    yourself
    ]

    descriptionDescriptionBar: aDescription [
	<category: 'acessing-magritte'>
	<magritteDescription: #descriptionDescription>
	^aDescription
	    propertyAt: #bar put: nil;
	    yourself
    ]

    descriptionDescriptionRec: aDescription [
	<category: 'acessing-magritte'>
	<magritteDescription: #descriptionDescription>
	^aDescription reference: self magritteDescription
    ]

    testContainer [
	<category: 'tests'>
	self assert: self magritteDescription label = 'mock'.
	self assert: (self magritteDescription hasProperty: #foo).
	self assert: (self magritteDescription hasProperty: #bar)
    ]

    testDescription [
	<category: 'tests'>
	self assert: self magritteDescription size = 1.
	self assert: self magritteDescription children first label = 'foo'.
	self assert: (self magritteDescription children first hasProperty: #foo).
	self assert: (self magritteDescription children first hasProperty: #bar)
    ]

    testExtension [
	<category: 'tests'>
	| description |
	description := MAMockAddress new magritteDescription 
		    detect: [:each | each accessor selector = #place].
	self assert: description isRequired.
	self assert: description isVisible not
    ]

    testNilled [
	<category: 'tests'>
	| description |
	description := MAMockAddress new magritteDescription.
	self assert: description size = 3
    ]

    testRecursive [
	<category: 'tests'>
	self assert: self magritteDescription children first reference 
		    = self magritteDescription
    ]
]



TestCase subclass: MAExtensionsTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Utility'>

    does: aCollection haveEqualElementsTo: anotherCollection [
	<category: 'helpers'>
	aCollection size = anotherCollection size ifFalse: [^false].
	1 to: aCollection size
	    do: 
		[:index | 
		(aCollection at: index) = (anotherCollection at: index) ifFalse: [^false]].
	^true
    ]

    testAsString [
	<category: 'tests-string'>
	self assert: Object new greaseString = Object new printString.
	self assert: 'Hello World' greaseString = 'Hello World'.
	self assert: 123 greaseString = '123'
    ]

    testCopyWithAll [
	<category: 'tests-collection'>
	| col res |
	col := #(#a #b).
	res := col copyWithAll: #(#c #d).
	self assert: res = #(#a #b #c #d).
	self deny: col == res.
	col := Set with: #a with: #b.
	res := col copyWithAll: #(#c #d).
	self assert: res size = 4.
	self assert: (res includes: #a).
	self assert: (res includes: #b).
	self assert: (res includes: #c).
	self assert: (res includes: #d).
	self deny: col == res.
	col := OrderedCollection with: #a with: #b.
	res := col copyWithAll: #(#c #d).
	self 
	    assert: res = (OrderedCollection 
			    with: #a
			    with: #b
			    with: #c
			    with: #d).
	self deny: col == res
    ]

    testCopyWithoutFirst [
	<category: 'tests-collection'>
	| col res |
	col := #(#a #b #a #c).
	res := col copyWithoutFirstOccurrenceOf: #a.
	self assert: res = #(#b #a #c).
	self deny: col == res.
	col := Set 
		    with: #a
		    with: #b
		    with: #c.
	res := col copyWithoutFirstOccurrenceOf: #a.
	self assert: res size = 2.
	self assert: (res includes: #b).
	self assert: (res includes: #c).
	self deny: col == res
    ]

    testFileSize [
	<category: 'tests-integer'>
	self assert: 1000 asFileSize = '1000 B'.
	self assert: 1024 asFileSize = '1 KB'.
	self assert: (1000 * 1000) asFileSize = '976 KB'.
	self assert: (1024 * 1024) asFileSize = '1 MB'.
	self assert: (1000 * 1000 * 1000) asFileSize = '953 MB'.
	self assert: (1024 * 1024 * 1024) asFileSize = '1 GB'.
	self assert: (1000 * 1000 * 1000 * 1000) asFileSize = '931 GB'.
	self assert: (1024 * 1024 * 1024 * 1024) asFileSize = '1 TB'

	"etc"
    ]

    testHasEqualElements [
	<category: 'tests-collection'>
	| one two |
	one := #(1 2 3).
	two := #(1 2 3) asOrderedCollection.
	self assert: (self does: one haveEqualElementsTo: two).
	self assert: (self does: two haveEqualElementsTo: one).
	two := #(1 2 4).
	self deny: (self does: one haveEqualElementsTo: two).
	self deny: (self does: two haveEqualElementsTo: one).
	two := #(1 2 3 4).
	self deny: (self does: one haveEqualElementsTo: two).
	self deny: (self does: two haveEqualElementsTo: one)
    ]

    testIntersection [
	<category: 'tests-collection'>
	| group |
	group := #(1 2 3).
	self 
	    assert: (self does: (group intersection: group) haveEqualElementsTo: group).
	self 
	    assert: (self does: (group intersection: #()) haveEqualElementsTo: #()).
	self 
	    assert: (self does: (group intersection: #(4 5)) haveEqualElementsTo: #()).
	self assert: (self does: (group intersection: #(1 3 4 5))
		    haveEqualElementsTo: #(1 3)).
	self 
	    assert: (self does: (group intersection: #(2)) haveEqualElementsTo: #(2))
    ]

    testIsCollection [
	<category: 'tests-collection'>
	self deny: Object new isCollection.
	self deny: nil isCollection.
	self deny: 123 isCollection.
	self assert: 'abc' isCollection.
	self assert: #(#a #b #c) isCollection
    ]

    testIsUnary [
	<category: 'tests-string'>
	self assert: #testIsUnary isUnary.
	self deny: #+ isUnary.
	self deny: #with:with: isUnary
    ]

    testLines [
	<category: 'tests-string'>
	self assert: '' lines = #().
	self assert: 'foo' lines = #('foo').
	self assert: ('foo' , (String with: Character cr) , 'bar') lines 
		    = #('foo' 'bar').
	self 
	    assert: ('foo' , (String with: Character cr with: Character lf) , 'bar') 
		    lines = #('foo' 'bar')
    ]

    testMatches [
	<category: 'tests-string'>
	self assert: ('' matches: '').
	self assert: ('zort' matches: '').
	self assert: ('zort' matches: 'o').
	self assert: ('zort' matches: 'O').
	self assert: ('zort' matches: '*').
	self assert: ('mobaz' matches: '*baz').
	self deny: ('mobazo' matches: '*baz').
	self assert: ('mobazo' matches: '*baz*').
	self deny: ('mozo' matches: '*baz*').
	self assert: ('foozo' matches: 'foo*').
	self deny: ('bozo' matches: 'foo*').
	self assert: ('foo23baz' matches: 'foo*baz').
	self assert: ('foobaz' matches: 'foo*baz').
	self deny: ('foo23bazo' matches: 'foo*baz').
	self assert: ('Foo' matches: 'foo').
	self deny: ('foobazort' matches: 'foo*baz*zort').
	self assert: ('foobazzort' matches: 'foo*baz*zort').
	self assert: ('afoo3zortthenfoo3zort' matches: '*foo#zort').
	self assert: ('afoodezortorfoo3zort' matches: '*foo*zort')
    ]

    testMoveDown [
	<category: 'tests-collection'>
	| col |
	col := Array 
		    with: 1
		    with: 2
		    with: 3.
	self assert: (col moveDown: 1) = 2.
	self assert: col = #(2 1 3).
	self assert: (col moveDown: 1) = 3.
	self assert: col = #(2 3 1).
	self assert: (col moveDown: 1) = 3.
	self assert: col = #(2 3 1).
	self assert: (col moveDown: 0) = 0.
	self assert: col = #(2 3 1)
    ]

    testMoveUp [
	<category: 'tests-collection'>
	| col |
	col := Array 
		    with: 1
		    with: 2
		    with: 3.
	self assert: (col moveUp: 3) = 2.
	self assert: col = #(1 3 2).
	self assert: (col moveUp: 3) = 1.
	self assert: col = #(3 1 2).
	self assert: (col moveUp: 3) = 1.
	self assert: col = #(3 1 2).
	self assert: (col moveUp: 0) = 0.
	self assert: col = #(3 1 2)
    ]

    testReduce [
	<category: 'tests-collection'>
	self should: [#() reduce: [:a :b | a]] raise: Error.
	self assert: ((1 to: 9) reduce: [:a :b | a]) = 1.
	self assert: ((1 to: 9) reduce: [:a :b | b]) = 9.
	self assert: ((1 to: 9) reduce: [:a :b | a + b]) = 45.
	self assert: ((1 to: 9) reduce: [:a :b | a * b]) = 362880.
	self assert: (#('a' 'b' 'c') reduce: [:a :b | a , ' ' , b]) = 'a b c'.
	self assert: (#('a' 'b' 'c') reduce: [:a :b | b , ' ' , a]) = 'c b a'
    ]

    testSort [
	<category: 'tests-collection'>
	| array |
	array := Array 
		    with: 2
		    with: 3
		    with: 1.
	array sort: [:a :b | a < b].
	self assert: (self does: array haveEqualElementsTo: #(1 2 3)).
	array sort: [:a :b | a > b].
	self assert: (self does: array haveEqualElementsTo: #(3 2 1))
    ]

    testSubstringCaseSensitive [
	<category: 'tests-string'>
	self deny: ('' includesSubstring: '' caseSensitive: true).
	self deny: ('' includesSubstring: '' caseSensitive: false).
	self deny: ('abc' includesSubstring: '' caseSensitive: true).
	self deny: ('abc' includesSubstring: '' caseSensitive: false).
	self deny: ('' includesSubstring: 'abc' caseSensitive: true).
	self deny: ('' includesSubstring: 'abc' caseSensitive: false).
	self deny: ('abc' includesSubstring: 'aa' caseSensitive: true).
	self deny: ('abc' includesSubstring: 'cc' caseSensitive: false).
	self deny: ('abc' includesSubstring: 'aB' caseSensitive: true).
	self assert: ('abc' includesSubstring: 'a' caseSensitive: true).
	self assert: ('abc' includesSubstring: 'c' caseSensitive: false).
	self assert: ('abc' includesSubstring: 'aB' caseSensitive: false).
	self assert: ('abc' includesSubstring: 'AbC' caseSensitive: false).
	self assert: ('abc' includesSubstring: 'ABC' caseSensitive: false).
	self assert: ('abc' includesSubstring: 'aBc' caseSensitive: false)
    ]

    testTimePrintOn [
	<category: 'tests-time'>
	| stream |
	stream := String new writeStream.
	Time now 
	    print24: true
	    showSeconds: true
	    on: stream.
	self assert: stream contents size = 8.
	self assert: (stream contents at: 3) = $:.
	self assert: (stream contents at: 6) = $:
    ]

    testValidationError [
	<category: 'tests-errors'>
	| result |
	result := [MARequiredError signal: 'some message'] on: MARequiredError
		    do: [:err | err return: err greaseString].
	self assert: result = 'some message'.
	result := 
		[MARequiredError description: ((MAStringDescription new)
			    label: 'label';
			    yourself)
		    signal: 'some message'] 
			on: MARequiredError
			do: [:err | err return: err greaseString].
	self assert: result = 'label: some message'
    ]
]



TestCase subclass: MAFileModelTest [
    | model |
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Models'>

    MAFileModelTest class >> isAbstract [
	<category: 'testing'>
	^self name = #MAFileModelTest
    ]

    actualClass [
	<category: 'private'>
	^self subclassResponsibility
    ]

    setUp [
	<category: 'running'>
	super setUp.
	model := self actualClass new
    ]

    tearDown [
	<category: 'running'>
	model finalize
    ]

    testComparing [
	<category: 'tests'>
	| other |
	other := self actualClass new.
	other
	    filename: 'something.dat';
	    contents: (ByteArray 
			with: 1
			with: 2
			with: 3).
	self assert: model = model.
	self deny: model = other.
	self deny: other = model.
	other finalize	"should be in tearDown;  for now, at least let's discard when we pass"
    ]

    testContents [
	<category: 'tests'>
	self assert: model contents isEmpty.
	model contents: (ByteArray 
		    with: 1
		    with: 2
		    with: 3).
	self 
	    assert: model contents = (ByteArray 
			    with: 1
			    with: 2
			    with: 3).
	self assert: model filesize = 3
    ]

    testFilename [
	<category: 'tests'>
	self assert: model filename = 'unknown'.
	self assert: model extension isEmpty.
	model filename: 'test.txt'.
	self assert: model filename = 'test.txt'.
	self assert: model extension = 'txt'
    ]

    testIsEmpty [
	<category: 'tests'>
	self assert: model isEmpty.
	model filename: 'foo.txt'.
	self assert: model isEmpty.
	model mimetype: 'text/plain'.
	self assert: model isEmpty.
	model contents: 'hello'.
	self deny: model isEmpty
    ]

    testMimetype [
	<category: 'tests'>
	self assert: model mimetype = 'application/octet-stream'.
	self assert: model maintype = 'application'.
	self assert: model subtype = 'octet-stream'.
	model mimetype: 'text/html'.
	self assert: model mimetype = 'text/html'.
	self assert: model maintype = 'text'.
	self assert: model subtype = 'html'
    ]

    testMimetypeApplication [
	<category: 'tests'>
	model mimetype: 'application/pdf'.
	self assert: model isApplication.
	self deny: model isAudio.
	self deny: model isImage.
	self deny: model isText.
	self deny: model isVideo
    ]

    testMimetypeAudio [
	<category: 'tests'>
	model mimetype: 'audio/mpeg'.
	self deny: model isApplication.
	self assert: model isAudio.
	self deny: model isImage.
	self deny: model isText.
	self deny: model isVideo
    ]

    testMimetypeDefault [
	<category: 'tests'>
	self assert: model isApplication.
	self deny: model isAudio.
	self deny: model isImage.
	self deny: model isText.
	self deny: model isVideo
    ]

    testMimetypeImage [
	<category: 'tests'>
	model mimetype: 'image/png'.
	self deny: model isApplication.
	self deny: model isAudio.
	self assert: model isImage.
	self deny: model isText.
	self deny: model isVideo
    ]

    testMimetypeText [
	<category: 'tests'>
	model mimetype: 'text/xml'.
	self deny: model isApplication.
	self deny: model isAudio.
	self deny: model isImage.
	self assert: model isText.
	self deny: model isVideo
    ]

    testMimetypeVideo [
	<category: 'tests'>
	model mimetype: 'video/mpeg'.
	self deny: model isApplication.
	self deny: model isAudio.
	self deny: model isImage.
	self deny: model isText.
	self assert: model isVideo
    ]
]



MAFileModelTest subclass: MAMemoryFileModelTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Models'>

    actualClass [
	<category: 'private'>
	^MAMemoryFileModel
    ]
]



TestCase subclass: MAObjectTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Core'>

    MAObjectTest class >> buildTestClassFor: aClass [
	"Utility method to create test cases for each object. Use like:
	 
	 self buildTestClassFor: MAObject"

	<category: 'building'>
	| thisName thisClass thisCategory parentClass |
	thisName := (aClass name , 'Test') asSymbol.
	(thisName beginsWith: 'MA') ifFalse: [^self].
	thisClass := GRPlatform current magritteClassNamed: thisName.
	thisCategory := 'Magritte-Tests-Model-' 
		    , (aClass category copyAfterLast: $-).
	parentClass := self = thisClass 
		    ifTrue: [self superclass]
		    ifFalse: 
			[GRPlatform current 
			    magritteClassNamed: (aClass superclass name , 'Test') asSymbol].
	thisClass := parentClass 
		    subclass: thisName
		    instanceVariableNames: (thisClass isNil 
			    ifFalse: [thisClass instanceVariablesString]
			    ifTrue: [String new])
		    classVariableNames: ''
		    poolDictionaries: ''
		    category: thisCategory.
	thisClass compile: 'actualClass
	^ ' , aClass name classified: #private.
	thisClass class compile: 'isAbstract
	^ ' , aClass isAbstract greaseString
	    classified: #testing.
	aClass subclassesDo: [:each | self buildTestClassFor: each]
    ]

    MAObjectTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    MAObjectTest class >> packageNamesUnderTest [
	<category: 'accessing'>
	^#('Magritte-Model')
    ]

    MAObjectTest class >> shouldInheritSelectors [
	<category: 'testing'>
	^true
    ]

    actualClass [
	<category: 'private'>
	^MAObject
    ]

    instance [
	<category: 'accessing'>
	self subclassResponsibility
    ]

    testCopy [
	<category: 'tests-copying'>
	self assert: self instance = self instance copy.
	self deny: self instance == self instance copy
    ]

    testCopyProperties [
	<category: 'tests-copying'>
	self deny: self instance properties == self instance copy properties
    ]

    testEqual [
	<category: 'tests-comparing'>
	self assert: self instance = self instance.
	self assert: self instance = self instance copy.
	self assert: self instance copy = self instance.
	self deny: self instance = 123.
	self deny: self instance = String new
    ]

    testHash [
	<category: 'tests-comparing'>
	self assert: self instance hash isInteger.
	self assert: self instance hash = self instance hash.
	self assert: self instance hash = self instance copy hash
    ]

    testIsDescription [
	<category: 'tests-testing'>
	self deny: self instance isDescription
    ]

    testProperties [
	<category: 'tests-properties'>
	self assert: self instance properties notNil.
	self instance instVarNamed: 'properties' put: nil.
	self instance propertyAt: #foo put: #bar.
	self instance instVarNamed: 'properties' put: nil.
	self instance propertyAt: #foo ifAbsent: [nil].
	self instance instVarNamed: 'properties' put: nil.
	self instance propertyAt: #foo ifAbsentPut: [#bar].
	self instance instVarNamed: 'properties' put: nil.
	self instance hasProperty: #foo.
	self instance instVarNamed: 'properties' put: nil
    ]

    testPropertiesAt [
	<category: 'tests-properties'>
	self assert: (self instance propertyAt: #foo put: 'bar') = 'bar'.
	self assert: (self instance propertyAt: #foo) = 'bar'.
	self should: [self instance propertyAt: #bar] raise: MAPropertyError
    ]

    testPropertiesAtIfAbsent [
	<category: 'tests-properties'>
	self assert: (self instance propertyAt: #foo put: 'bar') = 'bar'.
	self assert: (self instance propertyAt: #foo ifAbsent: ['baz']) = 'bar'.
	self assert: (self instance propertyAt: #bar ifAbsent: ['baz']) = 'baz'
    ]

    testPropertiesAtIfAbsentPut [
	<category: 'tests-properties'>
	self assert: (self instance propertyAt: #foo put: 'bar') = 'bar'.
	self assert: (self instance propertyAt: #foo ifAbsentPut: ['baz']) = 'bar'.
	self assert: (self instance propertyAt: #foo) = 'bar'.
	self assert: (self instance propertyAt: #bar ifAbsentPut: ['baz']) = 'baz'.
	self assert: (self instance propertyAt: #bar) = 'baz'
    ]

    testPropertiesAtIfPresent [
	<category: 'tests-properties'>
	self 
	    assert: (self instance propertyAt: #foo
		    ifPresent: [:value | self assert: false]) isNil.
	self instance propertyAt: #foo put: 1.
	self 
	    assert: (self instance propertyAt: #foo
		    ifPresent: 
			[:value | 
			self assert: value = 1.
			2]) = 2
    ]

    testPropertiesAtPut [
	<category: 'tests-properties'>
	self instance propertyAt: #foo put: 'bar'.
	self assert: (self instance propertyAt: #foo) = 'bar'.
	self instance propertyAt: #foo put: 'baz'.
	self assert: (self instance propertyAt: #foo) = 'baz'
    ]

    testPropertiesHas [
	<category: 'tests-properties'>
	self deny: (self instance hasProperty: #foo).
	self instance propertyAt: #foo put: 'bar'.
	self assert: (self instance hasProperty: #foo).
	self deny: (self instance hasProperty: #bar)
    ]

    testSanity [
	"If this test case fails, there is something wrong with the setup of the test-case."

	<category: 'tests'>
	self assert: self actualClass isAbstract not
	    description: 'Unable to test abstract class.'.
	self assert: self instance class = self actualClass
	    description: 'Invalid test instance.'
    ]
]



MAObjectTest subclass: MAAccessorTest [
    | accessor value |
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MAAccessorTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    accessor [
	<category: 'accessing'>
	^accessor
    ]

    accessorInstance [
	<category: 'private'>
	self subclassResponsibility
    ]

    actualClass [
	<category: 'private'>
	^MAAccessor
    ]

    instance [
	<category: 'accessing'>
	^accessor
    ]

    setUp [
	<category: 'running'>
	super setUp.
	accessor := self accessorInstance
    ]

    testAsAccessor [
	<category: 'tests-identity'>
	self assert: self instance asAccessor = self instance.
	self assert: self instance asAccessor == self instance
    ]

    testCanRead [
	<category: 'tests-testing'>
	self subclassResponsibility
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self subclassResponsibility
    ]

    testRead [
	<category: 'tests'>
	self subclassResponsibility
    ]

    testStore [
	<category: 'tests-identity'>
	| evaluator |
	evaluator := GRPlatform current 
		    magritteEvaluatorClassFor: self actualClass.
	self 
	    assert: (evaluator evaluate: self accessor storeString) = self accessor
    ]

    testWrite [
	<category: 'tests'>
	self subclassResponsibility
    ]

    value [
	<category: 'accessing-model'>
	^value
    ]

    value: anObject [
	<category: 'accessing-model'>
	value := anObject
    ]
]



MAAccessorTest subclass: MADelegatorAccessorTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MADelegatorAccessorTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    accessorInstance [
	<category: 'private'>
	^self actualClass on: (MASelectorAccessor selector: #value)
    ]

    actualClass [
	<category: 'private'>
	^MADelegatorAccessor
    ]

    testCanRead [
	<category: 'tests-testing'>
	self assert: (self accessor canRead: self).
	self accessor next readSelector: #zork.
	self deny: (self accessor canRead: self)
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self assert: (self accessor canWrite: self).
	self accessor next writeSelector: #zork:.
	self deny: (self accessor canWrite: self)
    ]

    testRead [
	<category: 'tests'>
	self value: 123.
	self assert: (self accessor read: self) = 123.
	self value: '123'.
	self assert: (self accessor read: self) = '123'
    ]

    testWrite [
	<category: 'tests'>
	self accessor write: 123 to: self.
	self assert: self value = 123.
	self accessor write: '123' to: self.
	self assert: self value = '123'
    ]
]



MADelegatorAccessorTest subclass: MAChainAccessorTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MAChainAccessorTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    accessorInstance [
	<category: 'private'>
	^self actualClass accessors: #(#holder #contents #value)
    ]

    actualClass [
	<category: 'private'>
	^MAChainAccessor
    ]

    holder [
	<category: 'private'>
	^MAValueHolder on: self
    ]

    testAccessor [
	<category: 'tests'>
	self accessor accessor: self.
	self assert: self accessor accessor = self
    ]

    testAsAccessor [
	<category: 'tests'>
	super testAsAccessor.
	accessor := #(#value) asAccessor.
	self assert: (accessor isKindOf: MASelectorAccessor).
	self assert: accessor selector = #value.
	accessor := #(#value #contents) asAccessor.
	self assert: (accessor isKindOf: MAChainAccessor).
	self assert: (accessor next isKindOf: MASelectorAccessor).
	self assert: accessor next selector = #value.
	self assert: (accessor accessor isKindOf: MASelectorAccessor).
	self assert: accessor accessor selector = #contents
    ]

    testCanRead [
	<category: 'tests-testing'>
	self assert: (self accessor canRead: self).
	self accessor accessor accessor readSelector: #zork.
	self deny: (self accessor canRead: self)
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self assert: (self accessor canWrite: self).
	self accessor accessor accessor writeSelector: #zork.
	self deny: (self accessor canWrite: self)
    ]

    testKind [
	<category: 'tests'>
	self assert: self accessor class = MAChainAccessor.
	self assert: self accessor next class = MASelectorAccessor.
	self assert: self accessor accessor class = MAChainAccessor.
	self assert: self accessor accessor next class = MASelectorAccessor.
	self assert: self accessor accessor accessor class = MASelectorAccessor
    ]

    testNext [
	<category: 'tests'>
	| next |
	next := #foo asAccessor.
	self accessor next: next.
	self assert: self accessor next = next
    ]

    testRead [
	<category: 'tests'>
	self value: 123.
	self assert: (self accessor read: self) = 123.
	self value: '12'.
	self assert: (self accessor read: self) = '12'
    ]

    testSelector [
	<category: 'tests'>
	self assert: self accessor next selector = #holder.
	self assert: self accessor accessor next selector = #contents.
	self assert: self accessor accessor accessor selector = #value
    ]

    testWrite [
	<category: 'tests'>
	self accessor write: 123 to: self.
	self assert: self value = 123.
	self accessor write: '123' to: self.
	self assert: self value = '123'
    ]
]



MAAccessorTest subclass: MADictionaryAccessorTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MADictionaryAccessorTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    accessorInstance [
	<category: 'private'>
	^self actualClass key: #value
    ]

    actualClass [
	<category: 'private'>
	^MADictionaryAccessor
    ]

    at: aKey ifAbsent: aBlock [
	<category: 'accessing'>
	^aKey = #value ifTrue: [value] ifFalse: [aBlock value]
    ]

    at: aKey put: aValue [
	<category: 'accessing'>
	self assert: aKey = #value.
	^value := aValue
    ]

    testCanRead [
	<category: 'tests-testing'>
	self assert: (self accessor canRead: self).
	self accessor key: #zork.
	self assert: (self accessor canRead: self)
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self assert: (self accessor canWrite: self)
    ]

    testKey [
	<category: 'tests'>
	self accessor key: #other.
	self assert: self accessor key = #other
    ]

    testRead [
	<category: 'tests'>
	self value: 123.
	self assert: (self accessor read: self) = 123.
	self value: '12'.
	self assert: (self accessor read: self) = '12'
    ]

    testWrite [
	<category: 'tests'>
	self accessor write: 123 to: self.
	self assert: self value = 123.
	self accessor write: '123' to: self.
	self assert: self value = '123'
    ]
]



MAAccessorTest subclass: MAIdentityAccessorTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MAIdentityAccessorTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    accessorInstance [
	<category: 'private'>
	^self actualClass new
    ]

    actualClass [
	<category: 'private'>
	^MAIdentityAccessor
    ]

    testCanRead [
	<category: 'tests-testing'>
	self assert: (self accessor canRead: self)
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self deny: (self accessor canWrite: self)
    ]

    testRead [
	<category: 'tests'>
	self assert: (self accessor read: 123) = 123
    ]

    testWrite [
	<category: 'tests'>
	self should: [self accessor write: 123 to: self] raise: MAWriteError.
	self assert: self value isNil
    ]
]



MAAccessorTest subclass: MANullAccessorTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MANullAccessorTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    accessorInstance [
	<category: 'private'>
	^self actualClass new
    ]

    actualClass [
	<category: 'private'>
	^MANullAccessor
    ]

    testAsAccessor [
	<category: 'tests-identity'>
	super testAsAccessor.
	self assert: (nil asAccessor isKindOf: self actualClass)
    ]

    testCanRead [
	<category: 'tests-testing'>
	self deny: (self accessor canRead: self)
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self deny: (self accessor canWrite: nil)
    ]

    testRead [
	<category: 'tests'>
	self should: [self accessor read: self] raise: MAReadError
    ]

    testWrite [
	<category: 'tests'>
	self should: [self accessor write: 123 to: self] raise: MAWriteError.
	self assert: self value isNil
    ]
]



MAAccessorTest subclass: MAPluggableAccessorTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MAPluggableAccessorTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    accessorInstance [
	<category: 'private'>
	^self actualClass read: [:model | model value]
	    write: [:model :object | model value: object]
    ]

    actualClass [
	<category: 'private'>
	^MAPluggableAccessor
    ]

    testCanRead [
	<category: 'tests-testing'>
	self assert: (self instance canRead: self).
	self instance readBlock: nil.
	self deny: (self instance canRead: self)
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self assert: (self instance canWrite: nil).
	self assert: (self instance canWrite: 123).
	self assert: (self instance canWrite: self).
	self instance writeBlock: nil.
	self deny: (self instance canWrite: nil).
	self deny: (self instance canWrite: 123).
	self deny: (self instance canWrite: self)
    ]

    testRead [
	<category: 'tests'>
	self value: 123.
	self assert: (self accessor read: self) = 123.
	self value: '12'.
	self assert: (self accessor read: self) = '12'
    ]

    testReadBlock [
	<category: 'tests'>
	self accessor readBlock: 
		[:model | 
		self assert: model = self.
		123].
	self assert: (self accessor read: self) = 123
    ]

    testStore [
	"The class BlockContext is not serializeable, ignore this test."

	<category: 'tests-identity'>
	
    ]

    testWrite [
	<category: 'tests'>
	self accessor write: 123 to: self.
	self assert: self value = 123.
	self accessor write: '123' to: self.
	self assert: self value = '123'
    ]

    testWriteBlock [
	<category: 'tests'>
	self accessor writeBlock: 
		[:model :object | 
		self assert: model = self.
		self assert: object = 123].
	self accessor write: 123 to: self
    ]
]



MAAccessorTest subclass: MASelectorAccessorTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MASelectorAccessorTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    accessorInstance [
	<category: 'private'>
	^self actualClass selector: #value
    ]

    actualClass [
	<category: 'private'>
	^MASelectorAccessor
    ]

    testAsAccessor [
	<category: 'tests-identity'>
	super testAsAccessor.
	self assert: #value asAccessor = self instance.
	self deny: #value asAccessor == self instance
    ]

    testCanRead [
	<category: 'tests-testing'>
	self assert: (self accessor canRead: self).
	self accessor readSelector: #zork.
	self deny: (self accessor canRead: self).
	self accessor readSelector: nil.
	self deny: (self accessor canRead: self)
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self assert: (self accessor canWrite: self).
	self accessor writeSelector: #zork:.
	self deny: (self accessor canWrite: self).
	self accessor writeSelector: nil.
	self deny: (self accessor canWrite: self)
    ]

    testRead [
	<category: 'tests'>
	self value: 123.
	self assert: (self accessor read: self) = 123.
	self value: '12'.
	self assert: (self accessor read: self) = '12'
    ]

    testReadSelector [
	<category: 'tests'>
	self accessor readSelector: #contents.
	self assert: self accessor selector = #contents.
	self assert: self accessor readSelector = #contents.
	self assert: self accessor writeSelector = #value:
    ]

    testSelector [
	<category: 'tests'>
	self accessor selector: #contents.
	self assert: self accessor selector = #contents.
	self assert: self accessor readSelector = #contents.
	self assert: self accessor writeSelector = #contents:
    ]

    testWrite [
	<category: 'tests'>
	self accessor write: 123 to: self.
	self assert: self value = 123.
	self accessor write: '123' to: self.
	self assert: self value = '123'
    ]

    testWriteSelector [
	<category: 'tests'>
	self accessor writeSelector: #contents:.
	self assert: self accessor selector = #value.
	self assert: self accessor readSelector = #value.
	self assert: self accessor writeSelector = #contents:
    ]
]



MAAccessorTest subclass: MAVariableAccessorTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Accessor'>

    MAVariableAccessorTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    accessorInstance [
	<category: 'private'>
	^self actualClass name: 'value'
    ]

    actualClass [
	<category: 'private'>
	^MAVariableAccessor
    ]

    testCanRead [
	<category: 'tests-testing'>
	self assert: (self accessor canRead: self).
	self accessor name: 'zork'.
	self deny: (self accessor canRead: self)
    ]

    testCanWrite [
	<category: 'tests-testing'>
	self assert: (self accessor canWrite: self).
	self accessor name: 'zork'.
	self deny: (self accessor canWrite: self)
    ]

    testName [
	<category: 'tests'>
	self accessor name: 'other'.
	self assert: self accessor name = 'other'
    ]

    testRead [
	<category: 'tests'>
	self value: 123.
	self assert: (self accessor read: self) = 123.
	self value: '12'.
	self assert: (self accessor read: self) = '12'
    ]

    testWrite [
	<category: 'tests'>
	self accessor write: 123 to: self.
	self assert: self value = 123.
	self accessor write: '123' to: self.
	self assert: self value = '123'
    ]
]



MAObjectTest subclass: MADescriptionTest [
    | description |
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MADescriptionTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    MADescriptionTest class >> shouldInheritSelectors [
	<category: 'testing'>
	^true
    ]

    actualClass [
	<category: 'private'>
	^MADescription
    ]

    description [
	<category: 'acessing-magritte'>
	^description
    ]

    descriptionInstance [
	<category: 'private'>
	^(self actualClass new)
	    accessor: MANullAccessor new;
	    yourself
    ]

    instance [
	<category: 'accessing'>
	^description
    ]

    setUp [
	<category: 'running'>
	super setUp.
	description := self descriptionInstance.
	self assert: description accessor notNil
    ]

    testAccessor [
	<category: 'tests-accessing'>
	self description accessor: (MASelectorAccessor selector: #foo).
	self assert: self description accessor selector = #foo
    ]

    testAsContainer [
	<category: 'tests-converting'>
	self subclassResponsibility
    ]

    testComment [
	<category: 'tests-accessing'>
	self description comment: 'bar'.
	self assert: self description comment = 'bar'
    ]

    testCopyAccessor [
	<category: 'tests-copying'>
	self assert: self description copy accessor = self description accessor.
	self deny: self description copy accessor == self description accessor
    ]

    testDictionaryKey [
	<category: 'tests-identity'>
	| dictionary |
	dictionary := Dictionary new.
	dictionary at: self instance put: 1.
	self assert: (dictionary at: self instance) = 1.
	dictionary at: self instance put: 2.
	self assert: (dictionary at: self instance) = 2
    ]

    testGroup [
	<category: 'tests-accessing'>
	self assert: self description group isNil.
	self description group: 'foo'.
	self assert: self description group = 'foo'
    ]

    testHasChildren [
	<category: 'tests-testing'>
	self deny: self description hasChildren
    ]

    testHasComment [
	<category: 'tests-testing'>
	self description comment: nil.
	self deny: self description hasComment.
	self description comment: ''.
	self deny: self description hasComment.
	self description comment: 'comment'.
	self assert: self description hasComment
    ]

    testHasLabel [
	<category: 'tests-testing'>
	self description label: nil.
	self deny: self description hasLabel.
	self description label: ''.
	self deny: self description hasLabel.
	self description label: 'label'.
	self assert: self description hasLabel
    ]

    testIsContainer [
	<category: 'tests-testing'>
	self deny: self description isContainer
    ]

    testIsDescription [
	<category: 'tests-testing'>
	self assert: self description isDescription
    ]

    testIsSortable [
	<category: 'tests-testing'>
	self 
	    assert: (self description isSortable or: [self description isSortable not])
    ]

    testLabel [
	<category: 'tests-accessing'>
	self description label: 'foo'.
	self assert: self description label = 'foo'
    ]

    testPriority [
	<category: 'tests-accessing'>
	self description priority: 123.
	self assert: self description priority = 123
    ]

    testReadonly [
	<category: 'tests-actions'>
	self description beReadonly.
	self assert: self description readonly.
	self assert: self description isReadonly.
	self description beWriteable.
	self deny: self description readonly.
	self deny: self description isReadonly
    ]

    testRequired [
	<category: 'tests-actions'>
	self description beRequired.
	self assert: self description required.
	self assert: self description isRequired.
	self description beOptional.
	self deny: self description required.
	self deny: self description isRequired
    ]

    testSetElement [
	<category: 'tests-identity'>
	| set |
	set := Set new.
	set add: self instance.
	self assert: set size = 1.
	self assert: (set includes: self instance).
	set add: self instance.
	self assert: set size = 1.
	self assert: (set includes: self instance)
    ]

    testVisible [
	<category: 'tests-actions'>
	self description beHidden.
	self deny: self description visible.
	self deny: self description isVisible.
	self description beVisible.
	self assert: self description visible.
	self assert: self description isVisible
    ]
]



MADescriptionTest subclass: MAContainerTest [
    | child1 child2 child3 |
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAContainerTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAContainer
    ]

    child1 [
	<category: 'accessing'>
	^child1 ifNil: 
		[child1 := (MAStringDescription new)
			    accessor: #child1;
			    label: 'child1';
			    priority: 1;
			    yourself]
    ]

    child2 [
	<category: 'accessing'>
	^child2 ifNil: 
		[child2 := (MAStringDescription new)
			    accessor: #child2;
			    label: 'child2';
			    priority: 2;
			    yourself]
    ]

    child3 [
	<category: 'accessing'>
	^child3 ifNil: 
		[child3 := (MAStringDescription new)
			    accessor: #child3;
			    label: 'child3';
			    priority: 3;
			    yourself]
    ]

    exampleInstance [
	<category: 'private'>
	^(MACachedMemento new)
	    setDescription: self description;
	    setCache: ((Dictionary new)
			at: self child1 put: nil;
			at: self child2 put: nil;
			at: self child3 put: nil;
			yourself);
	    yourself
    ]

    testAdd [
	<category: 'tests-adding'>
	self description add: self child1.
	self assert: self description size = 1.
	self assert: (self description includes: self child1).
	self description add: self child2.
	self assert: self description size = 2.
	self assert: (self description includes: self child1).
	self assert: (self description includes: self child2)
    ]

    testAddAll [
	<category: 'tests-adding'>
	self description addAll: (Array with: self child1 with: self child2).
	self assert: self description size = 2.
	self assert: (self description includes: self child1).
	self assert: (self description includes: self child2)
    ]

    testAllSatisfy [
	<category: 'tests-enumerating'>
	(self description)
	    add: self child1;
	    add: self child2.
	self assert: (self description 
		    allSatisfy: [:each | each = self child1 or: [each = self child2]]).
	self deny: (self description allSatisfy: [:each | each = self child1])
    ]

    testAnySatisfy [
	<category: 'tests-enumerating'>
	(self description)
	    add: self child1;
	    add: self child2.
	self assert: (self description anySatisfy: [:each | each = self child2]).
	self deny: (self description anySatisfy: [:each | each isNil])
    ]

    testAsContainer [
	<category: 'tests-converting'>
	self assert: self description asContainer = self description.
	self assert: self description asContainer == self description
    ]

    testAt [
	<category: 'tests-enumerating'>
	(self description)
	    add: self child1;
	    add: self child2.
	self assert: (self description at: 1) = self child1.
	self assert: (self description at: 2) = self child2.
	self should: [self description at: 3] raise: Error
    ]

    testAtIfAbsent [
	<category: 'tests-enumerating'>
	(self description)
	    add: self child1;
	    add: self child2.
	self assert: (self description at: 1 ifAbsent: ['not']) = self child1.
	self assert: (self description at: 2 ifAbsent: ['not']) = self child2.
	self assert: (self description at: 3 ifAbsent: ['not']) = 'not'
    ]

    testChildren [
	<category: 'tests-accessing'>
	self assert: self description children isCollection.
	self assert: self description children isEmpty
    ]

    testCollect [
	<category: 'tests-enumerating'>
	| collected |
	(self description)
	    add: self child1;
	    add: self child2.
	collected := self description collect: [:each | each].
	self assert: self description = collected.
	self deny: self description == collected.
	collected := self description collect: [:each | each copy].
	self assert: self description = collected.
	self deny: self description == collected.
	collected := self description collect: 
			[:each | 
			(each copy)
			    accessor: (MASelectorAccessor selector: #foo);
			    yourself].
	self deny: self description = collected.
	self deny: self description == collected
    ]

    testConcatenate [
	<category: 'tests-operators'>
	| concatenate |
	concatenate := self child1 , self child2.
	self assert: concatenate size = 2.
	self assert: concatenate children first = self child1.
	self assert: concatenate children second = self child2.
	concatenate := self child1 , self child2 , self child3.
	self assert: concatenate size = 3.
	self assert: concatenate children first = self child1.
	self assert: concatenate children second = self child2.
	self assert: concatenate children third = self child3
    ]

    testCopy [
	<category: 'tests-copying'>
	(self description)
	    add: self child1;
	    add: self child2.
	super testCopy.
	self deny: self description copy children == self description children.
	self assert: self description copy children first 
		    = self description children first.
	self assert: self description copy children second 
		    = self description children second
    ]

    testCopyEmpty [
	<category: 'tests-copying'>
	(self description)
	    add: self child1;
	    add: self child2.
	self assert: self description copyEmpty isEmpty
    ]

    testCopyFromTo [
	<category: 'tests-copying'>
	| copied |
	(self description)
	    add: self child1;
	    add: self child2;
	    add: self child3.
	copied := self description copyFrom: 2 to: 3.
	self assert: copied ~= self description.
	self assert: copied size = 2.
	self assert: copied children first = self child2.
	self assert: copied children second = self child3
    ]

    testCopyWithout [
	<category: 'tests-copying'>
	| copied |
	(self description)
	    add: self child1;
	    add: self child2;
	    add: self child3.
	copied := self description copyWithout: self child1.
	self assert: copied ~= self description.
	self assert: copied size = 2.
	self assert: copied children first = self child2.
	self assert: copied children second = self child3
    ]

    testCopyWithoutAll [
	<category: 'tests-copying'>
	| copied |
	(self description)
	    add: self child1;
	    add: self child2;
	    add: self child3.
	copied := self description 
		    copyWithoutAll: (Array with: self child1 with: self child3).
	self assert: copied ~= self description.
	self assert: copied size = 1.
	self assert: copied children first = self child2
    ]

    testDetect [
	<category: 'tests-enumerating'>
	self description add: self child1.
	self assert: (self description detect: [:each | self child1 = each]) 
		    = self child1.
	self should: [self description detect: [:each | self child2 = each]]
	    raise: Error
    ]

    testDetectIfNone [
	<category: 'tests-enumerating'>
	self description add: self child1.
	self 
	    assert: (self description detect: [:each | self child1 = each] ifNone: [123]) 
		    = self child1.
	self 
	    assert: (self description detect: [:each | self child2 = each] ifNone: [123]) 
		    = 123
    ]

    testDo [
	<category: 'tests-enumerating'>
	| collection children |
	collection := self description class defaultCollection.
	(self description)
	    add: self child1;
	    add: self child2.
	self description do: [:each | collection add: each].
	children := self description children.
	self assert: children size = collection size.
	1 to: collection size
	    do: [:index | self assert: (children at: index) = (collection at: index)]
    ]

    testDoSepratedBy [
	<category: 'tests-enumerating'>
	| collection |
	collection := OrderedCollection new.
	(self description)
	    add: self child1;
	    add: self child2.
	self description do: [:each | collection add: each]
	    separatedBy: [collection add: nil].
	self assert: collection size = 3.
	self assert: collection first = self child1.
	self assert: collection second isNil.
	self assert: collection third = self child2
    ]

    testEmpty [
	<category: 'tests-testing'>
	self assert: self description isEmpty.
	self description add: self child1.
	self deny: self description isEmpty
    ]

    testHasChildren [
	<category: 'tests-testing'>
	super testHasChildren.
	self description add: self child1.
	self assert: self description hasChildren
    ]

    testIncludes [
	<category: 'tests-testing'>
	self deny: (self description includes: self child1).
	self description add: self child1.
	self assert: (self description includes: self child1)
    ]

    testInjectInto [
	<category: 'tests-enumerating'>
	(self description)
	    add: self child1;
	    add: self child2.
	self 
	    assert: (self description inject: 'start'
		    into: [:result :each | result , ' ' , each label]) = 'start child1 child2'
    ]

    testIntersection [
	<category: 'tests-operators'>
	| a b union |
	a := self child1 , self child2.
	b := self child2 , self child3.
	union := a intersection: b.
	self assert: union size = 1.
	self deny: (union includes: self child1).
	self assert: (union includes: self child2).
	self deny: (union includes: self child3)
    ]

    testIsContainer [
	<category: 'tests-testing'>
	self assert: self description isContainer
    ]

    testKeysAndValuesDo [
	<category: 'tests-enumerating'>
	(self description)
	    add: self child1;
	    add: self child2.
	self description keysAndValuesDo: 
		[:index :each | 
		index = 1 
		    ifTrue: [self assert: self child1 = each]
		    ifFalse: 
			[index = 2 
			    ifTrue: [self assert: self child2 = each]
			    ifFalse: [self assert: false]]]
    ]

    testMoveDown [
	<category: 'tests-moving'>
	(self description)
	    add: self child1;
	    add: self child2.
	self assert: self description children first = self child1.
	self assert: self description children second = self child2.
	self description moveDown: self child1.
	self assert: self description children first = self child2.
	self assert: self description children second = self child1.
	self description moveDown: self child1.
	self assert: self description children first = self child2.
	self assert: self description children second = self child1
    ]

    testMoveUp [
	<category: 'tests-moving'>
	(self description)
	    add: self child1;
	    add: self child2.
	self assert: self description children first = self child1.
	self assert: self description children second = self child2.
	self description moveUp: self child2.
	self assert: self description children first = self child2.
	self assert: self description children second = self child1.
	self description moveUp: self child2.
	self assert: self description children first = self child2.
	self assert: self description children second = self child1
    ]

    testNoFailingValidation [
	<category: 'tests-validating'>
	| example |
	(self description)
	    add: self child1;
	    add: self child2.
	example := self exampleInstance.
	self shouldnt: [example validate] raise: MAValidationError
    ]

    testNoneSatisfy [
	<category: 'tests-enumerating'>
	(self description)
	    add: self child1;
	    add: self child2.
	self assert: (self description noneSatisfy: [:each | each isNil])
    ]

    testNotEmpty [
	<category: 'tests-testing'>
	self deny: self description notEmpty.
	self description add: self child1.
	self assert: self description notEmpty
    ]

    testOneFailingValidation [
	<category: 'tests-validating'>
	| example |
	(self description)
	    add: self child1;
	    add: ((self child2)
			addCondition: [:v | false];
			beRequired;
			yourself).
	example := self exampleInstance.
	self should: [example validate] raise: MAValidationError.
	[example validate] on: MAValidationError
	    do: 
		[:err | 
		self assert: err class = MAMultipleErrors.
		self assert: err tag = self description.
		self assert: err collection size = 1.
		self assert: err collection first tag = self child2]
    ]

    testReject [
	<category: 'tests-enumerating'>
	| rejected |
	(self description)
	    add: self child1;
	    add: self child2.
	rejected := self description reject: [:each | false].
	self assert: self description = rejected.
	rejected := self description reject: [:each | true].
	self assert: rejected isEmpty
    ]

    testRemove [
	<category: 'tests-removing'>
	(self description)
	    add: self child1;
	    add: self child2.
	self description remove: self child1.
	self assert: self description size = 1.
	self deny: (self description includes: self child1).
	self assert: (self description includes: self child2).
	self description remove: self child2.
	self assert: self description isEmpty
    ]

    testRemoveAll [
	<category: 'tests-removing'>
	(self description)
	    add: self child1;
	    add: self child2.
	self description removeAll.
	self assert: self description isEmpty
    ]

    testSelect [
	<category: 'tests-enumerating'>
	| selected |
	(self description)
	    add: self child1;
	    add: self child2.
	selected := self description select: [:each | true].
	self assert: self description = selected.
	selected := self description select: [:each | false].
	self assert: selected isEmpty
    ]

    testSize [
	<category: 'tests-accessing'>
	self assert: self description size isZero.
	self description add: self child1.
	self assert: self description size = 1.
	self description add: self child2.
	self assert: self description size = 2.
	self description add: self child3.
	self assert: self description size = 3
    ]

    testTwoFailingValidation [
	<category: 'tests-validating'>
	| example |
	(self description)
	    add: ((self child1)
			addCondition: [:v | false];
			beRequired;
			yourself);
	    add: ((self child2)
			addCondition: [:v | false];
			beRequired;
			yourself).
	example := self exampleInstance.
	self should: [example validate] raise: MAValidationError.
	[example validate] on: MAValidationError
	    do: 
		[:err | 
		self assert: err class = MAMultipleErrors.
		self assert: err tag = self description.
		self assert: err collection size = 2.
		self assert: err collection first tag = self child1.
		self assert: err collection last tag = self child2]
    ]

    testUnion [
	<category: 'tests-operators'>
	| a b union |
	a := self child1 , self child2.
	b := self child2 , self child3.
	union := a union: b.
	self assert: union size = 3.
	self assert: (union includes: self child1).
	self assert: (union includes: self child2).
	self assert: (union includes: self child3)
    ]

    testWithDo [
	<category: 'tests-enumerating'>
	(self description)
	    add: self child1;
	    add: self child2.
	self description with: self description children
	    do: [:first :second | self assert: first = second]
    ]
]



MAContainerTest subclass: MAPriorityContainerTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAPriorityContainerTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAPriorityContainer
    ]

    testMoveDown [
	<category: 'tests-moving'>
	self should: [super testMoveDown] raise: Error
    ]

    testMoveUp [
	<category: 'tests-moving'>
	self should: [super testMoveUp] raise: Error
    ]
]



MADescriptionTest subclass: MAElementDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAElementDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    actualClass [
	<category: 'private'>
	^MAElementDescription
    ]

    emptyInstance [
	<category: 'private'>
	^String new
    ]

    includedInstance [
	<category: 'private'>
	self subclassResponsibility
    ]

    includedInstanceString [
	<category: 'private'>
	^MAStringWriter write: self includedInstance
	    description: self descriptionInstance
    ]

    invalidInstance [
	<category: 'private'>
	^Object new
    ]

    invalidInstanceString [
	<category: 'private'>
	^self invalidInstance greaseString
    ]

    nonIdenticalInstance [
	<category: 'private'>
	^self includedInstance copy
    ]

    nullInstance [
	<category: 'private'>
	^nil
    ]

    shouldSkipStringTests [
	<category: 'private'>
	^false
    ]

    testAddCondition [
	<category: 'tests-validation'>
	self description addCondition: [:value | value isNil].
	self assert: self description conditions size = 1.
	self assert: self description conditions first value isString
    ]

    testAddConditionLabelled [
	<category: 'tests-validation'>
	self description addCondition: [:value | value isNil]
	    labelled: 'ist net nil'.
	self assert: self description conditions size = 1.
	self assert: self description conditions first value = 'ist net nil'
    ]

    testAsContainer [
	<category: 'tests-converting'>
	self assert: self description asContainer size = 1.
	self assert: (self description asContainer includes: self description)
    ]

    testConcatenation [
	<category: 'tests-operators'>
	| child1 child2 concatenate |
	child1 := self description copy.
	child2 := self description copy.
	concatenate := child1 , child2.
	self assert: concatenate size = 2.
	self assert: concatenate children first = child1.
	self assert: concatenate children second = child2.
	concatenate := child1 , concatenate.
	self assert: concatenate size = 3.
	self assert: concatenate children first = child1.
	self assert: concatenate children second = child1.
	self assert: concatenate children third = child2
    ]

    testCopy [
	<category: 'tests-copying'>
	super testCopy.
	self assert: self description copy default = self description default
    ]

    testDefault [
	<category: 'tests-accessing'>
	self description default: self includedInstance.
	self assert: self description default = self includedInstance
    ]

    testFromString [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self assert: (self description fromString: self includedInstanceString) 
		    = self includedInstance.
	self 
	    assert: (self description fromString: self includedInstanceString
		    reader: self description stringReader) = self includedInstance.
	self 
	    assert: (self description fromString: self includedInstanceString
		    reader: self description stringReader new) = self includedInstance
    ]

    testFromStringCollection [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self 
	    assert: (self description 
		    fromStringCollection: (Array with: self includedInstanceString
			    with: self includedInstanceString)) 
			= (Array with: self includedInstance with: self includedInstance).
	self 
	    assert: (self description 
		    fromStringCollection: (Array with: self includedInstanceString
			    with: self includedInstanceString)
		    reader: self description stringReader) 
			= (Array with: self includedInstance with: self includedInstance)
    ]

    testFromStringEvaluated [
	"This ensures that the parsing algorithm doesn't compile the input, what would cause a  security hole in the framework."

	<category: 'tests-strings'>
	| error |
	error := nil.
	self shouldSkipStringTests ifTrue: [^self].
	[self description fromString: '1 / 0. nil'] on: Exception
	    do: [:err | error := err].
	self deny: (error isKindOf: ZeroDivide)
    ]

    testFromStringInvalid [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self should: [self description fromString: self invalidInstanceString]
	    raise: MAReadError
    ]

    testFromStringNull [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self assert: (self description fromString: self emptyInstance) isNil.
	self 
	    assert: (self description fromString: self emptyInstance
		    reader: self description stringReader) isNil.
	self 
	    assert: (self description fromString: self emptyInstance
		    reader: self description stringReader new) isNil
    ]

    testKind [
	<category: 'tests-accessing'>
	self assert: (self includedInstance isKindOf: self description kind)
    ]

    testKindErrorMessage [
	<category: 'tests-validation'>
	self assert: self description kindErrorMessage notEmpty.
	self description kindErrorMessage: 'zork'.
	self assert: self description kindErrorMessage = 'zork'.
	[self description validateKind: self invalidInstance] on: MAKindError
	    do: [:err | self assert: self description kindErrorMessage = err messageText]
    ]

    testRequiredErrorMessage [
	<category: 'tests-validation'>
	self assert: self description requiredErrorMessage notEmpty.
	self description requiredErrorMessage: 'zork'.
	self assert: self description requiredErrorMessage = 'zork'.
	
	[(self description)
	    beRequired;
	    validateRequired: self nullInstance] 
		on: MARequiredError
		do: [:err | self assert: self description requiredErrorMessage = err messageText]
    ]

    testSatisfied [
	<category: 'tests-testing'>
	self assert: (self description isSatisfiedBy: self includedInstance).
	self assert: (self description isSatisfiedBy: self nullInstance).
	self deny: (self description isSatisfiedBy: self invalidInstance)
    ]

    testStringReader [
	<category: 'tests-accessing'>
	| object |
	self description stringReader: (object := MAStringReader new).
	self assert: self description stringReader = object
    ]

    testStringWriter [
	<category: 'tests-accessing'>
	| object |
	self description stringWriter: (object := MAStringWriter new).
	self assert: self description stringWriter = object
    ]

    testToString [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self assert: (self description toString: self includedInstance) 
		    = self includedInstanceString.
	self 
	    assert: (self description toString: self includedInstance
		    writer: self description stringWriter) = self includedInstanceString.
	self 
	    assert: (self description toString: self includedInstance
		    writer: self description stringWriter new) = self includedInstanceString
    ]

    testToStringCollection [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self 
	    assert: (self description 
		    toStringCollection: (Array with: self includedInstance
			    with: self includedInstance)) 
			= (Array with: self includedInstanceString with: self includedInstanceString).
	self 
	    assert: (self description 
		    toStringCollection: (Array with: self includedInstance
			    with: self includedInstance)
		    writer: self description stringWriter) 
			= (Array with: self includedInstanceString with: self includedInstanceString)
    ]

    testToStringFromString [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self 
	    assert: (self description 
		    fromString: (self description toString: self includedInstance)) 
			= self includedInstance.
	self 
	    assert: (self description 
		    fromString: (self description toString: self includedInstance
			    writer: self description stringWriter)
		    reader: self description stringReader) = self includedInstance.
	self 
	    assert: (self description 
		    fromString: (self description toString: self includedInstance
			    writer: self description stringWriter new)
		    reader: self description stringReader new) = self includedInstance
    ]

    testToStringNull [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self assert: (self description toString: self nullInstance) 
		    = self description undefined.
	self 
	    assert: (self description toString: self nullInstance
		    writer: self description stringWriter) = self description undefined.
	self 
	    assert: (self description toString: self nullInstance
		    writer: self description stringWriter new) = self description undefined
    ]

    testToStringUndefined [
	<category: 'tests-strings'>
	self shouldSkipStringTests ifTrue: [^self].
	self description undefined: 'n/a'.
	self assert: (self description toString: self nullInstance) = 'n/a'.
	self 
	    assert: (self description toString: self nullInstance
		    writer: self description stringWriter) = 'n/a'.
	self 
	    assert: (self description toString: self nullInstance
		    writer: self description stringWriter new) = 'n/a'
    ]

    testUndefined [
	<category: 'tests-accessing'>
	self description undefined: 'nop'.
	self assert: self description undefined = 'nop'
    ]

    testValidate [
	<category: 'tests-validation'>
	self description beRequired.
	self shouldnt: [self description validate: self includedInstance]
	    raise: MAValidationError.
	self should: [self description validate: self invalidInstance]
	    raise: MAKindError.
	self should: [self description validate: self nullInstance]
	    raise: MARequiredError
    ]

    testValidateConditions [
	"This test might fail for MADateDescriptionTest, since there is a bug in Squeak."

	<category: 'tests-validation'>
	| object |
	object := self includedInstance.
	self description addCondition: [:value | object == value]
	    labelled: 'included instance test'.
	self shouldnt: [self description validate: object] raise: MAConditionError.
	self should: [self description validate: self nonIdenticalInstance]
	    raise: MAConditionError
    ]

    testValidateKind [
	<category: 'tests-validation'>
	self should: [self description validateKind: self invalidInstance]
	    raise: MAKindError.
	self shouldnt: [self description validateKind: self includedInstance]
	    raise: MAKindError
    ]

    testValidateRequired [
	<category: 'tests-validation'>
	self description beOptional.
	self shouldnt: [self description validateRequired: self nullInstance]
	    raise: MARequiredError.
	self shouldnt: [self description validateRequired: self includedInstance]
	    raise: MARequiredError.
	self description beRequired.
	self should: [self description validateRequired: self nullInstance]
	    raise: MARequiredError.
	self shouldnt: [self description validateRequired: self includedInstance]
	    raise: MARequiredError
    ]

    testValidateSpecific [
	<category: 'tests-validation'>
	self shouldnt: [self description validate: self includedInstance]
	    raise: MARequiredError
    ]
]



MAElementDescriptionTest subclass: MABooleanDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MABooleanDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MABooleanDescription
    ]

    includedInstance [
	<category: 'private'>
	^true
    ]

    testFalseString [
	<category: 'tests'>
	self description falseString: 'nein'.
	self assert: (self description labelForOption: false) = 'nein'
    ]

    testLabelForOption [
	<category: 'tests'>
	self assert: (self description labelForOption: true) = 'true'.
	self assert: (self description labelForOption: false) = 'false'.
	self assert: (self description labelForOption: nil) = ''
    ]

    testOptions [
	<category: 'tests'>
	self assert: self description options = #(false true).
	self assert: (self description allOptionsWith: Object new) = #(false true)
    ]

    testTrueString [
	<category: 'tests'>
	self description trueString: 'ja'.
	self assert: (self description labelForOption: true) = 'ja'
    ]

    testValidateConditions [
	<category: 'tests-validation'>
	
    ]
]



MAElementDescriptionTest subclass: MAClassDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAClassDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAClassDescription
    ]

    includedInstance [
	<category: 'private'>
	^String
    ]

    nonIdenticalInstance [
	"Classes cannot be copied on some platforms, so we override the inherited
	 behaviour in order to return a different class."

	<category: 'private'>
	^Object
    ]

    shouldSkipStringTests [
	<category: 'private'>
	^true
    ]
]



MAElementDescriptionTest subclass: MAColorDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAColorDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAColorDescription
    ]

    includedInstance [
	<category: 'private'>
	^GRPlatform current magritteColorClass blue
    ]
]



MAElementDescriptionTest subclass: MAFileDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAFileDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAFileDescription
    ]

    includedInstance [
	<category: 'private'>
	^(MAMemoryFileModel new)
	    contents: 'Lukas Renggli';
	    filename: 'author.txt';
	    yourself
    ]

    shouldSkipStringTests [
	<category: 'private'>
	^true
    ]

    testKind [
	<category: 'tests-accessing'>
	super testKind.
	self description kind: MAFileModelStub.
	self assert: self description kind = MAFileModelStub
    ]
]



MAElementDescriptionTest subclass: MAMagnitudeDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAMagnitudeDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    actualClass [
	<category: 'private'>
	^MAMagnitudeDescription
    ]

    excludedInstance [
	<category: 'private'>
	self subclassResponsibility
    ]

    maxInstance [
	<category: 'private'>
	self subclassResponsibility
    ]

    minInstance [
	<category: 'private'>
	self subclassResponsibility
    ]

    testInfToInf [
	<category: 'tests'>
	self assert: self description min isNil.
	self assert: self description max isNil.
	self assert: (self description isSatisfiedBy: self minInstance).
	self assert: (self description isSatisfiedBy: self includedInstance).
	self assert: (self description isSatisfiedBy: self maxInstance)
    ]

    testInfToVal [
	<category: 'tests'>
	self description max: self includedInstance.
	self assert: self description min isNil.
	self assert: self description max = self includedInstance.
	self assert: (self description isSatisfiedBy: self minInstance).
	self assert: (self description isSatisfiedBy: self includedInstance).
	self deny: (self description isSatisfiedBy: self maxInstance)
    ]

    testMax [
	<category: 'tests-accessing'>
	self description max: self maxInstance.
	self assert: self description max = self maxInstance
    ]

    testMin [
	<category: 'tests-accessing'>
	self description min: self minInstance.
	self assert: self description min = self minInstance
    ]

    testMinMax [
	<category: 'tests-accessing'>
	self description min: self minInstance max: self maxInstance.
	self assert: self description min = self minInstance.
	self assert: self description max = self maxInstance
    ]

    testRangeErrorMessage [
	<category: 'tests-validation'>
	(self description)
	    min: self minInstance;
	    max: self maxInstance.
	self assert: self description rangeErrorMessage notEmpty.
	self description rangeErrorMessage: 'zork'.
	self assert: self description rangeErrorMessage = 'zork'.
	[self description validate: self excludedInstance] on: MARangeError
	    do: [:err | self assert: self description rangeErrorMessage = err messageText]
    ]

    testRangeErrorMessageGenerated [
	<category: 'tests-validation'>
	self description min: nil max: nil.
	self assert: self description rangeErrorMessage isNil.
	self description min: nil max: self maxInstance.
	self assert: self description rangeErrorMessage notEmpty.
	self description min: self minInstance max: nil.
	self assert: self description rangeErrorMessage notEmpty.
	self description min: self minInstance max: self maxInstance.
	self assert: self description rangeErrorMessage notEmpty
    ]

    testValToInf [
	<category: 'tests'>
	self description min: self includedInstance.
	self assert: self description min = self includedInstance.
	self assert: self description max isNil.
	self deny: (self description isSatisfiedBy: self minInstance).
	self assert: (self description isSatisfiedBy: self includedInstance).
	self assert: (self description isSatisfiedBy: self maxInstance)
    ]

    testValToVal [
	<category: 'tests'>
	self description min: self includedInstance.
	self description max: self includedInstance.
	self assert: self description min = self includedInstance.
	self assert: self description max = self includedInstance.
	self deny: (self description isSatisfiedBy: self minInstance).
	self assert: (self description isSatisfiedBy: self includedInstance).
	self deny: (self description isSatisfiedBy: self maxInstance)
    ]

    testValidateSpecific [
	<category: 'tests-validation'>
	super testValidateSpecific.
	(self description)
	    min: self minInstance;
	    max: self maxInstance.
	self shouldnt: [self description validate: self includedInstance]
	    raise: MARangeError.
	self should: [self description validate: self excludedInstance]
	    raise: MARangeError
    ]
]



MAMagnitudeDescriptionTest subclass: MADateAndTimeDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MADateAndTimeDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MADateAndTimeDescription
    ]

    excludedInstance [
	<category: 'private'>
	^DateAndTime 
	    year: 1980
	    month: 1
	    day: 11
	    hour: 11
	    minute: 38
	    second: 12
    ]

    includedInstance [
	<category: 'private'>
	^DateAndTime 
	    year: 1980
	    month: 6
	    day: 11
	    hour: 11
	    minute: 38
	    second: 12
    ]

    maxInstance [
	<category: 'private'>
	^DateAndTime 
	    year: 1980
	    month: 6
	    day: 12
	    hour: 11
	    minute: 38
	    second: 12
    ]

    minInstance [
	<category: 'private'>
	^DateAndTime 
	    year: 1980
	    month: 6
	    day: 10
	    hour: 11
	    minute: 38
	    second: 12
    ]
]



MAMagnitudeDescriptionTest subclass: MADateDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MADateDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MADateDescription
    ]

    excludedInstance [
	<category: 'private'>
	^Date 
	    newDay: 1
	    month: (Date nameOfMonth: 6)
	    year: 1980
    ]

    includedInstance [
	<category: 'private'>
	^Date 
	    newDay: 11
	    month: (Date nameOfMonth: 6)
	    year: 1980
    ]

    maxInstance [
	<category: 'private'>
	^Date 
	    newDay: 12
	    month: (Date nameOfMonth: 6)
	    year: 1980
    ]

    minInstance [
	<category: 'private'>
	^Date 
	    newDay: 10
	    month: (Date nameOfMonth: 6)
	    year: 1980
    ]
]



MAMagnitudeDescriptionTest subclass: MADurationDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MADurationDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MADurationDescription
    ]

    excludedInstance [
	<category: 'private'>
	^Duration 
	    days: 0
	    hours: 0
	    minutes: 0
	    seconds: 2
    ]

    includedInstance [
	<category: 'private'>
	^Duration 
	    days: 1
	    hours: 2
	    minutes: 3
	    seconds: 4
    ]

    maxInstance [
	<category: 'private'>
	^Duration 
	    days: 2
	    hours: 2
	    minutes: 3
	    seconds: 4
    ]

    minInstance [
	<category: 'private'>
	^Duration 
	    days: 0
	    hours: 2
	    minutes: 3
	    seconds: 4
    ]
]



MAMagnitudeDescriptionTest subclass: MANumberDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MANumberDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MANumberDescription
    ]

    excludedInstance [
	<category: 'private'>
	^0.6180
    ]

    includedInstance [
	<category: 'private'>
	^2.7182
    ]

    maxInstance [
	<category: 'private'>
	^3.1415
    ]

    minInstance [
	<category: 'private'>
	^1.6180
    ]

    testBeInteger [
	<category: 'tests'>
	self description beInteger.
	self assert: (self description isSatisfiedBy: 1).
	self assert: (self description isSatisfiedBy: -1).
	self deny: (self description isSatisfiedBy: 1 / 2).
	self deny: (self description isSatisfiedBy: 1.2)
    ]

    testBeNegative [
	<category: 'tests'>
	self description beNegative.
	self assert: (self description isSatisfiedBy: -1).
	self assert: (self description isSatisfiedBy: -1.5).
	self deny: (self description isSatisfiedBy: 1).
	self deny: (self description isSatisfiedBy: 1.5)
    ]

    testBePositive [
	<category: 'tests'>
	self description bePositive.
	self assert: (self description isSatisfiedBy: 1).
	self assert: (self description isSatisfiedBy: 1.5).
	self deny: (self description isSatisfiedBy: -0.1).
	self deny: (self description isSatisfiedBy: -1)
    ]

    testFromString [
	"We do some special tests here because #visitNumberDescription: in
	 MAStringReader works around problems with Number>>readFrom."

	<category: 'private'>
	self shouldSkipStringTests ifTrue: [^self].
	super testFromString.
	self 
	    should: [self description fromString: 'xyz']
	    raise: MAReadError
	    description: 'Non-numeric string should raise an error'.
	self 
	    should: [self description fromString: '12-234']
	    raise: MAReadError
	    description: 'Non-numeric string should raise an error'.
	self 
	    should: [self description fromString: '1.4.2007']
	    raise: MAReadError
	    description: 'Non-numeric string should raise an error'.
	self assert: (self description fromString: '') isNil
	    description: 'Empty string should be parsed to nil'.
	self assert: (self description fromString: '-20') = -20
	    description: 'Negative numbers should be accepted'
    ]

    testValidateConditions [
	<category: 'tests'>
	
    ]
]



MAMagnitudeDescriptionTest subclass: MATimeDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MATimeDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MATimeDescription
    ]

    excludedInstance [
	<category: 'private'>
	^Time 
	    hour: 9
	    minute: 33
	    second: 12
    ]

    includedInstance [
	<category: 'private'>
	^Time 
	    hour: 11
	    minute: 33
	    second: 12
    ]

    maxInstance [
	<category: 'private'>
	^Time 
	    hour: 12
	    minute: 33
	    second: 12
    ]

    minInstance [
	<category: 'private'>
	^Time 
	    hour: 10
	    minute: 33
	    second: 12
    ]
]



MAMagnitudeDescriptionTest subclass: MATimeStampDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MATimeStampDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MATimeStampDescription
    ]

    excludedInstance [
	<category: 'private'>
	^GRPlatform current magritteTimeStampClass 
	    year: 1980
	    month: 1
	    day: 11
	    hour: 11
	    minute: 38
	    second: 12
    ]

    includedInstance [
	<category: 'private'>
	^GRPlatform current magritteTimeStampClass 
	    year: 1980
	    month: 6
	    day: 11
	    hour: 11
	    minute: 38
	    second: 12
    ]

    maxInstance [
	<category: 'private'>
	^GRPlatform current magritteTimeStampClass 
	    year: 1980
	    month: 6
	    day: 12
	    hour: 11
	    minute: 38
	    second: 12
    ]

    minInstance [
	<category: 'private'>
	^GRPlatform current magritteTimeStampClass 
	    year: 1980
	    month: 6
	    day: 10
	    hour: 11
	    minute: 38
	    second: 12
    ]
]



MAElementDescriptionTest subclass: MAReferenceDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAReferenceDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    actualClass [
	<category: 'private'>
	^MAReferenceDescription
    ]

    referenceInstance [
	<category: 'private'>
	^MAStringDescription new
    ]

    setUp [
	<category: 'running'>
	super setUp.
	self description reference: self referenceInstance.
	self assert: self description reference accessor notNil
    ]

    testCopyReference [
	<category: 'tests-copying'>
	self assert: self description copy reference = self description reference.
	self deny: self description copy reference == self description reference
    ]
]



MAReferenceDescriptionTest subclass: MAOptionDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAOptionDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    actualClass [
	<category: 'private'>
	^MAOptionDescription
    ]

    optionInstances [
	<category: 'private'>
	^Array 
	    with: 'foo'
	    with: 'bar'
	    with: 'zork'
    ]

    setUp [
	<category: 'running'>
	super setUp.
	self description options: self optionInstances
    ]

    testAllOptions [
	<category: 'tests-accessing'>
	(self description)
	    beRequired;
	    beSorted;
	    options: #(#c #b #a).
	self assert: self description allOptions = #(#a #b #c).
	(self description)
	    beRequired;
	    beUnsorted;
	    options: #(#c #b #a).
	self assert: self description allOptions = #(#c #b #a)
    ]

    testAllOptionsWithExisting [
	<category: 'tests-accessing'>
	(self description)
	    beRequired;
	    options: #(#a #b #c).
	self assert: (self description allOptionsWith: #a) = #(#a #b #c)
    ]

    testAllOptionsWithNil [
	<category: 'tests-accessing'>
	(self description)
	    beRequired;
	    options: #(#a #b #c).
	self assert: (self description allOptionsWith: nil) = #(#a #b #c)
    ]

    testCopyOptions [
	<category: 'tests-copying'>
	self deny: self description copy options == self description options.
	self assert: self description copy options = self description options
    ]

    testFromStringInvalid [
	"There is no invalid string input."

	<category: 'tests-strings'>
	
    ]

    testOptions [
	<category: 'tests-accessing'>
	self description options: #(#a #b #c).
	self assert: self description options = #(#a #b #c)
    ]

    testOptionsAndLabels [
	<category: 'tests-strings'>
	self description reference: MANumberDescription new.
	self assert: (self description labelForOption: 1) = '1'.
	self description 
	    optionsAndLabels: (Array with: 1 -> 'one' with: 2 -> 'two').
	self assert: (self description labelForOption: 1) = 'one'.
	self assert: (self description labelForOption: 2) = 'two'.
	self assert: (self description labelForOption: 3) = '3'
    ]

    testOptionsTextual [
	<category: 'tests-accessing'>
	self description optionsTextual: 'a' , (String with: Character cr) , 'b'.
	self assert: self description optionsTextual 
		    = ('a' , (String with: Character cr) , 'b').
	self assert: self description options = #('a' 'b')
    ]

    testReferencePrinting [
	<category: 'tests'>
	| label |
	self description reference: MAStringDescription new.
	self assert: (self description labelForOption: 1) = '1'.
	label := self description labelForOption: 1 @ 2.
	self assert: (label includesSubString: '1').
	self assert: (label includesSubString: '2').
	label := self description labelForOption: 1 -> 2.
	self assert: (label includesSubString: '1').
	self assert: (label includesSubString: '2')
    ]

    testSorted [
	<category: 'tests-properties'>
	self description beSorted.
	self assert: self description isSorted.
	self assert: self description sorted.
	self description beUnsorted.
	self deny: self description isSorted.
	self deny: self description sorted
    ]
]



MAOptionDescriptionTest subclass: MAMultipleOptionDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAMultipleOptionDescriptionTest class >> defaultUnique [
	<category: 'accessing-default'>
	^false
    ]

    MAMultipleOptionDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAMultipleOptionDescription
    ]

    includedInstance [
	<category: 'private'>
	^self optionInstances copyFrom: 1 to: 2
    ]

    testOrdered [
	<category: 'tests-properties'>
	self description beOrdered.
	self assert: self description isOrdered.
	self assert: self description ordered.
	self description beUnordered.
	self deny: self description isOrdered.
	self deny: self description ordered
    ]

    testSorted [
	<category: 'tests-properties'>
	self description beDistinct.
	self assert: self description isDistinct.
	self assert: self description distinct.
	self description beIndefinite.
	self deny: self description isDistinct.
	self deny: self description distinct
    ]
]



MAOptionDescriptionTest subclass: MASingleOptionDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MASingleOptionDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MASingleOptionDescription
    ]

    includedInstance [
	<category: 'private'>
	^self optionInstances first
    ]

    testAllOptionsOptional [
	<category: 'tests-accessing'>
	(self description)
	    beOptional;
	    beSorted;
	    options: #(#c #b #a).
	self assert: self description allOptions = #(nil #a #b #c).
	(self description)
	    beOptional;
	    beUnsorted;
	    options: #(#c #b #a).
	self assert: self description allOptions = #(nil #c #b #a)
    ]

    testAllOptionsWithExtensible [
	<category: 'tests-accessing'>
	(self description)
	    beRequired;
	    beUnsorted;
	    beLimited;
	    options: #(#c #d #a).
	self assert: (self description allOptionsWith: #b) = #(#c #d #a).
	(self description)
	    beRequired;
	    beUnsorted;
	    beExtensible;
	    options: #(#c #d #a).
	self assert: (self description allOptionsWith: #b) = #(#c #d #a #b).
	(self description)
	    beRequired;
	    beSorted;
	    beLimited;
	    options: #(#c #d #a).
	self assert: (self description allOptionsWith: #b) = #(#a #c #d).
	(self description)
	    beRequired;
	    beSorted;
	    beExtensible;
	    options: #(#c #d #a).
	self assert: (self description allOptionsWith: #b) = #(#a #b #c #d)
    ]

    testAllOptionsWithOptional [
	<category: 'tests-accessing'>
	(self description)
	    beOptional;
	    beSorted;
	    beExtensible;
	    options: #(#c #d #a).
	self assert: (self description allOptionsWith: #b) = #(nil #a #b #c #d).
	(self description)
	    beOptional;
	    beSorted;
	    beLimited;
	    options: #(#c #d #a).
	self assert: (self description allOptionsWith: #b) = #(nil #a #c #d).
	(self description)
	    beOptional;
	    beUnsorted;
	    beExtensible;
	    options: #(#c #d #a).
	self assert: (self description allOptionsWith: #b) = #(nil #c #d #a #b).
	(self description)
	    beOptional;
	    beUnsorted;
	    beLimited;
	    options: #(#c #d #a).
	self assert: (self description allOptionsWith: #b) = #(nil #c #d #a)
    ]

    testExtensible [
	<category: 'tests-properties'>
	self description beExtensible.
	self assert: self description isExtensible.
	self assert: self description extensible.
	self description beLimited.
	self deny: self description isExtensible.
	self deny: self description extensible
    ]

    testGroupBy [
	<category: 'tests-properties'>
	self deny: self description isGrouped.
	self description groupBy: #grouping.
	self assert: self description isGrouped
    ]

    testGroupOf [
	<category: 'tests-properties'>
	self assert: MADateDescription grouping = 'Magnitude'
    ]

    testOptionsAndLabelsFromString [
	<category: 'tests'>
	(self description)
	    undefined: 'void';
	    optionsAndLabels: (Array with: 1 -> 'one' with: 2 -> 'two').
	self assert: (self description fromString: 'void') isNil.
	self assert: (self description fromString: 'one') = 1.
	self assert: (self description fromString: 'two') = 2
    ]

    testOptionsAndLabelsToString [
	<category: 'tests'>
	(self description)
	    undefined: 'void';
	    optionsAndLabels: (Array with: 1 -> 'one' with: 2 -> 'two').
	self assert: (self description toString: nil) = 'void'.
	self assert: (self description toString: 1) = 'one'.
	self assert: (self description toString: 2) = 'two'.
	self assert: (self description toString: 3) = '3'
    ]

    testValidationExtensible [
	<category: 'tests-validation'>
	self description beLimited.
	self assert: (self description isSatisfiedBy: 'foo').
	self deny: (self description isSatisfiedBy: 'zonk').
	self deny: (self description isSatisfiedBy: 1).
	self description beExtensible.
	self assert: (self description isSatisfiedBy: 'foo').
	self assert: (self description isSatisfiedBy: 'zonk').
	self deny: (self description isSatisfiedBy: 1)
    ]
]



MAReferenceDescriptionTest subclass: MARelationDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MARelationDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    actualClass [
	<category: 'private'>
	^MARelationDescription
    ]

    addressInstance1 [
	<category: 'private'>
	^(MAMockAddress new)
	    street: 'Tillierstrasse 17';
	    plz: 3005;
	    place: 'Bern';
	    yourself
    ]

    addressInstance2 [
	<category: 'private'>
	^(MAMockAddress new)
	    street: 'In der Au';
	    plz: 8765;
	    place: 'Engi';
	    yourself
    ]

    setUp [
	<category: 'running'>
	super setUp.
	(self description)
	    reference: MAMockAddress magritteDescription;
	    classes: (Array with: MAMockAddress)
    ]

    shouldSkipStringTests [
	<category: 'private'>
	^true
    ]

    testCopyClasses [
	<category: 'tests-copying'>
	self assert: self description copy classes = self description classes.
	self deny: self description copy classes == self description classes
    ]
]



MARelationDescriptionTest subclass: MAToManyRelationDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAToManyRelationDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAToManyRelationDescription
    ]

    includedInstance [
	<category: 'private'>
	^Array with: self addressInstance1 with: self addressInstance2
    ]

    testDefinitive [
	<category: 'tests-properties'>
	self description beDefinitive.
	self assert: self description isDefinitive.
	self assert: self description definitive.
	self description beModifiable.
	self deny: self description isDefinitive.
	self deny: self description definitive
    ]

    testOrdered [
	<category: 'tests-properties'>
	self description beOrdered.
	self assert: self description isOrdered.
	self assert: self description ordered.
	self description beUnordered.
	self deny: self description isOrdered.
	self deny: self description ordered
    ]

    testSorted [
	<category: 'tests-properties'>
	self description beSorted.
	self assert: self description isSorted.
	self assert: self description sorted.
	self description beUnsorted.
	self deny: self description isSorted.
	self deny: self description sorted
    ]
]



MAToManyRelationDescriptionTest subclass: MAToManyScalarRelationDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    actualClass [
	<category: 'private'>
	^MAToManyScalarRelationDescription
    ]

    includedInstance [
	<category: 'private'>
	^Array with: '1' with: '2'
    ]

    setUp [
	<category: 'running'>
	super setUp.
	(self description)
	    reference: ((MAStringDescription new)
			accessor: MANullAccessor new;
			yourself);
	    classes: (Array with: String)
    ]
]



MARelationDescriptionTest subclass: MAToOneRelationDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAToOneRelationDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAToOneRelationDescription
    ]

    includedInstance [
	<category: 'private'>
	^self addressInstance1
    ]
]



MAReferenceDescriptionTest subclass: MATableDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MATableDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MATableDescription
    ]

    includedInstance [
	<category: 'private'>
	^MATableModel 
	    rows: 3
	    columns: 3
	    contents: #('1' '2' '3' '2' '4' '6' '3' '6' '9')
    ]

    shouldSkipStringTests [
	<category: 'private'>
	^true
    ]
]



MAReferenceDescriptionTest subclass: MATokenDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MATokenDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MATokenDescription
    ]

    includedInstance [
	<category: 'private'>
	^#('foo' 'bar')
    ]

    testFromStringInvalid [
	"There is no invalid string input."

	<category: 'tests-strings'>
	
    ]
]



MAElementDescriptionTest subclass: MAStringDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAStringDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAStringDescription
    ]

    includedInstance [
	<category: 'private'>
	^'Lukas Renggli'
    ]

    testFromStringInvalid [
	"There is no invalid string input."

	<category: 'tests-strings'>
	
    ]
]



MAStringDescriptionTest subclass: MAMemoDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    actualClass [
	<category: 'private'>
	^MAMemoDescription
    ]

    testLineCount [
	<category: 'tests-properties'>
	self description lineCount: 123.
	self assert: self description lineCount = 123
    ]
]



MAStringDescriptionTest subclass: MAPasswordDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MAPasswordDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAPasswordDescription
    ]

    testIsObfuscated [
	<category: 'tests'>
	self deny: (self description isObfuscated: '').
	self deny: (self description isObfuscated: nil).
	self deny: (self description isObfuscated: 123).
	self deny: (self description isObfuscated: '**1').
	self assert: (self description isObfuscated: '******')
    ]

    testObfuscated [
	<category: 'tests'>
	self assert: (self description obfuscated: nil) = ''.
	self assert: (self description obfuscated: 'zork') = '****'.
	self assert: (self description obfuscated: 'foobar') = '******'
    ]
]



MAStringDescriptionTest subclass: MASymbolDescriptionTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Description'>

    MASymbolDescriptionTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MASymbolDescription
    ]

    includedInstance [
	<category: 'private'>
	^#magritte
    ]

    testValidateConditions [
	<category: 'tests-validation'>
	
    ]
]



MAObjectTest subclass: MAMementoTest [
    | memento value description |
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Memento'>

    MAMementoTest class >> isAbstract [
	<category: 'testing'>
	^true
    ]

    actualClass [
	<category: 'private'>
	^MAMemento
    ]

    defaultInstance [
	<category: 'private'>
	^'Lukas Renggli'
    ]

    descriptionInstance [
	<category: 'private'>
	^MAContainer with: ((MAStringDescription new)
		    default: self defaultInstance;
		    accessor: #value;
		    yourself)
    ]

    descriptionValue [
	<category: 'accessing'>
	^self magritteDescription children first
    ]

    includedInstance [
	<category: 'private'>
	^'Rene Magritte'
    ]

    instance [
	<category: 'accessing'>
	^memento
    ]

    invalidInstance [
	<category: 'private'>
	^31415
    ]

    magritteDescription [
	<category: 'acessing-magritte'>
	^description
    ]

    memento [
	<category: 'accessing'>
	^memento
    ]

    mementoInstance [
	<category: 'private'>
	^self actualClass model: self modelInstance
    ]

    modelInstance [
	<category: 'private'>
	^self
    ]

    nullInstance [
	<category: 'private'>
	^nil
    ]

    otherInstance [
	<category: 'private'>
	^'Ursula Freitag'
    ]

    read [
	<category: 'accessing-memento'>
	^self memento readUsing: self descriptionValue
    ]

    setUp [
	<category: 'running'>
	super setUp.
	description := self descriptionInstance.
	memento := self mementoInstance
    ]

    testCommit [
	<category: 'tests-actions'>
	self subclassResponsibility
    ]

    testDescription [
	<category: 'tests-accessing'>
	self assert: self memento magritteDescription = self magritteDescription.
	self assert: self memento magritteDescription = self descriptionInstance
    ]

    testModel [
	<category: 'tests-accessing'>
	self assert: self memento model = self modelInstance
    ]

    testRead [
	<category: 'tests-basic'>
	self subclassResponsibility
    ]

    testReset [
	<category: 'tests-actions'>
	self subclassResponsibility
    ]

    testValidateIncluded [
	<category: 'tests-actions'>
	self write: self includedInstance.
	self shouldnt: [self memento validate] raise: MAValidationError
    ]

    testValidateInvalid [
	<category: 'tests-actions'>
	self write: self invalidInstance.
	self should: [self memento validate] raise: MAValidationError
    ]

    testValidateRequired [
	<category: 'tests-actions'>
	self descriptionValue beRequired.
	self write: self nullInstance.
	self should: [self memento validate] raise: MAValidationError
    ]

    testWrite [
	<category: 'tests-basic'>
	self subclassResponsibility
    ]

    value [
	<category: 'accessing-model'>
	^value
    ]

    value: anObject [
	<category: 'accessing-model'>
	value := anObject
    ]

    write: anObject [
	<category: 'accessing-memento'>
	self memento write: anObject using: self descriptionValue
    ]
]



MAMementoTest subclass: MACachedMementoTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Memento'>

    MACachedMementoTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MACachedMemento
    ]

    testCache [
	<category: 'tests-accessing'>
	self assert: self memento cache size = self magritteDescription size
    ]

    testCommit [
	<category: 'tests-actions'>
	self write: self includedInstance.
	self assert: self read = self includedInstance.
	self assert: self value = self nullInstance.
	self assert: self memento hasChanged.
	self memento commit.
	self assert: self read = self includedInstance.
	self assert: self value = self includedInstance.
	self deny: self memento hasChanged
    ]

    testRead [
	<category: 'tests-basic'>
	self assert: self read = self defaultInstance.
	self value: self includedInstance.
	self assert: self read = self defaultInstance
    ]

    testReset [
	<category: 'tests-actions'>
	self value: self defaultInstance.
	self write: self includedInstance.
	self assert: self memento hasChanged.
	self memento reset.
	self assert: self read = self defaultInstance.
	self assert: self value = self defaultInstance.
	self deny: self memento hasChanged
    ]

    testWrite [
	<category: 'tests-basic'>
	self write: self includedInstance.
	self assert: self read = self includedInstance.
	self assert: self value = self nullInstance.
	self write: self defaultInstance.
	self assert: self read = self defaultInstance.
	self assert: self value = self nullInstance
    ]
]



MACachedMementoTest subclass: MACheckedMementoTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Memento'>

    MACheckedMementoTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MACheckedMemento
    ]

    testConflictCommit [
	<category: 'tests-actions'>
	self write: self includedInstance.
	self assert: self read = self includedInstance.
	self assert: self memento hasChanged.
	self deny: self memento hasConflict.
	self value: self otherInstance.
	self assert: self read = self includedInstance.
	self assert: self memento hasChanged.
	self assert: self memento hasConflict.
	self memento commit.
	self assert: self read = self includedInstance.
	self assert: self value = self includedInstance.
	self deny: self memento hasChanged.
	self deny: self memento hasConflict
    ]

    testConflictReset [
	<category: 'tests-actions'>
	self write: self includedInstance.
	self assert: self read = self includedInstance.
	self assert: self memento hasChanged.
	self deny: self memento hasConflict.
	self value: self otherInstance.
	self assert: self read = self includedInstance.
	self assert: self memento hasChanged.
	self assert: self memento hasConflict.
	self memento reset.
	self assert: self read = self otherInstance.
	self assert: self value = self otherInstance.
	self deny: self memento hasChanged.
	self deny: self memento hasConflict
    ]

    testOriginal [
	<category: 'tests-accessing'>
	self assert: self memento original size = self magritteDescription size
    ]

    testValidateConflictCommit [
	<category: 'tests-actions'>
	self write: self includedInstance.
	self shouldnt: [self memento validate] raise: MAValidationError.
	self value: self otherInstance.
	self should: [self memento validate] raise: MAValidationError.
	self memento commit.
	self shouldnt: [self memento validate] raise: MAValidationError
    ]

    testValidateConflictReset [
	<category: 'tests-actions'>
	self write: self includedInstance.
	self shouldnt: [self memento validate] raise: MAValidationError.
	self value: self otherInstance.
	self should: [self memento validate] raise: MAValidationError.
	self memento reset.
	self shouldnt: [self memento validate] raise: MAValidationError
    ]
]



MAMementoTest subclass: MAStraitMementoTest [
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Memento'>

    MAStraitMementoTest class >> isAbstract [
	<category: 'testing'>
	^false
    ]

    actualClass [
	<category: 'private'>
	^MAStraitMemento
    ]

    testCommit [
	<category: 'tests-actions'>
	self write: self includedInstance.
	self assert: self value = self includedInstance.
	self assert: self read = self includedInstance.
	self memento commit.
	self assert: self value = self includedInstance.
	self assert: self read = self includedInstance
    ]

    testRead [
	<category: 'tests-basic'>
	self assert: self read = self defaultInstance.
	self value: self includedInstance.
	self assert: self read = self includedInstance.
	self value: self defaultInstance.
	self assert: self read = self defaultInstance
    ]

    testReset [
	<category: 'tests-actions'>
	self write: self includedInstance.
	self memento reset.
	self assert: self read = self includedInstance
    ]

    testValidateRequired [
	<category: 'tests-actions'>
	
    ]

    testWrite [
	<category: 'tests-basic'>
	self write: self includedInstance.
	self assert: self value = self includedInstance.
	self write: self defaultInstance.
	self assert: self value = self defaultInstance.
	self write: self nullInstance.
	self assert: self value = self nullInstance
    ]
]



TestCase subclass: MATableModelTest [
    | table |
    
    <comment: nil>
    <category: 'Magritte-Tests-Model-Models'>

    setUp [
	<category: 'running'>
	table := (MATableModel rows: 3 columns: 4) 
		    collect: [:row :col :value | row raisedTo: col]
    ]

    testAtAt [
	<category: 'tests-accessing'>
	self assert: (table at: 1 at: 1) = 1.
	self assert: (table at: 2 at: 3) = 8.
	self assert: (table at: 3 at: 2) = 9.
	self assert: (table at: 3 at: 4) = 81
    ]

    testAtAtAbsent [
	<category: 'tests-accessing'>
	self should: [table at: 0 at: 1] raise: Error.
	self should: [table at: 1 at: 0] raise: Error.
	self should: [table at: 4 at: 4] raise: Error.
	self should: [table at: 3 at: 5] raise: Error
    ]

    testAtAtPut [
	<category: 'tests-accessing'>
	self assert: (table 
		    at: 1
		    at: 1
		    put: -1) = -1.
	self assert: (table 
		    at: 2
		    at: 3
		    put: -8) = -8.
	self assert: (table 
		    at: 3
		    at: 2
		    put: -9) = -9.
	self assert: (table 
		    at: 3
		    at: 4
		    put: -81) = -81.
	self assert: (table at: 1 at: 1) = -1.
	self assert: (table at: 2 at: 3) = -8.
	self assert: (table at: 3 at: 2) = -9.
	self assert: (table at: 3 at: 4) = -81
    ]

    testAtAtPutAbsent [
	<category: 'tests-accessing'>
	self should: 
		[table 
		    at: 0
		    at: 1
		    put: 0]
	    raise: Error.
	self should: 
		[table 
		    at: 1
		    at: 0
		    put: 0]
	    raise: Error.
	self should: 
		[table 
		    at: 4
		    at: 4
		    put: 0]
	    raise: Error.
	self should: 
		[table 
		    at: 3
		    at: 5
		    put: 0]
	    raise: Error
    ]

    testCollect [
	<category: 'tests-enumerating'>
	table := table collect: [:row :col :val | row + col + val].
	table 
	    do: [:row :col :val | self assert: (row raisedTo: col) = (val - row - col)]
    ]

    testContents [
	<category: 'tests-accessing'>
	self assert: table contents = #(1 1 1 1 2 4 8 16 3 9 27 81)
    ]

    testCopy [
	<category: 'tests-copying'>
	self assert: table copy rowCount = table rowCount.
	self assert: table copy columnCount = table columnCount.
	self assert: table copy contents = table contents.
	self deny: table copy contents == table contents
    ]

    testCopyEmpty [
	<category: 'tests-copying'>
	self assert: table copyEmpty rowCount = table rowCount.
	self assert: table copyEmpty columnCount = table columnCount.
	self assert: (table copyEmpty contents allSatisfy: [:each | each isNil])
    ]

    testCopyRowsColumns [
	<category: 'tests-copying'>
	self assert: (table copyRows: 1 columns: 2) rowCount = 1.
	self assert: (table copyRows: 1 columns: 2) columnCount = 2.
	self assert: (table copyRows: 1 columns: 2) contents = #(1 1).
	self assert: (table copyRows: 4 columns: 3) rowCount = 4.
	self assert: (table copyRows: 4 columns: 3) columnCount = 3.
	self assert: (table copyRows: 4 columns: 3) contents 
		    = #(1 1 1 2 4 8 3 9 27 nil nil nil)
    ]

    testCoumnCount [
	<category: 'tests-accessing'>
	self assert: table columnCount = 4
    ]

    testDo [
	<category: 'tests-enumerating'>
	table do: [:row :col :val | self assert: (row raisedTo: col) = val]
    ]

    testEqual [
	<category: 'tests-comparing'>
	self assert: table = table.
	self assert: table = table copy.
	self assert: table copy = table.
	self assert: table copy = table copy.
	self deny: table = (table copy 
			    at: 1
			    at: 2
			    put: 3).
	self deny: table = (table copyRows: 3 columns: 3).
	self deny: table = (table copyRows: 4 columns: 4)
    ]

    testHash [
	<category: 'tests-comparing'>
	self assert: table hash = table hash.
	self assert: table hash = table copy hash.
	self assert: table copy hash = table hash.
	self assert: table copy hash = table copy hash
    ]

    testRowCount [
	<category: 'tests-accessing'>
	self assert: table rowCount = 3
    ]

    testSetup [
	<category: 'tests'>
	self assert: table rowCount = 3.
	self assert: table columnCount = 4.
	self assert: table contents = #(1 1 1 1 2 4 8 16 3 9 27 81)
    ]
]



Object subclass: MAAccessorMock [
    
    <category: 'Magritte-Tests-Model-Accessor'>
    <comment: nil>
]



Object subclass: MAMockAddress [
    | place street plz |
    
    <category: 'Magritte-Tests-Model-Mocks'>
    <comment: nil>

    = anObject [
	<category: 'comparing'>
	^self species = anObject species and: 
		[self street = anObject street 
		    and: [self plz = anObject plz and: [self place = anObject place]]]
    ]

    descriptionContainer [
	<category: 'acessing-magritte'>
	<magritteContainer>
	^(super descriptionContainer)
	    propertyAt: #addressContainerBase put: nil;
	    yourself
    ]

    descriptionNilled1 [
	<category: 'acessing-magritte'>
	<magritteDescription>
	^nil
    ]

    descriptionNilled1: aDescription [
	<category: 'acessing-magritte'>
	<magritteDescription: #descriptionNilled1>
	^aDescription beRequired
    ]

    descriptionNilled2 [
	<category: 'acessing-magritte'>
	<magritteDescription>
	^MAStringDescription new
    ]

    descriptionNilled2: aDescription [
	<category: 'acessing-magritte'>
	<magritteDescription: #descriptionNilled2>
	^nil
    ]

    descriptionPlace [
	<category: 'acessing-magritte'>
	<magritteDescription>
	^(MAStringDescription new)
	    accessor: #place;
	    label: 'Place';
	    yourself
    ]

    descriptionPlace: aDescription [
	<category: 'acessing-magritte'>
	<magritteDescription: #descriptionPlace>
	^aDescription beRequired
    ]

    descriptionPlaceOther: aDescription [
	<category: 'acessing-magritte'>
	<magritteDescription: #descriptionPlace>
	^aDescription beHidden
    ]

    descriptionPlz [
	<category: 'acessing-magritte'>
	<magritteDescription>
	^(MANumberDescription new)
	    accessor: #plz;
	    label: 'PLZ';
	    yourself
    ]

    descriptionStreet [
	<category: 'acessing-magritte'>
	<magritteDescription>
	^(MAStringDescription new)
	    accessor: #street;
	    label: 'Street';
	    yourself
    ]

    hash [
	<category: 'comparing'>
	^self street hash
    ]

    place [
	<category: 'accessing-generated'>
	^place
    ]

    place: anObject [
	<category: 'accessing-generated'>
	place := anObject
    ]

    plz [
	<category: 'accessing-generated'>
	^plz
    ]

    plz: anObject [
	<category: 'accessing-generated'>
	plz := anObject
    ]

    street [
	<category: 'accessing-generated'>
	^street
    ]

    street: anObject [
	<category: 'accessing-generated'>
	street := anObject
    ]
]



MAMockAddress subclass: MAMockAddress2 [
    
    <category: 'Magritte-Tests-Model-Mocks'>
    <comment: nil>

    descriptionContainer [
	"this pragma #magritteContainer is optional as the pragma will be retrieved from the super class's overridden method."

	<category: 'acessing-magritte'>
	<magritteContainer>
	^(super descriptionContainer)
	    propertyAt: #addressContainerDerived put: nil;
	    yourself
    ]

    descriptionStreet [
	"this pragma #magritteDescription is optional as the pragma will be retrieved from the super class's overridden method."

	<category: 'acessing-magritte'>
	<magritteDescription>
	^(super descriptionStreet)
	    beRequired;
	    yourself
    ]
]

