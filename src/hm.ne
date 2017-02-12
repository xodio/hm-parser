
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
    children: [],
  })
%}

name -> [a-zA-Z0-9_]:+ {%
  data => ({
    type: 'name',
    name: R.compose(R.join(''), R.flatten)(data),
  })
%}

capId -> [A-Z] [a-zA-Z0-9_]:* {%
  data => data[0] + R.join('', data[1])
%}

typeConstructorArg -> typevar | nullaryTypeConstructor

nullaryTypeConstructor -> capId {%
  data => ({
    type: 'typeConstructor',
    text: data[0],
    children: [],
  })
%}

typeConstructor -> capId (__ typeConstructorArg):* {%
  data => ({
    type: 'typeConstructor',
    text: data[0],
    children: R.compose(
      R.pluck(0),
      R.pluck(1),
      R.prop(1)
    )(data),
  })
%}
