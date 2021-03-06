import { CALL_API, Schemas } from '../middleware/api';

export const REGISTRATIONS_REQUEST = 'REGISTRATIONS_REQUEST';
export const REGISTRATIONS_SUCCESS = 'REGISTRATIONS_SUCCESS';
export const REGISTRATIONS_FAILURE = 'REGISTRATIONS_FAILURE';

function fetchRegistrations(nextPageUrl) {
  console.log("fetchRegistrations");

  return {
    [CALL_API]: {
      types: [REGISTRATIONS_REQUEST, REGISTRATIONS_SUCCESS, REGISTRATIONS_FAILURE],
      endpoint: nextPageUrl,
      schema: Schemas.REGISTRATION_ARRAY
    }
  };
}
/**
 * Fetches a page of starred repos by a particular user.
 * Bails out if page is cached and user didn’t specifically request next page.
 * Relies on Redux Thunk middleware.
 */
export function loadRegistrations(nextPage) {
  return (dispatch, getState) => {
    const {
      nextPageUrl = 'registrations',
      pageCount = 0
    } = getState().pagination.registrations || [];

    if (pageCount > 0 && !nextPage) {
      return null;
    }

    return dispatch(fetchRegistrations(nextPageUrl));
  };
}

export const MESSAGES_REQUEST = 'MESSAGES_REQUEST';
export const MESSAGES_SUCCESS = 'MESSAGES_SUCCESS';
export const MESSAGES_FAILURE = 'MESSAGES_FAILURE';

function fetchMessages(rabId, nextPageUrl) {
  console.log("fetchMessages");

  return {
    rabId,
    [CALL_API]: {
      types: [MESSAGES_REQUEST, MESSAGES_SUCCESS, MESSAGES_FAILURE],
      endpoint: nextPageUrl,
      schema: Schemas.MESSAGE_ARRAY
    }
  };
}
/**
 * Fetches a page of starred repos by a particular user.
 * Bails out if page is cached and user didn’t specifically request next page.
 * Relies on Redux Thunk middleware.
 */
export function loadMessages(rabId, nextPage) {
  return (dispatch, getState) => {
    const {
      nextPageUrl = `registrations/${rabId}/messages`,
      pageCount = 0
    } = getState().pagination.messagesByRab[rabId] || [];

    if (pageCount > 0 && !nextPage) {
      return null;
    }

    return dispatch(fetchMessages(rabId, nextPageUrl));
  };
}

export const SUBMIT_MESSAGE_REQUEST = 'SUBMIT_MESSAGE_REQUEST';
export const SUBMIT_MESSAGE_SUCCESS = 'SUBMIT_MESSAGE_SUCCESS';
export const SUBMIT_MESSAGE_FAILURE = 'SUBMIT_MESSAGE_FAILURE';

export function submitMessage(rabId, bytes) {
  return (dispatch, getState) => {

  var data = new FormData();
  data.append('bytes', JSON.stringify(bytes) );
  
  const action = {
    rabId,
    [CALL_API]: {
      types: [SUBMIT_MESSAGE_REQUEST, SUBMIT_MESSAGE_SUCCESS, SUBMIT_MESSAGE_FAILURE],
      options: {method: 'POST', body: data },
      endpoint: `registrations/${rabId}/messages`,
      schema: Schemas.MESSAGE
    }
  };

    return dispatch(action);
  };
}

export const RESET_ERROR_MESSAGE = 'RESET_ERROR_MESSAGE';
/**
 * Resets the currently visible error message.
 */
export function resetErrorMessage() {
  return {
    type: RESET_ERROR_MESSAGE
  };
}
