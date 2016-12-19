const Koa = require('koa')
const postgraphql = require('postgraphql').postgraphql

const convert = require('koa-convert')
const wecaht = require('co-wechat')

const pgConfig = process.env.PG_CONFIG || 'postgres://localhost:5432'
const wechatToken = process.env.WECHAT_TOKEN || 'place_holder_for_wecaht_token'
const wechatAppId = process.env.WECHAT_APPID || 'placeholder_for_appid'
const aesKey = process.env.AES_KEY || 'aes_key'
const isDebug = process.env.NODE_ENV === 'development'

const app = new Koa()

app.use(postgraphql(pgConfig, 'hitokoto', {
  pgDefaultRole: 'hitokoto_anonymous',
  jwtSecret: 'hitokoto',
  jwtPgTypeIdentifier: '"hitokoto".jwt_token',
  graphiql: true,
  graphiqlRoute: '/graphiql',
  enableCors: isDebug
}))

app.use(convert(wecaht({
  appid: wechatAppId,
  token: wechatToken,
  encodingAESKey: aesKey
}).middleware(function *() {
  const message = this.weixin
  console.log(message)
  this.body = 'test automatic response'
})))

app.use((ctx) => {
  ctx.response.body = 'Hello, docker!'
})

app.listen(5000)
