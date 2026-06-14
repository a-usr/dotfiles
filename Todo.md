# Fuck my life

# Todo
- [x]  Fix up the Modules. I tried to do namespaced files, using a toplevel option that gets passed through to submodules,
however that would result in an infrec, so now you have to amend what my past self changed to the assumedly working system before testing it properly. Fucking dumbass. I hate him.

or, alternatively:

- [x]  Figure out a way to do automatic namespacing using file structure that allows for influence on the global namespace without causing an infrec.
Is this impossible? Maybe. Could try to ask for help online. Might get shamed for attempting to do cursed stuff.
You know what to do about that (No, dont be racist or homophobic or whatever, Ignore them. It's not worth it.)

- [ ]  Add more options for who-knows-what. Also rename a bunch. Past me made some poor choices.
e.g. `General.Headless` instead of something like `HostEnv.HasGraphics` or `With.GraphicalEnvironment`

- [ ] Move towards an "Trait" kind of interface for basic nixos options. E.g. add the "Gaming" trait to a machine to enable steam (as opposed to using `extra.gaming`), or the "nvidia" trait to enable nvidia support. Make those traits directly checked (attrset in function input instead of enum option type). Make trait objects `OverrideAttrs` for trait configs?

