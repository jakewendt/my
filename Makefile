CC = gcc
VERSION = 0.0.1
CFLAGS = -g -O2

all: pi-bin

pi-bin: pi.c
	$(CC) $(CFLAGS) -DVERSION=\"$(VERSION)\" pi.c -o pi

clean:
	rm -f pi

distclean:
	rm -f pi config.* Makefile

