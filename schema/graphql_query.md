```graphql
{
  allHitokotos {
    edges {
      node {
        id
      	content
      	author
      	source
      }
  	}
  }
}
```

```graphql
{
  randomHitokoto {
    id
    content
    author
    source
  }
}
```

```graphql
{
  hitokotoById(id: 1) {
    id
    content
    author
    source
  }
}
```


```graphql
mutation {
  createHitokoto(input: {clientMutationId: "test", hitokoto: {content: "测试", author: "连城究", source: "测试啊……"}}) {
    hitokoto {
     	id 
    }
  }
}
```


```graphql
mutation {
  login(input: { clientMutationId: "UUID", email: "emlcjnil@gmail.com", password: "123456" }) {
    clientMutationId
    jwtToken
  }
}
```

```graphql
mutation {
  createNewHitokoto(input: {clientMutationId: "uuid", content: "十月的天没有下雨", author: "李晋", source:"十月迷城"}) {
    clientMutationId,
    hitokoto {
      id
      content
      author
      source
      author
    }
  } 
}

Headers:

Authorization: Bearer ${your_jwt_token} 
```