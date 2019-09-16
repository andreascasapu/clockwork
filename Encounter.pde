public class Encounter extends Scene {
  
  private DiceTray[] dice_trays;
  private Stats reward;
  
  public Encounter(TextBox[] new_text_boxes, Button[] new_buttons, DiceTray[] new_dice_trays, Stats new_reward) {
    super(new_text_boxes, new_buttons); //<>//
    assert(new_dice_trays != null && new_reward != null);
    dice_trays = new_dice_trays;
    reward = new_reward;
  }
  
  public Encounter(TextBox[][] new_text_boxes, Button[] new_buttons, DiceTray[] new_dice_trays, Stats new_reward) {
    super(new_text_boxes, new_buttons);
    assert(new_dice_trays != null && new_reward != null);
    dice_trays = new_dice_trays;
    reward = new_reward;
  }
  
  public DiceTray[] get_dice_trays() {
    return dice_trays;
  }
  
  public Stats get_reward() {
    return reward;
  }
  
  @Override
  public void show() {
    float leading_scalar = 5f / 3;
    float horizontal_scalar = 2f / 3;
    float vertical_scalar = 1f;
    super.show(leading_scalar, horizontal_scalar, vertical_scalar);
    StringBuilder reward_text_builder = new StringBuilder();
    for (int i = 0; i < 5; i++) {
      reward_text_builder.append(reward.get_stat(i));
      if (i != 4) {
        reward_text_builder.append(' ');
      }
    }
    new TextBox(info_box, reward_text_builder.toString(), color(0)).show(leading_scalar, horizontal_scalar, vertical_scalar);
  }
  
  @Override
  public void cleanup() {
    super.cleanup();
    for (int i = 0; i < get_dice_trays().length; i++) {
      get_dice_trays()[i].cleanup();
    }
  }
}
