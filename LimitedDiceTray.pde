public class LimitedDiceTray extends DiceTray {
  
  private int limit;
  private int type;
  private Stats punishment;
  
  public LimitedDiceTray(Position new_corner, float new_side, boolean new_locked, int new_limit, int new_type, Stats new_punishment) {
    super(new_corner, new_side, new_locked, color(min(255, red(stat_cols[new_type]) * 1.5), min(255, green(stat_cols[new_type]) * 1.5), min(255, blue(stat_cols[new_type]) * 1.5)));
    limit = new_limit;
    type = new_type;
    punishment = new_punishment;
  }
  
  public LimitedDiceTray(Dice new_dice, Position new_corner, float new_side, boolean new_locked, int new_limit, int new_type, Stats new_punishment) {
    super(new_dice, new_corner, new_side, new_locked, color(min(255, red(stat_cols[new_type]) * 1.5), min(255, green(stat_cols[new_type]) * 1.5), min(255, blue(stat_cols[new_type]) * 1.5)));
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
  
  public void punish_player() {
    for (int i = 0; i < 5; i++) {
      player_stats.set_stat(i, player_stats.get_stat(i) - punishment.get_stat(i));
    }
  }
  
  @Override
  protected boolean fillable_by(Dice new_dice) {
    return !is_locked() && (new_dice == null || (new_dice.get_value() >= get_limit() && new_dice.get_type() == get_type()));
  }
}
