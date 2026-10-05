# Ctrl+Shift+Enter: split the active kitty window, Hyprland dwindle-style.
# The first split halves the window (50/50); each further split gives the new window the smaller
# golden-ratio share (38.2%). The splits layout picks the axis from the window's shape.
from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    tab = boss.active_tab
    if window is None or tab is None:
        return
    bias = 50 if len(tab.windows) <= 1 else 38
    boss.call_remote_control(window, ('launch', '--cwd=current', '--location=split', f'--bias={bias}'))
