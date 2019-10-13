public class UISquare extends UIBox{
  
  public UISquare(Position new_corner, float new_side, color new_col) {
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
