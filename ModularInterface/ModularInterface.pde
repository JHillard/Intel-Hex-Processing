
import controlP5.*;
import java.util.*;

ControlP5 ChipSelect;
ControlP5 defaults;
ControlP5 EEPROM1;
ControlP5 EEPROM2;
Textlabel membankSelectText1;
Textlabel membankSelectText2;
boolean EEPROM1_chosen = false;
boolean Membank_0 = false;
boolean Membank_1 = false;
boolean Membank_2 = false;
boolean Membank_3 = false;
String selectedChip = "";
String chip1 = "MC7400";
String chip2 = "MC0000";
String membankSelection = "";


int col = color(255);
int prgmState;

void setup() {
  size(400,400);
  smooth();
  EEPROM1 = new ControlP5(this);
  EEPROM1.addToggle(chip1 + "_chosen")
     .setPosition(40,100)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;

     
  defaults = new ControlP5(this);
  defaults.setVisible(false);
    int membankXpos = 15;
    int membankYpos = 35;
    int membankYspace = 20;
    defaults.addToggle("Membank_0")
     .setPosition(membankXpos,membankYpos + membankYspace*1)
     .setSize(50,20)
     .setValue(false)
     .setCaptionLabel("")
     .setMode(ControlP5.SWITCH)
     ;
    defaults.addToggle("Membank_1")
     .setPosition(membankXpos,membankYpos + membankYspace*2)
     .setSize(50,20)
     .setValue(true)
     .setCaptionLabel("")
     .setMode(ControlP5.SWITCH)
     ;
    defaults.addToggle("Membank_2")
     .setPosition(membankXpos,membankYpos + membankYspace*3)
     .setSize(50,20)
     .setValue(false)
     .setCaptionLabel("")
     .setMode(ControlP5.SWITCH)
     ;
    defaults.addToggle("Membank_3")
     .setPosition(membankXpos,membankYpos + membankYspace*4)
     .setSize(50,20)
     .setValue(false)
     .setCaptionLabel("")
     .setMode(ControlP5.SWITCH)
     ;
     membankSelectText1 = defaults.addTextlabel("membankSelectText1")
                          .setText("Select Memory Bank")
                          .setPosition(membankXpos, membankYpos)
                          ;
      membankSelectText2 = defaults.addTextlabel("membankSelectText2")
                          .setText(membankSelection)
                          .setPosition(membankXpos+10, membankYpos+membankYspace*5)
                          ;                          
     
  EEPROM2 = new ControlP5(this);
  EEPROM2.addToggle("toggle2")
     .setPosition(40,250)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;   
     

  List l = Arrays.asList(chip1, chip2);
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
  cleanCanvas();
  showSelections();
  generateSelectionString();
  popMatrix();
  
}
void generateSelectionString(){
  membankSelection = str(int(Membank_0)) + str(int(Membank_1)) + str(int(Membank_2)) + str(int(Membank_3));
  println("Bank Selection: " + membankSelection);
}
/*
*Called everytime chip select is chosen from dropdown menu.  
*/
void Chip_Select(int n){
  //println( ChipSelect.get(ScrollableList.class, "Chip_Select").getItem(n).get(4));
 println(ChipSelect.get(ScrollableList.class, "Chip_Select").getItem(n).get("name"));
 selectedChip = (ChipSelect.get(ScrollableList.class, "Chip_Select").getItem(n).get("name")).toString();
 
}
void showSelections(){
   if (selectedChip == chip1) EEPROM1.show();
   if (selectedChip == chip2) EEPROM2.show();
   if (selectedChip != "") defaults.show();
   membankSelectText2.setText(membankSelection);
}

void cleanCanvas(){
  EEPROM1.hide();
  EEPROM2.hide();  
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