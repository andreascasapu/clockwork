public class TextBox extends Box implements Showable{
  
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
  
  public TextBox(Box box) {
    this(box.get_corner(), box.get_width(), box.get_height());
  }
  
  public TextBox(Box box, String new_text, color new_text_color) {
    this(box.get_corner(), box.get_width(), box.get_height(), new_text, new_text_color);
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
  
  public void show(float font_size, float leading_scalar, float horizontal_scalar, float vertical_scalar) {
    PFont font = cp_gothic;
    
    float new_width = get_width() * horizontal_scalar;
    float new_height = get_height() * vertical_scalar;
    Position new_corner = new Position(get_corner().get_x() + (get_width() - new_width) / 2f, get_corner().get_y() + (get_height() - new_height) / 2f);
    Box print_box = new Box(new_corner, new_width, new_height);
    textFont(font, font_size);
    textLeading(font_size * leading_scalar);
    fill(get_text_color());
    text(text, print_box.get_corner().get_x() + print_box.get_width() / 2f, print_box.get_corner().get_y() + print_box.get_height() / 2f);
  }
  
  public void show(float leading_scalar, float horizontal_scalar, float vertical_scalar) {
    float new_width = get_width() * horizontal_scalar;
    float new_height = get_height() * vertical_scalar;
    Position new_corner = new Position(get_corner().get_x() + (get_width() - new_width) / 2f, get_corner().get_y() + (get_height() - new_height) / 2f);
    Box print_box = new Box(new_corner, new_width, new_height);
    show(find_font_size(print_box, text, leading_scalar), leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  @Override
  public void show() {
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 1;
    float vertical_scalar = 1;
    
    show(leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  @Override
  public void cleanup() {
    
  }
}
