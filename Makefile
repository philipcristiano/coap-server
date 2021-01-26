PROJECT = coap_server
PROJECT_DESCRIPTION = New project

DEPS = \
	jsx \
	gen_coap \
	prometheus

BUILD_DEPS = version.mk erlfmt
LOCAL_DEPS = sasl
TEST_DEPS = meck jesse
TEST_DIR = tests
DIALYZER_DIRS = --src src tests

dep_erlfmt = git https://github.com/WhatsApp/erlfmt.git v0.8.0

dep_jsx = git https://github.com/talentdeficit/jsx.git v2.10.0
dep_gen_coap = git https://github.com/philipcristiano/gen_coap.git master
dep_prometheus = git https://github.com/deadtrickster/prometheus.erl.git v4.6.0
dep_recon = git https://github.com/ferd/recon.git 2.5.1
dep_sync = git https://github.com/rustyio/sync.git master
dep_version.mk = git https://github.com/manifest/version.mk.git v0.2.0

DEP_PLUGINS = version.mk

SHELL_OPTS = -eval 'application:ensure_all_started(coap_server).' -config sys +S2 -setcookie COOKIE

.PHONY: live-js
live-js:
	npm run dev

erlfmt:
	$(gen_verbose) $(SHELL_ERL) -pa $(SHELL_PATHS) -eval 'erlfmt_cli:do("erlfmt", [write, {files, ["src/*.erl", "tests/*.erl"]} ]), halt(0)'

erlfmt_check:
	$(gen_verbose) $(SHELL_ERL) -pa $(SHELL_PATHS) -eval 'erlfmt_cli:do("erlfmt", [check, {files, ["src/*.erl", "tests/*.erl"]} ]), halt(0)'

include erlang.mk
