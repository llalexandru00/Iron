# Iron

In in.in there is an example of code interpreted by this language. At first we defined some constants b, c, stdSize and defSize. All "global variables" are in fact constants and are defined with a '.' in front. We can already see 2 types of primitives: int and tuple.

Secondly we defined 2 functions. Inside functions we can use statements like assignments, if structures or loop structures. Also we have access to a print function.

Moreover we can build our own components, which nest other built-in components or already defined ones. The first parameter is a tuple and is the default size of an object of that class.

The last lines are the definition of our main frame. Inside a component we can of course place other components, but we need to specify their position, by the second argument in the constructor, which is a tuple. If we don't specify the size parameter, it should be inherited from the default size specifier of the class. To access proprieties from the class we can use the "$" symbol defore the identifier, so we can make use of things like "caption", "border" etc.

For positioning purposes, we can chose between an absolute positioning: defining explicit coordinates, or relative positioning, using other components to help out alignment. Therefore something like $3 will access the third corned of our component, which is the south-east one (they are numbered in a clockwise order). However, ^3 will also access the third corner, but the parent's one. This can make the things easier in terms of positioning. We can also access explicit some corners, by typing the component's name followed by the corner's number inside brackets. By default, if the corner after which the alignment is made, the $1 will be considered.

If we write $3 = ^3, it means the thrid corner will be where parent's third corner will be. If we write ^1+{5, 5}, by default it will place the first corner at the coordinates of parent's first corner but with a margin of 5.
