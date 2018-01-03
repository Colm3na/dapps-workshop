module.exports = {
  root: true,
  parserOptions: {
    parser: 'babel-eslint',
    sourceType: 'module',
  },
  env: {
    browser: true,
  },
  extends: ['airbnb/base', 'plugin:vue/base'],
  plugins: ['html', 'import'],
  globals: {
    cordova: true,
    DEV: true,
    PROD: true,
    __THEME: true,
  },
  rules: {
    'import/first': 0,
    'import/named': 2,
    'import/namespace': 2,
    'import/default': 2,
    'import/export': 2,
    'import/no-dynamic-require': 0,
    // allow debugger during development
    'no-debugger': process.env.NODE_ENV === 'production' ? 2 : 0,
    'global-require': 0,
    'function-paren-newline': ['error', 'consistent'],
    'no-empty-pattern': 0,
  },
};
