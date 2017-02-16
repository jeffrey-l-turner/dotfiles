module.exports = {
    'settings': {
        'import/resolver': {
        },
    },

    'extends': 'eslint:recommended',

    'env': {
        'browser': true,
        'node': true,
        'es6': true,
    },

    'parserOptions': {
        'ecmaVersion': 6,
        'sourceType': 'module',
    },

    'ecmaFeatures': {
        'arrowFunctions': true,
        'binaryLiterals': false,
        'blockBindings': true,
        'classes': true,
        'defaultParams': true,
        'destructuring': true,
        'forOf': true,
        'generators': true,
        'modules': false,
        'objectLiteralComputedProperties': true,
        'objectLiteralDuplicateProperties': false,
        'objectLiteralShorthandMethods': true,
        'objectLiteralShorthandProperties': true,
        'octalLiterals': false,
        'regexUFlag': false,
        'regexYFlag': false,
        'restParams': true,
        'spread': true,
        'superInFunctions': true,
        'templateStrings': true,
        'unicodePointEscapes': true,
        'globalReturn': false,
        'jsx': true,
    },

    'rules': {
       // enable additional rules
        'indent': ['error', 4,],
        'linebreak-style': ['error', 'unix',],
        'quotes': ['error', 'single',],
        'semi': ['error', 'always',],

          // override default options for rules from base configurations
        'comma-dangle': ['error', 'always',],
        'no-cond-assign': ['error', 'always',],

        // disable rules from base configurations
        'no-console': 'off',

        // following Rules are divided into sections from http://eslint.org/docs/rules/

        // Possible errors
        'no-comma-dangle': 0,

        // Best practices
        'block-scoped-var': 2,
        'complexity': [2, 10,],
        'eqeqeq': [2, 'smart',],
        'no-else-return': 2,
        'no-floating-decimal': 2,
        'wrap-iife': [2, 'any',],
        'curly': 2,

        // Variables
        'no-use-before-define': 0,
        'no-undef': 2,

        // Node.js
        'no-mixed-requires': 0,

        // Stylistic issues
        'brace-style': 2,
        'camelcase': 0,
        'new-cap': 0,
        'no-lonely-if': 2,
        'no-underscore-dangle': 0,
        'keyword-spacing': 2,
        'object-curly-spacing': [2, 'never',],
        'space-infix-ops': 2,
        'one-var': 0,
        'no-irregular-whitespace': 2, 

        // Legacy
        'no-bitwise': 2,
        'max-len': [2, 150, 4,],
    },

    'globals': {
        'document': true, 
        '_': true,
        '$': true,
        'window': true, 
    },
};