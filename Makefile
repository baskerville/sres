VERSION = 0.2

CC      = gcc
LIBS    = -lm -lxcb
CFLAGS  = -std=c99 -pedantic -Wall -Wextra -I$(PREFIX)/include
CFLAGS  += -D_POSIX_C_SOURCE=200112L -DVERSION=\"$(VERSION)\"
LDFLAGS = -L$(PREFIX)/lib

PREFIX    ?= /usr/local
BINPREFIX = $(PREFIX)/bin

SRC = sres.c helpers.c
OBJ = $(SRC:.c=.o)

all: CFLAGS += -Os
all: LDFLAGS += -s
all: options sres

options:
	@echo "sres build options:"
	@echo "CC      = $(CC)"
	@echo "CFLAGS  = $(CFLAGS)"
	@echo "LDFLAGS = $(LDFLAGS)"
	@echo "LIBS    = $(LIBS)"
	@echo "PREFIX  = $(PREFIX)"

.c.o:
	@echo "CC $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

sres: $(OBJ)
	@echo CC -o $@
	@$(CC) -o $@ $(OBJ) $(LDFLAGS) $(LIBS)

clean:
	@echo "cleaning"
	@rm -f $(OBJ) sres

install:
	@echo "installing executable files to $(DESTDIR)$(BINPREFIX)"
	@mkdir -p "$(DESTDIR)$(BINPREFIX)"
	@cp sres "$(DESTDIR)$(BINPREFIX)"
	@chmod 755 "$(DESTDIR)$(BINPREFIX)/sres"

uninstall:
	@echo "removing executable files from $(DESTDIR)$(BINPREFIX)"
	@rm -f $(DESTDIR)$(BINPREFIX)/sres

.PHONY: all options clean install uninstall
