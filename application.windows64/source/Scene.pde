public class Scene implements Showable{
  
  private TextBox[] text_boxes;
  private Button[] buttons;
  
  public Scene(TextBox[] new_text_boxes) {
    assert(new_text_boxes != null);
    text_boxes = new_text_boxes;
    buttons = new Button[0];
  }
  
  public Scene(TextBox[] new_text_boxes, Button[] new_buttons) {
    this(new_text_boxes);
    assert(new_buttons != null);
    buttons = new_buttons;
  }
  
  public Scene(TextBox[][] new_text_boxes) {
    assert(new_text_boxes != null);
    ArrayList<TextBox> boxes = new ArrayList<TextBox>();
    for (int i = 0; i < new_text_boxes.length; i++) {
      for(int j = 0; j < new_text_boxes[i].length; j++) {
        if (new_text_boxes[i][j] instanceof TextBox) {
          boxes.add(new_text_boxes[i][j]);
        }
      }
    }
    text_boxes = boxes.toArray(new TextBox[boxes.size()]);
    buttons = new Button[0];
  }
  
  public Scene(TextBox[][] new_text_boxes, Button[] new_buttons) {
    this(new_text_boxes);
    assert(new_buttons != null);
    buttons = new Button[0];
  }
  
  public TextBox[] get_text_boxes() {
    return text_boxes;
  }
  
  public Button[] get_buttons() {
    return buttons;
  }
  
  public void show(float leading_scalar, float horizontal_scalar, float vertical_scalar) {
    float min_size = find_minimum_font_size_in_group(get_text_boxes(), leading_scalar, horizontal_scalar, vertical_scalar);
    for (TextBox box : get_text_boxes()) {
      box.show(min_size, leading_scalar, horizontal_scalar, vertical_scalar);
    }
  }
  
  @Override
  public void show() {
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 1f;
    float min_size = find_minimum_font_size_in_group(get_text_boxes(), leading_scalar, horizontal_scalar, vertical_scalar);
    for (TextBox box : get_text_boxes()) {
      box.show(min_size, leading_scalar, horizontal_scalar, vertical_scalar);
    }
  }
  
  @Override
  public void cleanup() {
    for (int i = 0; i < get_buttons().length; i++) {
      get_buttons()[i].cleanup();
    }
    cleanup_scenes.add(this);
  }
}
