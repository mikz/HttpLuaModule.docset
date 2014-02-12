#!/usr/bin/env ruby

sql = ARGF.read

create = %{
CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);
CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);
}

sqlite = IO.popen('sqlite3 Contents/Resources/docSet.dsidx' , 'r+' )

sqlite << create << sql
