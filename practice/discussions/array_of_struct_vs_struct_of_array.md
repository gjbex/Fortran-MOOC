# Arrays of user defined type versus user defined types with array elements

When storing certain types of data, you typically have a number of choices.  For example, consider data related to particles, e.g., position, momentum, mass, ...  This data can be represented as a user defined type.  When considering multiple particles, all particle data could be stored in an array with element of that user defined type.

Alternatively, the data of all particles could be stored in a user defined types that contains arrays that store the positions and other data of all particles.

Which would you prefer?  How does this relate to efficiency and caches?
