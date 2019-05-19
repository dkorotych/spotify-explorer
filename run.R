source("init.R")

# higharts require CDN
options(rcharts.cdn = T)
# keep spotify token
options(httr_oauth_cache=T)

fav_file = file.path("data", "fav-artists.csv")
other_file = file.path("data", "other-artists.csv")
dir.create("data", showWarnings = F)

# This fetches and saves the spotify data locally
if (!file.exists(fav_file) | !file.exists(other_file)) {
    MAX_RESULTS = 50
    access_token <- get_spotify_access_token()
    
    user_name = strsplit(get_my_profile()$display_name, ' ')[[1]]
    if (length(user_name) > 1) user_name = user_name[1]
    
    top_a <- get_my_top_artists_or_tracks(type = "artists", limit = MAX_RESULTS)
    top_t <- get_my_top_artists_or_tracks(type = "tracks", limit = MAX_RESULTS)
    top_t_artists <- unique(unlist(lapply(1:nrow(top_t), 
                                          function(i) top_t[i,'artists'][[1]]['name'])))
    followed_artists <- get_my_followed_artists(limit = MAX_RESULTS)
    fav_artists <- unique(c(followed_artists[,'name'], unlist(top_a$name), top_t_artists))
    
    ids <- c('artist_id', 'album_id', 'track_id')
    feats <- c('album_release_year', 'tempo', 'danceability', 'energy', 'key', 'loudness', 
               'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence')
    a_feats <- c('artist_name', feats)
    top_artists_feats <- data.frame()
    other_artists_feats <- data.frame()
    
    for (i in 1:length(fav_artists)) {
        artist_name <- fav_artists[i]
        
        tryCatch({
            artist <- get_artist_audio_features(artist_name)
        }, warning = function(w) {
            message(w)
        }, error = function(e) {
            message(e)
        })
        
        # artist tracks in your top tracks
        d <- artist[fav_artists[i] %in% top_t_artists, c(ids, feats)]
        
        if (nrow(d) > 0) {
            top_artists_feats <- rbind(top_artists_feats, c(artist_name, colMeans(d[,feats])))
        } else {
            other_artists_feats <- rbind(other_artists_feats, c(artist_name, colMeans(artist[,feats])))
        }
    }
    
    colnames(top_artists_feats) <- a_feats
    colnames(other_artists_feats) <- a_feats
    write.csv(fav_file, x = top_artists_feats, row.names = F)
    write.csv(other_file, x = other_artists_feats, row.names = F)
}

port <- Sys.getenv('PORT')

shiny::runApp(
    appDir = getwd(),
    host = '0.0.0.0',
    port = as.numeric(port)
)

#source("server.R")
#source("ui.R")