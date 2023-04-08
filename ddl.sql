create database projeto;

create table artista(
    artista_nome varchar(50),
    artista_sobre text,
    artista_qt_curtidas bigint default 0,
    artista_qt_seguidores bigint default 0,

    primary key (artista_nome)
);

create table lancamento(
    artista_nome varchar(50),
    lancamento_titulo varchar(100),
    lancamento_tipo varchar(10) check (lancamento_tipo in ('Álbum', 'EP', 'Single')),
    lancamento_copyright varchar(50) not null,
    lancamento_data_publicacao date not null check (lancamento_data_publicacao <= current_date),

    foreign key (artista_nome) references artista(artista_nome) on delete cascade on update cascade,
    primary key (artista_nome, lancamento_titulo, lancamento_tipo)
);

create table musica(
    artista_nome varchar(50),
    musica_titulo varchar(100),
    musica_duracao interval not null check (musica_duracao > '00:00:00'),
    musica_letra text,
    musica_qt_curtidas bigint default 0,

    foreign key (artista_nome) references artista(artista_nome) on delete cascade on update cascade,
    primary key (artista_nome, musica_titulo)
);

create table genero(
    artista_nome varchar(50),
    musica_titulo varchar(100),
    genero_nome varchar(10) check (genero_nome in ('Clássica', 'Sertanejo', 'Eletrônica', 'Funk', 'Hip Hop', 'Jazz', 'Pop', 'R&B', 'Rock', 'Metal', 'Punk', 'Samba', 'Pagode', 'MPB')),

    foreign key (artista_nome, musica_titulo) references musica(artista_nome, musica_titulo) on delete cascade on update cascade,
    primary key (artista_nome, musica_titulo, genero_nome)
);

create table produtor(
    artista_nome varchar(50),
    musica_titulo varchar(100),
    produtor_nome varchar(50),

    foreign key (artista_nome, musica_titulo) references musica(artista_nome, musica_titulo) on delete cascade on update cascade,
    primary key (artista_nome, musica_titulo, produtor_nome)
);

create table interprete(
    artista_nome varchar(50),
    musica_titulo varchar(100),
    interprete_nome varchar(50),

    foreign key (artista_nome, musica_titulo) references musica(artista_nome, musica_titulo) on delete cascade on update cascade,
    primary key (artista_nome, musica_titulo, interprete_nome)
);

create table compositor(
    artista_nome varchar(50),
    musica_titulo varchar(100),
    compositor_nome varchar(50),

    foreign key (artista_nome, musica_titulo) references musica(artista_nome, musica_titulo) on delete cascade on update cascade,
    primary key (artista_nome, musica_titulo, compositor_nome)
);

create table usuario(
    usuario_apelido varchar(25),
    usuario_nome varchar(50),
    usuario_email varchar(50) unique not null check (usuario_email like '_%@_%._%'),

    primary key (usuario_apelido)
);

create table playlist(
    usuario_apelido varchar(25),
    playlist_nome varchar(50),
    playlist_qt_seguidores bigint default 0,

    foreign key (usuario_apelido) references usuario(usuario_apelido) on delete cascade on update cascade,
    primary key (usuario_apelido, playlist_nome)
);

create table participacao(
    artista_nome varchar(50),
    musica_titulo varchar(100),
    participacao_nome varchar(50),

    foreign key (artista_nome, musica_titulo) references musica(artista_nome, musica_titulo) on delete cascade on update cascade,
    foreign key (participacao_nome) references artista(artista_nome) on delete cascade on update cascade,
    primary key (artista_nome, musica_titulo, participacao_nome)
);

create table lancamento_contem_musica(
    lancamento_artista_nome varchar(50),
    lancamento_titulo varchar(100),
    lancamento_tipo varchar(10),
    musica_artista_nome varchar(50),
    musica_titulo varchar(100),

    foreign key (lancamento_artista_nome, lancamento_titulo, lancamento_tipo) references lancamento(artista_nome, lancamento_titulo, lancamento_tipo) on delete cascade on update cascade,
    foreign key (musica_artista_nome, musica_titulo) references musica(artista_nome, musica_titulo) on delete cascade on update cascade,
    primary key (lancamento_artista_nome, lancamento_titulo, lancamento_tipo, musica_artista_nome, musica_titulo)
);

create table usuario_curte_musica(
    usuario_apelido varchar(25),
    artista_nome varchar(50),
    musica_titulo varchar(100),
    data_curtida date not null default current_date check (data_curtida <= current_date),

    foreign key (usuario_apelido) references usuario(usuario_apelido) on delete cascade on update cascade,
    foreign key (artista_nome, musica_titulo) references musica(artista_nome, musica_titulo) on delete cascade on update cascade,
    primary key (usuario_apelido, artista_nome, musica_titulo)
);

create table usuario_segue_artista(
    usuario_apelido varchar(25),
    artista_nome varchar(50),

    foreign key (usuario_apelido) references usuario(usuario_apelido) on delete cascade on update cascade,
    foreign key (artista_nome) references artista(artista_nome) on delete cascade on update cascade,
    primary key (usuario_apelido, artista_nome)
);

create table usuario_segue_playlist(
    seguidor_apelido varchar(25),
    autor_playlist_apelido varchar(25),
    playlist_nome varchar(50),

    foreign key (seguidor_apelido) references usuario(usuario_apelido) on delete cascade on update cascade,
    foreign key (autor_playlist_apelido, playlist_nome) references playlist(usuario_apelido, playlist_nome) on delete cascade on update cascade,
    primary key (seguidor_apelido, autor_playlist_apelido, playlist_nome)
);

create table playlist_contem_musica(
    usuario_apelido varchar(25),
    playlist_nome varchar(50),
    artista_nome varchar(50),
    musica_titulo varchar(100),
    data_adicao date not null default current_date check (data_adicao <= current_date),

    foreign key (usuario_apelido, playlist_nome) references playlist(usuario_apelido, playlist_nome) on delete cascade on update cascade,
    foreign key (artista_nome, musica_titulo) references musica(artista_nome, musica_titulo) on delete cascade on update cascade,
    primary key (usuario_apelido, playlist_nome, artista_nome, musica_titulo)
);
