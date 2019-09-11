public class TextBox extends UIBox {
  
  String text;
  color text_color;
  
  public TextBox(Position new_corner, float new_wh, float new_ht) {
    super(new_corner, new_wh, new_ht, color(0));
    text = "";
    text_color = color(0);
  }
  
  public TextBox(Position new_corner, float new_wh, float new_ht, String new_text, color new_text_color) {
    this(new_corner, new_wh, new_ht);
    text = new_text;
    text_color = new_text_color;
  }
  
  public TextBox(UIBox box, float horizontal_scalar, float vertical_scalar) {
    this(new Position(box.get_x() + box.get_width() * (1f - horizontal_scalar) / 2f, box.get_y() + box.get_height() * (1f - vertical_scalar) / 2f), box.get_width() * horizontal_scalar, box.get_height() * vertical_scalar);
  }
  public TextBox(UIBox box, float horizontal_scalar, float vertical_scalar, String new_text) {
    this(box, horizontal_scalar, vertical_scalar);
    text = new_text;
  }
  
  public String get_text() {
    return text;
  }
  
  public void set_text(String new_text) {
    text = new_text;
  }
  
  public color get_text_color() {
    return text_color;
  }
}
