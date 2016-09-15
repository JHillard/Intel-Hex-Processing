
import controlP5.*;
import java.util.*;

PImage img;

ControlP5 ChipSelect;
//Logic Function Controller.
ControlP5 logicFunction;
//Selector between logic function and wave generation
ControlP5 programSelection;
// Waveform Generation Controller
ControlP5 waveGen;
//Controller for Pin selections and things that will always appear despite selections.
ControlP5 defaults;
  Textlabel membankSelectText1;
  Textlabel membankSelectText2;
  Textlabel outpinText1;
  Textlabel outpinText2;
//Controller for opening screen. Put tutorial modules or intro text here.
ControlP5 openingScreen;
  Textlabel opening1;
  Textlabel opening2;
ControlP5 EEPROM1;
ControlP5 EEPROM2;
//Various booleans modified by the above controllers. Doesn't communicate to the rest of program. 
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

//Controller Strings. These are Strings used by the rest of the program to determine what the user has selected. 
String selectedChip = "";
String chip1 = "MC7400";
String chip2 = "MC0000";

String sinTag = "Sin Wave";
String cosTag = "Cos Wave";
String squareTag = "Square Wave";
String sawTag = "Saw Wave";
String selectedWave = "";

String logicString = "";
String logicPrompt = "Arbitrary Logic Function";

String membankSelection = "";
String outpinSelection = "";
String logicFunctionTag = "Logic Function";
String waveGenTag = "Waveform Generator";
String selectedProgram = "";

//Misc variables.
int col = color(255);
int prgmState;

void setup() {
  size(800, 500);
  smooth();
  
  
img = loadImage("M27C512.png");



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
    .setText("SELECT CHIP to get started.")
    .setPosition(width/2, height/2 + 15);
    ;
  opening1.setPosition(width/2-opening1.getWidth()/2, height/2);
  opening2.setPosition(width/2-opening2.getWidth()/2, height/2+15);
  
  defaults = new ControlP5(this);
  defaults.setVisible(false);
        int membankXpos = 200;
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
          .setPosition(membankXpos+10, membankYpos+membankYspace*5+2)
          ;  
          
        int outpinXpos = 500;
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
          .setPosition(outpinXpos, outpinYpos+outpinYspace*9+2)
          ;                                    

          List l2 = Arrays.asList(logicFunctionTag, waveGenTag);
          /* add a ScrollableList, by default it behaves like a DropdownList */
          programSelection = new ControlP5(this);
          programSelection.addScrollableList("Program_Selection")
            .setPosition(200, 100)
            .setSize(200, 100)
            .setBarHeight(20)
            .setItemHeight(20)
            .addItems(l2)
            // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
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
   
   List l3 = Arrays.asList(sinTag,cosTag,sawTag,squareTag);
  /* add a ScrollableList, by default it behaves like a DropdownList */
  waveGen = new ControlP5(this);
  waveGen.addScrollableList("Wave_Selection")
    .setPosition(200, 100)
    .setSize(200, 75)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(l3)
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
   
   
   logicFunction = new ControlP5(this);
   logicFunction.addTextfield(logicPrompt)
     .setPosition(200, 100)
     .setSize(200,20)
     .setFocus(true)
     ;  
    
}


void draw() {
  background(0);
  pushMatrix();
  cleanCanvas();
  manageCanvas();
  generateSelectionString();
  image(img,0,0);
  popMatrix();
}
/*
*Monitors Buttons/Text Fields to appropraitely assign control values based on user input. These variables are what
* interfaces the graphics module to the rest of the program.
*/
void generateSelectionString() {
  membankSelection = str(int(Membank_0)) + str(int(Membank_1)) + str(int(Membank_2)) + str(int(Membank_3));
  outpinSelection = str(int(outpin_0)) + str(int(outpin_1)) + str(int(outpin_2)) + str(int(outpin_3)) + str(int(outpin_4)) + str(int(outpin_5)) + str(int(outpin_6)) + str(int(outpin_7));       
  logicString = logicFunction.get(Textfield.class,logicPrompt).getText();
  //println("Bank Selection: " + membankSelection);
  //println("Output Pin Selection: " + outpinSelection);
  //println("Logic String: " + logicString);
}

/*
*Called everytime program is chosen from programming dropdown menu
*/
void Program_Selection(int n){
 println(programSelection.get(ScrollableList.class, "Program_Selection").getItem(n).get("name"));
 selectedProgram = (programSelection.get(ScrollableList.class, "Program_Selection").getItem(n).get("name")).toString(); 
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
/*
* Handles what control elements should be on or off. Repositions some elements as appropriate.
*/
void manageCanvas() {
  if (selectedChip == chip1) EEPROM1.show();
  if (selectedChip == chip2) EEPROM2.show();
  if (selectedChip != ""){
    defaults.show();
    programSelection.show();
    programSelection.setPosition(75,height-200);
    ChipSelect.setPosition(0-150,height-200);
    if(selectedProgram == logicFunctionTag) logicFunction.show();
    if(selectedProgram == waveGenTag) waveGen.show();
    logicFunction.setPosition(300,height-200);
    waveGen.setPosition(300,height-200);
  }
  if (selectedChip == ""){
    openingScreen.show();
    ChipSelect.setPosition(0+100,height/2-50);
  }
  membankSelectText2.setText(membankSelection);
  outpinText2.setText(outpinSelection);
}
/*
*Removes all GUI control elements from the canvas. Makes manageCanvas() job easier.
*/
void cleanCanvas() {
  programSelection.hide();
  EEPROM1.hide();
  EEPROM2.hide();
  defaults.hide();
  logicFunction.hide();
  waveGen.hide();
  openingScreen.hide();
}