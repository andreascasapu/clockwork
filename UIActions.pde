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

private void print_text_in_box(String text, PFont font, color col, float leading_scalar, UIBox box, float horizontal_scalar, float vertical_scalar) {
  float new_width = box.get_width() * horizontal_scalar;
  float new_height = box.get_height() * vertical_scalar;
  Position new_corner = new Position(box.get_x() + (box.get_width() - new_width) / 2f, box.get_y() + (box.get_height() - new_height) / 2f);
  UIBox print_box = new UIBox(new_corner, new_width, new_height, color(0));
  float font_size = find_font_size(print_box, text, leading_scalar);
  textFont(font, font_size);
  textLeading(font_size * leading_scalar);
  fill(col);
  text(text, print_box.get_x() + print_box.get_width() / 2f, print_box.get_y() + print_box.get_height() / 2f);
}

private void print_text_in_box(float font_size, String text, PFont font, color col, float leading_scalar, UIBox box, float horizontal_scalar, float vertical_scalar) {
  float new_width = box.get_width() * horizontal_scalar;
  float new_height = box.get_height() * vertical_scalar;
  Position new_corner = new Position(box.get_x() + (box.get_width() - new_width) / 2f, box.get_y() + (box.get_height() - new_height) / 2f);
  UIBox print_box = new UIBox(new_corner, new_width, new_height, color(0));
  textFont(font, font_size);
  textLeading(font_size * leading_scalar);
  fill(col);
  text(text, print_box.get_x() + print_box.get_width() / 2f, print_box.get_y() + print_box.get_height() / 2f);
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
    Position new_corner = new Position(boxes[i].get_x() + (boxes[i].get_width() - new_width) / 2f, (boxes[i].get_height() - new_height) / 2f);
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
      print_text_in_box(punishment_text_builder.toString(), cp_gothic, color(255), leading_scalar, new UIBox(new Position(tray.get_x() - tray.get_side() / 2f, tray.get_y() + tray.get_side()), 2 * tray.get_side(), tray.get_side() / 2f, color(255)), horizontal_scalar, vertical_scalar);
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
