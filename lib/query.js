exports.randomHitokotoQuery = `
  {
    randomHitokoto {
      id
      content
      source
      author
      type
      userByCreatorId {
        name
      }
    }
  }
`

exports.registerQuery = `
mutation($email:String!, $name:String!, $password:String!) {
  register(input: {email: $email, name: $name, password: $password}) {
		user {
      id
    }
  }
}
`

exports.loginQuery = `
mutation($email:String!, $password:String!) {
  login(input: {email: $email, password: $password}) {
		jwtToken
  }
} 
`

exports.currentUserQuery = `
{
  currentUser {
    id
    name
  }
}
`

exports.createNewHitokotoQuery = `
mutation($content:String, $author:String, $source:String, $type: String) {
  createNewHitokoto(input: {content: $content, author: $author, source: $source, type: $type}) {
    hitokoto {
      id
      content
      author
      source
      author
      type
    }
  } 
}
`
