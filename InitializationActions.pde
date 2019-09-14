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
      Position curr_pos = new Position(box.get_x() + box_width / 2f + j * box_width - 1f / 2 * tray_side, box.get_y() + box_height / 2f + i * box_height - 1f / 2 * tray_side);
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
      Position curr_pos = new Position(box.get_x() + box_width / 2f + j * box_width - 1f / 2 * tray_side, box.get_y() + box_height / 2f + i * box_height - 1f / 2 * tray_side);
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
