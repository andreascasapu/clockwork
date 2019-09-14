public class Stats {
  
  private int body;
  private int wits;
  private int craft;
  private int luck;
  private int life;
  
  public Stats(int[] stat_array) {
    assert(stat_array.length == 5);
    body = stat_array[0];
    wits = stat_array[1];
    craft = stat_array[2];
    luck = stat_array[3];
    life = stat_array[4];
  }
  
  public Stats(int new_body, int new_wits, int new_craft, int new_luck, int new_life) {
    this(new int[]{new_body, new_wits, new_craft, new_luck, new_life});
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
  
  public void set_stat(int id, int new_val) {
    assert(id >= 0 && id < 5);
    switch (id) {
      case 0:
        body = new_val;
        break;
      case 1:
        wits = new_val;
        break;
      case 2:
        craft = new_val;
        break;
      case 3:
        luck = new_val;
        break;
      case 4:
        life = new_val;
        break;
    }
  }
}
