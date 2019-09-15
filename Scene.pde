public class Scene implements Showable{
  
  private TextBox[] text_boxes;
  private DiceTray[] dice_trays;
  private Button[] buttons;
  Stats reward;
  
  public Scene(TextBox[] new_text_boxes) {
    text_boxes = new_text_boxes;
    dice_trays = null;
    buttons = null;
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
    dice_trays = null;
    buttons = null;
  }
  
  public Scene(TextBox[] new_text_boxes, DiceTray[] new_dice_trays, Button[] new_buttons, Stats new_reward) {
    this(new_text_boxes);
    dice_trays = new_dice_trays;
    buttons = new_buttons;
    reward = new_reward;
  }
  
  public TextBox[] get_text_boxes() {
    return text_boxes;
  }
  
  public DiceTray[] get_dice_trays() {
    return dice_trays;
  }
  
  public Button[] get_buttons() {
    return buttons;
  }
  
  public Stats get_reward() {
    return reward;
  }
  
  public void cleanup() {
    if (get_dice_trays() != null) {
      for (int i = 0; i < get_dice_trays().length; i++) {
        get_dice_trays()[i].cleanup();
      }
    }
    if (get_buttons() != null) {
      for (int i = 0; i < get_buttons().length; i++) {
        get_buttons()[i].cleanup();
      }
    }
    cleanup_scenes.add(this);
  }
  
  public void show() {
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 1f;
    float min_size = find_minimum_font_size_in_group(get_text_boxes(), leading_scalar, horizontal_scalar, vertical_scalar);
    for (TextBox box : get_text_boxes()) {
      print_text_in_box(min_size, box.get_text(), cp_gothic, box.get_text_color(), box, leading_scalar, horizontal_scalar, vertical_scalar);
    }
    if (reward != null) {
      StringBuilder reward_text_builder = new StringBuilder();
      for (int i = 0; i < 5; i++) {
        reward_text_builder.append(reward.get_stat(i));
        if (i != 4) {
          reward_text_builder.append(' ');
        }
      }
      print_text_in_box(reward_text_builder.toString(), cp_gothic, color(0), info_box, leading_scalar, horizontal_scalar, vertical_scalar);
    }
  }
}
