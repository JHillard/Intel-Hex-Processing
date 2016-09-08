/*
README:
TO USE:
  Press "Ctrl + R" to run the sketch or press play. Follow the selection process
written on screen. Once you have made your selections, type the string "truth" into
the memory bank selection menu and press enter. The program will then compile your
logic choices and write a hex file. Intermediary outputs, such as the truth table or
results of the logic functions, can be viewed in the console.

To change the name of the intel hex file, change the variable FILENAME found at
the top of the code. 

If you are having trouble starting the program and you are getting a
"font not found error", please be sure to move the data folder associated with
this sketch in to the same folder as the .pde file. They are coupled. All
intel hex outpus will be written to the data folder. 

Most variables and methods one might want to change are tagged with the comment "To Modify:"
So if one is looking to expand the functionality of the program, Ctrl+F that tag and find what you are looking for.
*/



//Possible Bug; Wikipedia Article on Intel Hex says the Record Checksum should be calculated using the LSB's two's complement. But then goes on to use the
//two least signifigant digits in its calculation instead of the single LSB. The C intel hex lib also seems to use the two LSD checksum calculation method. This all works well now, but then it
//would appear wikipedia is broken.

//Intel Hex Writing Variables
final String FILENAME = "ProcessingCode.hex"; //To Modify: choose your filename;

Table table;
int addrSize = 12; //Number of Oscillators + DIP Switches
int outSize = 8; //Number of output pins. WARNING: STATIC. Intel Hex only works with 8-bit outputs.
int[] values = new int[addrSize];
String TruthTableName = "test.csv";
String addrName = "addr";
String outName = "out";
final int NUM_SELECTORS = 4; //number of DIP switches;
final int NUM_BANKS = int(pow(2,NUM_SELECTORS));
final int NUM_OSC = 8;

//GUI Variables
PFont font;
String selAsk = "Enter Memory Bank: ";
String selMenu ="";
String keyBoardText = "";
String BankSelect ="";
int PinSelect = -1;
String CustomLogic1 = "Cust1"; //To Modify: Add a brief title of your custom logic. These are the Title Strings
String CustomLogic2 = "Cust2";
final int WAVEFORMFRONT = 6; // Determines where to treat selections as waveforms, and where to treat as individual logic.
                             // To Modify: if adding more than the two default custom logics, increment this.
                             // Otherwise it will treat your new logic function as a waveform, and break.

Table WaveformSelection = new Table();
int Logic = -1;
Boolean Confirm = false;
Boolean BackStep = false;
Boolean ProcessSelection = false;
int Menu = 0;
int bg = 190;
int selectTextOffset = 125;


color darkBlue = color(50,55,100);
color white = color(255,255,255);
color highlightColor = color(215,215,255);

//==================================================================================================
//============ Section 1: GUI and User Input   =====================================================
//==================================================================================================
void setup() {
  font = loadFont("Consolas-20.vlw");
  size(1080, 450);
  textAlign(CENTER, CENTER);
  textSize(12);
  fill(0);
  WaveformSelection.addColumn("Memory Bank", Table.STRING);
  WaveformSelection.addColumn("Pin", Table.STRING);
  WaveformSelection.addColumn("Logic", Table.INT);
}

