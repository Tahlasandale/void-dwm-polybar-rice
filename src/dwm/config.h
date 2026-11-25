/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 5;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int usealtbar          = 1;        /* 1 means use non-dwm status bar (Polybar) */
static const char *altbarclass      = "Polybar"; /* Alternate bar class name */
static const char *alttrayname      = "tray";    /* Polybar tray instance name */
static const char *altbarcmd        = "$HOME/.config/polybar/launch.sh"; /* Alternate bar launch command */
static const int bottombarheight    = 0;       /* hauteur de la barre Polybar basse */
static const char *fonts[]          = { "JetBrainsMono Nerd Font:size=10", "monospace:size=10" };
static const char dmenufont[]       = "JetBrainsMono Nerd Font:size=10";

/* Catppuccin Mocha Palette */
static const char col_base[]        = "#1e1e2e";
static const char col_mantle[]      = "#181825";
static const char col_text[]        = "#cdd6f4";
static const char col_pink[]        = "#f5c2e7";
static const char col_active[]      = "#94e2d5";
static const char col_inactive[]    = "#11111b";

static const char *colors[][3]      = {
	/*               fg         bg        border      */
	[SchemeNorm] = { col_text,  col_base, col_inactive },
	[SchemeSel]  = { col_base,  col_pink, col_active   },
};

/* tagging (1 à 5 comme sur Sway) */
static const char *tags[] = { "1", "2", "3", "4", "5" };

static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ NULL,       NULL,       NULL,       0,            0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

#define STATUSBAR "dwmblocks"

/* key definitions */
#define MOD_SUPER Mod4Mask /* Touche Super / Windows (comme sur l'hôte Sway) */
#define MOD_ALT   Mod1Mask /* Touche Alt (compatibilité) */
#define MOD_CTRL  ControlMask /* Touche Ctrl */

#define TAGKEYS_MOD(MOD,KEY,TAG) \
	{ MOD,                       KEY,      view,            {.ui = 1 << TAG} }, \
	{ MOD|ShiftMask,             KEY,      movetoworkspace, {.ui = 1 << TAG} }, \
	{ MOD|ControlMask,           KEY,      toggleview,      {.ui = 1 << TAG} }, \
	{ MOD|ControlMask|ShiftMask, KEY,      toggletag,       {.ui = 1 << TAG} },

/* commands */
static char dmenumon[8] = "0";
static const char *dmenucmd[]      = { "dmenu-drun", NULL };
static const char *termcmd[]       = { "alacritty", NULL };
static const char *stcmd[]         = { "alacritty", NULL };
static const char *lockcmd[]       = { "slock", NULL };
static const char *bartogglecmd[]  = { "toggle-bars.sh", NULL };
static const char *themecmd[]      = { "nicotine-theme", "toggle", NULL };
static const char *wallcmd[]       = { "next-wallpaper.sh", NULL };
static const char *opencmd[]       = { "alacritty", "-e", "/home/bison/.local/bin/cdd-opencode.sh", NULL };
static const char *volupcmd[]      = { "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+", NULL };
static const char *voldowncmd[]    = { "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-", NULL };
static const char *volmutecmd[]    = { "wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle", NULL };
static const char *micmutecmd[]    = { "wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle", NULL };
static const char *brupcmd[]       = { "brightnessctl", "set", "5%+", NULL };
static const char *brdowncmd[]     = { "brightnessctl", "set", "5%-", NULL };
static const char *kbdbrupcmd[]    = { "brightnessctl", "--device=smc::kbd_backlight", "set", "10%+", NULL };
static const char *kbdbrdowncmd[]  = { "brightnessctl", "--device=smc::kbd_backlight", "set", "10%-", NULL };

