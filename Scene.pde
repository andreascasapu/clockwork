public class Scene {
  
  private TextBox[] text_boxes;
  private DiceTray[] dice_trays;
  private Button[] buttons;
  
  public Scene(TextBox[] new_text_boxes) {
    text_boxes = new_text_boxes;
    dice_trays = null;
    buttons = null;
  }
  
  public Scene(TextBox[][] new_text_boxes) {
    ArrayList<TextBox> boxes = new ArrayList<TextBox>();
    for (int i = 0; i < new_text_boxes.length; i++) {
      for(int j = 0; j < new_text_boxes[i].length; j++) {
        if (new_text_boxes[i][j] instanceof TextBox) {
          boxes.add(new_text_boxes[i][j]);
        }
      }
    }
    text_boxes = boxes.toArray(new TextBox[boxes.size()]);
    dice_trays = null;
    buttons = null;
  }
  
  public Scene(TextBox[] new_text_boxes, DiceTray[] new_dice_trays, Button[] new_buttons) {
    this(new_text_boxes);
    dice_trays = new_dice_trays;
    buttons = new_buttons;
  }
  
  public TextBox[] get_text_boxes() {
    return text_boxes;
  }
  
  public DiceTray[] get_dice_trays() {
    return dice_trays;
  }
  
  public Button[] get_buttons() {
    return buttons;
  }
  
  public void cleanup() {
    if (dice_trays != null) {
      for (int i = 0; i < dice_trays.length; i++) {
        dice_trays[i].cleanup();
      }
    }
    if (buttons != null) {
      for (int i = 0; i < buttons.length; i++) {
        buttons[i].cleanup();
      }
    }
    cleanup_scenes.add(this);
  }
}

private void make_encounter() {
  int type = int(random(0, 4));
  int num_trays = min(int(random(player_stats.get_stat(type) == 0 ? 0 : 1, player_stats.get_stat(type) + 1)), num_unlocked_player_trays);
  final LimitedDiceTray[] encounter_trays = new LimitedDiceTray[num_trays];
  int punish_pts = 0;
  for (int i = 0; i < 5; i++) {
    punish_pts += (i == 4 ? 1 : 2) * player_stats.get_stat(i);
  }
  punish_pts = max(num_trays, int(random(punish_pts / 6 + 1)));
  int[] tray_punishment_allocation = generate_values_array(num_trays, punish_pts, 0, 0.1);
  DiceTray[] base_trays = create_trays(new UIBox(action_box.get_corner(), action_box.get_width() / 2f, action_box.get_height(), color(0)), num_trays, max(1, int(num_trays / 3)), false, player_trays[0].get_side());
  for (int i = 0; i < num_trays; i++) {
    encounter_trays[i] = new LimitedDiceTray(base_trays[i], int(random(1, 7)), type, new Stats(generate_values_array(stat_names.length, tray_punishment_allocation[i], 0, 0.1)));
    encounter_trays[i].get_punishment().set_stat(4, encounter_trays[i].get_punishment().get_stat(4) * 2);
    encounter_trays[i].unlock();
    active_trays.add(encounter_trays[i]);
  }
  final Button encounter_button = new Button(new Position(action_box.get_corner().get_x() + action_box.get_width() * 3f / 4, action_box.get_corner().get_y() + action_box.get_height() / 2f), action_box.get_width() / 10f, action_box.get_height() / 4f, null, color(50, 200, 50), "DONE");
  final Button[] encounter_buttons = {encounter_button};
  active_buttons.add(encounter_button);
  final Scene encounter = new Scene(new TextBox[0], encounter_trays, encounter_buttons);
  active_scenes.add(encounter);
  encounter_button.set_to_run(new Runnable(){public void run(){
  for (LimitedDiceTray tray : encounter_trays) {
    if (!tray.has_dice()) {
      tray.punish_player();
    }
  }
  for (int i = 0; i < num_player_trays; i++) {
    player_trays[i].delete_dice();
  }
  encounter.cleanup();
  make_encounter();
  }});
  player_roll(type);
}
