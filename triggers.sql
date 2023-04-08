create function atualizar_qt_curtidas()
returns trigger as $$
begin
	if (TG_OP = 'INSERT') then
		update musica
		set musica_qt_curtidas = musica_qt_curtidas + 1
		where (artista_nome, musica_titulo) = (new.artista_nome, new.musica_titulo);

		update artista
		set artista_qt_curtidas = artista_qt_curtidas + 1
		where artista_nome = new.artista_nome;
	elsif (TG_OP = 'DELETE') then
		update musica
		set musica_qt_curtidas = musica_qt_curtidas - 1
		where (artista_nome, musica_titulo) = (old.artista_nome, old.musica_titulo);

		update artista
		set artista_qt_curtidas = artista_qt_curtidas - 1
		where artista_nome = old.artista_nome;
	end if;
	return new;
end;
$$ language plpgsql;

create trigger atualizar_qt_curtidas
after insert or delete on usuario_curte_musica
for each row
execute function atualizar_qt_curtidas();


create function atualizar_artista_qt_seguidores()
returns trigger as $$
begin
	if (TG_OP = 'INSERT') then
		update artista
		set artista_qt_seguidores = artista_qt_seguidores + 1
		where artista_nome = new.artista_nome;
	elsif (TG_OP = 'DELETE') then
		update artista
		set artista_qt_seguidores = artista_qt_seguidores - 1
		where artista_nome = old.artista_nome;
	end if;
    return new;
end;
$$ language plpgsql;

create trigger atualizar_artista_qt_seguidores
after insert or delete on usuario_segue_artista
for each row
execute function atualizar_artista_qt_seguidores();


create function atualizar_playlist_qt_seguidores()
returns trigger as $$
begin
	if (TG_OP = 'INSERT') then
		update playlist
		set playlist_qt_seguidores = playlist_qt_seguidores + 1
		where (usuario_apelido, playlist_nome) = (new.autor_playlist_apelido, new.playlist_nome);
	elsif (TG_OP = 'DELETE') then
		update playlist
		set playlist_qt_seguidores = playlist_qt_seguidores - 1
		where (usuario_apelido, playlist_nome) = (old.autor_playlist_apelido, old.playlist_nome);
	end if;
    return new;
end;
$$ language plpgsql;

create trigger atualizar_playlist_qt_seguidores
after insert or delete on usuario_segue_playlist
for each row
execute function atualizar_playlist_qt_seguidores();


create function checar_data_adicao()
returns trigger as $$
begin
    if new.data_adicao < all (
		select lancamento_data_publicacao
		from lancamento l
		join lancamento_contem_musica rel
		on (l.artista_nome, l.lancamento_titulo, l.lancamento_tipo) = (rel.lancamento_artista_nome, rel.lancamento_titulo, rel.lancamento_tipo)
		where (new.artista_nome, new.musica_titulo) = (musica_artista_nome, musica_titulo)
	) then
        raise exception 'data_adicao precisa ser depois da música ter sido lançada!';
    END if;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

create trigger checar_data_adicao
before insert on playlist_contem_musica
for each row
execute function checar_data_adicao();


create function checar_data_curtida()
returns trigger as $$
begin
    if new.data_curtida < all (
		select lancamento_data_publicacao
		from lancamento l
		join lancamento_contem_musica rel
		on (l.artista_nome, l.lancamento_titulo, l.lancamento_tipo) = (rel.lancamento_artista_nome, rel.lancamento_titulo, rel.lancamento_tipo)
		where (new.artista_nome, new.musica_titulo) = (musica_artista_nome, musica_titulo)
	) then
        raise exception 'data_curtida precisa ser depois da música ter sido lançada!';
    END if;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

create trigger checar_data_curtida
before insert on usuario_curte_musica
for each row
execute function checar_data_curtida();
