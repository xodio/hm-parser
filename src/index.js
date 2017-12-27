
import { curry } from 'ramda';
import nearley from 'nearley';
import grammar from './grammar';

const parseFrom = curry(function parseFrom(start, s) {
  const parser = new nearley.Parser(
    grammar.ParserRules,
    start
  );

  return parser.feed(s).results[0];
});

export const typeConstructor = parseFrom('typeConstructor');
export const typevar = parseFrom('typevar');
export const constrainedType = parseFrom('constrainedType');
export const list = parseFrom('list');
export const fn = parseFrom('function');
export const uncurriedFunction = parseFrom('uncurriedFunction');
export const method = parseFrom('method');
export const thunk = parseFrom('thunk');
export const record = parseFrom('record');
export const name = parseFrom('name');
export const classConstraints = parseFrom('classConstraints');
export const parse = parseFrom('declaration');

export default {
  typeConstructor,
  typevar,
  constrainedType,
  list,
  fn,
  uncurriedFunction,
  method,
  thunk,
  record,
  name,
  classConstraints,
  parse,
};
