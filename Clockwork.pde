import java.util.*;

private PFont cp_gothic;

private final int num_player_trays = 10;
private final int num_active_player_trays = 3;
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

private String[] stat_names = {"BODY", "WITS", "CRAFT", "LUCK"};
private color stat_cols[] = {color(60, 120, 180), color(110, 50, 150), color(160, 40, 40), color(100, 170, 80)};
private String[] resource_names = {"HEALTH"};
private color resource_cols[] = {color(255)};

private String[] equipment_names = {"HEAD", "BODY", "LEGS", "TOOL"};
private Stats[] equipment_stats = {new Stats(), new Stats(), new Stats(), new Stats(), new Stats()};


private UIBox fluff_box;
private UIBox resource_box;
private UIBox action_box;
private UIBox stat_box;
private UIBox dice_box;

private Stats player_stats;

private Scene stats_scene;
private Scene resources_scene;
private Scene equipment_scene;

private Button roll_button;
private Button done_button;

void setup() {
  size(1080, 720);
  cp_gothic = loadFont("CopperplateGothic-Bold-18.vlw");
  textAlign(CENTER, CENTER);
  
  create_UI_boxes();
  
  create_scenes();
  
  final int num_rows = 2;
  create_player_trays(num_rows);
  
  unlock_trays(3);
  Position button_pos = new Position(action_box.get_x() + 9f / 10 * action_box.get_width(), action_box.get_y() + action_box.get_height() / 2f);
  roll_button = new Button(button_pos, action_box.get_width() / 10f, action_box.get_height() * 1f / 3, new Runnable(){public void run(){int id = int(random(0, 4));
                                                                                                                                        for (int i = 0; i < num_active_player_trays; i++) {
                                                                                                                                          player_trays[i].delete_dice();
                                                                                                                                        }
                                                                                                                                        for (int i = 0; i < min(num_active_player_trays, player_stats.get_stat(id)); i++) {
                                                                                                                                          player_trays[i].roll(id);
                                                                                                                                        }
                                                                                                                                       }
                                                                                                                                      }, color(200, 50, 50), "ROLL");
  active_buttons.add(roll_button);
  
  final LimitedDiceTray challenge_tray = new LimitedDiceTray(new Position(action_box.get_x() + action_box.get_width() / 10f, action_box.get_y() + action_box.get_height() / 4f), action_box.get_height() / 2f, false, 4, int(random(0, 4)));
  active_trays.add(challenge_tray);
  
  button_pos = new Position(action_box.get_x() + 7f / 10 * action_box.get_width(), action_box.get_y() + action_box.get_height() / 2f);
  done_button = new Button(button_pos, action_box.get_width() * 1f / 10, action_box.get_height() * 1f / 3, new Runnable(){public void run(){if (challenge_tray.has_dice()) {
                                                                                                                                              challenge_tray.cleanup();
                                                                                                                                              done_button.cleanup();
                                                                                                                                            }
                                                                                                                                          }
                                                                                                                                        }, color(50, 200, 50), "DONE");
  active_buttons.add(done_button);
}

void draw() {
  draw_layout();
  //draw_stats();
  draw_dice_trays();
  draw_buttons();
  draw_dice();
  draw_scenes();
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
