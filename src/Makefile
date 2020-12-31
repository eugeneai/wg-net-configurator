.PHONY: all tests st itests gt igt t i transform run irun

LGT=LOGTALKHOME=/usr/lib/logtalk/share/logtalk swilgt

all: tests

t: tests

i: itests

tests:
	$(LGT) -g "{tester},halt."

itests:
	$(LGT) -g "{tester},logtalk_load(tools(loader))."
