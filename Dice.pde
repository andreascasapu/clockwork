public class Dice extends Square{
  
  private int value;
  private DiceTray tray;
  private boolean is_held;
  private int type;
  
  public Dice(DiceTray new_tray, int new_type) {
    super(new_tray.get_corner(), new_tray.get_side(), stat_cols[new_type]);
    active_dice.add(this);
    value = int(random(1, 7));
    tray = new_tray;
    type = new_type;
    is_held = false;
  }
  
  public Dice(DiceTray new_tray, int new_type, int new_value) {
    this(new_tray, new_type);
    value = new_value;
  }
  
  public boolean is_held() {
    return is_held;
  }
  
  public void set_held(boolean new_held) {
    is_held = new_held;
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
  
  public void cleanup() {
    cleanup_dice.add(this);
  }
  
  public int get_type() {
    return type;
  }
}
