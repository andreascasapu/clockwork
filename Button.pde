public class Button extends UIBox{
  
  Runnable to_run;
  String text;
  boolean is_pressed;
  
  public Button(Position new_corner, float new_wh, float new_ht, Runnable new_to_run, color new_col) {
    super(new Position(new_corner.get_x() - new_wh / 2, new_corner.get_y() - new_ht / 2), new_wh, new_ht, new_col);
    to_run = new_to_run;
    text = "";
    is_pressed = false;
  }
  
  public Button(Position new_pos, float new_wh, float new_ht, Runnable new_to_run, color new_col, String new_text) {
    this(new_pos, new_wh, new_ht, new_to_run, new_col);
    text = new_text;
  }
  
  public String get_text() {
    return text;
  }
  
  public void press() {
    to_run.run();
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
  
  public void cleanup() {
    cleanup_buttons.add(this);
  }
}
