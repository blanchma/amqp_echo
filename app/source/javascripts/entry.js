var _ = require('lodash');
_.times(5, function(i) {
  console.log(i);
});
var React  = require('react');
var ReactBootstrap = require('react-bootstrap');

React.render(
  <h1>Hello, Tute!</h1>,
  document.getElementById('example')
);
