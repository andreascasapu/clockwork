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

// INITIALIZATON UTILITIES

private DiceTray[] create_trays(UIBox box, int num_trays, int num_rows, boolean enable) {
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

private DiceTray[] create_trays(UIBox box, int num_trays, int num_rows, boolean enable, float tray_side) {
  int tray_id = 0;
  int current_num = int(num_trays / num_rows);
  
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
  active_boxes.add(info_box);
  action_box = new UIBox(new Position(0, height * 1f / 9), width, height * 5f / 9, color(184, 115, 51));
  active_boxes.add(action_box);
  stat_box = new UIBox(new Position(0, height * 2f / 3), width * 1f / 3, height * 1f / 3, color(190, 115, 51));
  active_boxes.add(stat_box);
  dice_box = new UIBox(new Position(width * 1f / 3, height * 2f / 3), width * 2f / 3, height * 1f / 3, color(184, 115, 60));
  active_boxes.add(dice_box);
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

private void create_scenes() {
  int[] stat_array = generate_values_array(4, 12, 0, 0.2);
  int sum = 0;
  for (int i = 0; i < 4; i++) {
    sum += stat_array[i];
  }
  int health = 10 + 2 * (12 - sum);
  player_stats = new Stats(stat_array[0], stat_array[1], stat_array[2], stat_array[3], health);
  
  update_stats_scene();
}

private void unlock_trays(int num) {
  for (int i = 0; i < num; i++) {
    player_trays[i].unlock();
  }
}

// UI UTILITIES

private boolean fits_in_box(String text, float text_size, float text_leading, UIBox box) {
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

private float find_font_size(UIBox text_box, String text, float leading_scalar) {
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

private void print_text_in_box(String text, PFont font, color col, float leading_scalar, Box box, float horizontal_scalar, float vertical_scalar) {
  float new_width = box.get_width() * horizontal_scalar;
  float new_height = box.get_height() * vertical_scalar;
  Position new_corner = new Position(box.get_corner().get_x() + (box.get_width() - new_width) / 2f, box.get_corner().get_y() + (box.get_height() - new_height) / 2f);
  UIBox print_box = new UIBox(new_corner, new_width, new_height, color(0));
  float font_size = find_font_size(print_box, text, leading_scalar);
  textFont(font, font_size);
  textLeading(font_size * leading_scalar);
  fill(col);
  text(text, print_box.get_corner().get_x() + print_box.get_width() / 2f, print_box.get_corner().get_y() + print_box.get_height() / 2f);
}

private void print_text_in_box(float font_size, String text, PFont font, color col, float leading_scalar, Box box, float horizontal_scalar, float vertical_scalar) {
  float new_width = box.get_width() * horizontal_scalar;
  float new_height = box.get_height() * vertical_scalar;
  Position new_corner = new Position(box.get_corner().get_x() + (box.get_width() - new_width) / 2f, box.get_corner().get_y() + (box.get_height() - new_height) / 2f);
  UIBox print_box = new UIBox(new_corner, new_width, new_height, color(0));
  textFont(font, font_size);
  textLeading(font_size * leading_scalar);
  fill(col);
  text(text, print_box.get_corner().get_x() + print_box.get_width() / 2f, print_box.get_corner().get_y() + print_box.get_height() / 2f);
}

private void draw_layout() {
  for (UIBox box : active_boxes) {
    box.show();
  }
}

private float find_minimum_font_size_in_group(TextBox[] boxes, float leading_scalar, float horizontal_scalar, float vertical_scalar) {
  float min_size = 1000000;
  for (int i = 0; i < boxes.length; i++) {
    float new_width = boxes[i].get_width() * horizontal_scalar;
    float new_height = boxes[i].get_height() * vertical_scalar;
    Position new_corner = new Position(boxes[i].get_corner().get_x() + (boxes[i].get_width() - new_width) / 2f, (boxes[i].get_height() - new_height) / 2f);
    UIBox new_box = new UIBox(new_corner, new_width, new_height, color(0));
    float font_size = find_font_size(new_box, boxes[i].get_text(), leading_scalar);
    if (font_size < min_size) {
      min_size = font_size;
    }
  }
  return min_size;
}

private void draw_dice_trays() {
  for (DiceTray tray : active_trays) {
    color col = tray.get_color();
    if (tray.is_locked()) {
      tray.show(color(red(col) * 0.2, green(col) * 0.2, blue(col) * 0.2));
    } else if (held_dice != null && tray.is_swappable(held_dice.get_tray()) && tray.is_touched()) {
      tray.show(color(red(col) * 0.6, green(col) * 0.6, blue(col) * 0.6));
    } else {
      tray.show();
    }
    if (tray instanceof LimitedDiceTray) {
      float leading_scalar = 5f / 3;
      float horizontal_scalar = 2f / 3;
      float vertical_scalar = 2f / 3;
      print_text_in_box(Integer.toString(((LimitedDiceTray) tray).get_limit()), cp_gothic, color(255), leading_scalar, tray, horizontal_scalar, vertical_scalar);
      StringBuilder punishment_text_builder = new StringBuilder();
      for (int i = 0; i < 5; i++) {
        punishment_text_builder.append(((LimitedDiceTray) tray).get_punishment().get_stat(i));
        if (i != 4) {
          punishment_text_builder.append(' ');
        }
      }
      print_text_in_box(punishment_text_builder.toString(), cp_gothic, color(255), leading_scalar, new UIBox(new Position(tray.get_corner().get_x() - tray.get_side() / 2f, tray.get_corner().get_y() + tray.get_side()), 2 * tray.get_side(), tray.get_side() / 2f, color(255)), horizontal_scalar, vertical_scalar);
    }
  }
  
}

private void print_dice(Dice dice) {
  color col = dice.get_color();
  if (dice == held_dice) {
    dice.show(color(red(col) * 0.9, green(col) * 0.9, blue(col) * 0.9));
  } else if (held_dice != null && dice.get_tray().is_swappable(held_dice.get_tray()) && dice.get_tray().is_touched()) {
    dice.show(color(red(col) * 0.7, green(col) * 0.7, blue(col) * 0.7));
  } else {
    dice.show();
  }
  
  float leading_scalar = 5f / 3;
  float horizontal_scalar = 2f / 3;
  float vertical_scalar = 2f / 3;
  print_text_in_box(Integer.toString(dice.get_value()), cp_gothic, color(0), leading_scalar, dice, horizontal_scalar, vertical_scalar);
}

private void draw_dice() {
  textFont(cp_gothic);
  
  for (Dice dice : active_dice) {
    print_dice(dice);
  }
  
  if (held_dice != null) {
    print_dice(held_dice);
  }
}

private void draw_buttons() {
  textFont(cp_gothic);
  for (Button button : active_buttons) {
    if (button.is_pressed()) {
      color col = button.get_color();
      button.show(color(red(col) * 1f / 3, green(col) * 1f / 3, blue(col) * 1f / 3));
    } else {
      button.show();
    }
    
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 2f / 3;
    print_text_in_box(button.get_text(), cp_gothic, color(255), leading_scalar, button, horizontal_scalar, vertical_scalar);
  }
}

private void draw_scenes() {
  float leading_scalar = 5f / 3;
  float horizontal_scalar = 2f / 3;
  float vertical_scalar = 1f;
  stats_scene.cleanup();
  update_stats_scene();
  for (Scene scene : active_scenes) {
    TextBox[] boxes = scene.get_text_boxes();
    float min_size = find_minimum_font_size_in_group(boxes, leading_scalar, horizontal_scalar, vertical_scalar);
    for (TextBox box : boxes) {
      print_text_in_box(min_size, box.get_text(), cp_gothic, box.get_text_color(), leading_scalar, box, horizontal_scalar, vertical_scalar);
    }
  }
}

private void cleanup_set_from(Set<?> to_remove, Set<?> from) {
  for (Object obj : to_remove) {
    from.remove(obj);
  }
  to_remove.clear();
}

private void cleanup_elements() {
  cleanup_set_from(cleanup_dice, active_dice);
  cleanup_set_from(cleanup_buttons, active_buttons);
  cleanup_set_from(cleanup_scenes, active_scenes);
  cleanup_set_from(cleanup_trays, active_trays);
  cleanup_set_from(cleanup_boxes, active_boxes);
}
