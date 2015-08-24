import React from 'react';
import { Grid } from 'react-bootstrap';
import Header from '../components/Header';
import RegistrationPage from '../components/RegistrationPage';
import MessageList from '../components/MessageList';
import InboxForm from '../components/InboxForm';




var App = React.createClass({
  getInitialState: function() {
    return {
      rabId: null
    }
  },

  render: function() {
    return (
      <Grid>
        <Header />
        <RegistrationPage onShowMessages={this.handleShowMessages}/>
        <InboxForm rabId={this.state.rabId} />
        <MessageList rabId={this.state.rabId}/>
      </Grid>
    );
  },

  handleShowMessages: function(rabId) {
    this.setState({rabId: rabId})
  }
});

module.exports = App;
