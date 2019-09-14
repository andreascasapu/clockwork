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

private void player_roll(int type) {
  assert(type >= 0 && type <= 3);
  int num_rolling_trays = min(player_stats.get_stat(type), num_unlocked_player_trays);
  for (int i = 0; i < num_rolling_trays; i++) {
    player_trays[i].roll(type);
    active_dice.add(player_trays[i].get_dice());
  }
}
