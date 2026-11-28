/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 1;                    /* -c option; centers dmenu on screen */
static int fuzzy = 1;                       /* -F  option; if 0, dmenu doesn't use fuzzy matching */
static unsigned int border_width = 0;       /* frame is drawn inside the window */

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"Maple Mono NF:size=11",
	"monospace:size=11"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm]   = { "#cdd6f4", "#1e1e2e" },
	[SchemeSel]    = { "#89b4fa", "#45475a" },
	[SchemeOut]    = { "#000000", "#45475a" },
	[SchemePrompt] = { "#89b4fa", "#1e1e2e" },
	[SchemeFrame]  = { "#080800", "#080800" },
	[SchemeBorder] = { "#89b4fa", "#89b4fa" },
};
/* -l option; 0 = 40vh auto height, else explicit vertical list height */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
