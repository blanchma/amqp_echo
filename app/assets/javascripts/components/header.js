import React from 'react';
import { Row, Col} from 'react-bootstrap';

var Header = React.createClass({
  render: function() {
    return(
      <nav className="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div className="container">
          <a className="navbar-brand" href="#">Avi-on Bridge</a>
        </div>
      </nav>
    );
  }
});

module.exports = Header;
