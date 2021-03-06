import * as ActionTypes from '../actions';
import _ from 'lodash';
import paginate from './paginate';
import { combineReducers } from 'redux';

/**
 * Updates an entity cache in response to any action with response.entities.
 */
export function entities(state = { registrations: {}, messages: {} }, action) {
  if (action.response && action.response.entities) {
    return _.merge({}, state, action.response.entities);
  }

  return state;
}

/**
 * Updates error message to notify about the failed fetches.
 */
export function errorMessage(state = null, action) {
  const { type, error } = action;

  if (type === ActionTypes.RESET_ERROR_MESSAGE) {
    return null;
  } else if (error) {
    return action.error;
  }

  return state;
}

function submitMessages(state = { }, action) {
  switch (action.type) {
  case ActionTypes.SUBMIT_MESSAGE_REQUEST:
    return _.merge({}, state, {
      submiting: true
    });
  case ActionTypes.SUBMIT_MESSAGE_SUCCESS:
    return _.merge({}, state, {
      submiting: false
    });
  case ActionTypes.SUBMIT_MESSAGE_FAILURE:
    return _.merge({}, state, {
      submiting: false
    });
    // return Object.assign({}, state, {
    //   [action]: posts(state[action.reddit], action)
    // });
  default:
    return state;
  }
}

/**
 * Updates the pagination data for different actions.
 */
export const pagination = combineReducers({
  registrations: paginate({
    mapActionToKey: action => action.type,
    types: [
      ActionTypes.REGISTRATIONS_REQUEST,
      ActionTypes.REGISTRATIONS_SUCCESS,
      ActionTypes.REGISTRATIONS_FAILURE
    ]
  }),
  messagesByRab: paginate({
    mapActionToKey: action => action.rabId,
    types: [
      ActionTypes.MESSAGES_REQUEST,
      ActionTypes.MESSAGES_SUCCESS,
      ActionTypes.MESSAGES_FAILURE
    ]
  }),
  submitMessages: submitMessages
});
