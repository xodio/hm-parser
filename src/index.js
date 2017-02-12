
import R from 'ramda';
import nearley from 'nearley';
import grammar from './grammar';

const defaultize = R.merge({
  children: [],
  text: '',
});

export function typeConstructor(s) {
  const parser = new nearley.Parser(
    grammar.ParserRules,
    'typeConstructor',
  );

  parser.feed(s);

  return defaultize(parser.results[0]);
}
