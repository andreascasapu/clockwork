public class DiceTray extends Square{
  
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
    return dice != null;
  }
  
  public int read_dice() {
    assert(has_dice());
    return dice.get_value();
  }
  
  public boolean add_dice(Dice new_dice) {
    assert(new_dice != null);
    if (!is_locked() && !has_dice()) {
      dice = new_dice;
      dice.get_tray().clear_tray();
      dice.set_tray(this);
      return true;
    }
    return false;
  }
  
  public boolean swap_dice(Dice new_dice) {
    assert(new_dice != null);
    if (!is_locked()) {
      new_dice.get_tray().set_dice(dice);
      if (has_dice()) {
        dice.set_tray(new_dice.get_tray());
      }
      new_dice.set_tray(this);
      dice = new_dice;
      return true;
    }
    return false;
  }
  
  public void clear_tray() {
    dice = null;
  }
  
  public void delete_dice() {
    active_dice.remove(dice);
    clear_tray();
  }
  
  public boolean is_locked() {
    return is_locked;
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
    assert(!has_dice());
    Dice new_dice = new Dice(this, type);
    dice = new_dice;
  }
  
  public boolean is_fillable() {
    return !is_locked() && is_touched() && (held_dice != null);
  }
  
  public void cleanup() {
    if (has_dice()) {
      dice.cleanup();
    }
    cleanup_trays.add(this);
  }
}
