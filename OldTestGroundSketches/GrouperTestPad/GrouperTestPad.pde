//Where we can test all the functionality of the table grouping function.
void setup() {
  Table WaveformSelection = new Table();
  Table groupedWaveforms = new Table();

  WaveformSelection.addColumn("Memory Bank", Table.STRING);
  WaveformSelection.addColumn("Pin", Table.INT);
  WaveformSelection.addColumn("Logic", Table.INT);

  //Generating Test bench WaveformSelection
  TableRow row = WaveformSelection.addRow();
  row.setString("Memory Bank", "0010");
  row.setInt("Pin", 0);
  row.setInt("Logic", 2);

  TableRow row1 = WaveformSelection.addRow();
  row1.setString("Memory Bank", "1010");
  row1.setInt("Pin", 2);
  row1.setInt("Logic", 2);

  TableRow row2 = WaveformSelection.addRow();
  row2.setString("Memory Bank", "0010");
  row2.setInt("Pin", 5);
  row2.setInt("Logic", 34);

  TableRow row3 = WaveformSelection.addRow();
  row3.setString("Memory Bank", "0010");
  row3.setInt("Pin", 9);
  row3.setInt("Logic", 21);

  TableRow row4 = WaveformSelection.addRow();
  row4.setString("Memory Bank", "1010");
  row4.setInt("Pin", 0);
  row4.setInt("Logic", 2);

  TableRow row5 = WaveformSelection.addRow();
  row5.setString("Memory Bank", "1010");
  row5.setInt("Pin", 1);
  row5.setInt("Logic", 3);

  groupedWaveforms = tableGrouper(WaveformSelection);
  printWaveform(WaveformSelection);
  println("^Before  vAfter");
  printWaveform(groupedWaveforms);
  String pinString = groupedWaveforms.getRow(1).getString(1);
  String logicString = groupedWaveforms.getRow(1).getString(2);
  Table pins = new Table();
  pins.addColumn("Pin", Table.INT);  
  pins = StringToTable(pinString, pins, 0);
  Table logic = new Table();
  logic.addColumn("Logic", Table.INT);
  logic= StringToTable(logicString, logic, 0);
  Table pinAndLogic= pairTwoIntTables(pins, logic);
  printIntTable(pinAndLogic);
}
//==============================================


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
*
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
 *
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