/*---------------------------------------------------------------------------------------------------*\
|"The legonator" Change the world you see into familiar legos like you know and love                  |
|version 2.1.1                                                                                        |
|Works with processing 3.5.4                                                                          |
|Made by Amjad Azimane, student idea to design, studentnumber: 1697560,                               |  
|Made in 2021, for course number DBB100                                                               |
|Sources: I learnt how to install the camera into your processing code through                        |
|the processing.video library documentation and the youtubechannel codetrain                          |
|IMPORTANT BEFORE YOU START:                                                                          |
|This program makes use of the video library. Install the library by going to tools ->                |
|add tool -> Libraries -> filter on video -> and install the one made by The processing foundation.   |
\*---------------------------------------------------------------------------------------------------*/


import processing.pdf.*; //using the pdf library built in processing to make pdfs later on
import processing.video.*; //a downloadable video library from the processing foundation, to use the built-in camera
Capture video; //using capture, from processing.video, to capture video later on.

//legoblocksvariables
float offset; // I used this to set the round shapes in the lego block itself, sticking it to a position
float rectwidth, rectheight; //this is to indicate the size of the lego blocks

//Colorvalues
float colorhue, colorsaturation, colorbrightness; //this is to assign hsb values later on to the lego bricks
float averagehue = 0, averagebrightness, averagesaturation, hueadding, brightnessadding, saturationadding;
int averagecounter;
//recordvariables
boolean record;
int recordcount;
String recordstring;

