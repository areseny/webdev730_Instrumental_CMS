Instrumental Sesc Brasil
========================

## Development environment

Start up with `foreman start -f Procfile.dev`

## Asset sync in production

Set the following env. variables on Heroku:

```
heroku config:add AWS_ACCESS_KEY_ID=xxxx
heroku config:add AWS_SECRET_ACCESS_KEY=yyyy
heroku config:add FOG_DIRECTORY=zzzz
heroku config:add FOG_PROVIDER=AWS
heroku config:add FOG_REGION=sa-east-1
heroku config:add ASSET_SYNC_GZIP_COMPRESSION=true
heroku config:add ASSET_SYNC_MANIFEST=false
heroku config:add ASSET_SYNC_EXISTING_REMOTE_FILES=keep
heroku config:add CLOUDFRONT_DOMAIN=xxx.cloudfront.net
```
