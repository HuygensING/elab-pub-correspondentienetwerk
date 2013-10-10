_ = require 'underscore'

staticDir = 'dist'

express = require('express')
app = express()

app.use express.bodyParser()

app.use express.static(__dirname + staticDir)
app.all '/*', (req, res) ->
	console.log "#{__dirname}/#{staticDir}"

  res.sendfile 'index.html', root: __dirname+'/'+staticDir

_writeResponse = (response, res) ->
	console.log '_writeResponse: no http code!' if not response.code?
	response.data = {} if not response.data?

	res.writeHead response.code, 'Content-Type': 'application/json; charset=UTF-8'
	res.end JSON.stringify(response.data)

app.listen 3000, 'localhost'
console.log 'Node server running on http://localhost:3000'