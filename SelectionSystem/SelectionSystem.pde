String selAsk = "Enter Memory Bank: ";
String selMenu ="";
String keyBoardText = "";
String BankSelect ="";
int PinSelect = -1;
String CustomLogic1 = "Cust1";
String CustomLogic2 = "Cust2";
Table WaveformSelection = new Table();
int Logic = -1;
Boolean Confirm = false;
Boolean BackStep = false;
Boolean ProcessSelection = false;
int Menu = 0;

void setup() {
  size(1080, 450);
  textAlign(CENTER, CENTER);
  textSize(12);
  fill(0);
  WaveformSelection.addColumn("Memory Bank", Table.STRING);
  WaveformSelection.addColumn("Pin", Table.STRING);
  WaveformSelection.addColumn("Logic", Table.INT);
}
 int bg = 190;
void draw() {
  background(bg);
  textSize(10);
  textAlign(RIGHT,BOTTOM);
  text("Press Delete to go Back\n Memory Selections to be written are shown in the Console below this window",width-3,height);
  textSize(30);
  textAlign(CENTER, CENTER);
  text(selAsk, 0, 0, width, height);
  
  if(Menu != 2) text(keyBoardText, 0, 25, width, height);
  else text(keyBoardText, width/2, 350);
  
  if(Menu > 0){//If/else selected Memory Bank
    textAlign(LEFT);
    text("SelectedBank: ", 15,35);
    text(BankSelect, 20,35+25); 
    //println(Menu);
  }else{BankSelect = "";}  
  if(Menu > 1){//If/else selected Out Pin.
    textAlign(LEFT);
    text("Selected Pin: ", 300,35);
    text(PinSelect, 300,35+25);  
  }else{PinSelect = -1;}
  if(Menu >2){//If/else selected Logic Output
    textAlign(LEFT);
    text("Selected Logic: ", 600,35);
    text(Logic, 600,35+25);
  }else{Logic= -1;}
  
  
  if(Menu == 0){//Everything for  selecting Memory Bank;
    selAsk = "Enter Memory Bank";
    if(Confirm){
      BankSelect = keyBoardText;
    }   
  }//End Menu 0;
  
  if(Menu == 1){//Everything for selecting Output Pin
   selAsk = "Select Output Pin(1-8):";
   if(Confirm){
      PinSelect = int(keyBoardText);
   }
  }//End Menu 1;
  
  if(Menu == 2){//Everything for selecting Logic Function
    selAsk = "Select Logic Function for Pin " + PinSelect + ":";
    selAsk = selAsk+ "\n1: All & (AND) \n2: All | (OR)\n3: All ^ (XOR)\n4: " +CustomLogic1 + "\n5: "+CustomLogic2 + "\n";   
    if(Confirm){
     Logic = int(keyBoardText); 
    }
  }//end Menu 2;
  
  if(Menu == 3){//Everything for Processing the SELECTION. MemBank, Pin, Logic.
    selAsk = "Confirm Selection above: (y/n)";
    if(Confirm){
     String answer = (keyBoardText); 
     if(answer.equals("y")){
       ProcessSelection = true;
     }
    }
  }//end Menu 3;
  
  
  if(ProcessSelection){ //Everything for Processing the SELECTION. MemBank, Pin, Logic, and sending it to the IHex Parser.
    Menu = -1;
    ProcessSelection = false;
    //Table Selection = new Table();
    TableRow newRow = WaveformSelection.addRow();
    newRow.setString("Memory Bank", BankSelect);
    newRow.setInt("Pin", PinSelect);
    newRow.setInt("Logic", Logic);
    PrintWaveformSelection();
    text("SDfsdfsdfs",0,0);
    BankSelect = "";
    PinSelect = -1;
    Logic = -1;
  }//End Process Selection
  if(Confirm){
    Confirm=false;
    keyBoardText = "";
    Menu ++;    
  }//End Confirm
  if(BackStep){
    BackStep = false;
    if(Menu>0) Menu--;
  }
    
    
    
}//End Draw()

void PrintWaveformSelection(){
  println("  Memory Bank:\t  Pin:\t Logic Function:");
 for (TableRow row: WaveformSelection.rows()){
    println("  " + row.getString("Memory Bank")+ "\t\t" + row.getInt("Pin") + "\t\t" + row.getInt("Logic") );
 } 
}

void keyPressed() {
  if (keyCode == BACKSPACE) {
    if (keyBoardText.length() > 0) {
      keyBoardText = keyBoardText.substring(0, keyBoardText.length()-1);
    }
  } else if (keyCode == DELETE) {
    keyBoardText = "";
    BackStep = true; 
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && (keyCode != ENTER)) {
    keyBoardText = keyBoardText + key;
  }else if (keyCode == ENTER && keyBoardText != ""){Confirm = true;}
}