public class UIBox {
  
  private color col;
  private Position corner;
  private float wh;
  private float ht;
  private float stroke_weight;
  
  public UIBox(Position new_corner, float new_wh, float new_ht, color new_col) {
    corner = new_corner;
    wh = new_wh;
    ht = new_ht;
    col = new_col;
    stroke_weight = 4;
  }
  
  public UIBox(float new_wt, float new_ht, Position new_corner, color new_col, float new_stroke_weight) {
    this(new_corner, new_wt, new_ht, new_col);
    stroke_weight = new_stroke_weight;
  }
  
  public float get_width() {
    return wh;
  }
  
  public float get_height() {
    return ht;
  }
  
  public Position get_corner() {
    return corner;
  }
  
  public void set_corner(Position new_corner) {
    corner = new_corner;
  }
  
  public float get_x() {
    return corner.get_x();
  }
  
  public float get_y() {
    return corner.get_y();
  }
  
  public float get_stroke_weight() {
    return stroke_weight;
  }
  
  public color get_color() {
    return col;
  }
  
  public void set_width(float new_wh) {
    wh = new_wh;
  }
  
  public void set_height(float new_ht) {
    ht = new_ht;
  }
  
  public Position get_center() {
    return new Position(get_x() + get_width() / 2, get_y() + get_height() / 2);
  }
  
  public void set_center(Position new_center) {
    set_corner(new Position(new_center.get_x() - get_width() / 2, new_center.get_y() - get_height() / 2));
  }
  
  public boolean is_touched() {
    return (mouseX >= get_x() && mouseX <= get_x() + get_width()) && (mouseY >= get_y() && mouseY <= get_y() + get_height());
  }
  
  public void show(color new_col) {
    strokeWeight(get_stroke_weight());
    fill(new_col);
    rect(get_x(), get_y(), get_width(), get_height());
  }
  
  public void show() {
    show(get_color());
  }
}
