public class Dice extends UISquare implements Showable{
  
  private int value;
  private DiceTray tray;
  private int type;
  
  public Dice(DiceTray new_tray, int new_type) {
    super(new_tray.get_corner(), new_tray.get_side(), stat_cols[new_type]);
    active_dice.add(this);
    value = int(random(1, 7));
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
      super.show(color(red(get_color()) * 0.9, green(get_color()) * 0.9, blue(get_color()) * 0.9));
    } else if (held_dice != null && get_tray().is_swappable(held_dice.get_tray()) && get_tray().is_touched()) {
      super.show(color(red(get_color()) * 0.7, green(get_color()) * 0.7, blue(get_color()) * 0.7));
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
