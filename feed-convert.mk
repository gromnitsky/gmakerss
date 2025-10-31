src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

mode := mbox

opt = $(or $($1),$(.$1),$2)
from = $(if $(.from),-f $(call se,$(.from)))
SHELL := bash
.SHELLFLAGS := -c -o pipefail
bin := $(src)/node_modules/.bin

mbox.out = rss/$(.dest)
mbox = $(bin)/rss2mail $(from) $(if $(f),,--history history.txt) -o $(mbox.out)
rnews = $(bin)/rss2mail $(from) --rnews $(.dest) | sudo -u news rnews -N

grepfeed = $(if $(.grepfeed),$(bin)/grepfeed -x $(.grepfeed),cat)

%:
	$(props_parse_init)
	$(call props_parse,$*)

	$(if $(call eq,$(mode),mbox),@mkdir -p $(dir $(mbox.out)))
	@mkdir -p .cache
	@echo $(call se,$(.url)) > $(basename $(.cache)).url

	curl -sfL --connect-timeout 15 -m 120 $(call se,$(.url)) $(call opt,curl.opt) | $(grepfeed) > $(.cache)
	$(if $(call eq,$(mode),mbox),flock -w 4 $(mbox.out) $(mbox),$(rnews)) < $(.cache)