static const Key keys[] = {
	/* modifier                     key              function        argument */
	/* 1. Terminal (Super + Entree / Alt + Entree / Alt + Shift + Entree) */
	{ MOD_SUPER,                    XK_Return,       spawn,          {.v = termcmd } },
	{ MOD_ALT,                      XK_Return,       spawn,          {.v = termcmd } },
	{ MOD_ALT|ShiftMask,            XK_Return,       spawn,          {.v = stcmd } },
	{ MOD_SUPER|ShiftMask,          XK_Return,       spawn,          {.v = stcmd } },

	/* 1b. Opencode (Super + o) */
	{ MOD_SUPER,                    XK_o,            spawn,          {.v = opencmd } },

	/* 2. Menu dmenu (Super + Espace / Ctrl + Espace / Alt + Espace / Alt + p) */
	{ MOD_SUPER,                    XK_space,        spawn,          {.v = dmenucmd } },
	{ MOD_CTRL,                     XK_space,        spawn,          {.v = dmenucmd } },
	{ MOD_ALT,                      XK_space,        spawn,          {.v = dmenucmd } },
	{ MOD_ALT,                      XK_p,            spawn,          {.v = dmenucmd } },

	/* Hardware multimedia keys */
	{ 0,                            XF86XK_AudioRaiseVolume,  spawn, {.v = volupcmd } },
	{ 0,                            XF86XK_AudioLowerVolume,  spawn, {.v = voldowncmd } },
	{ 0,                            XF86XK_AudioMute,         spawn, {.v = volmutecmd } },
	{ 0,                            XF86XK_AudioMicMute,      spawn, {.v = micmutecmd } },
	{ 0,                            XF86XK_MonBrightnessUp,   spawn, {.v = brupcmd } },
	{ 0,                            XF86XK_MonBrightnessDown, spawn, {.v = brdowncmd } },
	{ 0,                            XF86XK_KbdBrightnessUp,   spawn, {.v = kbdbrupcmd } },
	{ 0,                            XF86XK_KbdBrightnessDown, spawn, {.v = kbdbrdowncmd } },

	/* 3. Verrouillage ecran (Super + l et Alt + l -> slock) */
	{ MOD_SUPER,                    XK_l,            spawn,          {.v = lockcmd } },
	{ MOD_ALT,                      XK_l,            spawn,          {.v = lockcmd } },

	/* 3b. Bascule de theme (Super + t et Super + Maj + !) */
	{ MOD_SUPER,                    XK_t,            spawn,          {.v = themecmd } },
	{ MOD_SUPER|ShiftMask,          XK_exclam,       spawn,          {.v = themecmd } },

	/* 3c. Rotation du fond d'ecran (Ctrl + ! et Super + !) */
	{ MOD_CTRL,                     XK_exclam,       spawn,          {.v = wallcmd } },
	{ MOD_SUPER,                    XK_exclam,       spawn,          {.v = wallcmd } },

	/* 4. Fermer la fenetre (Super + w comme sur l'hote Sway, et Alt + Shift + w / Alt + Shift + c) */
	{ MOD_SUPER,                    XK_w,            killclient,     {0} },
	{ MOD_ALT|ShiftMask,            XK_w,            killclient,     {0} },
	{ MOD_ALT|ShiftMask,            XK_c,            killclient,     {0} },

	/* 5. Plein ecran / Monocle toggle (Super + f / Alt + f) */
	{ MOD_SUPER,                    XK_f,            setlayout,      {.v = &layouts[2]} },
	{ MOD_ALT,                      XK_f,            setlayout,      {.v = &layouts[2]} },

	/* 6. Basculer flottant (Super + Shift + Espace / Alt + Shift + Espace) */
	{ MOD_SUPER|ShiftMask,          XK_space,        togglefloating, {0} },
	{ MOD_ALT|ShiftMask,            XK_space,        togglefloating, {0} },

	/* 7. Navigation circulaire entre bureaux virtuels (Super + Gauche/Droite, Ctrl + Super + Gauche/Droite, Alt + Gauche/Droite) */
	{ MOD_SUPER,                    XK_Left,         cycleview,      {.i = -1 } },
	{ MOD_SUPER,                    XK_Right,        cycleview,      {.i = +1 } },
	{ MOD_SUPER|ControlMask,        XK_Left,         cycleview,      {.i = -1 } },
	{ MOD_SUPER|ControlMask,        XK_Right,        cycleview,      {.i = +1 } },
	{ MOD_ALT,                      XK_Left,         cycleview,      {.i = -1 } },
	{ MOD_ALT,                      XK_Right,        cycleview,      {.i = +1 } },
	{ MOD_ALT|ControlMask,          XK_Left,         cycleview,      {.i = -1 } },
	{ MOD_ALT|ControlMask,          XK_Right,        cycleview,      {.i = +1 } },

	/* 8. Navigation fenetres : Super + Haut/Bas, Super + k/j, Alt + Haut/Bas (NOTE: Alt + k/j libere pour micro !) */
	{ MOD_SUPER,                    XK_Up,           focusstack,     {.i = -1 } },
	{ MOD_SUPER,                    XK_Down,         focusstack,     {.i = +1 } },
	{ MOD_SUPER,                    XK_k,            focusstack,     {.i = -1 } },
	{ MOD_SUPER,                    XK_j,            focusstack,     {.i = +1 } },
	{ MOD_ALT,                      XK_Up,           focusstack,     {.i = -1 } },
	{ MOD_ALT,                      XK_Down,         focusstack,     {.i = +1 } },

	/* 9. Deplacement fenetre / Redimensionnement master */
	{ MOD_SUPER|ShiftMask,          XK_Up,           zoom,           {0} },
	{ MOD_SUPER|ShiftMask,          XK_Down,         zoom,           {0} },
	{ MOD_SUPER|ShiftMask,          XK_k,            zoom,           {0} },
	{ MOD_SUPER|ShiftMask,          XK_j,            zoom,           {0} },
	{ MOD_ALT|ShiftMask,            XK_Up,           zoom,           {0} },
	{ MOD_ALT|ShiftMask,            XK_Down,         zoom,           {0} },
	{ MOD_SUPER|ShiftMask,          XK_Left,         setmfact,       {.f = -0.05} },
	{ MOD_SUPER|ShiftMask,          XK_Right,        setmfact,       {.f = +0.05} },
	{ MOD_ALT|ShiftMask,            XK_Left,         setmfact,       {.f = -0.05} },
	{ MOD_ALT|ShiftMask,            XK_Right,        setmfact,       {.f = +0.05} },

	/* 10. Bureaux virtuels 1 a 5 sur CLAVIER AZERTY FRANCAIS (&, eacute, quotedbl, apostrophe, parenleft) */
	TAGKEYS_MOD(MOD_SUPER,          XK_ampersand,                    0)
	TAGKEYS_MOD(MOD_SUPER,          XK_eacute,                       1)
	TAGKEYS_MOD(MOD_SUPER,          XK_quotedbl,                     2)
	TAGKEYS_MOD(MOD_SUPER,          XK_apostrophe,                   3)
	TAGKEYS_MOD(MOD_SUPER,          XK_parenleft,                    4)
	TAGKEYS_MOD(MOD_ALT,            XK_ampersand,                    0)
	TAGKEYS_MOD(MOD_ALT,            XK_eacute,                       1)
	TAGKEYS_MOD(MOD_ALT,            XK_quotedbl,                     2)
	TAGKEYS_MOD(MOD_ALT,            XK_apostrophe,                   3)
	TAGKEYS_MOD(MOD_ALT,            XK_parenleft,                    4)

	/* Doublons : Chiffres 1 a 5 (avec Verr Maj / Shift) */
	TAGKEYS_MOD(MOD_SUPER,          XK_1,                            0)
	TAGKEYS_MOD(MOD_SUPER,          XK_2,                            1)
	TAGKEYS_MOD(MOD_SUPER,          XK_3,                            2)
	TAGKEYS_MOD(MOD_SUPER,          XK_4,                            3)
	TAGKEYS_MOD(MOD_SUPER,          XK_5,                            4)
	TAGKEYS_MOD(MOD_ALT,            XK_1,                            0)
	TAGKEYS_MOD(MOD_ALT,            XK_2,                            1)
	TAGKEYS_MOD(MOD_ALT,            XK_3,                            2)
	TAGKEYS_MOD(MOD_ALT,            XK_4,                            3)
	TAGKEYS_MOD(MOD_ALT,            XK_5,                            4)

	/* Doublons : Pave numerique (KP_1 a KP_5) */
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_1,                         0)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_2,                         1)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_3,                         2)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_4,                         3)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_5,                         4)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_1,                         0)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_2,                         1)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_3,                         2)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_4,                         3)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_5,                         4)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_End,                       0)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_Down,                      1)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_Next,                      2)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_Left,                      3)
	TAGKEYS_MOD(MOD_SUPER,          XK_KP_Begin,                     4)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_End,                       0)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_Down,                      1)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_Next,                      2)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_Left,                      3)
	TAGKEYS_MOD(MOD_ALT,            XK_KP_Begin,                     4)

	/* 11. Quitter dwm (Super + Shift + e comme Sway, Alt + Shift + e ou Alt + Shift + q) */
	{ MOD_SUPER|ShiftMask,          XK_r,            restartdwm,     {0} },
	{ MOD_SUPER|ShiftMask,          XK_e,            quit,           {0} },
	{ MOD_ALT|ShiftMask,            XK_e,            quit,           {0} },
	{ MOD_ALT|ShiftMask,            XK_q,            quit,           {0} },

	/* 12. Masquer / afficher les deux barres (Super + b / Alt + Shift + b) */
	{ MOD_SUPER,                    XK_b,            spawn,          {.v = bartogglecmd } },
	{ MOD_ALT|ShiftMask,            XK_b,            spawn,          {.v = bartogglecmd } },
	/* Raccourci interne utilisé par toggle-bars.sh */
	{ MOD_SUPER|MOD_ALT,            XK_b,            togglebar,      {0} },
};

/* button definitions */
static const Button buttons[] = {
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
	{ ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
	{ ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
	{ ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
	{ ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },
	{ ClkClientWin,         MOD_SUPER,      Button1,        movemouse,      {0} },
	{ ClkClientWin,         MOD_SUPER,      Button2,        togglefloating, {0} },
	{ ClkClientWin,         MOD_SUPER,      Button3,        resizemouse,    {0} },
	{ ClkClientWin,         MOD_ALT,        Button1,        movemouse,      {0} },
	{ ClkClientWin,         MOD_ALT,        Button2,        togglefloating, {0} },
	{ ClkClientWin,         MOD_ALT,        Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MOD_SUPER,      Button1,        tag,            {0} },
	{ ClkTagBar,            MOD_SUPER,      Button3,        toggletag,      {0} },
	{ ClkTagBar,            MOD_ALT,        Button1,        tag,            {0} },
	{ ClkTagBar,            MOD_ALT,        Button3,        toggletag,      {0} },
};
