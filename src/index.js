
import nearley from 'nearley';
import grammar from './grammar';

export function typeConstructor(s) {
  const parser = new nearley.Parser(
    grammar.ParserRules,
    'typeConstructor',
  );

  parser.feed(s);

  return parser.results;
}
