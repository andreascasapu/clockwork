import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Clockwork extends PApplet {



private PFont cp_gothic;

private final int num_player_trays = 10;
private int num_unlocked_player_trays = 3;
private DiceTray player_trays[] = new DiceTray[num_player_trays];
private int difficulty;

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

private String[] stat_names = {"BODY", "WITS", "CRAFT", "LUCK", "LIFE"};
private int stat_cols[] = {color(60, 120, 180), color(110, 50, 150), color(160, 40, 40), color(100, 170, 80), color(255)};

private UIBox info_box;
private UIBox action_box;
private UIBox stat_box;
private UIBox dice_box;

private Stats player_stats;

private Scene stats_scene;

public void setup() {
  
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
  difficulty = 2;
  make_encounter();
}

public void reset() {
  difficulty = 2;
  stats_scene.cleanup();
  create_player_stats();
  update_stats_scene();
  while (num_unlocked_player_trays > 3) {
    num_unlocked_player_trays--;
    player_trays[num_unlocked_player_trays].lock();
  }
  make_encounter();
}

public void draw() {
  List<Set<? extends Showable>> showables = new ArrayList<Set<? extends Showable>>();
  showables.add(active_ui_boxes);
  showables.add(active_scenes);
  showables.add(active_trays);
  showables.add(active_buttons);
  showables.add(active_dice);
  
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
  
  List<Set<? extends Showable>> cleanups = new ArrayList<Set<? extends Showable>>();
  cleanups.add(cleanup_ui_boxes);
  cleanups.add(cleanup_scenes);
  cleanups.add(cleanup_trays);
  cleanups.add(cleanup_buttons);
  cleanups.add(cleanup_dice);
  assert(showables.size() == cleanups.size());
  for (int i = 0; i < cleanups.size(); i++) {
    cleanup_set_from(cleanups.get(i), showables.get(i));
  }
}

public void mouseDragged() {
  move_dice();
  cancel_button_press();
}

public void mousePressed() {
  grab_dice();
  depress_button();
}

public void mouseReleased() {
  drop_dice();
  press_button();
}
public class Box {
  
  private Position corner;
  private float wh;
  private float ht;
  
  public Box(Position new_corner, float new_wh, float new_ht) {
    corner = new_corner;
    wh = new_wh;
    ht = new_ht;
  }
  
  public float get_width() {
    return wh;
  }
  
  public void set_width(float new_wh) {
    wh = new_wh;
  }
  
  public float get_height() {
    return ht;
  }
  
  public void set_height(float new_ht) {
    ht = new_ht;
  }
  
  public Position get_corner() {
    return corner;
  }
  
  public void set_corner(Position new_corner) {
    corner = new_corner;
  }
  
  public Position get_centre() {
    return new Position(corner.get_x() + get_width() / 2, corner.get_y() + get_height() / 2);
  }
  
  public void set_centre(Position new_center) {
    set_corner(new Position(new_center.get_x() - get_width() / 2, new_center.get_y() - get_height() / 2));
  }
  
  public boolean is_touched() {
    return (mouseX >= corner.get_x() && mouseX <= corner.get_x() + get_width()) && (mouseY >= corner.get_y() && mouseY <= corner.get_y() + get_height());
  }
}
public class Button extends UIBox{
  
  Runnable to_run;
  String text;
  boolean is_pressed;
  
  public Button(Position new_centre, float new_wh, float new_ht, Runnable new_to_run, int new_col) {
    super(new Position(new_centre.get_x() - new_wh / 2, new_centre.get_y() - new_ht / 2), new_wh, new_ht, new_col);
    to_run = new_to_run;
    text = "";
    is_pressed = false;
  }
  
  public Button(Position new_centre, float new_wh, float new_ht, Runnable new_to_run, int new_col, String new_text) {
    this(new_centre, new_wh, new_ht, new_to_run, new_col);
    text = new_text;
  }
  
  public String get_text() {
    return text;
  }
  
  public boolean is_pressed() {
    return is_pressed;
  }
  
  public void set_pressed(boolean new_pressed) {
    is_pressed = new_pressed;
  }
  
  public void set_to_run(Runnable new_to_run) {
    to_run = new_to_run;
  }
  
  public void press() {
    to_run.run();
  }
  
  @Override
  public void show() {
    if (is_pressed()) {
      super.show(color(red(get_color()) / 3f, green(get_color()) / 3f, blue(get_color()) / 3f));
    } else {
      super.show();
    }
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 2f / 3;
    new TextBox(this, get_text(), color(255)).show(leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  @Override
  public void cleanup() {
    cleanup_buttons.add(this);
  }
}
public class Dice extends UISquare implements Showable{
  
  private int value;
  private DiceTray tray;
  private int type;
  
  public Dice(DiceTray new_tray, int new_type) {
    super(new_tray.get_corner(), new_tray.get_side(), stat_cols[new_type]);
    active_dice.add(this);
    value = PApplet.parseInt(random(1, 7));
    tray = new_tray;
    type = new_type;
  }
  
  public Dice(DiceTray new_tray, int new_type, int new_value) {
    this(new_tray, new_type);
    value = new_value;
  }
  
  public int get_value() {
    return value;
  }
  
  public DiceTray get_tray() {
    return tray;
  }
  
  public void set_tray(DiceTray new_tray) {
    assert(new_tray != null);
    tray = new_tray;
    set_side(new_tray.get_side());
  }
  
  public float get_side() {
    return tray.get_side();
  }
  
  public int get_type() {
    return type;
  }
  
  @Override
  public void show() {
    if (this == held_dice) {
      super.show(color(red(get_color()) * 0.9f, green(get_color()) * 0.9f, blue(get_color()) * 0.9f));
    } else if (held_dice != null && get_tray().is_swappable(held_dice.get_tray()) && get_tray().is_touched()) {
      super.show(color(red(get_color()) * 0.7f, green(get_color()) * 0.7f, blue(get_color()) * 0.7f));
    } else {
      super.show();
    }
    
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 2f / 3;
    new TextBox(this, Integer.toString(get_value()), color(0)).show(leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  @Override
  public void cleanup() {
    cleanup_dice.add(this);
    get_tray().set_dice(null);
  }
}
public class DiceTray extends UISquare{
  
  protected Dice dice;
  protected boolean is_locked;
  
  public DiceTray(Position new_corner, float new_side, boolean new_locked, int new_col) {
    super(new_corner, new_side, new_col);
    dice = null;
    is_locked = new_locked;
  }
  
  public DiceTray(Dice new_dice, Position new_corner, float new_side, boolean new_locked, int new_col) {
    this(new_corner, new_side, new_locked, new_col);
    dice = new_dice;
  }
  
  public Dice get_dice() {
    return dice;
  }
  
  public void set_dice(Dice new_dice) {
    dice = new_dice;
  }
  
  public boolean has_dice() {
    return get_dice() != null;
  }
  
  public int read_dice() {
    assert(has_dice());
    return get_dice().get_value();
  }
  
  public boolean is_locked() {
    return is_locked;
  }
  
  public void clear_tray() {
    set_dice(null);
  }
  
  private void cleanup_dice() {
    if (has_dice()) {
      get_dice().cleanup();
    }
  }
  
  public void delete_dice() {
    cleanup_dice();
    clear_tray();
  }
  
  private void set_locked(boolean locked) {
    is_locked = locked;
  }
  
  public void lock(){ 
    set_locked(true);
  }
  
  public void unlock() {
    set_locked(false);
  }
  
  public void roll(int type) {
    cleanup_dice();
    set_dice(new Dice(this, type));
  }
  
  protected boolean fillable_by(Dice new_dice) {
    return !is_locked();
  }
  
  public boolean is_swappable(DiceTray other_tray) {
    return fillable_by(other_tray.get_dice()) && other_tray.fillable_by(get_dice());
  }
  
  public void swap_dice(DiceTray other_tray) {
    assert(is_swappable(other_tray));
    Dice other_dice = other_tray.get_dice();
    other_tray.set_dice(get_dice());
    if (has_dice()) {
      get_dice().set_tray(other_tray);
    }
    if (other_dice != null) {
      other_dice.set_tray(this);
    }
    set_dice(other_dice);
  }
  
  @Override
  public void show() {
    if (is_locked()) {
      super.show(color(red(get_color()) * 0.2f, green(get_color()) * 0.2f, blue(get_color()) * 0.2f));
    } else if (held_dice != null && is_swappable(held_dice.get_tray()) && is_touched()) {
      super.show(color(red(get_color()) * 0.6f, green(get_color()) * 0.6f, blue(get_color()) * 0.6f));
    } else {
      super.show();
    }
  }
  
  @Override
  public void cleanup() {
    cleanup_dice();
    cleanup_trays.add(this);
  }
}
public class Encounter extends Scene {
  
  private DiceTray[] dice_trays;
  private Stats reward;
  
  public Encounter(TextBox[] new_text_boxes, Button[] new_buttons, DiceTray[] new_dice_trays, Stats new_reward) {
    super(new_text_boxes, new_buttons);
    assert(new_dice_trays != null && new_reward != null);
    dice_trays = new_dice_trays;
    reward = new_reward;
  }
  
  public Encounter(TextBox[][] new_text_boxes, Button[] new_buttons, DiceTray[] new_dice_trays, Stats new_reward) {
    super(new_text_boxes, new_buttons);
    assert(new_dice_trays != null && new_reward != null);
    dice_trays = new_dice_trays;
    reward = new_reward;
  }
  
  public DiceTray[] get_dice_trays() {
    return dice_trays;
  }
  
  public Stats get_reward() {
    return reward;
  }
  
  @Override
  public void show() {
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 1f;
    super.show(leading_scalar, horizontal_scalar, vertical_scalar);
    StringBuilder reward_text_builder = new StringBuilder();
    for (int i = 0; i < 5; i++) {
      reward_text_builder.append(reward.get_stat(i));
      if (i != 4) {
        reward_text_builder.append(' ');
      }
    }
    new TextBox(info_box, reward_text_builder.toString(), color(0)).show(leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  @Override
  public void cleanup() {
    super.cleanup();
    for (int i = 0; i < get_dice_trays().length; i++) {
      get_dice_trays()[i].cleanup();
    }
  }
}
public class LimitedDiceTray extends DiceTray {
  
  private int limit;
  private int type;
  private Stats punishment;
  
  public LimitedDiceTray(Position new_corner, float new_side, boolean new_locked, int new_limit, int new_type, Stats new_punishment) {
    super(new_corner, new_side, new_locked, color(min(255, red(stat_cols[new_type]) * 1.5f), min(255, green(stat_cols[new_type]) * 1.5f), min(255, blue(stat_cols[new_type]) * 1.5f)));
    limit = new_limit;
    type = new_type;
    punishment = new_punishment;
  }
  
  public LimitedDiceTray(Dice new_dice, Position new_corner, float new_side, boolean new_locked, int new_limit, int new_type, Stats new_punishment) {
    super(new_dice, new_corner, new_side, new_locked, color(min(255, red(stat_cols[new_type]) * 1.5f), min(255, green(stat_cols[new_type]) * 1.5f), min(255, blue(stat_cols[new_type]) * 1.5f)));
    limit = new_limit;
    type = new_type;
    punishment = new_punishment;
  }
  
  public LimitedDiceTray(DiceTray original_tray, int new_limit, int new_type, Stats new_punishment) {
    this(original_tray.get_corner(), original_tray.get_side(), original_tray.is_locked(), new_limit, new_type, new_punishment);
    punishment = new_punishment;
  }
  
  public int get_limit() {
    return limit;
  }
  
  public int get_type() {
    return type;
  }
  
  public Stats get_punishment() {
    return punishment;
  }
  
  @Override
  protected boolean fillable_by(Dice new_dice) {
    return !is_locked() && (new_dice == null || (new_dice.get_value() >= get_limit() && new_dice.get_type() == get_type()));
  }
  
  @Override
  public void show() {
    super.show();
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 2f / 3;
    new TextBox(this, Integer.toString(get_limit()), color(255)).show(leading_scalar, horizontal_scalar, vertical_scalar);
    StringBuilder punishment_text_builder = new StringBuilder();
    for (int i = 0; i < 5; i++) {
      punishment_text_builder.append(get_punishment().get_stat(i));
      if (i != 4) {
        punishment_text_builder.append(' ');
      }
    }
    TextBox print_box = new TextBox(new Position(get_corner().get_x() - get_side() / 2f, get_corner().get_y() + get_side()), 2 * get_side(), get_side() / 2f, punishment_text_builder.toString(), color(255));
    print_box.show(leading_scalar, horizontal_scalar, vertical_scalar);
  }
}
public final class Position {
  
  private final float x, y;
  
  public Position(float new_x, float new_y) {
    x = new_x;
    y = new_y;
  }
  
  public float get_x() {
    return x;
  }
  
  public float get_y() {
    return y;
  }
}
public class Scene implements Showable{
  
  private TextBox[] text_boxes;
  private Button[] buttons;
  
  public Scene(TextBox[] new_text_boxes) {
    assert(new_text_boxes != null);
    text_boxes = new_text_boxes;
    buttons = new Button[0];
  }
  
  public Scene(TextBox[] new_text_boxes, Button[] new_buttons) {
    this(new_text_boxes);
    assert(new_buttons != null);
    buttons = new_buttons;
  }
  
  public Scene(TextBox[][] new_text_boxes) {
    assert(new_text_boxes != null);
    ArrayList<TextBox> boxes = new ArrayList<TextBox>();
    for (int i = 0; i < new_text_boxes.length; i++) {
      for(int j = 0; j < new_text_boxes[i].length; j++) {
        if (new_text_boxes[i][j] instanceof TextBox) {
          boxes.add(new_text_boxes[i][j]);
        }
      }
    }
    text_boxes = boxes.toArray(new TextBox[boxes.size()]);
    buttons = new Button[0];
  }
  
  public Scene(TextBox[][] new_text_boxes, Button[] new_buttons) {
    this(new_text_boxes);
    assert(new_buttons != null);
    buttons = new Button[0];
  }
  
  public TextBox[] get_text_boxes() {
    return text_boxes;
  }
  
  public Button[] get_buttons() {
    return buttons;
  }
  
  public void show(float leading_scalar, float horizontal_scalar, float vertical_scalar) {
    float min_size = find_minimum_font_size_in_group(get_text_boxes(), leading_scalar, horizontal_scalar, vertical_scalar);
    for (TextBox box : get_text_boxes()) {
      box.show(min_size, leading_scalar, horizontal_scalar, vertical_scalar);
    }
  }
  
  @Override
  public void show() {
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 1f;
    float min_size = find_minimum_font_size_in_group(get_text_boxes(), leading_scalar, horizontal_scalar, vertical_scalar);
    for (TextBox box : get_text_boxes()) {
      box.show(min_size, leading_scalar, horizontal_scalar, vertical_scalar);
    }
  }
  
  @Override
  public void cleanup() {
    for (int i = 0; i < get_buttons().length; i++) {
      get_buttons()[i].cleanup();
    }
    cleanup_scenes.add(this);
  }
}
public interface Showable {
  
  public void show();
  
  public void cleanup();
}
public class Stats {
  
  private int body;
  private int wits;
  private int craft;
  private int luck;
  private int life;
  
  public Stats(int[] stat_array) {
    assert(stat_array.length == 5);
    body = stat_array[0];
    wits = stat_array[1];
    craft = stat_array[2];
    luck = stat_array[3];
    life = stat_array[4];
  }
  
  public Stats(int new_body, int new_wits, int new_craft, int new_luck, int new_life) {
    this(new int[]{new_body, new_wits, new_craft, new_luck, new_life});
  }
  
  public int get_body() {
    return body;
  }
  
  public void set_body(int new_body) {
    body = new_body;
  }
  
  public int get_wits() {
    return wits;
  }
  
  public void set_wits(int new_wits) {
    body = new_wits;
  }
  
  public int get_craft() {
    return craft;
  }
  
  public void set_craft(int new_craft) {
    body = new_craft;
  }
  
  public int get_luck() {
    return luck;
  }
  
  public void set_luck(int new_luck) {
    body = new_luck;
  }
  
  public int get_life() {
    return life;
  }
  
  public void set_life(int new_life) {
    body = new_life;
  }
  
  public int get_stat(int id) {
    assert(id >= 0 && id < 5);
    switch (id) {
      case 0:
        return get_body();
      case 1:
        return get_wits();
      case 2:
        return get_craft();
      case 3:
        return get_luck();
      case 4:
        return get_life();
    }
    return -1;
  }
  
  public void set_stat(int id, int new_val) {
    assert(id >= 0 && id < 5);
    switch (id) {
      case 0:
        body = new_val;
        break;
      case 1:
        wits = new_val;
        break;
      case 2:
        craft = new_val;
        break;
      case 3:
        luck = new_val;
        break;
      case 4:
        life = new_val;
        break;
    }
  }
  
  public void apply_to_player(int sign) {
    for (int i = 0; i < 5; i++) {
      player_stats.set_stat(i, max(0, player_stats.get_stat(i) + sign * get_stat(i)));
    }
  }
}
public class TextBox extends Box implements Showable{
  
  String text;
  int text_color;
  
  public TextBox(Position new_corner, float new_wh, float new_ht) {
    super(new_corner, new_wh, new_ht);
    text = "";
    text_color = color(0);
  }
  
  public TextBox(Position new_corner, float new_wh, float new_ht, String new_text, int new_text_color) {
    this(new_corner, new_wh, new_ht);
    text = new_text;
    text_color = new_text_color;
  }
  
  public TextBox(Box box) {
    this(box.get_corner(), box.get_width(), box.get_height());
  }
  
  public TextBox(Box box, String new_text, int new_text_color) {
    this(box.get_corner(), box.get_width(), box.get_height(), new_text, new_text_color);
  }
  
  public String get_text() {
    return text;
  }
  
  public void set_text(String new_text) {
    text = new_text;
  }
  
  public int get_text_color() {
    return text_color;
  }
  
  public void show(float font_size, float leading_scalar, float horizontal_scalar, float vertical_scalar) {
    PFont font = cp_gothic;
    
    float new_width = get_width() * horizontal_scalar;
    float new_height = get_height() * vertical_scalar;
    Position new_corner = new Position(get_corner().get_x() + (get_width() - new_width) / 2f, get_corner().get_y() + (get_height() - new_height) / 2f);
    Box print_box = new Box(new_corner, new_width, new_height);
    textFont(font, font_size);
    textLeading(font_size * leading_scalar);
    fill(get_text_color());
    text(text, print_box.get_corner().get_x() + print_box.get_width() / 2f, print_box.get_corner().get_y() + print_box.get_height() / 2f);
  }
  
  public void show(float leading_scalar, float horizontal_scalar, float vertical_scalar) {
    float new_width = get_width() * horizontal_scalar;
    float new_height = get_height() * vertical_scalar;
    Position new_corner = new Position(get_corner().get_x() + (get_width() - new_width) / 2f, get_corner().get_y() + (get_height() - new_height) / 2f);
    Box print_box = new Box(new_corner, new_width, new_height);
    show(find_font_size(print_box, text, leading_scalar), leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  @Override
  public void show() {
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 1;
    float vertical_scalar = 1;
    
    show(leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  @Override
  public void cleanup() {
    
  }
}
public class UIBox extends Box implements Showable{
  
  private int col;
  private float stroke_weight;
  
  public UIBox(Position new_corner, float new_wh, float new_ht, int new_col) {
    super(new_corner, new_wh, new_ht);
    col = new_col;
    stroke_weight = 4;
  }
  
  public UIBox(float new_wt, float new_ht, Position new_corner, int new_col, float new_stroke_weight) {
    this(new_corner, new_wt, new_ht, new_col);
    stroke_weight = new_stroke_weight;
  }
  
  public float get_stroke_weight() {
    return stroke_weight;
  }
  
  public int get_color() {
    return col;
  }
  
  public void show(int new_col) {
    strokeWeight(get_stroke_weight());
    fill(new_col);
    rect(get_corner().get_x(), get_corner().get_y(), get_width(), get_height());
  }
  
  @Override
  public void show() {
    show(get_color());
  }
  
  @Override
  public void cleanup() {
    cleanup_ui_boxes.add(this);
  }
}
public class UISquare extends UIBox{
  
  public UISquare(Position new_corner, float new_side, int new_col) {
    super(new_corner, new_side, new_side, new_col);
  }
  
  @Override
  public void set_width(float new_wh) {
    return;
  }
  
  @Override
  public void set_height(float new_ht) {
    return;
  }

  public float get_side() {
    return get_width();
  }
  
  public void set_side(float new_side) {
    super.set_width(new_side);
    super.set_height(new_side);
  }
}
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
  print(difficulty, ": ", num_trays, ' ', num_rows, '\n');
  int tray_id = 0;
  int current_num = PApplet.parseInt(num_trays / num_rows);
  
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
    result[i].set_side(min(tray_side, result[i].get_side()));
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
    int next_val = PApplet.parseInt(round(f_val));
    virtual_pts += f_val - next_val;
    array[i] = next_val;
    virtual_pts -= next_val;
  }
  for (int i = 0; i < num_elems; i++) {
    int swap_pos = PApplet.parseInt(random(i, num_elems));
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
  int[] stat_array = generate_values_array(4, 12, 0, 0.2f);
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
  int type = PApplet.parseInt(random(0, 4));
  //int num_trays = min(int(random(player_stats.get_stat(type) == 0 ? 0 : 1, player_stats.get_stat(type) + 1)), num_unlocked_player_trays);
  int num_trays = round(random(difficulty * 0.25f, difficulty * 0.5f));
  final LimitedDiceTray[] encounter_trays = new LimitedDiceTray[num_trays];
  /*int punish_pts = 0;
  for (int i = 0; i < 5; i++) {
    punish_pts += (i == 4 ? 1 : 2) * player_stats.get_stat(i);
  }
  punish_pts = max(num_trays, int(random(punish_pts / 6 + 1)));*/
  if (num_trays > 0) {
    //int[] tray_punishment_allocation = generate_values_array(num_trays, punish_pts, 0, 0.1);
    int[] tray_punishment_allocation = generate_values_array(num_trays, round(difficulty * num_trays * 0.75f), 0, 0.1f);
    DiceTray[] base_trays = create_trays(new Box(action_box.get_corner(), action_box.get_width() / 2f, action_box.get_height()), num_trays, max(1, round(num_trays / 3f)), false, player_trays[0].get_side());
    for (int i = 0; i < num_trays; i++) {
      encounter_trays[i] = new LimitedDiceTray(base_trays[i], PApplet.parseInt(random(1, 7)), type, new Stats(generate_values_array(stat_names.length, tray_punishment_allocation[i], 0.1f, 0.1f)));
      encounter_trays[i].get_punishment().set_stat(4, encounter_trays[i].get_punishment().get_stat(4) * 2);
      encounter_trays[i].unlock();
      active_trays.add(encounter_trays[i]);
    }
  }
  final Button encounter_button = new Button(new Position(action_box.get_corner().get_x() + action_box.get_width() * 3f / 4, action_box.get_corner().get_y() + action_box.get_height() / 2f), action_box.get_width() / 10f, action_box.get_height() / 4f, null, color(50, 200, 50), "DONE");
  active_buttons.add(encounter_button);
  final Button[] encounter_buttons = {encounter_button};
  //final Stats encounter_reward = new Stats(generate_values_array(stat_names.length, round(punish_pts / 2f), 0, 0.1));
  final Stats encounter_reward = new Stats(generate_values_array(stat_names.length, round(difficulty * 0.6f), 0, 0.1f));
  encounter_reward.set_life(encounter_reward.get_life() * 2);
  final Encounter encounter = new Encounter(new TextBox[0], encounter_buttons, encounter_trays, encounter_reward);
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
  int stat_sum = 0;
  for (int i = 0; i < 5; i++) {
    stat_sum += player_stats.get_stat(i);
  }
  if ((difficulty + 2) / 5 > difficulty / 5 && num_unlocked_player_trays < 10) {
     player_trays[num_unlocked_player_trays].unlock();
     num_unlocked_player_trays++;
  }
  difficulty += 2;
  if (stat_sum == 0 || player_stats.get_life() == 0) {
    encounter.cleanup();
    reset();
  } else {
    encounter.get_reward().apply_to_player(1);
    encounter.cleanup();
    make_encounter();
  }
  }});
  player_roll(type);
}
  public void settings() {  size(1080, 720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Clockwork" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
