-- List every release from a certain artist
SELECT *
FROM release
WHERE artist_name = <artist_name>;

-- How many songs with durations between X and Y are there by playlist?
SELECT playlist_name, user_nickname, COUNT(*) AS qt_songs
FROM playlist_has_song
  NATURAL JOIN song
WHERE song_duration BETWEEN <duration_x> AND <duration_y>
GROUP BY playlist_name, user_nickname;

-- What's the most liked song by a certain artist?
SELECT *
FROM song s1
WHERE s1.artist_name = <artist_name>
AND song_qt_likes = (
	SELECT MAX(s2.song_qt_likes)
	FROM song s2
	WHERE s2.artist_name = s1.artist_name
);

-- How many followers does a certain artist have?
SELECT artist_name, artist_qt_followers
FROM artist
WHERE artist_name = <artist_name>;

-- Which users like genre X but not genre Y?
(
    SELECT user_nickname, USER_NAME
    FROM "user"
	  NATURAL JOIN user_likes_song
	  NATURAL JOIN genre
    WHERE genre_name = <genre_name_x>
)
EXCEPT (
	SELECT user_nickname, USER_NAME
	FROM "user"
	  NATURAL JOIN user_likes_song
	  NATURAL JOIN genre
	WHERE genre_name = <genre_name_y>
);

-- Whats the shortest song from a certain artist?
SELECT *
FROM song s1
WHERE s1.artist_name = <artist_name>
AND s1.song_duration = (
	SELECT MIN(s2.song_duration)
	FROM song s2
	WHERE s2.artist_name = s1.artist_name
);

-- What's the duration of a certain album? (without using views)
SELECT r.artist_name, r.release_title, r.release_type, SUM(s.song_duration) AS release_duration
FROM release r
  JOIN release_has_song rhs ON (rhs.release_artist_name, rhs.release_title, rhs.release_type) = (r.artist_name, r.release_title, r.release_type)
  JOIN song s ON (s.artist_name, s.song_title) = (rhs.song_artist_name, rhs.song_title)
WHERE (r.artist_name, r.release_title, r.release_type) = (<artist_name>, <release_title>, 'Album')
GROUP BY r.artist_name, r.release_title, r.release_type;

-- What's the duration of a certain album? (using views)
SELECT artist_name, release_title, release_type, release_duration
FROM release_extended
WHERE (artist_name, release_title, release_type) = (<artist_name>, <release_title>, 'Álbum');

-- Which users like more than one playlist by the same creator?
SELECT follower_nickname, playlist_creator_nickname, COUNT(*) AS qt_playlists
FROM user_follows_playlist
GROUP BY follower_nickname, playlist_creator_nickname
HAVING COUNT(*) > 1;

-- What's the average quantity of likes in songs by each artist
SELECT artist_name, AVG(song_qt_likes) AS average_likes
FROM song
GROUP BY artist_name;