void setup() {
  size(1300, 990);
  video = new Capture(this, 15*90, 11*90, "pipeline:autovideosrc"); //we are basically saying that we want to capture the camera with a ratio of 11:15 times 90,to make it bigger. The pipeline is a specific way to capture video, if left out the capturing only works on select devices, while this pipeline makes the code work on more devices. 
  video.start(); //simply states that the capturing should start in the beginning of the code
}
void draw() {
  if (record) { //this part is to turn the code into a pdf
    recordcount++; //every time you try to record something, i increases with one;
    recordstring = "MyAmazingLegoFace" + recordcount + ".pdf"; //this is to create the file name of the pdf
    beginRecord(PDF, recordstring); //So what happens, is that the first time you click to make a pdf, it turns the name into MyAmazingLegoFace1, and then MyAmazingLegoFace2 etc. This is to be able to make multiple itterations of the code, and choose the best one later on.
    println("PICTURE TAKEN, NAME: " + recordstring); //Sends a message, saying a picture is taken
  }

  offset = rectwidth/4; //the offset of the round parts of the lego brick, is dependent on the rectwidth, this is so that the brick will be easily resizable without any malfunctions. 
  rectwidth = map(mouseX, 0, width, 30, 50); //the width of the cube is mapped to the x-coordinate of the mouse, in the window. If you start at the left its 10, which increases the more you go to the right, with a maximum of 50.
  rectheight = rectwidth; //the original idea was to map the rectheight to the y-coordinate of the mouse. This is still possible, however i liked the square lego bricks, since the lego bricks are the most recognizable when squared. Hence I just equalized it to the width.
  colorMode(HSB, 100); //I liked to play around with HSB more than rgb, because it gave me more understanding of what will be displayed, which can be played with, with filters. I also liked the simplicity of turning the normally 255, to 100. Much easier to understand.
  background(0); //this is the color of the space in between the bricks, which is set to black.

  for (int i = 0; i < width/rectwidth; i++) { //make lego bricks as much as the lego bricks fit horizontally on the screen
    for (int ii = 0; ii < height/rectheight; ii++) {//make lego bricks as much as the lego bricks fit vertically on the screen
      color c = video.get(int(width-(i*rectwidth)), int(ii*rectwidth));  //look at the video, look underneath every lego brick which is drawn, pick the color, and store it in a (x,y,z) format in "c". The width-(i*rectwidth) instead of the (i*rectwidth) is done to mirror the camera to the viewer. This is more satisfying to use, so you have more feeling of how you want to setup your picture.
      colorhue = hue(c); //Store the hue of the color you picked in this variable colorhue
      colorbrightness = brightness(c); //Store the brightness of the color you picked in this variable brightnesshue
      colorsaturation = saturation(c); //Store the saturation of the color you picked in this variable saturationhue
      body(i*rectwidth, ii*rectheight); //fill up the screen with lego bricks
      //Average colours of all pixels, to turn the frame of the pic into the average colour of the picture
      averagecounter++; //count how many times we are doing this, to shove into the average equation
      
      hueadding = hueadding + hue(c); // average = adding all numbers/ the amount of numbers. Averagecounter is the amound of numbers. Adding all numbers is "hue"adding, or any other adding.
      averagehue = hueadding/averagecounter; //The actual equation of the average.

      saturationadding = saturationadding + saturation(c);//Same as hueadding, but with saturation
      averagesaturation = saturationadding/averagecounter;

      brightnessadding = brightnessadding + brightness(c);//Same as hueadding, but with brightness
      averagebrightness = brightnessadding/averagecounter;
    }
  }
  if (averagecounter > 1000){ //This piece resets the average colour every 1000 times it calculates the average. If you exclude this code, it calculates the average of everything since you start the code.
    averagecounter = 0;
    hueadding = 0;
    saturationadding = 0;
    brightnessadding = 0;
  }


  for (int i = 0; i < width/rectwidth; i++) { //This makes the actual border
    colorhue = averagehue; //assigning all average values to the color values of the bricks
    colorsaturation = averagesaturation*4; //the saturation is added a little bit, thought its aesthetically pleasing
    colorbrightness = averagebrightness;
    //These are making seperate rows of blocks above the already coloured blocks
    body(i*rectwidth, rectwidth*(height/rectwidth - 1));   //the minus 1 is for the row to appear inside of the sketch, instead of one row just outside. Height/rectwidth calculates how many bricks fit in the sketch, where the bricks are drawn in the last possible row inside the sketch.
    body(rectwidth*(width/rectwidth - 1), i*rectwidth);
    body(0, i*rectwidth);
    body(i*rectwidth, 0);
  }

  if (record) { //the code between startrecord and endrecord gets shoved into a pdf, and makes the boolean record false so you can record again by making it true. This makes it possible to record multiple pdfs during one setting, without resetting the code.
    endRecord();
    record = false;
  }
}
void mousePressed() {//if you press the mouse, record
  record = true;
}
void captureEvent(Capture video) {// only record video depending on the framerate of the video. If its 20 fps then only record video 20 times a second, instead of the 60 fps in update(). A performance enhancement code.
  video.read();
}
void body(float x, float y) { //this is the creation of the legobrick, its all dependant on eachother, so you can resize it easily. I know there is an actual resize() function in processing, but I preferred this method more due to adjusting it to my liking. Only the translation is not dependent on the rest, which makes the shadow of the circles of the brick relatively smaller once the entire brick gets smaller. I liked this effect ,so I kept it as a constant.
  //THE BRICK BODY
  fill(colorhue, colorsaturation*3/2, colorbrightness); //I wanted the image to be a little bit more saturated than the original camera output, looked more alive like real lego bricks. They are known for their saturated colours.
  rect(x, y, rectwidth, rectheight, 10);//draw the brick
  //THE BRICK SHADOW
  translate(2, 2);
  fill(colorhue, colorsaturation*3/2, colorbrightness/2);//I wanted the shadow not to be pure dark, but a little darker than the rest like real shadows are. So the shadows are never true dark, this is achieved by deviding the brightness by two.
  circles(x, y); // Draw the circles the same coordinates as the brick
  //THE BRICK CIRCLES
  translate(-2, -2);//the shadows got shifted from its original position, and the real cirlces got shifted back, I did this in this order so the real circles get on top of the shadow.
  fill(colorhue, colorsaturation*3/2, colorbrightness*7/5);// I wanted the circles to be a little bit brighter than the brickbody
  circles(x, y); //inserting the circles into the brick, above the shadow
}

void circles(float x, float y) {//this is how every specific circle gets drawn in the brick, all using variables to have a relative position dependent on the width of the brick
  ellipse(x + offset, y + offset, rectwidth/3, rectwidth/3); //left top
  ellipse(x + rectwidth - offset, y + offset, rectwidth/3, rectwidth/3); //right top
  ellipse(x + rectwidth - offset, y + rectheight - offset, rectwidth/3, rectwidth/3); //right bottom
  ellipse(x + offset, y + rectheight - offset, rectwidth/3, rectwidth/3); //left bottom
  // You can also change the offset to make the circles get more near eachother, or change the rectheight to make the brick longer. Its all customizable. No need to change every variable.
}
