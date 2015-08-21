import React, { Component, PropTypes } from 'react';
import { Row, Col, Input, Button, Panel} from 'react-bootstrap';

export default class InboxForm extends Component {

  constructor(props) {
    super(props);
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
             return (
               <Col xs={1} md={1} key={`byte_${key}`}>
                 <Input  type='text' bsSize="small" placeholder={`Byte[${key}]`} />
               </Col>)
           })
         }
         <Col xs={2} md={2}>
           <Button bsStyle='success' >Submit</Button>
         </Col>
         </ Row >
         </Panel>
       </Col>
     </Row>
    );
  }
}
