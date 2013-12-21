Instrumental Sesc Brasil
========================

## Development environment

Start up with `foreman start -f Procfile.dev`

## Environment Variables

```
# Configure asset sync in production:
heroku config:add AWS_ACCESS_KEY_ID=xxxx
heroku config:add AWS_SECRET_ACCESS_KEY=yyyy
heroku config:add FOG_DIRECTORY=zzzz
heroku config:add FOG_PROVIDER=AWS
heroku config:add FOG_REGION=sa-east-1
heroku config:add ASSET_SYNC_GZIP_COMPRESSION=true
heroku config:add ASSET_SYNC_MANIFEST=false
heroku config:add ASSET_SYNC_EXISTING_REMOTE_FILES=keep
heroku config:add CLOUDFRONT_DOMAIN=xxx.cloudfront.net

# Configure recaptcha:
heroku config:add RECAPTCHA_PUBLIC_KEY=xxx
heroku config:add RECAPTCHA_PRIVATE_KEY=yyy

# Configure e-mail delivery:
heroku config:add EMAIL_HOST=instrumentalsescbrasil.org.br

# Airbrake error monitoring:
heroku config:add AIRBRAKE_KEY=xxx

# Facebook API:
heroku config:add FACEBOOK_APP_ID=xxx

# TimeZone:
heroku config:add TZ="America/Sao_Paulo"

# Disqus:
heroku config:add DISQUS_SHORTNAME=instrumentalsescbrasil
heroku config:add DISQUS_BASEURL=http://instrumentalsescbrasil.org.br

# Admin area access:
heroku config:add ADMIN_USERNAME=xxx
heroku config:add ADMIN_PASSWORD=yyy
```

## TODO

- Add 404 and 500 custom pages
- Auto link to artists in markdown
- Setup cloud logging service
- Remove stuff from Heroku's slug compilation
- Configure Facebook App correctly on final domain
- Optimize cache and queries
- Neverending scroll on artist list
