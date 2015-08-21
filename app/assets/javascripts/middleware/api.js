import "babel-core/polyfill";
import { Schema, arrayOf, normalize } from 'normalizr';
import { camelizeKeys } from 'humps';
import 'isomorphic-fetch';

/**
 * Extracts the next page URL from Github API response.
 */
function getNextPageUrl(response) {
  const link = response.headers.get('link');
  if (!link) {
    return null;
  }

  const nextLink = link.split(',').filter(s => s.indexOf('rel="next"') > -1)[0];
  if (!nextLink) {
    return null;
  }

  return nextLink.split(';')[0].slice(1, -1);
}

const API_ROOT = 'http://localhost:9393/api/';

/**
 * Fetches an API response and normalizes the result JSON according to schema.
 * This makes every API response have the same shape, regardless of how nested it was.
 */
function callApi(endpoint, schema) {
  if (endpoint.indexOf(API_ROOT) === -1) {
    endpoint = API_ROOT + endpoint;
  }

  return fetch(endpoint)
    .then(response =>
      response.json().then(json => ({ json, response}))
    ).then(({ json, response }) => {
      if (!response.ok) {
        return Promise.reject(json);
      }

      const camelizedJson = camelizeKeys(json);
      const nextPageUrl = getNextPageUrl(response) || undefined;

      return Object.assign({},
        normalize(camelizedJson, schema),
        { nextPageUrl }
      );
    });
}

// We use this Normalizr schemas to transform API responses from a nested form
// to a flat form where repos and users are placed in `entities`, and nested
// JSON objects are replaced with their IDs. This is very convenient for
// consumption by reducers, because we can easily build a normalized tree
// and keep it updated as we fetch more data.

// Read more about Normalizr: https://github.com/gaearon/normalizr

const registrationSchema = new Schema('registrations', {
  idAttribute: 'queue'
});

const messageSchema = new Schema('messages', {
  idAttribute: 'id'
});


/**
 * Schemas for Github API responses.
 */
export const Schemas = {
  REGISTRATION: registrationSchema,
  REGISTRATION_ARRAY: arrayOf(registrationSchema),
  MESSAGE: messageSchema,
  MESSAGE_ARRAY: arrayOf(messageSchema)
};

/**
 * Action key that carries API call info interpreted by this Redux middleware.
 */
export const CALL_API = Symbol('Call API');

/**
 * A Redux middleware that interprets actions with CALL_API info specified.
 * Performs the call and promises when such actions are dispatched.
 */
export default store => next => action => {
  const callAPI = action[CALL_API];

  if (typeof callAPI === 'undefined') {
    return next(action);
  }

  let { endpoint } = callAPI;
  const { schema, types, bailout } = callAPI;

  if (typeof endpoint === 'function') {
    endpoint = endpoint(store.getState());
  }

  if (typeof endpoint !== 'string') {
    throw new Error('Specify a string endpoint URL.');
  }
  if (!schema) {
    throw new Error('Specify one of the exported Schemas.');
  }
  if (!Array.isArray(types) || types.length !== 3) {
    throw new Error('Expected an array of three action types.');
  }
  if (!types.every(type => typeof type === 'string')) {
    throw new Error('Expected action types to be strings.');
  }
  if (typeof bailout !== 'undefined' && typeof bailout !== 'function') {
    throw new Error('Expected bailout to either be undefined or a function.');
  }

  if (bailout && bailout(store.getState())) {
    return Promise.resolve();
  }

  function actionWith(data) {
    const finalAction = Object.assign({}, action, data);
    delete finalAction[CALL_API];
    return finalAction;
  }

  const [requestType, successType, failureType] = types;
  next(actionWith({ type: requestType }));

  return callApi(endpoint, schema).then(
    response => next(actionWith({
      response,
      type: successType
    })),
    error => next(actionWith({
      type: failureType,
      error: error.message || 'Something bad happened'
    }))
  );
};
