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
    @staticmethod
    def use(context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            if context.empty or context.error:
                fg = 11  # Nord11
            if context.border:
                fg = 6  # Nord6
            if context.image:
                fg = 7  # Nord7
            if context.video:
                fg = 11  # Nord11
            if context.audio:
                fg = 15  # Nord15
            if context.document:
                fg = 9  # Nord9
            if context.container:
                fg = 13  # Nord13
            if context.directory:
                fg = 9  # Nord9
            if context.executable and not any((context.media, context.container, context.fifo, context.socket)):
                fg = 14  # Nord14
                attr |= bold
            if context.socket:
                fg = 15  # Nord15
                attr |= bold
            if context.fifo or context.device:
                fg = 13  # Nord13
                if context.device:
                    attr |= bold
            if context.link:
                fg = 7 if context.good else 11  # Nord7 for good, Nord11 for bad
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (11, 9):
                    fg = 11  # Nord11
                else:
                    fg = 11  # Nord11
            if not context.selected and (context.cut or context.copied):
                fg = 6  # Nord6
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 13  # Nord13
            if context.badinfo:
                if attr & reverse:
                    bg = 11  # Nord11
                else:
                    fg = 11  # Nord11

        elif context.in_titlebar:
            if context.hostname:
                fg = 11 if context.bad else 14  # Nord11 or Nord14
            elif context.directory:
                fg = 9  # Nord9
            elif context.tab:
                if context.good:
                    attr |= reverse
            elif context.link:
                fg = 7  # Nord7

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 14  # Nord14
                elif context.bad:
                    fg = 11  # Nord11
            if context.marked:
                attr |= bold | reverse
                fg = 13  # Nord13
            if context.frozen:
                attr |= bold
                fg = 7  # Nord7
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 11  # Nord11
            if context.loaded:
                bg = 14  # Nord14
            if context.vcsinfo:
                fg = 9  # Nord9
                attr &= ~bold
            if context.vcscommit:
                fg = 13  # Nord13
                attr &= ~bold
            if context.vcsdate:
                fg = 7  # Nord7
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
                fg = 11  # Nord11
            elif context.vcschanged:
                fg = 11  # Nord11
            elif context.vcsunknown:
                fg = 11  # Nord11
            elif context.vcsstaged:
                fg = 14  # Nord14
            elif context.vcssync:
                fg = 14  # Nord14
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = 14  # Nord14
            elif context.vcsbehind:
                fg = 11  # Nord11
            elif context.vcsahead:
                fg = 9  # Nord9
            elif context.vcsdiverged:
                fg = 15  # Nord15
            elif context.vcsunknown:
                fg = 11  # Nord11

        return fg, bg, attr
