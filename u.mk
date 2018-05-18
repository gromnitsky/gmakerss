separator := 9dcd4654-4b01-11e8-9491-000c2945132f
define newline :=


endef
props_def := :{".url":"" , ".dest":"" , ".from":"" , ".curl.opt":"" , ".grepfeed":""}

props_parse = $(eval $(subst $(separator),$(newline),$(shell node -e 'process.stdout.write(Object.entries(JSON.parse(process.argv[1].slice(1))).map( ([k,v]) => `$${k}:=$${v}`).join("$(separator)"))' $(call se,$1) )))
props_parse_init = $(call props_parse,$(props_def))
eq = $(and $(findstring x$(1),x$(2)), $(findstring x$(2),x$(1)))
se = '$(subst ','\'',$1)'
