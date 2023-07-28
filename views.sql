CREATE VIEW artist_genre(artist_name, genre_name) AS
    SELECT DISTINCT artist_name, genre_name
    FROM genre;

CREATE VIEW release_genre(artist_name, release_title, release_type, genre_name) AS
    SELECT DISTINCT rhs.release_artist_name, rhs.release_title, rhs.release_type, g.genre_name
    FROM release_has_song rhs
      JOIN genre g ON (g.artist_name, g.song_title) = (rhs.song_artist_name, rhs.song_title);

CREATE VIEW release_extended(artist_name, release_title, release_type, release_date, release_qt_songs, release_duration) AS
    SELECT r.artist_name, r.release_title, r.release_type, release_date, COUNT(*), SUM(song_duration)
    FROM release r
      JOIN release_has_song rhs ON (rhs.release_artist_name, rhs.release_title, rhs.release_type) = (r.artist_name, r.release_title, r.release_type)
      JOIN song s ON (rhs.song_artist_name, rhs.song_title) = (s.artist_name, s.song_title)
    GROUP BY r.artist_name, r.release_title, r.release_type;

CREATE VIEW playlist_extended(user_nickname, playlist_name, playlist_qt_songs, playlist_duration, playlist_qt_followers) AS
    SELECT p.user_nickname, p.playlist_name, COUNT(*), SUM(song_duration), p.playlist_qt_followers
    FROM playlist p
      NATURAL JOIN playlist_has_song
      NATURAL JOIN song
    GROUP BY p.user_nickname, p.playlist_name;
