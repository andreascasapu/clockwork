import java.util.*;

private PFont cp_gothic;

private final int num_player_trays = 10;
private final int num_unlocked_player_trays = 3;
private DiceTray player_trays[] = new DiceTray[num_player_trays];

private Dice held_dice = null;
private Set<Dice> active_dice = new HashSet();
private Set<Dice> cleanup_dice = new HashSet();
private Set<Button> active_buttons = new HashSet();
private Set<Button> cleanup_buttons = new HashSet();
private Set<Scene> active_scenes = new HashSet();
private Set<Scene> cleanup_scenes = new HashSet();
private Set<DiceTray> active_trays = new HashSet();
private Set<DiceTray> cleanup_trays = new HashSet();
private Set<UIBox> active_ui_boxes = new HashSet();
private Set<UIBox> cleanup_ui_boxes = new HashSet();

private String[] stat_names = {"BODY", "WITS", "CRAFT", "LUCK", "HEALTH"};
private color stat_cols[] = {color(60, 120, 180), color(110, 50, 150), color(160, 40, 40), color(100, 170, 80), color(255)};

private UIBox info_box;
private UIBox action_box;
private UIBox stat_box;
private UIBox dice_box;

private Stats player_stats;

private Scene stats_scene;

void setup() {
  size(1080, 720);
  //fullScreen();
  cp_gothic = loadFont("CopperplateGothic-Bold-18.vlw");
  textAlign(CENTER, CENTER);
  
  create_UI_boxes();
  
  create_player_stats();
  update_stats_scene();
  
  final int num_rows = 2;
  create_player_trays(num_rows);
  
  // TESTING PURPOSES
  for (int i = 0; i < 3; i++) {
    player_trays[i].unlock();
  }
  make_encounter();
}

void draw() {
  List<Set<? extends Showable>> showables = new ArrayList<Set<? extends Showable>>();
  showables.add(active_ui_boxes);
  showables.add(active_scenes);
  showables.add(active_trays);
  showables.add(active_buttons);
  showables.add(active_dice);
  /*draw_layout();
  draw_dice_trays();
  draw_buttons();
  draw_dice();
  draw_scenes();*/
  stats_scene.cleanup();
  update_stats_scene();
  for (int i = 0; i < showables.size(); i++) {
    for (Showable showable : showables.get(i)) {
      showable.show();
    }
  }
  if (held_dice != null) {
    held_dice.show();
  }
  cleanup_elements();
}

void mouseDragged() {
  move_dice();
  cancel_button_press();
}

void mousePressed() {
  grab_dice();
  depress_button();
}

void mouseReleased() {
  drop_dice();
  press_button();
}
