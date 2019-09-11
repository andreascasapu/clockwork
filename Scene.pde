public class Scene {
  
  private TextBox[] text_boxes;
  
  public Scene(TextBox[] new_text_boxes) {
    text_boxes = new_text_boxes;
  }
  
  public Scene(TextBox[][] new_text_boxes) {
    ArrayList<TextBox> boxes = new ArrayList<TextBox>();
    for (int i = 0; i < new_text_boxes.length; i++) {
      for(int j = 0; j < new_text_boxes[i].length; j++) {
        if (new_text_boxes[i][j] instanceof TextBox) {
          boxes.add(new_text_boxes[i][j]);
        }
      }
    }
    text_boxes = boxes.toArray(new TextBox[boxes.size()]);
  }
  
  public TextBox[] get_text_boxes() {
    return text_boxes;
  }
}
