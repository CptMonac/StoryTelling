//Author: CptMonac
//Modified from Google Image Search code by Youssef Faltas
//Displays images based on speech prompts 
 
import com.getflourish.stt.*;
import ddf.minim.*;

int imgCount = 10;  
String searchTerm;
String imgLink;
PImage searchImage, defaultImage;
STT microphone;
float elapsedTime;
boolean recordAudio;
               
void setup()
{
  size(800,800);
  microphone = new STT(this);
  microphone.enableDebug();
  microphone.setLanguage("en");
  //microphone.enableAutoRecord();

  textFont(createFont("Arial", 24));
  defaultImage = loadImage("prompt.jpg");
  searchTerm = "Say something!";
  imgLink = null;
  elapsedTime = second();
  recordAudio = true;
}
  
void draw()
{
 background(128);
 if (recordAudio)
 {
   microphone.begin();
 }
 if ((second() - elapsedTime) > 1.5)
 {
   microphone.end();
   elapsedTime = second();
   recordAudio = false;
 }

 if (imgLink != null)
 {
 	  searchImage = loadImage(imgLink, "jpg");
    image(searchImage, 0, 0, width-200, height);
 }
 else 
    image(defaultImage, 0, 0, width-200, height); 

 text(searchTerm, width-200, height - 100, 200, 200); 
}
  
// Method is called if transcription was successfull 
void transcribe (String utterance, float confidence) 
{
  JSONArray results;	     //Store image array
  JSONObject ServerResponse; //Store initial server response
  JSONObject imageObject;    //Store image objects

  //Update search term
  searchTerm = utterance;
  
  //Request images based on search term
  utterance = utterance.replaceAll(" ", "%20");
  String url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+utterance+"&as_filetype=jpg"+"&imgsz=large"+"as_rights=cc_publicdomain";
  ServerResponse = loadJSONObject(url);
  ServerResponse = ServerResponse.getJSONObject("responseData");
  results = ServerResponse.getJSONArray("results");
  
  //Store image url
  imageObject = results.getJSONObject(int(random(results.size())));
  imgLink = imageObject.getString("unescapedUrl");
  recordAudio = true;
}

public void keyPressed()
{
  microphone.begin();
}

public void keyReleased()
{
  microphone.end();
}
