public class Button extends UIBox{
  
  Runnable to_run;
  String text;
  boolean is_pressed;
  
  public Button(Position new_centre, float new_wh, float new_ht, Runnable new_to_run, color new_col) {
    super(new Position(new_centre.get_x() - new_wh / 2, new_centre.get_y() - new_ht / 2), new_wh, new_ht, new_col);
    to_run = new_to_run;
    text = "";
    is_pressed = false;
  }
  
  public Button(Position new_centre, float new_wh, float new_ht, Runnable new_to_run, color new_col, String new_text) {
    this(new_centre, new_wh, new_ht, new_to_run, new_col);
    text = new_text;
  }
  
  public String get_text() {
    return text;
  }
  
  public boolean is_pressed() {
    return is_pressed;
  }
  
  public void set_pressed(boolean new_pressed) {
    is_pressed = new_pressed;
  }
  
  public void set_to_run(Runnable new_to_run) {
    to_run = new_to_run;
  }
  
  public void press() {
    to_run.run();
  }
  
  public void cleanup() {
    cleanup_buttons.add(this);
  }
  
  @Override
  public void show() {
    if (is_pressed()) {
      super.show(color(red(get_color()) / 3f, green(get_color()) / 3f, blue(get_color()) / 3f));
    } else {
      super.show();
    }
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 2f / 3;
    print_text_in_box(get_text(), cp_gothic, color(255), this, leading_scalar, horizontal_scalar, vertical_scalar);
  }
}
