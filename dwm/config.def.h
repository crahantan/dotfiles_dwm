/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 4; /* border pixel of windows */
static const unsigned int gappx = 20;   /* gaps between windows */
static const unsigned int snap = 32;    /* snap pixel */
static const int showbar = 1;           /* 0 means no bar */
static const int topbar = 0;            /* 0 means bottom bar */
static const unsigned int stairpx = 10; /* depth of the stairs layout */
static const int stairdirection = 1;    /* 0: left-aligned, 1: right-aligned */
static const int stairsamesize =
    1; /* 1 means shrink all the staired windows to the same size */
static const char *fonts[] = {"JetBrainsMono Nerd Font:size=12"};
static const char dmenufont[] = "JetBrainsMono Nerd Font:size=12";
// Tokyo night theme
// static const char col_bg[] = "#1a1b26";        // Tokyo Night background
// static const char col_bg_alt[] = "#24283b";    // Tokyo Night darker
// background static const char col_fg[] = "#c0caf5";        // Tokyo Night
// foreground static const char col_fg_bright[] = "#ffffff"; // Tokyo Night
// bright white static const char col_accent[] = "#7aa2f7"; // Tokyo Night blue
// accent
// Grey light theme
// static const char col_bg[] = "#f4f4f5";        // Fondo gris muy claro
// static const char col_bg_alt[] = "#e5e7eb";    // Fondo alterno gris suave
// static const char col_fg[] = "#374151";        // Texto gris oscuro
// static const char col_fg_bright[] = "#111827"; // Texto negro grisáceo
// static const char col_accent[] = "#3b82f6";    // Azul brillante
// Dark solid theme
static const char col_bg[] = "#1a1a1a";        // Fondo negro sólido
static const char col_bg_alt[] = "#262626";    // Fondo alterno gris muy oscuro
static const char col_fg[] = "#d4d4d8";        // Texto gris claro
static const char col_fg_bright[] = "#f4f4f5"; // Texto blanco grisáceo
static const char col_accent[] = "#3b82f6";    // Azul brillante (mantenido)

static const char *colors[][3] = {
    /*               fg           bg        border     */
    [SchemeNorm] = {col_fg, col_bg, col_bg},
    [SchemeSel] = {col_fg_bright, col_accent, col_bg_alt},
    [SchemeTabActive] = {col_fg_bright, col_bg, col_bg},
    [SchemeTabInactive] = {col_fg_bright, col_fg, col_fg_bright}};
/* tagging */
static const char *tags[] = {" ", " ", " ", " ", " ",
                             " ", " ", " ", " "};

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor */
    {"Spotify", NULL, NULL, 1 << 8, 0, -1},
    {"ZapZap", NULL, NULL, 1 << 8, 0, -1},
};

/* layout(s) */
static const float mfact = 0.70; /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;    /* number of clients in master area */
static const int resizehints =
    1; /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen =
    1; /* 1 will force focus on the fullscreen window */

/* Bartabgroups properties */
#define BARTAB_BORDERS 1      // 0 = off, 1 = on
#define BARTAB_BOTTOMBORDER 1 // 0 = off, 1 = on
#define BARTAB_TAGSINDICATOR                                                   \
  2                     // 0 = off, 1 = on if >1 client/view tag, 2 = always on
#define BARTAB_TAGSPX 5 // # pixels for tag grid boxes
#define BARTAB_TAGSROWS 3 // # rows in tag grid (9 tags, e.g. 3x3)
static void (*bartabmonfns[])(Monitor *) = {stairs, monocle, tile,
                                            NULL /* , customlayoutfn */};
static void (*bartabfloatfns[])(Monitor *) = {stairs, monocle, tile,
                                              NULL /* , customlayoutfn */};

static const Layout layouts[] = {
    /* symbol     arrange function */
    /* first entry is default */
    /* no layout function means floating behavior */
    {"[S]", stairs},
    {"[]=", tile},
    {"[M]", monocle},
    {"><>", NULL},
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
static const char *dmenucmd[] = {
    "dmenu_run", "-m",   dmenumon, "-fn",      dmenufont, "-nb",         col_bg,
    "-nf",       col_fg, "-sb",    col_accent, "-sf",     col_fg_bright, NULL};
static const char *roficmd[] = {"rofi",
                                "-combi-modi",
                                "window,drun,run",
                                "-font",
                                "Mononoki Nerd Font 18",
                                "-show",
                                "combi",
                                "-icon-theme",
                                "Papirus",
                                "-show-icons",
                                NULL};
static const char *termcmd[] = {"kitty", NULL};
static const char *volumeUp[] = {"pamixer",     "-i",  "5", "--allow-boost",
                                 "--set-limit", "130", NULL};
static const char *volumeDown[] = {"pamixer", "-d", "5", NULL};
static const char *volumeMute[] = {"pamixer", "-m", NULL};
static const char *volumeUnMute[] = {"pamixer", "-u", NULL};
static const char *screenshoot[] = {"spectacle", "-r", NULL};

#include "../patches/dwm/shifttag.c"
#include "../patches/dwm/shiftview.c"
#include "focusurgent.c"

static const Key keys[] = {
    /* modifier                     key        function        argument */
    {MODKEY | ShiftMask, XK_s, spawn, {.v = screenshoot}},
    {MODKEY, XK_d, spawn, {.v = roficmd}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
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
    {MODKEY, XK_w, setlayout, {.v = &layouts[2]}},
    {MODKEY, XK_e, setlayout, {.v = &layouts[3]}},
    {MODKEY, XK_space, setlayout, {0}},
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8){MODKEY | ShiftMask, XK_e, quit, {0}},
    {MODKEY, XK_b, shiftview, {.i = -1}},
    {MODKEY | ShiftMask, XK_b, shifttag, {.i = -1}},
    {MODKEY, XK_n, shiftview, {.i = +1}},
    {MODKEY | ShiftMask, XK_n, shifttag, {.i = +1}},
    {MODKEY, XK_u, focusurgent, {0}},
    {MODKEY, XK_minus, setgaps, {.i = -1}},
    {MODKEY, XK_plus, setgaps, {.i = +1}},
    {MODKEY | ShiftMask, XK_equal, setgaps, {.i = 0}},
    {MODKEY | ShiftMask, XK_f, fullscreen, {0}},
    {0, XK_F4, spawn, {.v = volumeUp}},
    {0, XK_F3, spawn, {.v = volumeDown}},
    {0, XK_F6, spawn, {.v = volumeMute}},
    {0, XK_F7, spawn, {.v = volumeUnMute}},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
 * ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};
