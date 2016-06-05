//Where we can test all the functionality of the table grouping function.
void setup(){
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
  row1.setString("Memory Bank", "0010");
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
}

Table tableGrouper(Table waveforms){
 Table groupedWaves = new Table();
  groupedWaves.addColumn("Memory Bank", Table.STRING);
  groupedWaves.addColumn("Pin", Table.STRING);
  groupedWaves.addColumn("Logic", Table.STRING);
 //groupedWaves: MemBank, pin1_pin2_pin3....pinN, Logic1_....LogicN;
  for( TableRow row : waveforms.rows()){
    String bank = row.getString("Memory Bank");
    String newPin = "" + row.getInt("Pin");
    String newLogic = "" + row.getInt("Logic");
    String oldPins, oldLogics;
    TableRow bankRow;
    try{
      bankRow = groupedWaves.findRow(bank, "Memory Bank");
      oldPins = bankRow.getString("Pin");
      oldLogics = bankRow.getString("Logic");
    }catch(Exception e){
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

void printWaveform(Table waveform){
  try{
    for (TableRow row : waveform.rows()) {
      println(row.getString("Memory Bank") +"|" + row.getString("Pin") +"|" + row.getString("Logic") );
      }
  }catch(Exception e){
      for (TableRow row : waveform.rows()) {
      println(row.getString("Memory Bank") +"|" + row.getInt("Pin") +"|" + row.getInt("Logic") );
      }  
  }
    
}