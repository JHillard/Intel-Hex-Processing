
import controlP5.*;
import java.util.*;

ControlP5 ChipSelect;
ControlP5 MC7400;
ControlP5 MC0000;
boolean MC7400_chosen = false;
boolean MC7400_Membank_0 = false;
boolean MC7400_Membank_1 = false;
boolean MC7400_Membank_2 = false;
boolean MC7400_Membank_3 = false;




int col = color(255);
int prgmState;

void setup() {
  size(400,400);
  smooth();
  MC7400 = new ControlP5(this);
  MC7400.addToggle("MC7400_chosen")
     .setPosition(40,100)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
    MC7400.addToggle("MC7400_Membank_0")
     .setPosition(40,100)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
    MC7400.addToggle("MC7400_Membank_1")
     .setPosition(40,100)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
    MC7400.addToggle("MC7400_Membank_2")
     .setPosition(40,100)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
    MC7400.addToggle("MC7400_Membank_3")
     .setPosition(40,100)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
     
     
     
     
  MC0000 = new ControlP5(this);
  MC0000.addToggle("toggle2")
     .setPosition(40,250)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;   
     

  List l = Arrays.asList("MC0000", "MC7400");
  /* add a ScrollableList, by default it behaves like a DropdownList */
  ChipSelect = new ControlP5(this);
  ChipSelect.addScrollableList("Chip_Select")
     .setPosition(200, 100)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(l)
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
     
     
}
 
 
void draw() {
  background(0);
  pushMatrix();
   MC7400.hide();
 if (MC7400_chosen) drawMC7400(); 
 
 popMatrix();
  
}
/*
*Called everytime chip select is chosen from dropdown menu.  
*/
void Chip_Select(int n){
  //println( ChipSelect.get(ScrollableList.class, "Chip_Select").getItem(n).get(4));
 println(ChipSelect.get(ScrollableList.class, "Chip_Select").getItem(n).get("name"));
  
}
void drawMC7400(){
  MC7400.show();
 
}


void dropdown(int n) {
  /* request the selected item based on index n */
  println(n, ChipSelect.get(ScrollableList.class, "Chip Select").getItem(n));
  
  /* here an item is stored as a Map  with the following key-value pairs:
   * name, the given name of the item
   * text, the given text of the item by default the same as name
   * value, the given value of the item, can be changed by using .getItem(n).put("value", "abc"); a value here is of type Object therefore can be anything
   * color, the given color of the item, how to change, see below
   * view, a customizable view, is of type CDrawable 
   */
  
   CColor c = new CColor();
  c.setBackground(color(255,0,0));
  ChipSelect.get(ScrollableList.class, "Chip Select").getItem(n).put("color", c);
}