import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadRegistrations } from './../actions';

import { Row, Col, Table, Button, Panel} from 'react-bootstrap';
import _ from 'lodash';

export default class RegistrationPage extends Component {

  constructor(props) {
    super(props);
  }

  componentWillMount() {
    this.props.loadRegistrations() ;
  }

  componentWillReceiveProps(nextProps) {
  }

  render() {
    return(
       <Row className='show-grid'>
         <Col xs={12} md={12}>
         <Panel header={<h2>Remote Avi-on</h2>}>
           <Table>
            <thead>
               <tr>
                 <th>Queue</th>
                 <th>Mac Address</th>
                 <th>User ID</th>
                 <th>Location ID</th>
                 <th>Messages</th>
               </tr>
             </thead>
             <tbody>
             {
               _.collect(this.props.registrations, registration => {
                return (<tr key={registration.id}>
                  <td>{registration.queue}</td>
                  <td>{registration.macAddress}</td>
                  <td>{registration.userId}</td>
                  <td>{registration.locationId}</td>
                  <td>
                    <Button bsStyle='primary' onClick={e => this.props.onShowMessages(registration.id)}>
                    Messages
                    </Button>
                  </td>
                </tr>);
               })
             }
             </tbody>
           </Table>
         </Panel>
       </Col>
     </Row>
    );
  }
}

function mapStateToProps(state) {
  return {registrations: state.entities.registrations };
}

export default connect(
  mapStateToProps,
  { loadRegistrations}
)(RegistrationPage);
