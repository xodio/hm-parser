
@builtin "whitespace.ne"
@{%
  const R = require('ramda');
%}

type ->
  ( typevar
  | list
  | typeConstructor
  | function
  ) {% data => data[0][0] %}

typevar -> lowId {%
  data => ({
    type: 'typevar',
    text: data[0],
    children: [],
  })
%}

lowId -> [a-z] [a-zA-Z0-9_]:* {%
  data => data[0] + R.join('', data[1])
%}

capId -> [A-Z] [a-zA-Z0-9_]:* {%
  data => data[0] + R.join('', data[1])
%}

# Type constructor ============================================================

typeConstructor -> capId (__ typeConstructorArg):* {%
  data => ({
    type: 'typeConstructor',
    text: data[0],
    children: R.pluck(1)(data[1]),
  })
%}

typeConstructorArg ->
  ( typevar
  | wrappedConstrainedType
  | nullaryTypeConstructor
  | wrappedTypeConstructor
  ) {% data => data[0][0] %}

nullaryTypeConstructor -> capId {%
  data => ({
    type: 'typeConstructor',
    text: data[0],
    children: [],
  })
%}

wrappedTypeConstructor -> "(" _ typeConstructor _ ")" {% data => data[2] %}

# Constrained type ============================================================

constrainedTypeArg ->
  ( nullaryTypeConstructor
  | typevar
  | wrappedTypeConstructor
  | wrappedConstrainedType
  ) {% data => data[0][0] %}

constrainedType -> lowId (__ constrainedTypeArg):* {%
  data => ({
    type: 'constrainedType',
    text: data[0],
    children: R.pluck(1)(data[1]),
  })
%}

wrappedConstrainedType -> "(" _ constrainedType _ ")" {% data => data[2] %}

# List ========================================================================

list -> "[" _ type _ "]" {%
  data => ({
    type: 'list',
    text: '',
    children: [ data[2] ],
  })
%}

# Function ====================================================================

function -> functionArg (_ "->" _ functionArg):+ {%
  data => ({
    type: 'function',
    text: '',
    children: [data[0]].concat(R.pluck(3)(data[1])),
  })
%}

functionArg ->
  ( typevar
  | list
  | typeConstructor
  | constrainedType
  | wrappedFunction
  ) {% data => data[0][0] %}

wrappedFunction -> "(" _ function _ ")" {% data => data[2] %}

# Uncurried function ==========================================================

uncurriedFunction -> uncurriedFunctionParams _ "->" _ type {%
  data => ({
    type: 'uncurriedFunction',
    text: '',
    children: [data[0], data[4]],
  })
%}

uncurriedFunctionParams -> "(" _ type (_ "," _ type):+ _ ")" {%
  data => ({
    type: 'parameters',
    text: '',
    children: [data[2]].concat(R.pluck(3)(data[3])),
  })
%}

# Method ======================================================================

method -> typeConstructor _ "~>" _ functionArg (_ "->" _ functionArg):* {%
  data => ({
    type: 'method',
    text: '',
    children: [data[0], data[4]].concat(R.pluck(3)(data[5]))
  })
%}
