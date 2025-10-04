To pass options from a submodule context back into the global context without risking a infinite recursion, 
I have to have some sort of breaking condition, since I have to re-evaluate all options with the new global configuration values. This condition should succeed if there arent any values that differ from the existing values.
