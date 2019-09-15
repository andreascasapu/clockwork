public class TextBox extends Box{
  
  String text;
  color text_color;
  
  public TextBox(Position new_corner, float new_wh, float new_ht) {
    super(new_corner, new_wh, new_ht);
    text = "";
    text_color = color(0);
  }
  
  public TextBox(Position new_corner, float new_wh, float new_ht, String new_text, color new_text_color) {
    this(new_corner, new_wh, new_ht);
    text = new_text;
    text_color = new_text_color;
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
