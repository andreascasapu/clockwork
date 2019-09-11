private void create_player_trays(int num_rows) {
  int tray_id = 0;
  int current_num = num_player_trays / num_rows;
  
  float modifier = 2f / 3;
  float tray_side = min(dice_box.get_height() * 1f / num_rows * modifier, dice_box.get_width() * 1f / (current_num + num_player_trays % current_num) * modifier);
  
  float box_height = dice_box.get_height() * 1f / num_rows;
  for (int i = 0; i < num_rows; i++) {
    if (i == num_rows - 1) {
      current_num += num_player_trays % num_rows;
    }
    float box_width = dice_box.get_width() * 1f / current_num;
    for (int j = 0; j < current_num; j++) {
      Position curr_pos = new Position(dice_box.get_x() + box_width / 2f + j * box_width - 1f / 2 * tray_side, dice_box.get_y() + box_height / 2f + i * box_height - 1f / 2 * tray_side);
      player_trays[tray_id] = new DiceTray(curr_pos, tray_side, true, color(255));
      active_trays.add(player_trays[tray_id]);
      tray_id++;
    }
  }
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
  fluff_box = new UIBox(new Position(0, 0), width * 2f / 3, height * 1f / 3, color(184, 115, 60));
  resource_box = new UIBox(new Position(width * 2f / 3, 0), width * 1f / 3, height * 1f / 3, color(190, 115, 51));
  action_box = new UIBox(new Position(0, height * 1f / 3), width, height * 1f / 3, color(184, 115, 51));
  stat_box = new UIBox(new Position(0, height * 2f / 3), width * 1f / 3, height * 1f / 3, color(190, 115, 51));
  dice_box = new UIBox(new Position(width * 1f / 3, height * 2f / 3), width * 2f / 3, height * 1f / 3, color(184, 115, 60));
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
    boxes[i][1] = new TextBox(new Position(width / 6f, height * 2f / 3 + i * height / 3f / stat_names.length), width / 6f, height / 3f / stat_names.length, Integer.toString(stat_array[i]), stat_cols[i]);
  }
  stats_scene = new Scene(boxes);
  active_scenes.add(stats_scene);
  
  boxes = new TextBox[1][2];
  boxes[0][0] = new TextBox(new Position(width * 2f / 3, height / 12f), width / 6f, height / 6f, resource_names[0], resource_cols[0]);
  boxes[0][1] = new TextBox(new Position(width * 2f / 3 + width / 6f, height / 12f), width / 6f, height / 6f, Integer.toString(health), resource_cols[0]);
  resources_scene = new Scene(boxes);
  active_scenes.add(resources_scene);
  
  boxes = new TextBox[equipment_names.length][stat_names.length + 1];
  for (int i = 0; i < equipment_names.length; i++) {
    boxes[i][0] = new TextBox(new Position(0, i * height / 3f / equipment_names.length), width * 2f / 9, height / 3f / equipment_names.length, equipment_names[i], equipment_stats[i].exists ? color(255) : color(255 * 0.25f));
    for (int j = 0; j < stat_names.length; j++) {
      boxes[i][j + 1] = new TextBox(new Position(width * 2f / 9 + j * width / 3f / stat_names.length , i * height / 3f / equipment_names.length), width / 3f * 2 / 3, height / 3f / equipment_names.length, Integer.toString(equipment_stats[i].get_stat(j)), equipment_stats[i].exists() ? stat_cols[j] : color(red(stat_cols[j]) * 0.45f, green(stat_cols[j]) * 0.45f, blue(stat_cols[j]) * 0.45f));
    }
  }
  equipment_scene = new Scene(boxes);
  active_scenes.add(equipment_scene);
}

private void unlock_trays(int num) {
  for (int i = 0; i < num; i++) {
    player_trays[i].unlock();
  }
}
