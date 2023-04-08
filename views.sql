create view artista_genero(artista_nome, genero_nome) as
    select distinct artista_nome, genero_nome
    from genero;

create view lancamento_genero(artista_nome, lancamento_titulo, lancamento_tipo, genero_nome) as
    select distinct rel.lancamento_artista_nome, rel.lancamento_titulo, rel.lancamento_tipo, genero_nome
    from lancamento_contem_musica rel
    join genero g on (g.artista_nome, g.musica_titulo) = (rel.musica_artista_nome, rel.musica_titulo);

create view lancamento_completo(artista_nome, lancamento_titulo, lancamento_tipo, lancamento_copyright, lancamento_data_publicacao, lancamento_qt_musicas, lancamento_duracao) as
    select lanc.artista_nome, lanc.lancamento_titulo, lanc.lancamento_tipo, lancamento_copyright, lancamento_data_publicacao, count(*), sum(musica_duracao)
    from lancamento lanc
    join lancamento_contem_musica rel on (rel.lancamento_artista_nome, rel.lancamento_titulo, rel.lancamento_tipo) = (lanc.artista_nome, lanc.lancamento_titulo, lanc.lancamento_tipo)
    join musica mus on (rel.musica_artista_nome, rel.musica_titulo) = (mus.artista_nome, mus.musica_titulo)
    group by lanc.artista_nome, lanc.lancamento_titulo, lanc.lancamento_tipo;

create view playlist_completo(usuario_apelido, playlist_nome, playlist_qt_musicas, playlist_duracao, playlist_qt_seguidores) as
    select p.usuario_apelido, p.playlist_nome, count(*), sum(musica_duracao), p.playlist_qt_seguidores
    from playlist p
    natural join playlist_contem_musica
    natural join musica
    group by p.usuario_apelido, p.playlist_nome;
