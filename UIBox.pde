public class UIBox extends Box implements Showable{
  
  private color col;
  private float stroke_weight;
  
  public UIBox(Position new_corner, float new_wh, float new_ht, color new_col) {
    super(new_corner, new_wh, new_ht);
    col = new_col;
    stroke_weight = 4;
  }
  
  public UIBox(float new_wt, float new_ht, Position new_corner, color new_col, float new_stroke_weight) {
    this(new_corner, new_wt, new_ht, new_col);
    stroke_weight = new_stroke_weight;
  }
  
  public float get_stroke_weight() {
    return stroke_weight;
  }
  
  public color get_color() {
    return col;
  }
  
  public void show(color new_col) {
    strokeWeight(get_stroke_weight());
    fill(new_col);
    rect(get_corner().get_x(), get_corner().get_y(), get_width(), get_height());
  }
  
  public void show() {
    show(get_color());
  }
}
