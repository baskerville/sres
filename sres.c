#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <xcb/xcb.h>
#include "helpers.h"

#define FORMAT_ONE   "%i"
#define FORMAT_TWO  "%ix%i"
enum {RETURN_BOTH, RETURN_WIDTH, RETURN_HEIGHT};

int main (int argc, char *argv[]) {

    int return_what = RETURN_BOTH;
    char format[MAXLEN] = {0};
    char opt;

    while ((opt = getopt(argc, argv, "vhHW")) != -1) {
        switch (opt) {
            case 'h':
                printf("sres [-h|-v|-H|-W] [FORMAT]\n");
                return EXIT_SUCCESS;
                break;
            case 'v':
                printf("%s\n", VERSION);
                return EXIT_SUCCESS;
                break;
            case 'H':
                return_what = RETURN_HEIGHT;
                break;
            case 'W':
                return_what = RETURN_WIDTH;
                break;
        }
    }

    int num = argc - optind;
    char **args = argv + optind;

    xcb_connection_t *dpy = xcb_connect(NULL, NULL);
    if (xcb_connection_has_error(dpy))
        err("Can't open the default display.\n");
    xcb_screen_t *screen = xcb_setup_roots_iterator(xcb_get_setup(dpy)).data;
    if (screen == NULL)
        err("Can't acquire the default screen.\n");

    int w = screen->width_in_pixels;
    int h = screen->height_in_pixels;

    if (num > 0) {
        strncpy(format, args[0], sizeof(format));
    } else {
        switch (return_what) {
            case RETURN_BOTH:
                strncpy(format, FORMAT_TWO, sizeof(format));
                break;
            case RETURN_WIDTH:
            case RETURN_HEIGHT:
                strncpy(format, FORMAT_ONE, sizeof(format));
                break;
        }
    }

    switch (return_what) {
        case RETURN_BOTH:
            printf(format, w, h);
            break;
        case RETURN_WIDTH:
            printf(format, w);
            break;
        case RETURN_HEIGHT:
            printf(format, h);
            break;
    }

    printf("\n");

    xcb_disconnect(dpy);
    return EXIT_SUCCESS;
}
