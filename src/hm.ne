
@builtin "whitespace.ne"
@{%
  const R = require('ramda');
%}

type ->
    typevar
  | list
  | typeConstructor {% data => data[0] %}

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
    children: R.compose(
      R.flatten,
      R.pluck(1),
      R.prop(1)
    )(data),
  })
%}

typeConstructorArg ->
    typevar
  | wrappedConstrainedType
  | nullaryTypeConstructor
  | wrappedTypeConstructor {% data => data[0] %}

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
    nullaryTypeConstructor
  | typevar
  | wrappedTypeConstructor
  | wrappedConstrainedType {% data => data[0] %}

constrainedType -> lowId (__ constrainedTypeArg):* {%
  data => ({
    type: 'constrainedType',
    text: data[0],
    children: R.compose(
      R.flatten,
      R.pluck(1),
      R.prop(1)
    )(data),
  })
%}

wrappedConstrainedType -> "(" _ constrainedType _ ")" {% data => data[2] %}

# List ========================================================================

list -> "[" _ type _ "]" {%
  data => ({
    type: 'list',
    text: '',
    children: R.flatten([ data[2] ]),
  })
%}
