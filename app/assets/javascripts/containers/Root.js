import React, { Component } from 'react';
import { Provider } from 'react-redux';
import { Router, Route } from 'react-router';
import configureStore from '../store/configureStore';
import App from './App';

const store = configureStore();

var Root = React.createClass({
  render() {
    return (
      <div>
        <Provider store={store}>
        {() =>
          <Router history={this.props.history}>
            <Route path='/admin' component={App} />
          </Router>
        }
        </Provider>
      </div>
    );
  }
});

module.exports = Root;
