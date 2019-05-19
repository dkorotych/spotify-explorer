# Spotify PCA Explorer

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy/?template=https://github.com/ai-protagonist/spotify-explorer)

This [Shiny](http://shiny.rstudio.com/) relies on libarary called `spotiryr` for analysing your Spotify data.  
Please configure 2 evironmental variables: `SPOTIFY_CLIENT_ID` and `SPOTIFY_CLIENT_SECRET`.  
```
heroku config:set SPOTIFY_CLIENT_ID="..." -a <app-name>
heroku config:set SPOTIFY_CLIENT_SECRET="..." -a <app-name>
```
