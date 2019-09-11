public class LimitedDiceTray extends DiceTray {
  
  private int limit;
  private int type;
  
  public LimitedDiceTray(Position new_corner, float new_side, boolean new_locked, int new_limit, int new_type) {
    super(new_corner, new_side, new_locked, color(min(255, red(stat_cols[new_type]) * 1.5), min(255, green(stat_cols[new_type]) * 1.5), min(255, blue(stat_cols[new_type]) * 1.5)));
    limit = new_limit;
    type = new_type;
  }
  
  public LimitedDiceTray(Dice new_dice, Position new_corner, float new_side, boolean new_locked, int new_limit, int new_type) {
    super(new_dice, new_corner, new_side, new_locked, color(min(255, red(stat_cols[new_type]) * 1.5), min(255, green(stat_cols[new_type]) * 1.5), min(255, blue(stat_cols[new_type]) * 1.5)));
    limit = new_limit;
    type = new_type;
  }
  
  @Override
  public boolean add_dice(Dice new_dice) {
    if (!has_dice() && !is_locked() && new_dice.get_type() == get_type() && new_dice.value >= limit) {
      dice = new_dice;
      dice.get_tray().clear_tray();
      dice.set_tray(this);
      return true;
    }
    return false;
  }
  
  @Override
  public boolean swap_dice(Dice new_dice) {
    assert(new_dice != null);
    if (!is_locked() && new_dice.get_type() == get_type() && new_dice.value >= limit) {
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
  
  @Override
  public boolean is_fillable() {
    return super.is_fillable() && held_dice.get_value() >= limit;
  }
  
  public int get_limit() {
    return limit;
  }
  
  public int get_type() {
    return type;
  }
}
