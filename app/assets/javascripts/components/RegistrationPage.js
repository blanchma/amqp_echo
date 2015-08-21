import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadRegistrations } from './../actions';

import { Row, Col, Table} from 'react-bootstrap';
import _ from 'lodash';

export default class RegistrationPage extends Component {

  constructor(props) {
    super(props);
  }

  componentWillMount() {
    this.props.loadRegistrations() ;
  }

  render() {
    return(
       <Row className='show-grid'>
         <Col xs={12} md={12}>
         <Table>
          <thead>
             <tr>
               <th>#</th>
               <th>First Name</th>
               <th>Last Name</th>
               <th>Username</th>
             </tr>
           </thead>
           <tbody>
           {
             _.collect(this.props.registrations, function(registration) {
               return <tr><td>{registration.queue}</td></tr>;
             })
           }
           </tbody>
         </Table>
       </Col>
     </Row>
    );
  }
}

function mapStateToProps(state) {
  return { registrations: state.registrations };
}

export default connect(
  mapStateToProps,
  { loadRegistrations}
)(RegistrationPage);
