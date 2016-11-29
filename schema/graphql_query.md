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