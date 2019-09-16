// DICE UTILITIES

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
    held_dice.set_centre(mouse_pos);
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

// INITIALIZATON UTILITIES

private DiceTray[] create_trays(Box box, int num_trays, int num_rows, boolean enable) {
  assert(num_trays >= num_rows);
  int tray_id = 0;
  int current_num = int(num_trays / num_rows);
  
  float modifier = 2f / 3;
  float tray_side = min(box.get_height() * 1f / num_rows * modifier, box.get_width() * 1f / (current_num + num_trays % current_num) * modifier);
  DiceTray[] result = new DiceTray[num_trays];
  float box_height = box.get_height() * 1f / num_rows;
  for (int i = 0; i < num_rows; i++) {
    if (i == num_rows - 1) {
      current_num += num_trays % num_rows;
    }
    float box_width = box.get_width() * 1f / current_num;
    for (int j = 0; j < current_num; j++) {
      Position curr_pos = new Position(box.get_corner().get_x() + box_width / 2f + j * box_width - 1f / 2 * tray_side, box.get_corner().get_y() + box_height / 2f + i * box_height - 1f / 2 * tray_side);
      result[tray_id] = new DiceTray(curr_pos, tray_side, true, color(255));
      if (enable) {
        active_trays.add(result[tray_id]);
      }
      tray_id++;
    }
  }
  return result;
}

private DiceTray[] create_trays(Box box, int num_trays, int num_rows, boolean enable, float tray_side) {
  DiceTray[] result = create_trays(box, num_trays, num_rows, enable);
  for (int i = 0; i < result.length; i++) {
    Position centre = result[i].get_centre();
    result[i].set_side(tray_side);
    result[i].set_centre(centre);
  }
  return result;
}

private void create_player_trays(int num_rows) {
  player_trays = create_trays(dice_box, num_player_trays, num_rows, true);
}

private int[] generate_values_array(int num_elems, int pts, float pts_deviation, float allowed_deviation) {
  assert(pts_deviation >= 0 && pts_deviation <= 1);
  int[] array = new int[num_elems];
  int[] order = new int[num_elems];
  float virtual_pts = random(1 - pts_deviation, 1 + pts_deviation) * pts;
  for (int i = 0; i < num_elems; i++) {
    order[i] = i;
    float avg = 1f * virtual_pts / (num_elems - i);
    float min = max(0, (1 - allowed_deviation) * avg);
    float max = (1 + allowed_deviation) * avg;
    float f_val = random(min, max);
    int next_val = int(round(f_val));
    virtual_pts += f_val - next_val;
    array[i] = next_val;
    virtual_pts -= next_val;
  }
  for (int i = 0; i < num_elems; i++) {
    int swap_pos = int(random(i, num_elems));
    int temp = order[i];
    order[i] = order[swap_pos];
    order[swap_pos] = temp;
  }
  for (int i = 0; i < num_elems; i++) {
    order[i] = array[order[i]];
  }
  return order;
}

private void create_UI_boxes() {
  info_box = new UIBox(new Position(0, 0), width, height * 1f / 9, color(184, 124, 51));
  active_ui_boxes.add(info_box);
  action_box = new UIBox(new Position(0, height * 1f / 9), width, height * 5f / 9, color(184, 115, 51));
  active_ui_boxes.add(action_box);
  stat_box = new UIBox(new Position(0, height * 2f / 3), width * 1f / 3, height * 1f / 3, color(190, 115, 51));
  active_ui_boxes.add(stat_box);
  dice_box = new UIBox(new Position(width * 1f / 3, height * 2f / 3), width * 2f / 3, height * 1f / 3, color(184, 115, 60));
  active_ui_boxes.add(dice_box);
}

private void update_stats_scene() {
  TextBox[][] boxes = new TextBox[stat_names.length][2];
  for (int i = 0; i < stat_names.length; i++) {
    boxes[i][0]= new TextBox(new Position(0, height * 2f / 3 + i * height / 3f / stat_names.length), width / 6f, height / 3f / stat_names.length, stat_names[i], stat_cols[i]);
    boxes[i][1] = new TextBox(new Position(width / 6f, height * 2f / 3 + i * height / 3f / stat_names.length), width / 6f, height / 3f / stat_names.length, Integer.toString(player_stats.get_stat(i)), stat_cols[i]);
  }
  stats_scene = new Scene(boxes);
  active_scenes.add(stats_scene);
}

private void create_player_stats() {
  int[] stat_array = generate_values_array(4, 12, 0, 0.2);
  int sum = 0;
  for (int i = 0; i < 4; i++) {
    sum += stat_array[i];
  }
  int health = 10 + 2 * (12 - sum);
  player_stats = new Stats(stat_array[0], stat_array[1], stat_array[2], stat_array[3], health);
}

// UI UTILITIES

