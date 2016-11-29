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