

var path = require('path');
var webpack = require('webpack');

var webpack = require('webpack');
var _ = require('lodash');

var config = module.exports = require('./main.config.js');

config = _.merge(config, {
  debug: true,
  displayErrorDetails: true,
  outputPathinfo: true,
  devtool: 'sourcemap',
});

config.plugins.push(
  new webpack.optimize.CommonsChunkPlugin('common', 'common-bundle.js')
);

config.plugins.push(
  new webpack.optimize.DedupePlugin()
);


config.plugins.push(
  new webpack.HotModuleReplacementPlugin()
);
