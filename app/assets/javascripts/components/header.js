import React from 'react';
import { Navbar} from 'react-bootstrap';

var Header = React.createClass({
  render: function() {
    return(
       <Navbar inverse fixedTop={true} brand='Avi-on Bridge'>
       </Navbar>
    );
  }
});

module.exports = Header;
