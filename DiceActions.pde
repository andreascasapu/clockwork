private void drop_dice() {
  if(held_dice != null) {
    for (DiceTray tray : active_trays) {
      Dice old_dice = tray.get_dice();
      if (tray.is_touched() && tray.is_swappable(held_dice.get_tray())) {
        tray.swap_dice(held_dice.get_tray());
        held_dice.set_corner(held_dice.get_tray().get_corner());
        if (old_dice != null) {
            old_dice.set_corner(old_dice.get_tray().get_corner());
        }
        held_dice = null;
        return;
      }
    }
    held_dice.set_corner(held_dice.get_tray().get_corner());
    held_dice = null;
  }
}

private void grab_dice() {
  for (DiceTray tray : active_trays) {
    if (tray.is_touched() && tray.has_dice()) {
      held_dice = tray.get_dice();
      return;
    }
  }
}

private void move_dice() {
  if (held_dice != null) {
    Position mouse_pos = new Position(mouseX, mouseY);
    held_dice.set_center(mouse_pos);
  }
}
