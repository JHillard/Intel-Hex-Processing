//Possible Bugs:
//Processing only deals with signed integers, so when converting the binary into hex, there's a chance that
//Signs get in the way. 

//Second Possible Bug; Wikipedia Article on Intel Hex says the Record Checksum should be calculated using the LSB's two's complement. But then goes on to use the
//two least signifigant digits in its calculation. The C intel hex lib also seems to use the two LSD checksum calculation method. This all works well now, but then what
// is up with wikipedia?


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


void setup() {
  Table recordTable;
  Table truthTable;
  //truthTable = CSVprocess();
  //recordTable = createIHex(truthTable); 
  //for (TableRow row :recordTable.rows()){
  // println(row.getString(0));   
  //}
   Table inputs = OscillatorGenerator();
   truthTable = logicProcessor(inputs);
   //printAddresses(truthTable);
   println("Outputs");
   printTable(truthTable);
   //recordTable = createIHex(truthTable);
   
   exit();
}

Table logicProcessor(Table inputs){
   Table truthTable = new Table();
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
  a = int(str.charAt(0))-normal;
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