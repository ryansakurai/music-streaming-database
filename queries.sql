-- Liste todos os lançamentos de um determinado artista.
select *
from lancamento
where artista_nome = <artista_nome>;

-- Quantas músicas num intervalo de duração entre x e y tem por playlist?
select playlist_nome, usuario_apelido, count(*) as qtd
from playlist_contem_musica natural join musica
where musica_duracao between <duracao_x> and <duracao_y>
group by playlist_nome, usuario_apelido;

-- Qual é a música mais curtida de um determinado artista?
select *
from musica
where artista_nome = <artista_nome>
and musica_qt_curtidas = (
	select max(musica_qt_curtidas)
	from musica
	where artista_nome = <artista_nome>
)

-- Quantos seguidores um determinado artista possui?
select artista_qt_seguidores
from artista
where artista_nome = <artista_nome>

-- Quais usuários curtem o gênero X e não curtem o gênero Y?
(
    select usuario_apelido, usuario_nome
    from usuario natural join usuario_curte_musica natural join genero
    where genero_nome = <genero_nome_x>
)
except (
	select usuario_apelido, usuario_nome
	from usuario natural join usuario_curte_musica natural join genero
	where genero_nome = <genero_nome_y>
);

-- Qual é a música com menor duração de um determinado artista?
select *
from musica
where artista_nome = <artista_nome>
and musica_duracao = (
	select min(musica_duracao)
	from musica
	where artista_nome = <artista_nome>
);

-- Qual a duração de um determinado lançamento do tipo álbum de um certo artista?
select sum(mus.musica_duracao) as duracao
from lancamento lanc
join lancamento_contem_musica rel on (rel.lancamento_artista_nome, rel.lancamento_titulo, rel.lancamento_tipo) = (lanc.artista_nome, lanc.lancamento_titulo, lanc.lancamento_tipo)
join musica mus on (rel.musica_artista_nome, rel.musica_titulo) = (mus.artista_nome, mus.musica_titulo)
where (lanc.artista_nome, lanc.lancamento_titulo, lanc.lancamento_tipo) = (<artista_nome>, <lancamento_titulo>, 'Álbum');

select lancamento_duracao
from lancamento_completo
where (artista_nome, lancamento_titulo, lancamento_tipo) = (<artista_nome>, <lancamento_titulo>, 'Álbum');

-- Quais usuários que curtem uma playlist também curtem outra playlist do mesmo criador?
select seguidor_apelido
from (
	select seguidor_apelido, autor_playlist_apelido, count(playlist_nome) as qtd_playlists
	from usuario_segue_playlist
	group by seguidor_apelido, autor_playlist_apelido
) contagem
where qtd_playlists > 1;

-- Qual é a média de curtidas por música de cada artista?
select artista_nome, avg(musica_qt_curtidas) as media_curtidas
from musica
group by artista_nome
