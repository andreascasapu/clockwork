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
