-- List every release from a certain artist
select *
from release
where artist_name = <artist_name>;

-- How many songs with durations between X and Y are there by playlist?
select playlist_name, user_nickname, count(*) as qt_songs
from playlist_has_song natural join song
where song_duration between <duration_x> and <duration_y>
group by playlist_name, user_nickname;

-- What's the most liked song by a certain artist?
select *
from song s1
where s1.artist_name = <artist_name>
and song_qt_likes = (
	select max(s2.song_qt_likes)
	from song s2
	where s2.artist_name = s1.artist_name
);

-- How many followers does a certain artist have?
select artist_name, artist_qt_followers
from artist
where artist_name = <artist_name>;

-- Which users like genre X but not genre Y?
(
    select user_nickname, user_name
    from "user" natural join user_likes_song natural join genre
    where genre_name = <genre_name_x>
)
except (
	select user_nickname, user_name
	from "user" natural join user_likes_song natural join genre
	where genre_name = <genre_name_y>
);

-- Whats the shortest song from a certain artist?
select *
from song s1
where s1.artist_name = <artist_name>
and s1.song_duration = (
	select min(s2.song_duration)
	from song s2
	where s2.artist_name = s1.artist_name
);

-- What's the duration of a certain album? (without using views)
select r.artist_name, r.release_title, r.release_type, sum(s.song_duration) as release_duration
from release r
join release_has_song rhs on (rhs.release_artist_name, rhs.release_title, rhs.release_type) = (r.artist_name, r.release_title, r.release_type)
join song s on (s.artist_name, s.song_title) = (rhs.song_artist_name, rhs.song_title)
where (r.artist_name, r.release_title, r.release_type) = (<artist_name>, <release_title>, 'Album')
group by r.artist_name, r.release_title, r.release_type;

-- What's the duration of a certain album? (using views)
select artist_name, release_title, release_type, release_duration
from release_extended
where (artist_name, release_title, release_type) = (<artist_name>, <release_title>, 'Álbum');

-- Which users like more than one playlist by the same creator?
select follower_nickname, playlist_creator_nickname, count(*) as qt_playlists
from user_follows_playlist
group by follower_nickname, playlist_creator_nickname
having count(*) > 1;

-- What's the average quantity of likes in songs by each artist
select artist_name, avg(song_qt_likes) as average_likes
from song
group by artist_name;
