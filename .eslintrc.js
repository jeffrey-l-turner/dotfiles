module.exports = {

  'settings': {
    'import/ignore': [
      'node_modules',
      '\\.json$',
      '\\.(scss|less|css)$'
    ],
    'import/parser': 'babel-eslint',
    'import/resolve': {
      'extensions': [
        '.js',
        '.jsx',
        '.json'
      ]
    }
  },

  'plugins': [
  ],

  'extends': [
   ],

  'env': {
    'browser': true,
    'node': true,
    'es6': true,
    'jest': true,
  },

  'globals': {
    'document': true, 
    '_': true,
    '$': true,
    'window': true, 
  },

  'parserOptions': {
    'ecmaVersion': 6,
    'sourceType': 'module',
  },

}



