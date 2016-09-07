import javax.script.*;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;


void setup() {
  println("hi");
  //Double x= xmain();
  print(evalLogicString("a|b", 0,1,0,0,0,0,0,0));
  //print(generateFullLogic("a&b"));
  print(generateFullLogic("a|b"));
  //println("X is: " +(x));
}



//Solved the import error: http://stackoverflow.com/questions/22502630/switching-from-rhino-to-nashorn
//Basic Code from:
//Handling the datatypes; http://www.tutorialspoint.com/java/lang/object_getclass.htm

int NUM_OSC = 8;
String generateFullLogic(String logicFunction){
    String varInit = "var a = 0; ";
    varInit = varInit + "var b = 0; ";
    varInit = varInit + "var c = 0; ";
    varInit = varInit + "var d = 0; ";
    varInit = varInit + "var e = 0; ";
    varInit = varInit + "var f = 0; ";
    varInit = varInit + "var g = 0; ";
    varInit = varInit + "var h = 0; ";
    String scriptInit = "var k = " + str(int(pow(2,NUM_OSC))) + ";";
    scriptInit+= "print(\"\\nParsed Logic Function: "  + logicFunction + "\");";
    String forLoop  = "";
    forLoop += "var answer = \"\"; ";
    forLoop += "for(i=0; i<k; i++){";
    forLoop += "   var binStr = (i+" + str(int(pow(2,NUM_OSC)))+ ").toString(2).substring(1); "; //Substring and adding 2^8 gives zero padding
    forLoop += "   a = binStr[0];";
    forLoop += "   b = binStr[1];";
    forLoop += "   c = binStr[2];";
    forLoop += "   d = binStr[3];";
    forLoop += "   e = binStr[4];";
    forLoop += "   f = binStr[5];";
    forLoop += "   g = binStr[6];";
    forLoop += "   h = binStr[7];";
    forLoop += "   var stagedAnswer = " + logicFunction + ";";
    forLoop += "   answer += stagedAnswer + \",\";";
    forLoop += "   print(binStr+\"_\"+stagedAnswer);";
    forLoop += "}";
    ScriptEngineManager mgr = new ScriptEngineManager();
    ScriptEngine engine = mgr.getEngineByName("javascript");
    try {
      String initCode = "load(\"nashorn:mozilla_compat.js\"); importPackage(java.util);"; // The load statement makes the script engine compatible with the importPackage call.
      engine.eval(initCode);
      engine.eval(varInit+scriptInit);
      engine.eval(forLoop);
      String answer = engine.get("answer").toString();

      return answer;
      //x =a;  
    }
    catch (Exception e) {
      println("ERROR; Perhaps bad Logic Function?");
      e.printStackTrace();
    } 
    
    return "Logic Failed. Please Try again.";
}
 
/*
*Given a logic function and string of 0,1 inputs, evaluates a single answer to the logic function. Useful for debugging, not used in final truth table generation.
*/
boolean evalLogicString(String logicFunction, int a, int b, int c, int d, int e2, int f, int g, int h){
 String varCode = "var a = " +str(a) + "; ";
 varCode = varCode +  "var b = " +str(b) + "; ";
 varCode = varCode +  "var c = " +str(c) + "; ";
 varCode = varCode +  "var d = " +str(d) + "; ";
 varCode = varCode +  "var e = " +str(e2) + "; ";
 varCode = varCode +  "var f = " +str(f) + "; ";
 varCode = varCode +  "var g = " +str(g) + "; ";
 varCode = varCode +  "var h = " +str(h) + "; ";
ScriptEngineManager mgr = new ScriptEngineManager();
ScriptEngine engine = mgr.getEngineByName("javascript");
try {
  String initCode = "load(\"nashorn:mozilla_compat.js\"); importPackage(java.util);";
  engine.eval(initCode);
  engine.eval(varCode);
  engine.eval("var answer = " + logicFunction + ";");
  String answer = engine.get("answer").toString();
  boolean boolAnswer = !answer.equals("0");
  return boolAnswer;
}
catch (Exception e) {
  println("ERROR; Perhaps bad Logic Function?");
  e.printStackTrace();
}   
 return false; 
}