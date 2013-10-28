NAME=HttpLuaModule

all: bundle
bundle:
	tar --exclude="*file" --exclude='.*' --exclude='*.sql' --exclude='*.lock' --exclude='*.rb' -C .. -cvzf $(NAME).tgz $(NAME).docset
