knox = require 'knox'
mime = require 'mime'

module.exports = (BasePlugin) ->
    class docpadS3Plugin extends BasePlugin
        name: "Docpad-S3"

        writeAfter: (collection)->
            knoxConfig = {
                key: process.env.DOCPAD_S3_KEY,
                secret: process.env.DOCPAD_S3_SECRET,
                bucket: process.env.DOCPAD_S3_BUCKET,
            }

            docpad = @docpad
            client = knox.createClient knoxConfig

            docpad.getFiles(write:true).forEach (file)->
                path = file.attributes.relativeOutPath
                data = file.get('contentRendered') || file.get('content') || file.getData()
                console.log path, file.get('contentRendered')?, file.get('content')?, file.getData()?, file.get('content').length
                length = data.length
                type = mime.lookup path #file.get('contentType')
                
                headers = {
                    "Content-Length": length,
                    "Content-Type": type
                }

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