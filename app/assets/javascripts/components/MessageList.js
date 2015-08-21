import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadMessages } from './../actions';

import { Row, Col, Table, Button} from 'react-bootstrap';
import _ from 'lodash';

export default class MessageList extends Component {

  constructor(props) {
    super(props);
  }

  componentWillMount() {
    if (this.props.rabId !== null) {
      this.props.loadMessages(this.props.rabId);
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.rabId !== this.props.rabId && nextProps.rabId !== null) {
      this.props.loadMessages(nextProps.rabId);
    }
  }

  render() {
    return(
       <Row className='show-grid'>
         <Col xs={12} md={12}>
         <Table>
          <thead>
             <tr>
               <th>Message ID</th>
               <th>Raw</th>
               <th>Device</th>
               <th>Direction</th>
             </tr>
           </thead>
           <tbody>
           {
             _.collect(this.props.messages, message => {
              return (
                <tr>
                  <td>{message.messageId}</td>
                  <td>{message.body}</td>
                  <td>{message.deviceAvid}</td>
                  <td>{message.direction}</td>
                </tr>);
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
  return {messages: state.entities.messages };
}

export default connect(
  mapStateToProps,
  { loadMessages }
)(MessageList);
