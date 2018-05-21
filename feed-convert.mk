src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

mode := mbox

opt = $(or $($1),$(.$1),$2)
from = $(if $(.from),-f $(call se,$(.from)))
SHELL := bash
.SHELLFLAGS := -c -o pipefail
bin := $(src)/node_modules/.bin

mbox.out := rss
mbox = $(bin)/rss2mail $(from) $(if $(f),,--history history.txt) -o $(mbox.out)/$(.dest)
rnews = $(bin)/rss2mail $(from) --rnews $(.dest) | sudo -u news rnews -N

%:
	$(props_parse_init)
	$(call props_parse,$*)

	$(if $(call eq,$(mode),mbox),@mkdir -p $(mbox.out))
	curl -sfL --connect-timeout 15 -m 120 $(call se,$(.url)) $(call opt,curl.opt) | $(bin)/grepfeed -x $(call opt,grepfeed) | $($(mode))
