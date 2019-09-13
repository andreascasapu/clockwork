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
  
  public int get_limit() {
    return limit;
  }
  
  public int get_type() {
    return type;
  }
  
  @Override
  protected boolean fillable_by(Dice new_dice) {
    return !is_locked() && (new_dice == null || (new_dice.get_value() >= get_limit() && new_dice.get_type() == get_type()));
  }
}
