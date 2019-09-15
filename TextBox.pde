public class TextBox extends Box {
  
  String text;
  color text_color;
  float leading_scalar;
  float horizontal_scalar;
  float vertical_scalar;
  
  public TextBox(Position new_corner, float new_wh, float new_ht) {
    super(new_corner, new_wh, new_ht);
    text = "";
    text_color = color(0);
    leading_scalar = 1;
    horizontal_scalar = 1;
    vertical_scalar = 1;
  }
  
  public TextBox(Position new_corner, float new_wh, float new_ht, String new_text, color new_text_color) {
    this(new_corner, new_wh, new_ht);
    text = new_text;
    text_color = new_text_color;
  }
  
  public TextBox(Position new_corner, float new_wh, float new_ht, String new_text, color new_text_color, float new_leading_scalar, float new_horizontal_scalar, float new_vetical_scalar) {
    this(new_corner, new_wh, new_ht, new_text, new_text_color);
    leading_scalar = new_leading_scalar;
    horizontal_scalar = new_horizontal_scalar;
    vertical_scalar = new_vetical_scalar;
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
  
  public void show(color new_text_color, float new_leading_scalar, float new_horizontal_scalar, float new_vertical_scalar) {
    print_text_in_box(text, cp_gothic, new_text_color, new_leading_scalar, this, new_horizontal_scalar, new_vertical_scalar);
  }
  
  public void show(color new_text_color) {
    show(new_text_color, leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  public void show() {
    show(text_color);
  }
}
