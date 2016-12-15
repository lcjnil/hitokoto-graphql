const Koa = require('koa')
const postgraphql = require('postgraphql').postgraphql

const pgConfig = process.env.PG_CONFIG || 'postgres://localhost:5432'
const isDebug = process.env.NODE_ENV === 'development'


const app = new Koa()

app.use((ctx, next) => {
  console.log(ctx.request.headers)
  return next()
})

app.use(postgraphql(pgConfig, 'hitokoto', {
  pgDefaultRole: 'hitokoto_anonymous',
  jwtSecret: 'hitokoto',
  jwtPgTypeIdentifier: '"hitokoto".jwt_token',
  graphiql: true,
  graphiqlRoute: '/graphiql',
  enableCors: isDebug
}))

app.use((ctx) => {
  ctx.response.body = 'Hello, docker!'
})

app.listen(5000)
