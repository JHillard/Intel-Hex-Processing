//Possible Bugs:
//Processing only deals with signed integers, so when converting the binary into hex, there's a chance that
//Signs get in the way. 

//Second Possible Bug; Wikipedia Article on Intel Hex says the Record Checksum should be calculated using the LSB's two's complement. But then goes on to use the
//two least signifigant digits in its calculation. The C intel hex lib also seems to use the two LSD checksum calculation method. This all works well now, but then what
// is up with wikipedia?

//Intel Hex Writing Variables
PrintWriter writer;
Table table;
int addrSize = 8; //Number of Oscillators
int outSize = 8;
int[] values = new int[addrSize];
String TruthTableName = "test.csv";
String addrName = "addr";
String outName = "out";
final int NUM_SELECTORS = 4; //number of DIP switch;
final int NUM_BANKS = int(pow(2,NUM_SELECTORS));
final int NUM_OSC = addrSize;

//GUI Variables
String selAsk = "Enter Memory Bank: ";
String selMenu ="";
String keyBoardText = "";
String BankSelect ="";
int PinSelect = -1;
String CustomLogic1 = "Cust1"; //To Modify: Add a brief title of your custom logic. These are the Title Strings
String CustomLogic2 = "Cust2";
Table WaveformSelection = new Table();
int Logic = -1;
Boolean Confirm = false;
Boolean BackStep = false;
Boolean ProcessSelection = false;
int Menu = 0;
int bg = 190;

//==================================================================================================
//============ Section 1: GUI and User Input   =====================================================
//==================================================================================================
void setup() {
  size(1080, 450);
  textAlign(CENTER, CENTER);
  textSize(12);
  fill(0);
  WaveformSelection.addColumn("Memory Bank", Table.STRING);
  WaveformSelection.addColumn("Pin", Table.STRING);
  WaveformSelection.addColumn("Logic", Table.INT);
}

void draw() {
  background(bg);
  textSize(10);
  textAlign(RIGHT,BOTTOM);
  text("Type \"truth\" to Burn Logic Selections to Hex file.\nPress Delete to go Back\n Memory Selections to be written are shown in the Console below this window",width-3,height);
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
    //To Modify: If you want to add more than two Custom logic commands, add their Title String here.
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
    text("SDfsdfsdfs",0,0); // Odd Refresh bug needed to move the program forward. Calls a Canvas refresh?
    BankSelect = "";
    PinSelect = -1;
    Logic = -1;
  }//End Process Selection
  if(Confirm && keyBoardText.equals("truth")){
   BurnIntelHex(); 
  }  
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



//==================================================================================================
//============ Section 2: Intel Hex Generation =====================================================
//==================================================================================================
/*
*Takes the WaveformSelection Tables, Generates inputs, Assembles Truth Tables,
*    Then writes it all to a Hex File.    
*/
void BurnIntelHex(){
  Table recordTable;
  Table truthTable;
  
  //recordTable = createIHex(truthTable); 
  //for (TableRow row :recordTable.rows()){
  // println(row.getString(0));   
  //}
   Table inputs = OscillatorGenerator();
   //WaveformSelection;
   truthTable = truthtableGenerator(WaveformSelection,inputs);
   //truthTable = CSVprocess();
    printTable(truthTable);
   //recordTable = createIHex(truthTable);
   
   exit();
  
}

