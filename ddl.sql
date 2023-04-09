create database yfitops;

create table artist(
    artist_name varchar(50),
    artist_about text,
    artist_qt_likes bigint default 0,
    artist_qt_followers bigint default 0,

    primary key (artist_name)
);

create table release(
    artist_name varchar(50),
    release_title varchar(100),
    release_type varchar(10) check (release_type in ('Album', 'EP', 'Single')),
    release_date date not null check (release_date <= current_date),

    foreign key (artist_name) references artist(artist_name) on delete cascade on update cascade,
    primary key (artist_name, release_title, release_type)
);

create table song(
    artist_name varchar(50),
    song_title varchar(100),
    song_duration interval not null check (song_duration > '00:00:00'),
    song_qt_likes bigint default 0,

    foreign key (artist_name) references artist(artist_name) on delete cascade on update cascade,
    primary key (artist_name, song_title)
);

create table genre(
    artist_name varchar(50),
    song_title varchar(100),
    genre_name varchar(10) check (genre_name in ('Classical', 'Sertanejo', 'EDM', 'Brazilian Funk', 'Hip Hop', 'Jazz', 'Pop', 'R&B', 'Rock', 'Metal', 'Punk', 'Samba', 'Pagode', 'MPB')),

    foreign key (artist_name, song_title) references song(artist_name, song_title) on delete cascade on update cascade,
    primary key (artist_name, song_title, genre_name)
);

create table "user"(
    user_nickname varchar(25),
    user_name varchar(50),
    user_email varchar(50) unique not null check (user_email like '_%@_%._%'),

    primary key (user_nickname)
);

create table playlist(
    user_nickname varchar(25),
    playlist_name varchar(50),
    playlist_qt_followers bigint default 0,

    foreign key (user_nickname) references "user"(user_nickname) on delete cascade on update cascade,
    primary key (user_nickname, playlist_name)
);

create table feature(
    artist_name varchar(50),
    song_title varchar(100),
    feature_name varchar(50),

    foreign key (artist_name, song_title) references song(artist_name, song_title) on delete cascade on update cascade,
    foreign key (feature_name) references artist(artist_name) on delete cascade on update cascade,
    primary key (artist_name, song_title, feature_name)
);

create table release_has_song(
    release_artist_name varchar(50),
    release_title varchar(100),
    release_type varchar(10),
    song_artist_name varchar(50),
    song_title varchar(100),

    foreign key (release_artist_name, release_title, release_type) references release(artist_name, release_title, release_type) on delete cascade on update cascade,
    foreign key (song_artist_name, song_title) references song(artist_name, song_title) on delete cascade on update cascade,
    primary key (release_artist_name, release_title, release_type, song_artist_name, song_title)
);

create table user_likes_song(
    user_nickname varchar(25),
    artist_name varchar(50),
    song_title varchar(100),
    like_date date not null default current_date check (like_date <= current_date),

    foreign key (user_nickname) references "user"(user_nickname) on delete cascade on update cascade,
    foreign key (artist_name, song_title) references song(artist_name, song_title) on delete cascade on update cascade,
    primary key (user_nickname, artist_name, song_title)
);

create table user_follows_artist(
    user_nickname varchar(25),
    artist_name varchar(50),

    foreign key (user_nickname) references "user"(user_nickname) on delete cascade on update cascade,
    foreign key (artist_name) references artist(artist_name) on delete cascade on update cascade,
    primary key (user_nickname, artist_name)
);

create table user_follows_playlist(
    follower_nickname varchar(25),
    playlist_creator_nickname varchar(25),
    playlist_name varchar(50),

    foreign key (follower_nickname) references "user"(user_nickname) on delete cascade on update cascade,
    foreign key (playlist_creator_nickname, playlist_name) references playlist(user_nickname, playlist_name) on delete cascade on update cascade,
    primary key (follower_nickname, playlist_creator_nickname, playlist_name)
);

create table playlist_has_song(
    user_nickname varchar(25),
    playlist_name varchar(50),
    artist_name varchar(50),
    song_title varchar(100),
    addition_date date not null default current_date check (addition_date <= current_date),

    foreign key (user_nickname, playlist_name) references playlist(user_nickname, playlist_name) on delete cascade on update cascade,
    foreign key (artist_name, song_title) references song(artist_name, song_title) on delete cascade on update cascade,
    primary key (user_nickname, playlist_name, artist_name, song_title)
);
