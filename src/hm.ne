
@builtin "whitespace.ne"
@{%
  const R = require('ramda');
%}

signature -> name _ "::" _ rootType

rootType ->
    function
  | type

type ->
    typevar
  | typeConstructor

function -> type (_ "->" _ type):+ {%
  data => ({
    type: 'function',
    children: data,
  })
%}

typevar -> [a-z] {%
  data => ({
    type: 'typevar',
    text: data[0],
  })
%}

name -> [a-zA-Z0-9_]:+ {%
  data => ({
    type: 'name',
    name: R.compose(R.join(''), R.flatten)(data),
  })
%}

typeConstructor -> [A-Z] [a-zA-Z0-9_]:* {%
  data => ({
    type: 'typeConstructor',
    name: R.compose(R.join(''), R.flatten)(data),
  })
%}