Table truthtableGenerator(Table WaveformSelection, Table inputs){
  Table truthTable = new Table();
  for(TableRow Selection: WaveformSelection.rows()){//Process each Waveform Selection
    String selAddr = Selection.getString("Memory Bank");
    int pin = Selection.getInt("Pin");
    int logic = Selection.getInt("Logic");
    
    for( TableRow oscRow: inputs.rows(){
       for all pins(){
         //If Pin is selected in Selection, use that to determine truth table via Logic selection
         //Else use all zeros;
         //TODO
       }
    }
  
  
  }
  for( TableRow row: inputs.rows()){
    int out1=logicAND_8(row);
    int out2=logicAND_8(row);
    int out3=logicAND_8(row);
    int out4=logicAND_8(row);
    int out5=logicAND_8(row);
    int out6=logicAND_8(row);
    int out7=logicAND_8(row);
    int out8=logicAND_8(row);
    
    String output = ""+ out8 + out7 + out6 + out5 + out4 + out3 + out2 + out1;
    println(output);
    TableRow answer = truthTable.addRow();
    answer.setString(0,row.getString(0));
    answer.setString(1, output);
  }
  return truthTable; 
}


/*
*Takes a string of inputs, and a logic designator, 
* Calls the appropriate Logic Function and returns its value.
*To Modify: Add your custom logic function call to the switch case.
*/
String logicProcessor(String inputs, int Logic){
  String answer= "";
  //Todo
  return answer;
}


Table OscillatorGenerator(){
  Table oscillators = new Table();
  int k = int(pow(2,NUM_OSC));
  for( int i=0; i<k; i++){
    TableRow set = oscillators.addRow();
    set.setString(0,(binary(i,NUM_OSC)));
  }
  return oscillators;
}

int logicAND_8(TableRow set){//Performs AND Logic on 8 input oscillators. Its fixed at 8 because it makes an easy template for those who want to roll their own logic function.
  int a,b,c,d,e,f,g,h, answer;
  int normal = int('0');
  String str =set.getString(0);
  println("Inputs_" + str);
  a = int(str.charAt(0))-normal; //Converts String of Oscillator inputs into integers for Processing Logic.
  b = int(str.charAt(1))-normal;
  c = int(str.charAt(2))-normal;
  d = int(str.charAt(3))-normal;
  e = int(str.charAt(4))-normal;
  f = int(str.charAt(5))-normal;
  g = int(str.charAt(6))-normal;
  h = int(str.charAt(7))-normal;
  println(a+"_"+ b+c+d+e+f+g+h);
  answer = a & b & c & d & e & f & g & h ; //If spinning your own logic function, change these symbols here.
  
  return answer;
}


Table MemoryBankGrouper(Table waveformSelection){
Table groupedWaveforms = new Table();
//TODO Change data structure so it goes
//10101
//----1, 2
//----3, 1
//0001
//---12
//Tables within tables.
return groupedWaveforms;
}




Table createIHex(Table truthTable) {
  Boolean firstAddr = true;
  String recordAddr = "";
  String currAddr = "";
  String lastAddr = "";
  String recordData = "";
  String hexByte = "";
  int byteCount = 0;
  String runningSum = "0";
  Table recordTable = new Table();
  final int byteLimit = 16;  //16 is the typical byteCount per record in IntelHex;
  
  for (TableRow row : truthTable.rows()) {
    hexByte = hex(unbinary(row.getString(1)), 2);
    currAddr = hex(unbinary(row.getString(0)), 2);
    if(firstAddr){
      recordAddr = currAddr;       
      recordData = hexByte;
      runningSum = hexByte;
      
      firstAddr = false;
      byteCount++;
    }else{   
      if( isSequential(lastAddr,currAddr) && byteCount < byteLimit){ //Test to determine whether to start a new record (new line), or continue concantinating data.
       recordData = recordData + hexByte;
       byteCount++;
       runningSum= hex( unhex(runningSum) + unhex(hexByte)); //Running sum on the data for the checksum.
      }else{//Need to start a new record!
        TableRow newRow = recordTable.addRow();
        newRow.setString(0, processRecord(recordAddr, recordData, byteCount, runningSum));
        
        recordAddr = currAddr;       
        recordData = hexByte;
        runningSum = hexByte;
        
        byteCount = 0;
      }
      
    }
    lastAddr = currAddr;
  }//end for
  TableRow newRow = recordTable.addRow();//Handle the last line of iHex encoding
  newRow.setString(0, processRecord(recordAddr, recordData, byteCount, runningSum));
  
  TableRow eofRow = recordTable.addRow();
  eofRow.setString(0, ":"+"00"+"0000"+"01"+"FF"); //EOF Character.
  return recordTable;
}

String processRecord(String recordAddr, String recordData, int byteCount, String dataSum){
  dataSum = hex( unhex(dataSum) + byteCount, 2);
  String checksum = hex( unhex("FF") - unhex(dataSum)+1   ,2);
  String record = ":"+hex(byteCount,2)+hex(unhex(recordAddr),4)+"00"+ recordData + checksum;
  return record;
}

/*
*Prints all the output values stored in a table. Useful for debugging.
*/
void printOutputs(Table truthTable){
    for (TableRow row : truthTable.rows()) {
    println("no_cast: " +row.getString(1));
    println("int: " +unbinary(row.getString(1)));
    println("hex: " + hex(unbinary(row.getString(1)), 2)) ;
    }
}

void printTable(Table truthTable){
    for (TableRow row : truthTable.rows()) {
    println(hex(unbinary(row.getString(0)), 2)+ "_"+ hex(unbinary(row.getString(1)), 2)) ;
    }
}



/*
*Prints all the address values stored in a table. Useful for debugging.
*/
void printAddresses(Table truthTable){
    for (TableRow row : truthTable.rows()) {
    println("no_cast: " +row.getString(0));
    println("int: " +unbinary(row.getString(0)));
    println("hex: " + hex(unbinary(row.getString(0)), 2)) ;
    }
}

/*
*Processes the CSV and returns the Table of our addresses and outputs
 */
Table CSVprocess() {
  Table table;
  Table truthTable = new Table();
  int rowNum = 0;
  table = loadTable(TruthTableName, "header");
  
  for (TableRow row : table.rows()) {
    String addr ="";
    String out = "";
    for (int i=1; i<=addrSize; i++) {  //captures each digit in input address and concantenates them into a single String
      addr = addr +row.getString(addrName+i);
    }
    for (int i=1; i<=outSize; i++) {
      out = out + row.getString(outName+i);  //Concantenates the outputs into a single String
    }
    truthTable.addRow();
    truthTable.setString(rowNum, 0, addr);
    truthTable.setString(rowNum, 1, out);//Adds the parsed CSV data to our return Table.
    rowNum++;
  }
  return truthTable;
}

/*
*Returns True if two hex numbers are sequential to one and other
 */
Boolean isSequential(String hex1, String hex2) {
  int i1, i2;
  i1 = unhex(hex1);
  i2 = unhex(hex2);
  return i2==(i1+1);
}