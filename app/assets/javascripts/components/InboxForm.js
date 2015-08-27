import React, { Component, PropTypes } from 'react';
import { Row, Col, Input, Button, Panel} from 'react-bootstrap';
import { connect } from 'react-redux';
import { submitMessage } from './../actions';


export default class InboxForm extends Component {

  constructor(props) {
    super(props);
  }

  handleSubmitMessage(event) {
    let bytes = _.collect(new Array(10), (n, key) => {
      return React.findDOMNode(this.refs[`byte_${key}`] ).querySelector('input').value
    });
    this.props.submitMessage(this.props.rabId, bytes);

  }

  render() {
    const title = (<h3>Inbox {this.props.rabId !== null ? 'for Rab ' + this.props.rabId : ''}</h3>)
    return(
       <Row className='show-grid'>
         <Col xs={12} md={12}>
         <Panel header={title}>
           <Row >
             {
               _.collect(new Array(10), (n, key) => {
                 return ( <Col xs={1} md={1} key={`ibyte_${key}`}>
                     <Input type='text' bsSize="small" placeholder={`Byte[${key}]`} ref={`byte_${key}`} />
                   </Col>)
               })
             }
           <Col xs={2} md={2}>
             <Button bsStyle='success' onClick={e => this.handleSubmitMessage(e)} >Submit</Button>
           </Col>
           </ Row >
         </Panel>
       </Col>
     </Row>
    );
  }
}


function mapStateToProps(state) {
  return { };
}

export default connect(
  mapStateToProps,
  { submitMessage }
)(InboxForm);
