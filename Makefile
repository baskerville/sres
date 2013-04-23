VERSION = 0.1

CC      = gcc
LIBS    = -lm -lxcb
CFLAGS  = -std=c99 -pedantic -Wall -Wextra -I$(PREFIX)/include
CFLAGS  += -D_POSIX_C_SOURCE=200112L -DVERSION=\"$(VERSION)\"
LDFLAGS = -L$(PREFIX)/lib

PREFIX    ?= /usr/local
BINPREFIX = $(PREFIX)/bin

SRC = sres.c helpers.c
HDR = helpers.h
OBJ = $(SRC:.c=.o)

all: CFLAGS += -Os
all: LDFLAGS += -s
all: sres

$(OBJ): $(SRC) $(HDR) Makefile

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

sres: $(OBJ)
	$(CC) -o $@ $(OBJ) $(LDFLAGS) $(LIBS)

install:
	mkdir -p "$(DESTDIR)$(BINPREFIX)"
	cp sres "$(DESTDIR)$(BINPREFIX)"
	chmod 755 "$(DESTDIR)$(BINPREFIX)/sres"

uninstall:
	rm -f $(DESTDIR)$(BINPREFIX)/sres

clean:
	rm -f $(OBJ) sres

.PHONY: all clean install uninstall
