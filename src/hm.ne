
@builtin "whitespace.ne"
@{%
  const R = require('ramda');
%}

signature -> funcName _ "::" _ typeConstructor _ "->" _ typeConstructor

funcName -> [a-zA-Z0-9_]:+ {%
  data => ({
    type: 'name',
    name: R.compose(R.join(''), R.flatten)(data),
    children: [],
  })
%}

typeConstructor -> [A-Z] [a-zA-Z0-9_]:* {%
  data => ({
    type: 'typeConstructor',
    name: R.compose(R.join(''), R.flatten)(data),
    children: [],
  })
%}
