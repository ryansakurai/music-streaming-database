create function update_qt_likes()
returns trigger as $$
begin
	if (TG_OP = 'INSERT') then
		update song
		set song_qt_likes = song_qt_likes + 1
		where (artist_name, song_title) = (new.artist_name, new.song_title);

		update artist
		set artist_qt_likes = artist_qt_likes + 1
		where artist_name = new.artist_name;
	elsif (TG_OP = 'DELETE') then
		update song
		set song_qt_likes = song_qt_likes - 1
		where (artist_name, song_title) = (old.artist_name, old.song_title);

		update artist
		set artist_qt_likes = artist_qt_likes - 1
		where artist_name = old.artist_name;
	end if;
	return new;
end;
$$ language plpgsql;

create trigger update_qt_likes
after insert or delete on user_likes_song
for each row
execute function update_qt_likes();


create function update_artist_qt_followers()
returns trigger as $$
begin
	if (TG_OP = 'INSERT') then
		update artist
		set artist_qt_followers = artist_qt_followers + 1
		where artist_name = new.artist_name;
	elsif (TG_OP = 'DELETE') then
		update artist
		set artist_qt_followers = artist_qt_followers - 1
		where artist_name = old.artist_name;
	end if;
    return new;
end;
$$ language plpgsql;

create trigger update_artist_qt_followers
after insert or delete on user_follows_artist
for each row
execute function update_artist_qt_followers();


create function update_playlist_qt_followers()
returns trigger as $$
begin
	if (TG_OP = 'INSERT') then
		update playlist
		set playlist_qt_followers = playlist_qt_followers + 1
		where (user_nickname, playlist_name) = (new.playlist_author_nickname, new.playlist_name);
	elsif (TG_OP = 'DELETE') then
		update playlist
		set playlist_qt_followers = playlist_qt_followers - 1
		where (user_nickname, playlist_name) = (old.playlist_author_nickname, old.playlist_name);
	end if;
    return new;
end;
$$ language plpgsql;

create trigger update_playlist_qt_followers
after insert or delete on user_follows_playlist
for each row
execute function update_playlist_qt_followers();


create function check_addition_date()
returns trigger as $$
begin
    if new.addition_date < all (
		select release_date
		from release r
		join release_has_song rhs
		on (r.artist_name, r.release_title, r.release_type) = (rhs.release_artist_name, rhs.release_title, rhs.release_type)
		where (new.artist_name, new.song_title) = (song_artist_name, song_title)
	) then
        raise exception 'Addition date has to be greater than the song''s release date';
    END if;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

create trigger check_addition_date
before insert on playlist_has_song
for each row
execute function check_addition_date();


create function check_like_date()
returns trigger as $$
begin
    if new.like_date < all (
		select release_date
		from release r
		join release_has_song rhs
		on (r.artist_name, r.release_title, r.release_type) = (rhs.release_artist_name, rhs.release_title, rhs.release_type)
		where (new.artist_name, new.song_title) = (song_artist_name, song_title)
	) then
        raise exception 'Like date must be greater than the song''s release date';
    END if;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

create trigger check_like_date
before insert on user_likes_song
for each row
execute function check_like_date();
