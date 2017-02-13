
import R from 'ramda';
import nearley from 'nearley';
import grammar from './grammar';

const parse = R.curry(function parse(start, s) {
  const parser = new nearley.Parser(
    grammar.ParserRules,
    start
  );

  return parser.feed(s).results[0];
});

export const typeConstructor = parse('typeConstructor');
export const typevar = parse('typevar');
export const constrainedType = parse('constrainedType');
