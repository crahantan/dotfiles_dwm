/* See LICENSE file for copyright and license details. */
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*concat paths*/
char rofi_path[1000];
char powermenu_path[1000];

/*HOME*/
const char *home = "/home/crahantan/";

/*PATHs*/
void concat() {
  strcat(strcpy(rofi_path, home), ".config/rofi/launchers/type-4/launcher.sh");
  strcat(strcpy(powermenu_path, home),
         ".config/rofi/powermenu/type-4/powermenu.sh");
}

/* appearance */
static const unsigned int borderpx = 3; /* border pixel of windows */
static const unsigned int gappx = 10;   /* gaps between windows */
static const unsigned int snap = 32;    /* snap pixel */
static const unsigned int systraypinning =
    0; /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor
X */
static const unsigned int systrayonleft =
    0; /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2; /* systray spacing */
static const int systraypinningfailfirst =
    1; /* 1: if pinning fails, display systray on the first monitor, False:
          display systray on the last monitor*/
static const int showsystray = 0;       /* 0 means no systray */
static const int showbar = 1;           /* 0 means no bar */
static const int topbar = 1;            /* 0 means bottom bar */
static const int splitstatus = 1;       /* 1 for split status items */
static const char *splitdelim = ";";    /* Character used for separating status
                                         */
static const unsigned int stairpx = 20; /* depth of the stairs layout */
static const int stairdirection = 0;    /* 0: left-aligned, 1: right-aligned */
static const int stairsamesize =
    1; /* 1 means shrink all the staired windows to the same size */
static const char *fonts[] = {"Iosevka Nerd Font Regular:size=12"};
static const char dmenufont[] = "Iosevka Nerd Font Regular:size=12";

/*pywal for dwm*/
#include "/home/crahantan/.cache/wal/colors-wal-dwm.h"

/* staticstatus */
static const int statmonval = 0;

/* Set visualization bar in order to statmoval*/
static const int initialbarmonitor = statmonval;

/* tagging */
static const char *tags[] = {" ", " ", " ", " ", " ",
                             " ", " ", " ", " "};

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor
       border width */

	{"Firefox",NULL,NULL,1,0,0-1}

};

    /* layout(s) */
    static const float mfact =
        0.55;                 /* factor of master area size [0.05..0.95] */
static const int nmaster = 1; /* number of clients in master area */
static const int resizehints =
    1; /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen =
    1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
    /* first entry is default */
    /* no layout function means floating behavior */
    /* symbol     arrange function */
    {"[S]", stairs},
    {"[M]", monocle},
    {"><>", NULL},
    {NULL, NULL},
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

/* commands */
static char dmenumon[2] =
    "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {"dmenu_run", "-m", dmenumon, "-fn", NULL};
static const char *rofi[] = {rofi_path, NULL};
static const char *termcmd[] = {"alacritty", NULL};
static const char *volumeUp[] = {"pamixer", "-i", "5", NULL};
static const char *volumeDown[] = {"pamixer", "-d", "5", NULL};
static const char *volumeMute[] = {"pamixer", "-m", NULL};
static const char *volumeUnMute[] = {"pamixer", "-u", NULL};
static const char *restartDwm[] = {"restartdwm", NULL};
static const char *powermenu[] = {powermenu_path, NULL};

#include "../patches/pdwm/shifttag.c"
#include "../patches/pdwm/shiftview.c"
#include "focusurgent.c"

static const Key keys[] = {
    /* modifier                     key        function        argument */
    {MODKEY | ShiftMask, XK_f, togglefullscr, {0}},
    {MODKEY, XK_d, spawn, {.v = rofi}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
    {MODKEY | ShiftMask, XK_e, spawn, {.v = restartDwm}},
    {MODKEY, XK_Escape, spawn, {.v = powermenu}},
    {MODKEY, XK_t, togglebar, {0}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_p, incnmaster, {.i = -1}},
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    {MODKEY | ShiftMask, XK_Return, zoom, {0}},
    {MODKEY, XK_Tab, view, {0}},
    {MODKEY | ShiftMask, XK_q, killclient, {0}},
    {MODKEY, XK_a, setlayout, {.v = &layouts[0]}},
    {MODKEY, XK_s, setlayout, {.v = &layouts[1]}},
    {MODKEY, XK_m, setlayout, {.v = &layouts[2]}},
    //{MODKEY, XK_y, setlayout, {.v = &layouts[3]}},
    {MODKEY | ControlMask, XK_comma, cyclelayout, {.i = -1}},
    {MODKEY | ControlMask, XK_period, cyclelayout, {.i = +1}},
    {MODKEY, XK_space, setlayout, {0}},
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
    {MODKEY, XK_minus, setgaps, {.i = -1}},
    {MODKEY, XK_plus, setgaps, {.i = +1}},
    {MODKEY | ShiftMask, XK_equal, setgaps, {.i = 0}},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8){MODKEY | ShiftMask, XK_e, quit, {0}},
    {MODKEY, XK_b, shiftview, {.i = -1}},
    {MODKEY | ShiftMask, XK_b, shifttag, {.i = -1}},
    {MODKEY, XK_n, shiftview, {.i = +1}},
    {MODKEY | ShiftMask, XK_n, shifttag, {.i = +1}},
    {MODKEY, XK_u, focusurgent, {0}},
    {0, XK_F4, spawn, {.v = volumeUp}},
    {0, XK_F3, spawn, {.v = volumeDown}},
    {0, XK_F6, spawn, {.v = volumeMute}},
    {0, XK_F6, spawn, {.v = volumeUnMute}},

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
 * ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};