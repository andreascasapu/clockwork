public class Box {
  
  private Position corner;
  private float wh;
  private float ht;
  
  public Box(Position new_corner, float new_wh, float new_ht) {
    corner = new_corner;
    wh = new_wh;
    ht = new_ht;
  }
  
  public float get_width() {
    return wh;
  }
  
  public void set_width(float new_wh) {
    wh = new_wh;
  }
  
  public float get_height() {
    return ht;
  }
  
  public void set_height(float new_ht) {
    ht = new_ht;
  }
  
  public Position get_corner() {
    return corner;
  }
  
  public void set_corner(Position new_corner) {
    corner = new_corner;
  }
  
  public Position get_centre() {
    return new Position(corner.get_x() + get_width() / 2, corner.get_y() + get_height() / 2);
  }
  
  public void set_centre(Position new_center) {
    set_corner(new Position(new_center.get_x() - get_width() / 2, new_center.get_y() - get_height() / 2));
  }
  
  public boolean is_touched() {
    return (mouseX >= corner.get_x() && mouseX <= corner.get_x() + get_width()) && (mouseY >= corner.get_y() && mouseY <= corner.get_y() + get_height());
  }
}
