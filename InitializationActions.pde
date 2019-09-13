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

private int[] generate_stat_array(int num, float avg, int min, int max, float treshold) {
  float pts = num * avg;
  int[] array = new int[num];
  for (int i = 0; i < num; i++) {
    float best_avg = pts / (num - i);
    int mi = -100;
    int ma = -100;
    for (int j = min; j <= max; j++) {
      for (int k = j; k <= max; k++) {
        if (abs(best_avg - ((ma + mi) / 2f)) > abs(best_avg - ((k + j) / 2f))) {
          ma = k;
          mi = j;
        }
      }
    }
    int next_val;
    if (abs(avg - best_avg) / avg >= treshold) {
      next_val = int(random(mi, ma + 1));
    } else {
      next_val = int(random(min, max + 1));
    }
    
    pts -= next_val;
    array[i] = next_val;
  }
  return array;
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

private void create_scenes() {
  float desired_average = 2.75;
  int[] stat_array = generate_stat_array(4, desired_average, 1, 4, 0.07);
  int sum = 0;
  for (int i = 0; i < 4; i++) {
    sum += stat_array[i];
  }
  int health = 10 + 2 * int(4 * desired_average - sum);
  player_stats = new Stats(stat_array[0], stat_array[1], stat_array[2], stat_array[3], health);
  
  TextBox[][] boxes = new TextBox[stat_names.length][2];
  for (int i = 0; i < stat_names.length; i++) {
    boxes[i][0]= new TextBox(new Position(0, height * 2f / 3 + i * height / 3f / stat_names.length), width / 6f, height / 3f / stat_names.length, stat_names[i], stat_cols[i]);
    boxes[i][1] = new TextBox(new Position(width / 6f, height * 2f / 3 + i * height / 3f / stat_names.length), width / 6f, height / 3f / stat_names.length, Integer.toString(player_stats.get_stat(i)), stat_cols[i]);
  }
  stats_scene = new Scene(boxes);
  active_scenes.add(stats_scene);
}

private void unlock_trays(int num) {
  for (int i = 0; i < num; i++) {
    player_trays[i].unlock();
  }
}
