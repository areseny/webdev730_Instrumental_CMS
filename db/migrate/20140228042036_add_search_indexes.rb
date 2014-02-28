class AddSearchIndexes < ActiveRecord::Migration
  def up
    execute <<-_
      create or replace function f_unaccent(text)
        returns text as
      $func$
      select unaccent('unaccent', $1)
      $func$ language sql immutable set search_path = public, pg_temp;
    _
    execute <<-_
      create index ix_search_results on search_results using gin(
        (setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."title"::text, ''))), 'A') || setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."content"::text, ''))), 'B'))
      );
    _
  end
  def down
    execute "drop index ix_search_results"
    execute "drop function f_unaccent(text)"
  end
end
