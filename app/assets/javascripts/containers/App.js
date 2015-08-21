import React from 'react';
import { Grid } from 'react-bootstrap';
import Header from '../components/Header';
import RegistrationPage from '../components/RegistrationPage';

var App = React.createClass({
  render: function() {
    return (
      <Grid>
        <Header />
        <RegistrationPage />
      </Grid>
    );
  }
});

module.exports = App;
