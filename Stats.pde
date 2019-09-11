public class Stats {
  
  private int body;
  private int wits;
  private int craft;
  private int luck;
  private int life;
  private boolean exists;
  
  public Stats() {
    body = 0;
    wits = 0;
    craft = 0;
    luck = 0;
    life = 0;
    exists = false;
  }
  
  public Stats(int new_body, int new_wits, int new_craft, int new_luck, int new_life) {
    body = new_body;
    wits = new_wits;
    craft = new_craft;
    luck = new_luck;
    life = new_life;
    exists = true;
  }
  
  public int get_body() {
    return body;
  }
  
  public int get_wits() {
    return wits;
  }
  
  
  public int get_craft() {
    return craft;
  }
  
  public int get_luck() {
    return luck;
  }
  
  public int get_life() {
    return life;
  }
  
  public int get_stat(int id) {
    assert(id >= 0 && id < 5);
    switch (id) {
      case 0:
        return get_body();
      case 1:
        return get_wits();
      case 2:
        return get_craft();
      case 3:
        return get_luck();
      case 4:
        return get_life();
    }
    return -1;
  }
  
  public boolean exists() {
    return exists;
  }
}