private boolean fits_in_box(String text, float text_size, float text_leading, Box box) {
  textSize(text_size);
  int lines = 1;
  for (int i = 0; i < text.length(); i++) {
    if (text.charAt(i) == '\n') {
      while (i < text.length() && Character.isWhitespace(text.charAt(i))) {
        i++;
      }
      i--;
      if (i != text.length() - 1) {
        lines++;
      }
    }
  }
  return (textWidth(text) <= box.get_width()) && (lines * text_size + (lines - 1) * max(0, text_leading - 2f / 3 * text_size) <= box.get_height());
}

private float find_font_size(Box text_box, String text, float leading_scalar) {
  int index = 1 << 20;
  float modifier = 1f / 10000;
  float font_size = 0;
  while (index > 0) {
    if (fits_in_box(text, font_size + index * modifier, (font_size + index * modifier) * leading_scalar, text_box)) {
      font_size += index * modifier;
    }
    index >>= 1;
  }
  return font_size;
}

private float find_minimum_font_size_in_group(TextBox[] boxes, float leading_scalar, float horizontal_scalar, float vertical_scalar) {
  float min_size = 1000000;
  for (int i = 0; i < boxes.length; i++) {
    float new_width = boxes[i].get_width() * horizontal_scalar;
    float new_height = boxes[i].get_height() * vertical_scalar;
    Position new_corner = new Position(boxes[i].get_corner().get_x() + (boxes[i].get_width() - new_width) / 2f, (boxes[i].get_height() - new_height) / 2f);
    Box new_box = new Box(new_corner, new_width, new_height);
    float font_size = find_font_size(new_box, boxes[i].get_text(), leading_scalar);
    if (font_size < min_size) {
      min_size = font_size;
    }
  }
  return min_size;
}

private void cleanup_set_from(Set<?> to_remove, Set<?> from) {
  for (Object obj : to_remove) {
    from.remove(obj);
  }
  to_remove.clear();
}
/*
private void cleanup_elements() {
  cleanup_set_from(cleanup_dice, active_dice);
  cleanup_set_from(cleanup_buttons, active_buttons);
  cleanup_set_from(cleanup_scenes, active_scenes);
  cleanup_set_from(cleanup_trays, active_trays);
  cleanup_set_from(cleanup_ui_boxes, active_ui_boxes);
}
*/
// BUTTON UTILITIES

private void depress_button() {
  for (Button button : active_buttons) {
    if (button.is_touched()) {
      button.set_pressed(true);
    }
  }
}

private void press_button() {
  for (Button button : active_buttons) {
    if (button.is_pressed()) {
      button.set_pressed(false);
      button.press();
    }
  }
}

private void cancel_button_press() {
  for (Button button : active_buttons) {
    if (button.is_pressed() && !button.is_touched()) {
      button.set_pressed(false);
    }
  }
}

// SCENE UTILITIES

private void make_encounter() {
  int type = int(random(0, 4));
  int num_trays = min(int(random(player_stats.get_stat(type) == 0 ? 0 : 1, player_stats.get_stat(type) + 1)), num_unlocked_player_trays);
  final LimitedDiceTray[] encounter_trays = new LimitedDiceTray[num_trays];
  int punish_pts = 0;
  for (int i = 0; i < 5; i++) {
    punish_pts += (i == 4 ? 1 : 2) * player_stats.get_stat(i);
  }
  punish_pts = max(num_trays, int(random(punish_pts / 6 + 1)));
  if (num_trays > 0) {
    int[] tray_punishment_allocation = generate_values_array(num_trays, punish_pts, 0, 0.1);
    DiceTray[] base_trays = create_trays(new Box(action_box.get_corner(), action_box.get_width() / 2f, action_box.get_height()), num_trays, max(1, int(num_trays / 3)), false, player_trays[0].get_side());
    for (int i = 0; i < num_trays; i++) {
      encounter_trays[i] = new LimitedDiceTray(base_trays[i], int(random(1, 7)), type, new Stats(generate_values_array(stat_names.length, tray_punishment_allocation[i], 0, 0.1)));
      encounter_trays[i].get_punishment().set_stat(4, encounter_trays[i].get_punishment().get_stat(4) * 2);
      encounter_trays[i].unlock();
      active_trays.add(encounter_trays[i]);
    }
  }
  final Button encounter_button = new Button(new Position(action_box.get_corner().get_x() + action_box.get_width() * 3f / 4, action_box.get_corner().get_y() + action_box.get_height() / 2f), action_box.get_width() / 10f, action_box.get_height() / 4f, null, color(50, 200, 50), "DONE");
  active_buttons.add(encounter_button);
  final Button[] encounter_buttons = {encounter_button};
  final Encounter encounter = new Encounter(new TextBox[0], encounter_buttons, encounter_trays, new Stats(generate_values_array(stat_names.length, punish_pts, 0, 0.1)));
  active_scenes.add(encounter);
  encounter_button.set_to_run(new Runnable(){public void run(){
  for (LimitedDiceTray tray : encounter_trays) {
    if (!tray.has_dice()) {
      tray.get_punishment().apply_to_player(-1);
    }
  }
  for (int i = 0; i < num_player_trays; i++) {
    player_trays[i].delete_dice();
  }
  encounter.get_reward().apply_to_player(1);
  encounter.cleanup();
  make_encounter();
  }});
  player_roll(type);
}
