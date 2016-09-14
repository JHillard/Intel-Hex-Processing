
import controlP5.*;
import java.util.*;

ControlP5 ChipSelect;
ControlP5 logicFunction;
ControlP5 waveGen;
ControlP5 defaults;
  Textlabel membankSelectText1;
  Textlabel membankSelectText2;
  Textlabel outpinText1;
  Textlabel outpinText2;
  String membankSelection = "";
  String outpinSelection = "";
ControlP5 openingScreen;
  Textlabel opening1;
  Textlabel opening2;
ControlP5 EEPROM1;
ControlP5 EEPROM2;
boolean EEPROM1_chosen = false;
boolean Membank_0 = false;
boolean Membank_1 = false;
boolean Membank_2 = false;
boolean Membank_3 = false;
boolean outpin_0 = false;
boolean outpin_1 = false;
boolean outpin_2 = false;
boolean outpin_3 = false;
boolean outpin_4 = false;
boolean outpin_5 = false;
boolean outpin_6 = false;
boolean outpin_7 = false;
String selectedChip = "";
String chip1 = "MC7400";
String chip2 = "MC0000";



int col = color(255);
int prgmState;

void setup() {
  size(400, 400);
  smooth();
  EEPROM1 = new ControlP5(this);
  EEPROM1.addToggle(chip1 + "_chosen")
    .setPosition(40, 100)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;

  openingScreen = new ControlP5(this);
  opening1 = openingScreen.addTextlabel("opening1")
    .setText("Welcome")
    .setPosition(width/2, height/2);
    ;
  opening2 = openingScreen.addTextlabel("opening2")
    .setText("Click CHIP SELECT to get started.")
    .setPosition(width/2, height/2 + 15);
    ;
  opening1.setPosition(width/2-opening1.getWidth()/2, height/2);
  opening2.setPosition(width/2-opening2.getWidth()/2, height/2+15);
  defaults = new ControlP5(this);
  defaults.setVisible(false);
        int membankXpos = 15;
        int membankYpos = 35;
        int membankYspace = 20;
        defaults.addToggle("Membank_0")
          .setPosition(membankXpos, membankYpos + membankYspace*1)
          .setSize(50, 20)
          .setValue(false)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("Membank_1")
          .setPosition(membankXpos, membankYpos + membankYspace*2)
          .setSize(50, 20)
          .setValue(true)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("Membank_2")
          .setPosition(membankXpos, membankYpos + membankYspace*3)
          .setSize(50, 20)
          .setValue(false)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("Membank_3")
          .setPosition(membankXpos, membankYpos + membankYspace*4)
          .setSize(50, 20)
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
          
        int outpinXpos = 200;
        int outpinYpos = 35;
        int outpinYspace = 20;
        defaults.addToggle("outpin_0")
          .setPosition(outpinXpos, outpinYpos + outpinYspace*1)
          .setSize(50, 20)
          .setValue(false)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("outpin_1")
          .setPosition(outpinXpos, outpinYpos + outpinYspace*2)
          .setSize(50, 20)
          .setValue(true)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("outpin_2")
          .setPosition(outpinXpos, outpinYpos + outpinYspace*3)
          .setSize(50, 20)
          .setValue(false)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("outpin_3")
          .setPosition(outpinXpos, outpinYpos + outpinYspace*4)
          .setSize(50, 20)
          .setValue(false)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
          defaults.addToggle("outpin_4")
          .setPosition(outpinXpos, outpinYpos + outpinYspace*5)
          .setSize(50, 20)
          .setValue(false)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("outpin_5")
          .setPosition(outpinXpos, outpinYpos + outpinYspace*6)
          .setSize(50, 20)
          .setValue(true)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("outpin_6")
          .setPosition(outpinXpos, outpinYpos + outpinYspace*7)
          .setSize(50, 20)
          .setValue(false)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        defaults.addToggle("outpin_7")
          .setPosition(outpinXpos, outpinYpos + outpinYspace*8)
          .setSize(50, 20)
          .setValue(false)
          .setCaptionLabel("")
          .setMode(ControlP5.SWITCH)
          ;
        outpinText1 = defaults.addTextlabel("outpinText1")
          .setText("Select Output Pins")
          .setPosition(outpinXpos, outpinYpos)
          ;
        outpinText2 = defaults.addTextlabel("outpinText2")
          .setText(outpinSelection)
          .setPosition(outpinXpos+10, outpinYpos+outpinYspace*9)
          ;                                    

  EEPROM2 = new ControlP5(this);
  EEPROM2.addToggle("toggle2")
    .setPosition(40, 250)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;   


  List l = Arrays.asList(chip1, chip2, "Main Menu");
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
  manageCanvas();
  generateSelectionString();
  popMatrix();
}
void generateSelectionString() {
  membankSelection = str(int(Membank_0)) + str(int(Membank_1)) + str(int(Membank_2)) + str(int(Membank_3));
  outpinSelection = str(int(outpin_0)) + str(int(outpin_1)) + str(int(outpin_2)) + str(int(outpin_3)) + str(int(outpin_4)) + str(int(outpin_5)) + str(int(outpin_6)) + str(int(outpin_7));       
  println("Bank Selection: " + membankSelection);
  println("Output Pin Selection: " + outpinSelection);
}
/*
*Called everytime chip select is chosen from dropdown menu.  
 */
void Chip_Select(int n) {
  //println( ChipSelect.get(ScrollableList.class, "Chip_Select").getItem(n).get(4));
  println(ChipSelect.get(ScrollableList.class, "Chip_Select").getItem(n).get("name"));
  selectedChip = (ChipSelect.get(ScrollableList.class, "Chip_Select").getItem(n).get("name")).toString();
  if(selectedChip == "Main Menu") selectedChip = "";
}
void manageCanvas() {
  if (selectedChip == chip1) EEPROM1.show();
  if (selectedChip == chip2) EEPROM2.show();
  if (selectedChip != ""){
    defaults.show();
    ChipSelect.setPosition(-width/2+25,height-200);
  }
  if (selectedChip == ""){
    openingScreen.show();
    ChipSelect.setPosition(0-100,150);
  }
  membankSelectText2.setText(membankSelection);
  outpinText2.setText(outpinSelection);
}

void cleanCanvas() {
  EEPROM1.hide();
  EEPROM2.hide();
  defaults.hide();
  openingScreen.hide();
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
  c.setBackground(color(255, 0, 0));
  ChipSelect.get(ScrollableList.class, "Chip Select").getItem(n).put("color", c);
}