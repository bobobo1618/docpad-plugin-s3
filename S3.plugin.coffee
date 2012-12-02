knox = require 'knox'
mime = require 'mime'
http = require 'http'

module.exports = (BasePlugin) ->
    class docpadS3Plugin extends BasePlugin
        name: "s3"

        writeAfter: (collection)->
            knoxConfig = {
                key: process.env.DOCPAD_S3_KEY,
                secret: process.env.DOCPAD_S3_SECRET,
                bucket: process.env.DOCPAD_S3_BUCKET,
            }

            if knoxConfig.key? and knoxConfig.secret? and knoxConfig.bucket?

                docpad = @docpad
                client = knox.createClient knoxConfig

                http.globalAgent.maxSockets = 2

                docpad.getFiles(write:true).forEach (file)->
                    path = file.attributes.relativeOutPath
                    data = file.get('contentRendered') || file.get('content') || file.getData()
                    length = data.length
                    type = mime.lookup path #file.get('contentType')

                    headers = {
                        "Content-Length": length,
                        "Content-Type": type,
                        "x-amz-acl": 'public-read'
                    }

                    if file.get('headers')
                        for header in file.get('headers')
                            headers[header.name] = header.value

                    req = client.put path, headers
                    req.on 'response', (res)->
                        if 200 == res.statusCode
                            console.log 'Uploaded %s to S3.', path
                        else
                            console.log 'Derp on %s', path
                        resdata = ''
                        res.on 'data', (chunk)->
                            resdata  = resdata + chunk
                        res.on 'end', ()->
                            console.log resdata

                    req.end data
            else
                console.log 'Skipping S3. An environment variable is missing. Printing detected config:'
                console.dir knoxConfig
