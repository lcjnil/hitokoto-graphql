module.exports = (hitokoto) => {
  switch (hitokoto.type) {
    case 'saying':
      return `${hitokoto.content}\n—— ${hitokoto.author} 《${hitokoto.source}》`
    default:
      return `${hitokoto.content}\n—— ${hitokoto.userByCreatorId.name}`
  }
}
