const expect = require('chai').expect
const uuid = require('uuid/v4')

const Lokka = require('lokka').Lokka
const Transport = require('lokka-transport-http').Transport
const client = new Lokka({
  transport: new Transport('http://localhost:5000/graphql')
})

describe('hitokoto api', () => {
  let jwt
  describe('randomHitokoto', () => {
    it('should return a randomHitokoto', async () => {
      const r = await client.query(`
        {
          randomHitokoto {
            id
            content
            source
            author
          }
        }
      `)
      expect(r).to.have.property('randomHitokoto')
      expect(r.randomHitokoto).to.include.keys('id', 'author', 'content', 'source')
    })

    it('should returns a jwt token when login', async () => {
      const id = uuid()
      const r = await client.mutate(`
        ($clientMutationId: String, $email: String!, $password: String!) {
          login(input: {clientMutationId: $clientMutationId, email: $email, password: $password} ) {
            clientMutationId
            jwtToken
          }
        }
      `, {
        clientMutationId: id,
        email: 'emlcjnil@gmail.com',
        password: '123456'
      })
      expect(r).to.have.property('login')
      expect(r.login).to.include.keys('clientMutationId', 'jwtToken')
      expect(r.login.clientMutationId).to.equal(id)

      jwt = r.login.jwtToken
    })

    it('should get currentUser when using jwt', async () => {
      // Too hard to use, should be replaced
      const newClient = new Lokka({
        transport: new Transport('http://localhost:5000/graphql', {
          headers: {Authorization: `Bearer ${jwt}`}
        })
      })

      const r = await newClient.query(`
        {
          currentUser {
            name
          }
        }
      `)
      expect(r).to.have.property('currentUser')
      expect(r.currentUser.name).to.equal('lcj')
    })
  })
})