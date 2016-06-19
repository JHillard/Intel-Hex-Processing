PrintWriter writer;
Table table;
int addrSize = 2;
int outSize = 8;
int[] values = new int[addrSize];
String TruthTable = "test.csv";
String addrName = "addr";
String outName = "out";

void setup() {
  
  Table truthTable;
  truthTable = CSVprocess();
  createIHex(truthTable);

  writer = createWriter("TestPad.hex");
  String testString = "Mic Check, Mic Check 2,2,3";
  writer.println(table);
  writer.flush();
  writer.close();
  println(truthTable.getString(0, 0)); 
  

  exit();
}

Table createIHex(Table truthTable) {
  String iHexLine = "";
  Boolean firstAdress = true;
  String record = "";
  String recordAddr = "";
  String currAddr = "";
  String lastAddr = "";
  String recordData = "";
  String hexByte = "";
  int byteCount = 0;
  Table recordTable = new Table();
  final int byteLimit = 16;  //16 is the typical byteCount per record in IntelHex;
  
  for (TableRow row : truthTable.rows()) {
    hexByte = hex(unbinary(row.getString(1)), 2);
    currAddr = hex(unbinary(row.getString(0)), 2);
    if( isSequential(lastAddr,currAddr) && !firstAdress && byteCount < byteLimit){ //Test to determine whether to start
    //a new record (new line), or continue concantinating data.
     recordData = recordData + hexByte;
     byteCount++;
    }else{//Need to start a new record!
      TableRow newRow = recordTable.addRow();
      newRow.setString(0, processRecord(recordAddr, recordData));
      
      recordAddr = hex(unbinary(row.getString(0)), 2);       
      recordData = currAddr;
    }
    lastAddr = currAddr;
  
}//end for    
  return recordTable;
}

String processRecord(String recordAddr, String recordData){
  return "hi";
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
*Processes the CSV and returns the Table of our addresses and outputs
 */
Table CSVprocess() {
  Table table;
  Table truthTable = new Table();
  int rowNum = 0;
  table = loadTable(TruthTable, "header");
  
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
    println(rowNum+"_"+addr + "_" + out);
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