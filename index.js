const Koa = require('koa')
const postgraphql = require('postgraphql').postgraphql

const app = new Koa()

app.use((ctx, next) => {
  console.log(ctx.request.headers)
  return next()
})

app.use(postgraphql('postgres://localhost:5432', 'hitokoto', {
  pgDefaultRole: 'hitokoto_anonymous',
  jwtSecret: 'hitokoto',
  jwtPgTypeIdentifier: '"hitokoto".jwt_token',
  graphiql: true,
  graphiqlRoute: '/graphiql'
}))

app.listen(5000)