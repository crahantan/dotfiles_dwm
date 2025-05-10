from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, reverse, bold, normal, default

# GitHub Dark Default colors
# Primary dark: #0d1117
# Primary light: #c9d1d9
# Black: #484f58 / #6e7681
# Red: #ff7b72 / #ffa198
# Green: #3fb950 / #56d364
# Yellow: #d29922 / #e3b341
# Blue: #58a6ff / #79c0ff
# Magenta: #bc8cff / #d2a8ff
# Cyan: #39c5cf / #56d4dd
# White: #b1bac4 / #f0f6fc

class GithubDark(ColorScheme):
    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            if context.empty or context.error:
                fg = 1  # red
            if context.border:
                fg = 7  # white
            if context.image:
                fg = 6  # cyan
            if context.video:
                fg = 1  # red
            if context.audio:
                fg = 5  # magenta
            if context.document:
                fg = 4  # blue
            if context.container:
                fg = 3  # yellow
            if context.directory:
                fg = 4  # blue
            if context.executable and not any((context.media, context.container, context.fifo, context.socket)):
                fg = 2  # green
                attr |= bold
            if context.socket:
                fg = 5  # magenta
                attr |= bold
            if context.fifo or context.device:
                fg = 3  # yellow
                if context.device:
                    attr |= bold
            if context.link:
                fg = 6 if context.good else 1  # cyan for good, red for bad
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (1, 4):
                    fg = 1  # red
                else:
                    fg = 1  # red
            if not context.selected and (context.cut or context.copied):
                fg = 7  # white
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 3  # yellow
            if context.badinfo:
                if attr & reverse:
                    bg = 1  # red
                else:
                    fg = 1  # red

        elif context.in_titlebar:
            if context.hostname:
                fg = 1 if context.bad else 2  # red or green
            elif context.directory:
                fg = 4  # blue
            elif context.tab:
                if context.good:
                    attr |= reverse
            elif context.link:
                fg = 6  # cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 2  # green
                elif context.bad:
                    fg = 1  # red
            if context.marked:
                attr |= bold | reverse
                fg = 3  # yellow
            if context.frozen:
                attr |= bold
                fg = 6  # cyan
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 1  # red
            if context.loaded:
                bg = 2  # green
            if context.vcsinfo:
                fg = 4  # blue
                attr &= ~bold
            if context.vcscommit:
                fg = 3  # yellow
                attr &= ~bold
            if context.vcsdate:
                fg = 6  # cyan
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 4  # blue
            if context.selected:
                attr |= reverse
            if context.loaded:
                if context.selected:
                    fg = 2  # green
                else:
                    bg = 2  # green

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 1  # red
            elif context.vcschanged:
                fg = 1  # red
            elif context.vcsunknown:
                fg = 1  # red
            elif context.vcsstaged:
                fg = 2  # green
            elif context.vcssync:
                fg = 2  # green
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = 2  # green
            elif context.vcsbehind:
                fg = 1  # red
            elif context.vcsahead:
                fg = 4  # blue
            elif context.vcsdiverged:
                fg = 5  # magenta
            elif context.vcsunknown:
                fg = 1  # red

        return fg, bg, attr
