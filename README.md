# Iron

This programming language writen in YACC will tackle the problematic of front-end definition. It is a general easy to use language, which at some scale can target specific technologies to deploy code to generate an interface. The uses are numerous, as in one programming language, one can target more platforms at once, without the need of handling syntactical different front-end layouts. 

  
# Goal = Expressions
  
  - finish basic expressions inside functions  -  testing phase
  - keep things clean in case of a probable rethinking
  - documentation

# In progress

Some of the things mantioned are still at a prototype stage, and some features aren't yet mentioned. At the syntax extend, it is defined, but for semantics there is still pleanty of work until an working version.

  - Rethink primitives: there must be only one primitive, the tuple (x, y), which can represent a 4 byte integer(x), an 8 byte long long(xy), or a 
    double (x/y). Also integrate Strings.
  - Testing

# Features

  - main function generates a window with the use of gtk (working only in linux) with a predifined size and caption
  - print identifiers and whole scopes
  - use of integer expressions and change of environment from function to function
  - constants are uniquely defined, error on duplicates
  
# How to use

In in.in there is an example of code interpreted by this language. At first we defined some constants b, c, stdSize and defSize. All "global variables" are in fact constants and are defined with a '.' in front. We can already see 2 types of primitives: int and tuple.

Secondly we defined 2 functions. Inside functions we can use statements like assignments, if structures or loop structures. Also we have access to a print function.

Moreover we can build our own components, which nest other built-in components or already defined ones. The first parameter is a tuple and is the default size of an object of that class.

The last lines are the definition of our main frame. Inside a component we can of course place other components, but we need to specify their position, by the second argument in the constructor, which is a tuple. If we don't specify the size parameter, it should be inherited from the default size specifier of the class. To access proprieties from the class we can use the "$" symbol defore the identifier, so we can make use of things like "caption", "border" etc.

For positioning purposes, we can chose between an absolute positioning: defining explicit coordinates, or relative positioning, using other components to help out alignment. Therefore something like $3 will access the third corned of our component, which is the south-east one (they are numbered in a clockwise order). However, ^3 will also access the third corner, but the parent's one. This can make the things easier in terms of positioning. We can also access explicit some corners, by typing the component's name followed by the corner's number inside brackets. By default, if the corner after which the alignment is made, the $1 will be considered.

If we write $3 = ^3, it means the thrid corner will be where parent's third corner will be. If we write ^1+{5, 5}, by default it will place the first corner at the coordinates of parent's first corner but with a margin of 5.
