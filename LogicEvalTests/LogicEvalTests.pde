import javax.script.*;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;


void setup() {
  println("hi");
  //Double x= xmain();
  print(evalLogicString("a&&b", 0,1,0,0,0,0,0,0));
  //println("X is: " +(x));
}

//Solved the import error: http://stackoverflow.com/questions/22502630/switching-from-rhino-to-nashorn
//Basic Code from:
//Handling the datatypes; http://www.tutorialspoint.com/java/lang/object_getclass.htm

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
  String jsCode = "var xxx = 2+2; ";
  engine.eval(initCode);
  engine.eval(jsCode);
  engine.eval(varCode);
  engine.eval("var answer = " + logicFunction + ";");
  String answer = engine.get("answer").toString();
  println(answer);
  boolean boolAnswer = !answer.equals("0");
  return boolAnswer;
  //x =a;  
}
catch (Exception e) {
  e.printStackTrace();
} 
 
  
 return false; 
}


//Double xmain() {
//  Double x=1d;
//  ScriptEngineManager mgr = new ScriptEngineManager();
//  ScriptEngine engine = mgr.getEngineByName("javascript");
  
//  try {
//    String initCode = "load(\"nashorn:mozilla_compat.js\"); importPackage(java.util);";
//    String jsCode = "var xxx = 2+2; ";
//    engine.eval(initCode);
//    engine.eval(jsCode);
//    //print(engine.get("xxx").getClass());
//    java.lang.Object hi = engine.get("xxx").getClass();
//    print(hi);
//    //x =a;  
//}
//  catch (Exception e) {
//    e.printStackTrace();
//  }
//  return x;
//}