SFDelegate2Block is lightweight and easy way to handle Objective-C delegates directly with blocks. 

Installation:
Add SFDelegate2Block dir to your project.

How to use:
- Create SFDelegate2Block object with appropriate delegate Protocol. It is possible to use  it without setting Protocol directly but proper work in this case not guarantied.
- Add one or few blocks to this object by calling setBlock:forSelector: method. See example project for details about block interface.
- Set SFDelegate2Block object as delegate like object.delegate = myDelegate2Block;