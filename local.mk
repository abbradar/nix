ifeq ($(MAKECMDGOALS), dist)
  # Make sure we are in repo root with `--git-dir`
  dist-files += $(shell git --git-dir=.git ls-files || find * -type f)
endif

dist-files += configure config.h.in nix.spec

clean-files += Makefile.config

GLOBAL_CXXFLAGS += -I . -I src -I src/libutil -I src/libstore -I src/libmain -I src/libexpr \
  -Wno-unneeded-internal-declaration

$(foreach i, config.h $(call rwildcard, src/lib*, *.hh) src/nix-store/serve-protocol.hh, \
  $(eval $(call install-file-in, $(i), $(includedir)/nix, 0644)))

$(foreach i, $(call rwildcard, src/boost, *.hpp), $(eval $(call install-file-in, $(i), $(includedir)/nix/$(patsubst src/%/,%,$(dir $(i))), 0644)))


# make the store
$(eval $(call install-dir, $(storedir), 1775))
$(eval $(call install-dir, $(localstatedir)/nix/profiles/per-user, 1777))
$(eval $(call install-dir, $(localstatedir)/nix/gcroots/per-user, 1777))
$(eval $(call install-dir, $(localstatedir)/nix/channel-cache))
