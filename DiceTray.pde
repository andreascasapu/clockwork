public class DiceTray extends UISquare{
  
  protected Dice dice;
  protected boolean is_locked;
  
  public DiceTray(Position new_corner, float new_side, boolean new_locked, color new_col) {
    super(new_corner, new_side, new_col);
    dice = null;
    is_locked = new_locked;
  }
  
  public DiceTray(Dice new_dice, Position new_corner, float new_side, boolean new_locked, color new_col) {
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
      super.show(color(red(get_color()) * 0.2, green(get_color()) * 0.2, blue(get_color()) * 0.2));
    } else if (held_dice != null && is_swappable(held_dice.get_tray()) && is_touched()) {
      super.show(color(red(get_color()) * 0.6, green(get_color()) * 0.6, blue(get_color()) * 0.6));
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
