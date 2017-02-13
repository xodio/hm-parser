
@builtin "whitespace.ne"
@{%
  const R = require('ramda');
%}

type ->
    typevar
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

typeConstructorArg -> typevar | nullaryTypeConstructor {%
  data => data[0]
%}

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
      R.flatten,
      R.pluck(1),
      R.prop(1)
    )(data),
  })
%}

constrainedTypeArg ->
    nullaryTypeConstructor
  | typevar {% data => data[0] %}

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
