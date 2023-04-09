create view artist_genre(artist_name, genre_name) as
    select distinct artist_name, genre_name
    from genre;

create view release_genre(artist_name, release_title, release_type, genre_name) as
    select distinct rhs.release_artist_name, rhs.release_title, rhs.release_type, g.genre_name
    from release_has_song rhs
    join genre g on (g.artist_name, g.song_title) = (rhs.song_artist_name, rhs.song_title);

create view release_extended(artist_name, release_title, release_type, release_date, release_qt_songs, release_duration) as
    select r.artist_name, r.release_title, r.release_type, release_date, count(*), sum(song_duration)
    from release r
    join release_has_song rhs on (rhs.release_artist_name, rhs.release_title, rhs.release_type) = (r.artist_name, r.release_title, r.release_type)
    join song s on (rhs.song_artist_name, rhs.song_title) = (s.artist_name, s.song_title)
    group by r.artist_name, r.release_title, r.release_type;

create view playlist_extended(user_nickname, playlist_name, playlist_qt_songs, playlist_duration, playlist_qt_followers) as
    select p.user_nickname, p.playlist_name, count(*), sum(song_duration), p.playlist_qt_followers
    from playlist p
    natural join playlist_has_song
    natural join song
    group by p.user_nickname, p.playlist_name;
