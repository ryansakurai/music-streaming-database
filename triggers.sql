CREATE FUNCTION update_qt_likes() RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		UPDATE song
		SET song_qt_likes = song_qt_likes + 1
		WHERE (artist_name, song_title) = (new.artist_name, new.song_title);

		UPDATE artist
		SET artist_qt_likes = artist_qt_likes + 1
		WHERE artist_name = new.artist_name;
	ELSIF (TG_OP = 'DELETE') THEN
		UPDATE song
		SET song_qt_likes = song_qt_likes - 1
		WHERE (artist_name, song_title) = (old.artist_name, old.song_title);

		UPDATE artist
		SET artist_qt_likes = artist_qt_likes - 1
		WHERE artist_name = old.artist_name;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_qt_likes
AFTER INSERT OR DELETE ON user_likes_song
FOR EACH ROW
EXECUTE FUNCTION update_qt_likes();


CREATE FUNCTION update_artist_qt_followers() RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		UPDATE artist
		SET artist_qt_followers = artist_qt_followers + 1
		WHERE artist_name = new.artist_name;
	ELSIF (TG_OP = 'DELETE') THEN
		UPDATE artist
		SET artist_qt_followers = artist_qt_followers - 1
		WHERE artist_name = old.artist_name;
	END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_artist_qt_followers
AFTER INSERT OR DELETE ON user_follows_artist
FOR EACH ROW
EXECUTE FUNCTION update_artist_qt_followers();


CREATE FUNCTION update_playlist_qt_followers() RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		UPDATE playlist
		SET playlist_qt_followers = playlist_qt_followers + 1
		WHERE (user_nickname, playlist_name) = (new.playlist_creator_nickname, new.playlist_name);
	ELSIF (TG_OP = 'DELETE') THEN
		UPDATE playlist
		SET playlist_qt_followers = playlist_qt_followers - 1
		WHERE (user_nickname, playlist_name) = (old.playlist_creator_nickname, old.playlist_name);
	END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_playlist_qt_followers
AFTER INSERT OR DELETE ON user_follows_playlist
FOR EACH ROW
EXECUTE FUNCTION update_playlist_qt_followers();


CREATE FUNCTION check_addition_date() RETURNS TRIGGER AS $$
BEGIN
    IF new.addition_date < ALL (
		SELECT release_date
		FROM RELEASE r
		  JOIN release_has_song rhs ON (r.artist_name, r.release_title, r.release_type) = (rhs.release_artist_name, rhs.release_title, rhs.release_type)
		WHERE (new.artist_name, new.song_title) = (song_artist_name, song_title)
	) THEN
        RAISE EXCEPTION 'Addition date has to be greater than the song''s release date';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_addition_date
BEFORE INSERT ON playlist_has_song
FOR EACH ROW
EXECUTE FUNCTION check_addition_date();


CREATE FUNCTION check_like_date() RETURNS TRIGGER AS $$
BEGIN
    IF new.like_date < ALL (
		SELECT release_date
		FROM RELEASE r
		  JOIN release_has_song rhs ON (r.artist_name, r.release_title, r.release_type) = (rhs.release_artist_name, rhs.release_title, rhs.release_type)
		WHERE (new.artist_name, new.song_title) = (song_artist_name, song_title)
	) THEN
        RAISE EXCEPTION 'Like date must be greater than the song''s release date';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_like_date
BEFORE INSERT ON user_likes_song
FOR EACH ROW
EXECUTE FUNCTION check_like_date();