void draw() {
  int offset = 40+selectTextOffset;
  
  textFont(font);
  fill(white);
  background(darkBlue);
  textSize(13);
  textAlign(RIGHT,TOP);
  String warning = "WARNING: This program does not error check your inputs.";
  String warning2 = "If you mistype a memory address, this program will attempt to make it.\n";
  text(warning + warning2,width-3,5);
  textAlign(RIGHT,BOTTOM);
  String instructions = "Press Delete to go Back a selection\nType \"truth\" and press ENTER in the memory bank window\n to Burn Logic Selections to a Hex file.\n";
  text(instructions + "Memory Selections to be written are shown in the Console below this window",width-3,height);

  
  
  textSize(14);
  textAlign(CENTER, CENTER);
  int graphicMid = width/2;
  int graphicLeftStart = 100;
  int inpBlockWidth = 13;
  int graphicHeight = 60;
  int inpBlockNum = 8;
  int graphicTopStart = 25;
  
  String bank = "Memory Banks:\nXXXX";
  if (Menu>0) bank = "Memory Bank:\n" + BankSelect; 
  textBox(bank, graphicMid-377, graphicTopStart, 160, 60, Menu==0|| Menu==3);
  for (int i = 0; i < inpBlockNum; i = i+1){
     textBox( "", graphicMid -210 + i*20, graphicTopStart, inpBlockWidth, 2*graphicHeight/3,Menu==3); 
  }
  textBox("Random Inputs", graphicMid -210, graphicHeight*3/4+graphicTopStart, 8*20-13/2, graphicHeight/4,Menu==3);
 
  String lf = "??";
  if (Menu>2) lf = str(Logic);
  textCirc("Logic\nFunction:\n"+lf, graphicMid, graphicTopStart+graphicHeight/2, 80,80, Menu == 2 || Menu==3); 
  for (int i = 0; i < inpBlockNum; i = i+1){
    String b = "x";
    if (i == PinSelect) b = str(i); 
    textBox( b, graphicMid + 55+i*20, graphicTopStart, inpBlockWidth, 2*graphicHeight/3,Menu == 1|| Menu==3); 
    
  }
  textBox("Output Bits", graphicMid + 55, graphicHeight*3/4+graphicTopStart, 8*20-13/2, graphicHeight/4, Menu == 1|| Menu==3);
  
  
  
  
  textSize(30);
  textAlign(CENTER, TOP);
  text(selAsk, 0, offset+30, width, height);
  textAlign(CENTER,CENTER);
  
  if(Menu != 2) text(keyBoardText, 0, 25, width, height);
  else{
    textAlign(LEFT,TOP);
    text(keyBoardText, width-250,offset+30, width-200,height);//To Modify: If you added extra functions to the selection screen, you may need to move down where the
    textAlign(CENTER,CENTER);                                      //input text displays on the screen to make everything fit.
  }
  
  if(Menu > 0){//If/else selected Memory Bank
    textAlign(LEFT);
    text("Selected Bank: ", 15,offset);
    text(BankSelect, 20,offset+25); 
    //println(Menu);
  }else{BankSelect = "";}  
  if(Menu > 1){//If/else selected Out Pin.
    textAlign(LEFT);
    text("Selected Pin: ", 300,offset);
    text(PinSelect, 300,offset+25);  
  }else{PinSelect = -1;}
  if(Menu >2){//If/else selected Logic Output
    textAlign(LEFT);
    text("Selected Logic: ", 600,offset);
    text(Logic, 600,offset+25);
  }else{Logic= -1;}
  
  if(Menu == 0){//Everything for  selecting Memory Bank;
    selAsk = "Enter Memory Bank";
    if(Confirm){
      BankSelect = keyBoardText;
    }   
  }//End Menu 0;
  
  if(Menu == 1){//Everything for selecting Output Pin
   selAsk = "Select Output Pin(0-7):";
   if(Confirm){
      PinSelect = int(keyBoardText);
   }
  }//End Menu 1;
  
  if(Menu == 2){//Everything for selecting Logic Function
    selAsk = "Select Logic Function for Pin " + PinSelect + ":";
    selAsk = selAsk+ "\n1: All & (AND) \n2: All | (OR)\n3: All ^ (XOR)\n4: " +CustomLogic1 + "\n5: "+CustomLogic2 + "\n6: Sin Wave";   
    //To Modify: If you want to add more than two Custom logic commands, add their Title String here and fix the WAVEFORM FRONT Variable.
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
     }else Confirm = false; 
     if(answer.equals("n")){
       BackStep = true;
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
   BurnIntelHex(WaveformSelection); 
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

void textCirc(String txt, int x1, int y1, int xWidth, int yWidth){
  boolean highlight = true; 
  textCirc(txt,x1,y1,xWidth,yWidth,highlight);
}
void textCirc(String txt, int x1, int y1, int xWidth, int yWidth, boolean highlight){
  if (highlight) fill(highlightColor);
  else  fill(white);
  ellipse(x1,y1,xWidth,yWidth);
  textAlign(CENTER, CENTER);
  fill(darkBlue);
  text(txt, x1, y1); 
  fill(white);
}
void textBox(String txt, int x1, int y1,int x2,int y2){
  textBox(txt,x1,y1,x2,y2,false);
}  
void textBox(String txt, int x1, int y1,int x2,int y2, boolean highlight){
 if (highlight) fill(highlightColor);
 else fill(white);
 rect(x1,y1,x2,y2);
 fill(darkBlue);
 textAlign(CENTER, CENTER);
 text(txt, (x2)/2+x1, (y2)/2+y1 ); 
 fill(white);
}
//==================================================================================================
//============ Section 2: Table Translation and Grouping============================================
//==================================================================================================
// Table maniuplation methods for sorting and otherwise manipulating truth tables and input selections
// to make iterating over inputs and generating logic possible.

/*
* Takes table with each operation enumerated by memory bank, pin, and logic. Outputs
* a table with all pins used in a single memory bank as one entry in a table, with all pins
* taking up a single entry, just coded together by Strings. This gets around Processing's lack of arrays or
* sorting ability. 
*/

Table tableGrouper(Table waveforms) {
  Table groupedWaves = new Table();
  groupedWaves.addColumn("Memory Bank", Table.STRING);
  groupedWaves.addColumn("Pin", Table.STRING);
  groupedWaves.addColumn("Logic", Table.STRING);
  //groupedWaves: MemBank, pin1_pin2_pin3....pinN, Logic1_....LogicN;
  for ( TableRow row : waveforms.rows()) {
    String bank = row.getString("Memory Bank");
    String newPin = "" + row.getInt("Pin");
    String newLogic = "" + row.getInt("Logic");
    String oldPins, oldLogics;
    TableRow bankRow;
    try {
      bankRow = groupedWaves.findRow(bank, "Memory Bank");
      oldPins = bankRow.getString("Pin");
      oldLogics = bankRow.getString("Logic");
    }
    catch(Exception e) {
      bankRow = groupedWaves.addRow();
      oldPins = "";
      oldLogics = "";
    }
    bankRow.setString("Memory Bank", bank);
    bankRow.setString("Pin", oldPins + newPin + "_");
    bankRow.setString("Logic", oldLogics + newLogic + "_");
  }
  return groupedWaves;
}

/*
* Takes a table of delimited Strings of the form a_b_c...n_ and turns it into a table of
* t1:
*  a
*  b
*  .
*  n
* This re-processes the strings outputed by tableGrouper into something more iterable for the truthTableGenerator
*/
Table StringToTable(String delmintedString, Table table, int column) {
  if (delmintedString.length() <= 1) return table;
  int s1 = int(delmintedString.substring(0, delmintedString.indexOf("_")));
  String sRemain = delmintedString.substring(delmintedString.indexOf("_")+1);
  TableRow newEntry = table.addRow();
  newEntry.setInt(column, s1);
  table = StringToTable(sRemain, table, column);
  return table;
}

/*
*Takes two INT single column tables t1 and t2 and pairs them up, so that 
 * t3:  t1: t2:
 * 1,2   1   2
 * 3,b   3   b
 * 3,1   3   1 
 * Tables must have same number of rows. Uses t1 rowLength to determine final output size.
 */
Table pairTwoIntTables(Table t1, Table t2) {
  Table t3 = new Table();
  t3.addColumn();
  t3.addColumn();
  for ( int i=0; i<t1.getRowCount(); i++) {
    TableRow row = t3.addRow();
    row.setInt(0, t1.getRow(i).getInt(0));
    row.setInt(1, t2.getRow(i).getInt(0));
  }
  return t3;
}

void printIntTable(Table tab) {
  for ( TableRow row : tab.rows()) {
    for (int i=0; i<tab.getColumnCount(); i++) {
      print(row.getInt(i)+ "_");
    }
    println("");
  }
}
void printWaveform(Table waveform) {
  try {
    for (TableRow row : waveform.rows()) {
      println(row.getString("Memory Bank") +"|" + row.getString("Pin") +"|" + row.getString("Logic") );
    }
  }
  catch(Exception e) {
    for (TableRow row : waveform.rows()) {
      println(row.getString("Memory Bank") +"|" + row.getInt("Pin") +"|" + row.getInt("Logic") );
    }
  }
}

//==================================================================================================
//============ Section 3: Intel Hex Generation =====================================================
//==================================================================================================
/*
*Takes the WaveformSelection Tables, Generates inputs, Assembles Truth Tables,
*    Then writes it all to a Hex File.    
*/
void BurnIntelHex(Table waveformSelection){
  Table recordTable;
  Table truthTable;
   PrintWaveformSelection();
   Table inputs = OscillatorGenerator();
   truthTable = truthtableGenerator(waveformSelection,inputs);
   println("Truth Table Generated! Outputs below:");
   printBinaryTruthTable(truthTable);
   recordTable = createIHex(truthTable);
   writeHexTable(recordTable);
   exit();  
}
void writeHexTable(Table table){
  println("Writing the following to hex file: "+ FILENAME+ ": ");
  PrintWriter output;
  output = createWriter("data/" +FILENAME);
  for( TableRow row: table.rows() ){
    output.println(row.getString(0));
    println(row.getString(0));
  }
  output.flush();
  output.close();
}
void PrintWaveformSelection(){
  println("  Memory Bank:\t  Pin:\t Logic Function:");
 for (TableRow row: WaveformSelection.rows()){
    println("  " + row.getString("Memory Bank")+ "\t\t" + row.getInt("Pin") + "\t\t" + row.getInt("Logic") );
 }
}

/*
* Truth Table is of form:
* address(input on pins), output on pins
*/
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
  final int byteLimit = 16;  //16 is the cultural Standard max byteCount per record in IntelHex;
  
  for (TableRow row : truthTable.rows()) {
    hexByte = hex(unbinary(row.getString(1)), 2);
    currAddr = hex(unbinary(row.getString(0)), 3);
    if(firstAddr){
      recordAddr = currAddr;       
      recordData = hexByte;
      runningSum = hexByte;
      
      firstAddr = false;
      byteCount++;
    }else{   
      if( isSequential(lastAddr,currAddr) & byteCount < byteLimit){ //Test to determine whether to start a new record (new line), or continue concantinating data.
       recordData = recordData + hexByte;
       byteCount++;
       runningSum= hex( unhex(runningSum) + unhex(hexByte)); //Running sum on the data for the checksum.
       
      }else{//Need to start a new record!
        TableRow newRow = recordTable.addRow();
        newRow.setString(0, processRecord(recordAddr, recordData, byteCount, runningSum));
        
        recordAddr = currAddr;       
        recordData = hexByte;
        runningSum = hexByte;
        
        byteCount = 1;
      }
      
    }
    lastAddr = currAddr;
  }//end for
  TableRow newRow = recordTable.addRow();//Add the record skipped by the for loop of iHex encoding
  newRow.setString(0, processRecord(recordAddr, recordData, byteCount, runningSum));
  TableRow eofRow = recordTable.addRow();
  eofRow.setString(0, ":"+"00"+"0000"+"01"+"FF"); //EOF Record.
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
*Returns True if two hex numbers are sequential to one and other
 */
Boolean isSequential(String hex1, String hex2) {
  int i1, i2;
  i1 = unhex(hex1);
  i2 = unhex(hex2);
  return i2==(i1+1);
}


//==================================================================================================
//============ Section 4: Logic and Truth Tables =====================================================
//==================================================================================================
//Everything responsible for getting a truth table ready.


/*
*Takes in an input of oscillators, and a waveform Table of shape:
* Memory Bank1, P1_P2_...PN_, L1_L2_...LN
* Memory Bank2, P1_P2_...PN_, L1_L2_...LN
* Memory Bank3, P1_P2_...PN_, L1_L2_...LN
* and outputs a truth table of shape:
* Address1, Output1
* Address2, Output2
* Address3, Output3
*/
Table truthtableGenerator(Table waveformSelection, Table inputs){
  println("Logic Function Outputs:");
  println("(Membank_InputBin_OutputBin_OutputInt)");
  Table truthTable = new Table();
  truthTable.addColumn("Address", Table.STRING);
  truthTable.addColumn("Outputs", Table.STRING);
  waveformSelection = tableGrouper(waveformSelection);
  for(TableRow selection: waveformSelection.rows()){//Each row holds an entire memory bank.
    String selAddr = selection.getString(0); //"Memory Bank"
    String pinString = selection.getString(1);//"Pin"
    String logicString = selection.getString(2);//"Logic"
    Table pT = new Table(); Table lT = new Table();
    pT.addColumn();lT.addColumn();
    StringToTable(pinString,pT,0);
    StringToTable(logicString,lT,0);
    Table pinAndLogic = pairTwoIntTables(pT,lT);
    int waveform= -1;
    println("Generating Truth Table!!!!");
    for( TableRow oscRow: inputs.rows()){ //Iterates through every input.
       String outputs = "0000"+"0000"; //Default 8 output pins. 
       String input = oscRow.getString(0);
       for( TableRow action: pinAndLogic.rows()){
           int pin = action.getInt(0);
           int logicCode = action.getInt(1);
           if(logicCode >= WAVEFORMFRONT){
             waveform = logicCode;
             break;
           }
           outputs = replaceCharAt(pin, str(executeLogic(logicCode, input)).toCharArray()[0], outputs );
           //println("p"+pin+"_l"+logicCode+"_in"+input+"_OU"+outputs);
       }
       if(waveform != -1){outputs = executeWaveform(waveform,input);}
       println(selAddr+"_"+input+"_"+outputs+"_"+str(unbinary(outputs)));
       TableRow singleLine = truthTable.addRow();
       singleLine.setString(0,selAddr+input); //Sets truth table address
       singleLine.setString(1,outputs);   //Sets truth table output.
    } 
  }
  return truthTable;
}

int executeLogic( int logicCode, String inputs){
  int output = 0;  
  switch(logicCode){
   case 1: 
     output= logicAND_8(inputs);
     break;
   case 2:
     output = logicOR_8(inputs);
     break;
   case 3: 
     output = logicXOR_8(inputs);
     break;
   case 4:
     output = logicCUST_1(inputs);
     break;
   case 5:
     output = logicCUST_2(inputs); 
     break;
   
   
 //To Modify: add extra custom logic methods to here and to the selection menu in section 1.
   default: output = 0; break; 
   //default: output = logicAND_8(inputs); break; 
   
  }
  return output;
}

/*
* Performs AND Logic on all 8 input oscillators. Its fixed at 8 because it makes an easy template 
* for those who want to roll their own logic function.
*/
int logicAND_8(String str){
  int a,b,c,d,e,f,g,h, answer;
  int normal = int('0');
  //println("Inputs_" + str);
  a = int(str.charAt(0))-normal; //Converts String of Oscillator inputs into integers for Processing Logic.
  b = int(str.charAt(1))-normal;
  c = int(str.charAt(2))-normal;
  d = int(str.charAt(3))-normal;
  e = int(str.charAt(4))-normal;
  f = int(str.charAt(5))-normal;
  g = int(str.charAt(6))-normal;
  h = int(str.charAt(7))-normal;
  //println(a+"_&"+ b+c+d+e+f+g+h);
  answer = a & b & c & d & e & f & g & h ;
  return answer;
}

/*
* Performs OR Logic on all 8 input oscillators. Its fixed at 8 because it makes an easy template 
* for those who want to roll their own logic function.
*/
int logicOR_8(String str){
  int a,b,c,d,e,f,g,h, answer;
  int normal = int('0');
  //println("Inputs_" + str);
  a = int(str.charAt(0))-normal; //Converts String of Oscillator inputs into integers for Processing Logic.
  b = int(str.charAt(1))-normal;
  c = int(str.charAt(2))-normal;
  d = int(str.charAt(3))-normal;
  e = int(str.charAt(4))-normal;
  f = int(str.charAt(5))-normal;
  g = int(str.charAt(6))-normal;
  h = int(str.charAt(7))-normal;
  //println(a+"_|"+ b+c+d+e+f+g+h);
  answer = a | b | c | d | e | f | g | h ; 
  return answer;
}

/*
* Performs XOR Logic on all 8 input oscillators. Its fixed at 8 because it makes an easy template 
* for those who want to roll their own logic function.
*/
int logicXOR_8(String str){
  int a,b,c,d,e,f,g,h, answer;
  int normal = int('0');
  //println("Inputs_" + str);
  a = int(str.charAt(0))-normal; //Converts String of Oscillator inputs into integers for Processing Logic.
  b = int(str.charAt(1))-normal;
  c = int(str.charAt(2))-normal;
  d = int(str.charAt(3))-normal;
  e = int(str.charAt(4))-normal;
  f = int(str.charAt(5))-normal;
  g = int(str.charAt(6))-normal;
  h = int(str.charAt(7))-normal;
  //println(a+"_^"+ b+c+d+e+f+g+h);
  answer = a ^ b ^ c ^ d ^ e ^ f ^ g ^ h ; //If spinning your own logic function, change these symbols here.
  return answer;
}

String executeWaveform(int selection, String inputs){
 String output;
 switch(selection){
   case 6:
       output = waveformSIN(inputs);
       break;
   case 7:
       //output = waveformCOS(inputs);
   /*To Modify: Adding a waveform? uncomment the waveform below and add it's method.
   case 8:
       output = waveform???(inputs);
       break;
   */
   default:
       output = "0000"+"0000";
       break;
 }
   return output; 
}
/*
*Creates sin wave from incrementing addresses.
*/
String waveformSIN(String str){
  String outputs = "0000"+"0000";
  float addr = unbinary(str);
  float maxAddr = unbinary("1111"+"1111"); //Assumes 8 bit address space;
  float period = 2*3.14159;
  float scaleM = unbinary("1111"+"1111");//Vertical stretch to fit the address space;
  float scaleB = 1;
  float operation = sin(addr/maxAddr*period);
  int answer = int((operation+scaleB)*scaleM/2);
  outputs = binary(answer,outSize);
  //println(outputs+"_"+answer);
  return outputs;
}

/*
*Creates cos wave from incrementing addresses.
*/
String waveformCOS(String str){
  String outputs = "0000"+"0000";
  float addr = unbinary(str);
  float maxAddr = unbinary("1111"+"1111"); //Assumes 8 bit address space;
  float period = 2*3.14159;
  float scaleM = unbinary("1111"+"1111");//Vertical stretch to fit the address space;
  float scaleB = 1;
  float operation = cos(addr/maxAddr*period);
  int answer = int((operation+scaleB)*scaleM/2);
  outputs = binary(answer,outSize);
  //println(outputs+"_"+answer);
  return outputs;
}


/*
*Creates ??? wave from incrementing addresses.
*/
/*To Modify: Uncomment and change the operation function below.
String waveform???(String str){
  String outputs = "0000"+"0000";
  float addr = unbinary(str);
  float maxAddr = unbinary("1111"+"1111"); //Assumes 8 bit address space;
  float period = 2*3.14159;
  float scaleM = unbinary("1111"+"1111");//Vertical stretch to fit the address space;
  float scaleB = 1;
  float operation = cos(addr/maxAddr*period);//To Modify: Add your own waveform function here. Must have max/min from 1 to -1 and have a period of 2PI
  int answer = int((operation+scaleB)*scaleM/2);
  outputs = binary(answer,outSize);
  //println(outputs+"_"+answer);
  return outputs;
}
*/




/*
* To modify: Performs ???? Logic
*/
int logicCUST_1(String str){
  int a,b,c,d,e,f,g,h, answer;
  int normal = int('0');
  //println("Inputs_" + str);
  a = int(str.charAt(0))-normal; //Converts String of Oscillator inputs into integers for Processing Logic.
  b = int(str.charAt(1))-normal;
  c = int(str.charAt(2))-normal;
  d = int(str.charAt(3))-normal;
  e = int(str.charAt(4))-normal;
  f = int(str.charAt(5))-normal;
  g = int(str.charAt(6))-normal;
  h = int(str.charAt(7))-normal;
  //println(a+"_?!"+ b+c+d+e+f+g+h);
  answer = a & b & c & d & e & f & g & h ; //To Modify: If spinning your own logic function, change these symbols here.
  return answer;
}

/*
* To modify: Performs ???? Logic
*/
int logicCUST_2(String str){
  int a,b,c,d,e,f,g,h, answer;
  int normal = int('0');
  //println("Inputs_" + str);
  a = int(str.charAt(0))-normal; //Converts String of Oscillator inputs into integers for Processing Logic.
  b = int(str.charAt(1))-normal;
  c = int(str.charAt(2))-normal;
  d = int(str.charAt(3))-normal;
  e = int(str.charAt(4))-normal;
  f = int(str.charAt(5))-normal;
  g = int(str.charAt(6))-normal;
  h = int(str.charAt(7))-normal;
  //println(a+"_?!"+ b+c+d+e+f+g+h);
  answer = a & b & c & d & e & f & g & h ; //To Modify: If spinning your own logic function, change these symbols here.
  return answer;
}

/*
*Simulates a bank of 8 oscillators and creates a table of all possible states.
*/
Table OscillatorGenerator(){
  Table oscillators = new Table();
  int k = int(pow(2,NUM_OSC));
  for( int i=0; i<k; i++){
    TableRow set = oscillators.addRow();
    set.setString(0,(binary(i,NUM_OSC)));
  }
  return oscillators;
}

void printTruthTable(Table truthTable){
    for (TableRow row : truthTable.rows()) {
    println(hex(unbinary(row.getString(0)), 2)+ "_"+ hex(unbinary(row.getString(1)), 2)) ;
    }
}
void printBinaryTruthTable(Table truthTable){
    for (TableRow row : truthTable.rows()) {
    println((row.getString(0))+ "_"+ row.getString(1)) ;
    }
}

/*
*Processes a CSV and returns the Table of our addresses and outputs
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
* Given an index, a character, and a String, returns a String with that character replaced in the string at said index.
*/
String replaceCharAt(int i, char c, String repl){
 char primeRepl[] = new char[repl.length()];
 primeRepl = repl.toCharArray();
 primeRepl[i] = c;
 return new String(primeRepl); 
}