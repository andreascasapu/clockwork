private void depress_button() {
  for (Button button : active_buttons) {
    if (button.is_touched()) {
      button.set_pressed(true);
    }
  }
}

private void press_button() {
  for (Button button : active_buttons) {
    if (button.is_pressed()) {
      button.set_pressed(false);
      button.press();
    }
  }
}

private void cancel_button_press() {
  for (Button button : active_buttons) {
    if (button.is_pressed() && !button.is_touched()) {
      button.set_pressed(false);
    }
  }
}
