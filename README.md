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

## Recaptcha

Set the following env. variables on Heroku:

```
heroku config:add RECAPTCHA_PUBLIC_KEY=xxx
heroku config:add RECAPTCHA_PRIVATE_KEY=yyy
```

# E-mail delivery

Use the Mandrill add-on and set the following env. variable on Heroku:

```
heroku config:add EMAIL_HOST=instrumentalsescbrasil.org.br
```

# Airbrake error monitoring

Set this:

```
heroku config:add AIRBRAKE_KEY=xxx
```

# Facebook API

Set this:

```
heroku config:add FACEBOOK_APP_ID=xxx
```

# TimeZone

Set this:

```
heroku config:add TZ="America/Sao_Paulo"
```

## TODO

- Add 404 and 500 custom pages
- Auto link to artists in markdown
- Setup cloud logging service
- Remove stuff from Heroku's slug compilation
- Configure Facebook App correctly on final domain
