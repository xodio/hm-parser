
Hindley Milner Parser
=====================

This is a parser for Haskell-alike Hindley Milner signatures with some sugar
added to support JS-specific things like methods.

It is a drop-in replacement for
[hindley-milner-parser-js](https://github.com/kedashoe/hindley-milner-parser-js)
package which is based on [mona](https://github.com/zkat/mona). Mona has few
problems: it is very slow if used with Mocha test runner and it imports
`babel-polyfill` by hard-code what makes it impossible to use within projects
that use another version of `babel-polyfill`.

Usage
-----

See [tests](test/test.js) for examples.

License
-------

MIT
