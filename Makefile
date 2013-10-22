
all: bundle
bundle:
	tar --exclude="Makefile" --exclude='.git' --exclude='.DS_Store' --exclude='gen.rb' --exclude='pretty.rb' --exclude='generated.sql' -cvzf HttpLuaModule.tgz ../HttpLuaModule.docset
