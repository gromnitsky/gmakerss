src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

g := .
mode := mbox

opt = $(or $($1),$(.$1),$2)
SHELL := bash
.SHELLFLAGS := -c -o pipefail
bin := $(src)/node_modules/.bin

mbox.out := rss
mbox = $(bin)/rss2mail --history history.txt >> $(mbox.out)/$(.name)
rnews = $(bin)/rss2mail --rnews $(.name) --history history.txt | sudo -u news rnews -N

%:
	$(props_parse_init)
	$(call props_parse,$*)

	@echo $(.name) | grep -qsiE $(call se,$(g))
	$(if $(call eq,$(mode),mbox),@mkdir -p $(mbox.out))
	curl -sfL --connect-timeout 15 -m 120 $(call se,$(.url)) $(call opt,curl.opt) | $(bin)/grepfeed -x $(call opt,grepfeed) | $($(mode))
