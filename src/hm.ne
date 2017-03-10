
@builtin "whitespace.ne"
@{%
  const R = require('ramda');
%}

declaration -> name _ "::" (_ classConstraints _ "=>"):? _ type {%
  data => ({
    name: data[0],
    constraints: R.pathOr([], [3, 1], data),
    type: data[5],
  })
%}

type ->
  ( typevar
  | list
  | typeConstructor
  | function
  | thunk
  | uncurriedFunction
  | constrainedType
  | method
  | record
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

# Name ========================================================================

name -> [A-Za-z0-9_'#@-]:+ {% data => R.join('', data[0]) %}

# Class constraints ===========================================================

classConstraints ->
  ( constraint
  | wrappedConstraints
  ) {% data => data[0][0] %}

constraint -> capId __ lowId {%
  data => [{
    typeclass: data[0],
    typevar: data[2],
  }]
%}

wrappedConstraints -> "(" _ constraint (_ "," _ constraint):* _ ")" {%
  data => data[2].concat(
    R.unnest(R.pluck(3)(data[3]))
  )
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
  | list
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

constrainedType -> lowId (__ constrainedTypeArg):+ {%
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
  | wrappedUncurriedFunction
  | wrappedThunk
  | record
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

wrappedUncurriedFunction -> "(" _ uncurriedFunction _ ")" {% data => data[2] %}

# Method ======================================================================

method -> typeConstructor _ "~>" _ functionArg (_ "->" _ functionArg):* {%
  data => ({
    type: 'method',
    text: '',
    children: [data[0], data[4]].concat(R.pluck(3)(data[5]))
  })
%}

# Thunk ======================================================================

thunk -> thunkParenthesis (_ "->" _ functionArg):+ {%
  data => ({
    type: 'function',
    text: '',
    children: [data[0]].concat(R.pluck(3)(data[1])),
  })
%}

thunkParenthesis -> "(" _ ")" {%
  data => ({
    type: 'thunk',
    text: '',
    children: [],
  })
%}

wrappedThunk -> "(" _ thunk _ ")" {% data => data[2] %}

# Record =====================================================================

record -> "{" _ recordField (_ "," _ recordField):* _ "}" {%
  data => ({
    type: 'record',
    text: '',
    children: [data[2]].concat(R.pluck(3)(data[3])),
  })
%}

recordField -> recordFieldName _ "::" _ type {%
  data => ({
    type: 'field',
    text: data[0],
    children: [data[4]],
  })
%}

recordFieldName -> [A-Za-z0-9_]:+ {% data => R.join('', data[0]) %}
