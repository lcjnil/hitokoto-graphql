const fetch = require('node-fetch')
const queries = require('./query')

const query = (rawQuery) => (variables = {}) => {
  const headers = {
    'Content-Type': 'application/json'
  }

  return fetch('http://localhost:5000/graphql', {
    method: 'POST',
    headers,
    body: JSON.stringify({
      query: rawQuery,
      variables
    })
  }).then(r => r.json())
}

module.exports = {
  getRandomHitokoto: query(queries.randomHitokotoQuery)
}
