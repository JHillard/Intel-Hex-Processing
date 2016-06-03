PrintWriter writer;
Table table;
int addrSize = 2;
int outSize = 1;
int[] values = new int[addrSize];
String TruthTable = "test.csv";
String addrName = "addr";
String outName = "out";

void setup() {
  Table truthTable;
  truthTable = CSVprocess();

  writer = createWriter("TestPad.hex");
  String testString = "Mic Check, Mic Check 2,2,3";
  writer.println(table);
  writer.flush();
  writer.close();
  println(truthTable.getString(0,0)); 
  exit();
}


Table CSVprocess(){
  
  Table table;
  Table truthTable = new Table();
  table = loadTable(TruthTable,"header");
  //String[][] truthTable = new String[table.getRowCount()][2];
  int rowNum = 0;
  for (TableRow row: table.rows()){
    String addr ="";
    String out = "";
    for (int i=1; i<=addrSize; i++){
      addr = addr +row.getString(addrName+i);
    }
    for (int i=1; i<=outSize; i++){
      out = out + row.getString(outName+i);
    }
    truthTable.addRow();
    truthTable.setString(rowNum, 0, addr);
    truthTable.setString(rowNum,1, out);
    println(rowNum+"_"+addr + "_" + out);
    rowNum++;
  }
  
return truthTable;
}