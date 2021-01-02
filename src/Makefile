.PHONY: all tests st itests gt igt t i transform run irun

LGT=LOGTALKHOME=/usr/lib/logtalk/share/logtalk swilgt
MODULE=parsers

all: tests

t: tests

i: itests

tests:
	$(LGT) -g "{testloader_$(MODULE)},halt."

itests:
	$(LGT) -g "{testloader_$(MODULE)},logtalk_load(tools(loader))."
