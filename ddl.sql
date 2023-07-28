CREATE TABLE artist (
    artist_name VARCHAR(50),
    artist_about text,
    artist_qt_likes BIGINT DEFAULT 0,
    artist_qt_followers BIGINT DEFAULT 0,

    PRIMARY KEY (artist_name)
);

CREATE TABLE release (
    artist_name VARCHAR(50),
    release_title VARCHAR(100),
    release_type VARCHAR(10) CHECK (release_type IN ('Album', 'EP', 'Single')),
    release_date DATE NOT NULL CHECK (release_date <= CURRENT_DATE),

    FOREIGN KEY (artist_name) REFERENCES artist(artist_name) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (artist_name, release_title, release_type)
);

CREATE TABLE song (
    artist_name VARCHAR(50),
    song_title VARCHAR(100),
    song_duration INTERVAL NOT NULL CHECK (song_duration > '00:00:00'),
    song_qt_likes BIGINT DEFAULT 0,

    FOREIGN KEY (artist_name) REFERENCES artist(artist_name) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (artist_name, song_title)
);

CREATE TABLE feature (
    artist_name VARCHAR(50),
    song_title VARCHAR(100),
    feature_name VARCHAR(50),

    FOREIGN KEY (artist_name, song_title) REFERENCES song(artist_name, song_title) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (feature_name) REFERENCES artist(artist_name) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (artist_name, song_title, feature_name)
);

CREATE TABLE genre (
    artist_name VARCHAR(50),
    song_title VARCHAR(100),
    genre_name VARCHAR(14) CHECK (genre_name IN ('Sertanejo', 'EDM', 'Brazilian Funk', 'Hip Hop', 'Pop', 'R&B', 'Rock', 'Metal', 'Punk')),

    FOREIGN KEY (artist_name, song_title) REFERENCES song(artist_name, song_title) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (artist_name, song_title, genre_name)
);

CREATE TABLE "user" (
    user_nickname VARCHAR(25),
    USER_NAME VARCHAR(50),
    user_email VARCHAR(50) UNIQUE NOT NULL CHECK (user_email LIKE '_%@_%._%'),

    PRIMARY KEY (user_nickname)
);

CREATE TABLE playlist (
    user_nickname VARCHAR(25),
    playlist_name VARCHAR(50),
    playlist_qt_followers BIGINT DEFAULT 0,

    FOREIGN KEY (user_nickname) REFERENCES "user"(user_nickname) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (user_nickname, playlist_name)
);

CREATE TABLE release_has_song (
    release_artist_name VARCHAR(50),
    release_title VARCHAR(100),
    release_type VARCHAR(10),
    song_artist_name VARCHAR(50),
    song_title VARCHAR(100),

    FOREIGN KEY (release_artist_name, release_title, release_type) REFERENCES release(artist_name, release_title, release_type) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (song_artist_name, song_title) REFERENCES song(artist_name, song_title) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (release_artist_name, release_title, release_type, song_artist_name, song_title)
);

CREATE TABLE user_likes_song (
    user_nickname VARCHAR(25),
    artist_name VARCHAR(50),
    song_title VARCHAR(100),
    like_date DATE NOT NULL DEFAULT CURRENT_DATE CHECK (like_date <= CURRENT_DATE),

    FOREIGN KEY (user_nickname) REFERENCES "user"(user_nickname) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (artist_name, song_title) REFERENCES song(artist_name, song_title) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (user_nickname, artist_name, song_title)
);

CREATE TABLE user_follows_artist (
    user_nickname VARCHAR(25),
    artist_name VARCHAR(50),

    FOREIGN KEY (user_nickname) REFERENCES "user"(user_nickname) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (artist_name) REFERENCES artist(artist_name) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (user_nickname, artist_name)
);

CREATE TABLE user_follows_playlist (
    follower_nickname VARCHAR(25),
    playlist_creator_nickname VARCHAR(25),
    playlist_name VARCHAR(50),

    FOREIGN KEY (follower_nickname) REFERENCES "user"(user_nickname) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (playlist_creator_nickname, playlist_name) REFERENCES playlist(user_nickname, playlist_name) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (follower_nickname, playlist_creator_nickname, playlist_name)
);

CREATE TABLE playlist_has_song (
    user_nickname VARCHAR(25),
    playlist_name VARCHAR(50),
    artist_name VARCHAR(50),
    song_title VARCHAR(100),
    addition_date DATE NOT NULL DEFAULT CURRENT_DATE CHECK (addition_date <= CURRENT_DATE),

    FOREIGN KEY (user_nickname, playlist_name) REFERENCES playlist(user_nickname, playlist_name) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (artist_name, song_title) REFERENCES song(artist_name, song_title) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (user_nickname, playlist_name, artist_name, song_title)
);
