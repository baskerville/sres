#include <stdio.h>
#include <X11/Xlib.h>

int
main (void) {
    Display *dpy;
    int screen, sw, sh;
    if (!(dpy = XOpenDisplay(NULL)))
        return -1;  
	screen = DefaultScreen(dpy);
	sw = DisplayWidth(dpy, screen);
	sh = DisplayHeight(dpy, screen);
    printf("%ix%i\n", sw, sh);
	XCloseDisplay(dpy);
    return 0;
}
