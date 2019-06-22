int eastCollisionPoint = 0;
int westCollisionPoint = 0;
boolean collisionEast = false;
boolean collisionWest = false;
boolean reachedEastBoundary = false;
boolean reachedWestBoundary = false;

boolean firstPoint = false;

int testColour = 255;

color c ; // used to check the colour of each pixel
int previousPixelLocation = 0;
int currentPixelLocation = 0;
int nextPixelLocation = 0;

int initialCountOfMagentaPixels = 0;
int initialCountOfYellowPixels = 0;
int countOfMagentaPixels = 0;
int countOfYelowPixels = 0;

int count = 0;
int startCount = 0;
float pixelsPerSqMeter = 0;

boolean previousPixelMagenta = false;
boolean currentPixelMagenta = false;
boolean nextPixelMagenta = false;
boolean insidePerimiter = false;
boolean previousState =  insidePerimiter;

float currentRed = 0;
float currentGreen = 0;
float currentBlue = 0;

float previousRed = 0;
float previousGreen = 0;
float previousBlue = 0;

float nextRed = 0;
float nextGreen = 0;
float nextBlue = 0;

float perimiterLength = 0;
int maxNumberOfPairs = 200;
int maxNumberOfPerimeters = 200;
int numberOfPerimeters  = 0; // number of perimeters measured
int numberOfPerimeterPoints = 0;
int currentPerimeterPoint = 0; // increment for each Perimeter point for all hummocks
int[] numberOfPerimeterPointsInCurrentHummock = new int[200];
float[] lengthOfEachPerimeter = new float[200];

int[] pX = new int[2000]; // store x perimeter points for all hummocks
int[] pY = new int[2000]; // store y perimeter points for all hummocks

int[] sX = new int[200]; // store starting x perimeter point for all hummocks
int[] sY = new int[200]; // store starting y perimeter point for all hummocks

int[] eX = new int[200]; // store ending x perimeter point for all hummocks
int[] eY = new int[200]; // store ending y perimeter point for all hummocks

int[] startPerimeter = new int[200]; // remember the start of perimters point for hummock numberOfPerimeters
int[] endPerimeter = new int[200]; // end of perimters points for a hummock

int numberOfCurrentPerimeter = 0;

// uses arrays to store the x  & y coordinates of up to maxNumberOfPairs measursemetn points
int[] x = new int[maxNumberOfPairs];
int[] y = new int[maxNumberOfPairs];
int i = 3; // index of array of points  start saving points after first pair of points 

// set up global variables

int imgX = 0;
int imgY = 0;

String f = "";
float textOffset = 1.04;

int gridSize = 0;
boolean scaleSet = false;
boolean scale1 = false;
boolean scale2 = false;
boolean point1 = false;
boolean point2 = false;
boolean ready = false;
boolean justStarted = true;

int saveCounter = 0;
float distance  = 0;
float measuredDistance = 0;
float sumOfMeasuredDistance = 0;

float roundedMeasuredDistance = 0;

PImage img;  // holder for the photogaph

void setup() {
  size(600, 600); 

  fill(255, 255, 0);

  img = loadImage("4000x3000.jpg");
 img.resize(0, 600);  // larger number makes for less reduction
  image(img, imgX, imgY); // display the image on the screen

  for (int i = 0; i < 50; i++) {
    println(" ");
  }
}

void draw() {

  fill(255, 255, 0);
  stroke(255, 255, 0);
//  rect(500, 500, 600, 600);
  stroke(0);

  PFont f = createFont("Arial", 20);
  textFont(f);
  textSize(20);

  ready = true;
  if (ready && justStarted) {
    println("ready");
    justStarted = false;
  }
} // end of void draw()

// each time the mouse is clicked do the following
void mouseClicked() {

  // used to measure the size of Triodia hummocks in the photo
  // Used to set the scale from the square meter in the phot
  if ((scale1 == true) && (scale2 == false)) {
    // second point on the scale has been clicked 
    x[2] = mouseX;
    y[2] = mouseY;
    scale2 = true;
    scaleSet = true;
    fill(0, 255, 0); // Green
    ellipse(x[2], y[2], 10, 10);
    fill(255, 255, 0); // Yelow
    distance = dist(x[1], y[1], x[2], y[2]);  // calculate the distance in pixels between the first 2 clicks
    pixelsPerSqMeter = distance * distance;
    println("pixelsPerSqMeter = " + pixelsPerSqMeter);
    initialCountOfYellowPixels = countYelowPixels(); // find out how many pure magenta pixels there are in the original image subtract this number from all future counts
    println("initialCountOfYellowPixels = " + initialCountOfYellowPixels);
    grid();
  }

  if (scale1 == false) {
    x[1] = mouseX;
    y[1] = mouseY;
    fill(0, 255, 0); // Green
    ellipse(x[1], y[1], 10, 10);
    fill(255, 255, 0); // Yelow
    scale1 = true;
    i = 3;
  }
} // end void mouseClicked()

void keyPressed() {

  //// not sure about this justStarted test
  //if (justStarted == true) {
  //  println("returning from keypress");
  //  return;
  //}
  //justStarted = false;


  if (key == '1' || key == '!') {
    if ((scaleSet == true) && (point1 == false)) {
      x[i] = mouseX;
      y[i] = mouseY;
      point1 = true;
      fill(255, 0, 255);
      ellipse(x[i], y[i], 10, 10);
      fill(255, 255, 0);
      i ++;  // increment i to point to next position in the array
    }
  }

  if (key == '2' || key == '@') {
    if (point1 == true) {
      x[i] = mouseX;
      y[i] = mouseY;
      point2 = true;
      point1 = false;
      fill(255, 0, 255);
      ellipse(x[i], y[i], 10, 10);
      // stroke(0);
      strokeWeight(2);
      line(x[i-1], y[i-1], x[i], y[i]);
      strokeWeight(1);
      stroke(0);
      fill(255, 255, 0);
      measuredDistance = dist(x[i-1], y[i-1], x[i], y[i]);
      saveRoundedMeasuredDistance(measuredDistance);

      f = str(roundedMeasuredDistance);
      text(f, x[i] * textOffset, y[i] * textOffset);
      i ++;  // increment i to point to next position in the array
    }
  }  // end Key 2

  // =============== start a new Perimeter for a hummock ======================
  if (key == 'n' || key == 'N') {
    firstPoint = false;
    startPerimeter[numberOfCurrentPerimeter] = currentPerimeterPoint; // remember where this perimerter begins
    // numberOfPerimeterPointsInCurrentHummock[numberOfCurrentPerimeter] = 0;
    perimiterLength = 0;
    numberOfPerimeterPoints = 0;
    pX[currentPerimeterPoint] = mouseX;
    pY[currentPerimeterPoint] = mouseY;

    // store the starting point for each perimeter
    println(" ");

    // save the starting X & Y posisiton for use when users ends the perimiter by pressing O
    sX[numberOfCurrentPerimeter] = mouseX;
    sY[numberOfCurrentPerimeter] = mouseY;
    println("+++ New numberOfCurrentPerimeter = " + numberOfCurrentPerimeter);

    println("endPerimeter["+numberOfCurrentPerimeter+"]=" + endPerimeter[numberOfCurrentPerimeter]);

    // draw the first dot in the new perimeter
    stroke(255, 0, 255); // megenta
    fill(255, 0, 255); // megenta
    ellipse(pX[currentPerimeterPoint], pY[currentPerimeterPoint], 10, 10);

    currentPerimeterPoint = currentPerimeterPoint + 1;  // store the number of perimeters for poistion in array
    numberOfPerimeters = numberOfPerimeters + 1;
  }  // End of NEW Perimeter

  // store 2nd and subsequent Perimeter points for a specific hummock
  if (key == 'p' || key == 'P') {
    firstPoint = true;
    pX[currentPerimeterPoint] = mouseX;
    pY[currentPerimeterPoint] = mouseY;
    stroke(255, 0, 255); // megenta
    fill(255, 0, 255); // megenta
    // ellipse(pX[currentPerimeterPoint], pY[currentPerimeterPoint], 10, 10);

    strokeWeight(3);
    line(pX[currentPerimeterPoint-1], pY[currentPerimeterPoint-1], pX[currentPerimeterPoint], pY[currentPerimeterPoint]);  // draw a line from the previous point to the current point
    strokeWeight(1);
    measuredDistance = dist(pX[currentPerimeterPoint-1], pY[currentPerimeterPoint-1], pX[currentPerimeterPoint], pY[currentPerimeterPoint]); // measure the distance from the previous point to the current point
    saveRoundedMeasuredDistance(measuredDistance);
    f = str(roundedMeasuredDistance);

    perimiterLength = perimiterLength + roundedMeasuredDistance;
    currentPerimeterPoint ++;  // increment the count of the number of dots around the perimeter by one
    numberOfPerimeterPoints ++;
  }


  // **************** Close the perimter for a specific hummock ***************************
  if (key == 'o' || key == 'O') {
    if (firstPoint == false) {

      return;
    }
    // next line may be redundant
    endPerimeter[numberOfCurrentPerimeter] = currentPerimeterPoint-1; // remember where this perimerter ends

    numberOfPerimeterPointsInCurrentHummock[numberOfCurrentPerimeter] = numberOfPerimeterPoints;
    println("*** numberOfPerimeterPointsInCurrentHummock["+numberOfCurrentPerimeter+"] " + numberOfPerimeterPointsInCurrentHummock[numberOfCurrentPerimeter]);
    println("*** endPerimeter[numberOfCurrentPerimeter] = " + endPerimeter[numberOfCurrentPerimeter]);
    println("***  numberOfPerimeterPoints = " + numberOfPerimeterPoints);

    // close the perimiter
    stroke(255,0,255);
    strokeWeight(3);
    line(pX[currentPerimeterPoint-1], pY[currentPerimeterPoint-1], sX[numberOfCurrentPerimeter], sY[numberOfCurrentPerimeter]);
    strokeWeight(1);

    // save the ending X & Y posisiton for use when re drawinng perimiters on WSAD movements
    eX[numberOfCurrentPerimeter] = pX[currentPerimeterPoint -1];
    eY[numberOfCurrentPerimeter] = pY[currentPerimeterPoint -1];

    measuredDistance = dist(pX[currentPerimeterPoint -1], pY[currentPerimeterPoint -1], sX[numberOfCurrentPerimeter], sY[numberOfCurrentPerimeter]);
    saveRoundedMeasuredDistance(measuredDistance);
    // println("roundedMeasuredDistance in O = " + roundedMeasuredDistance);

    perimiterLength = perimiterLength + roundedMeasuredDistance;
    perimiterLength = float(nf((perimiterLength), 0, 2)); // round off the perimeter Length to 2 desminal poinints

    f = str(perimiterLength);
    textSize(20);
    fill(255, 255, 255); // text colour
    text(f, sX[numberOfCurrentPerimeter] * textOffset, sY[numberOfCurrentPerimeter] * textOffset);
    lengthOfEachPerimeter[numberOfCurrentPerimeter] = perimiterLength;
    numberOfCurrentPerimeter = numberOfCurrentPerimeter + 1; // increment the number of perimeters
  } 
  // *********************** end Close the perimter for a specific hummock ***************************

  saveCounter ++;
  if (key == 'z' || key == 'Z') {
    save("triodia_038_" + saveCounter + ".png");
  }

  if (key == 'c' || key == 'C') {
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    fill(0, 255, 0); // Green
    ellipse(x[1], y[1], 10, 10);
    ellipse(x[2], y[2], 10, 10);

    scale1 = true;
    grid();
  }
  strokeWeight(1);

  // WSAD movement of lmage on screen WSAD WSAD WSAD WSAD WSAD WSAD WSAD WSAD 
  if (key == 'w' || key == 'W') {

    //    println("mouseX = " + mouseX);
    //    println("mouseY = " + mouseY);
    imgY = imgY - 100;

    for (int i = 0; i < 200; i++) {
      y[i]  = y[i]  - 100; // update the y points for every pair
      sY[i] = sY[i] - 100; // update the starting y Poinits for each perimeter
      eY[i] = eY[i] - 100; // update the ending y Poinits for each perimeter
      pY[i] = pY[i] - 100; // update the  y Poinits for each perimeter
    }

    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("w");
    redraw();
  }

  if (key == 's' || key == 'S') {
    imgY = imgY + 100;
    for (int i = 0; i < 200; i++) {
      y[i] = y[i]  + 100; // update the y points for every pair
      sY[i] = sY[i] + 100; // update the starting y Poinits for each perimeter
      eY[i] = eY[i] + 100; // update the ending y Poinits for each perimeter
      pY[i] = pY[i] + 100; // update the  y Poinits for each perimeter
    } 
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("s");
    redraw();
  }

  if (key == 'a' || key == 'A') {
    imgX = imgX - 100;

    for (int i = 0; i < 200; i++) {
      x[i]  = x[i]  - 100;  // update the position of each x point in the array
      sX[i] = sX[i] - 100;  // update the starting x Poinits for each perimeter
      eX[i] = eX[i] - 100;  // update the ending x Poinits for each perimeter
      pX[i] = pX[i] - 100;  // update the  x Poinits for each perimeter
    }
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("a");
    redraw();
  }

  if (key == 'd' || key == 'D') {
    imgX = imgX + 100;
    for (int i = 0; i < 200; i++) {
      x[i]  = x[i]  + 100;  // update the x points 
      sX[i] = sX[i] + 100;  // update the starting x Poinits for each perimeter
      eX[i] = eX[i] + 100;  // update the ending x Poinits for each perimeter
      pX[i] = pX[i] + 100;  // update the x Poinits for each perimeter
    }
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("d");
    redraw();
  }

  if (key == 'r' || key == 'R') {
    red();
  }

  if (key == 'y' || key == 'Y') {
    countYelowPixels();
  }


  if (key == 'b' || key == 'B') {
    //  blue();
  }

  if (key == 'i' || key == 'I') {
    area();
  }
} // end void keyPressed()

void saveRoundedMeasuredDistance(float measuredDistance) {
  roundedMeasuredDistance = float(nf((measuredDistance / distance), 0, 2));
  // println("distance in meters = " + roundedMeasuredDistance);
}

// draw a grid of dots on the screen 
void grid() {
  fill(255, 0, 0); // Red
  for (float i = 0; i < width; i = i + distance) {
    for (float j = 0; j < height; j = j + distance) {
      if (scaleSet == true) {
        ellipse(i, j, 4, 4);
      }
    }
  }
}

void redraw() {
  println("redrawing");
  if (scale1 == false && scale2 == false) {
    return;
  }

  fill(0, 255, 0); // Green
  ellipse(x[1], y[1], 10, 10);
  ellipse(x[2], y[2], 10, 10);

  for (int i = 3; i < maxNumberOfPairs - 2; i = i + 2) {
    ellipse(x[i], y[i], 10, 10); // first ellipse in the pair
    ellipse(x[i+1], y[i+1], 10, 10); // second ellipse in the pair
    stroke(255, 0, 255); // magenta
    strokeWeight(2);
    line(x[i], y[i], x[i+1], y[i+1]);
    strokeWeight(1);

    measuredDistance = dist(x[i], y[i], x[i+1], y[i+1]);
    saveRoundedMeasuredDistance(measuredDistance);

    //  println("distance in meters = " + roundedMeasuredDistance);
    f = str(roundedMeasuredDistance);
    // Text fill & stroke
    stroke(255, 255, 0); // yellow
    fill(255, 255, 0); // yellow
    text(f, x[i+1] * textOffset, y[i+1] * textOffset);
    fill(255, 0, 255); // magenta
    stroke(255, 0, 255); // magenta
  }
  count = 0;
  redrawPerimeterDots();
  redrawPerimeterLines();
  redrawPerimeterLengths();
}

void redrawPerimeterDots() {
  // redraw each perimerter set for each hummock
  for (int i = 0; i < numberOfPerimeters; i ++) {

    fill(255, 0, 255); // megenta
    for (int j = 0; j < endPerimeter[i] + 1; j ++) {      
      ellipse(pX[j + count], pY[j + count], 10, 10); 

      if (j < numberOfPerimeterPointsInCurrentHummock[i]-2) {
      }

      if (j == numberOfPerimeterPointsInCurrentHummock[i]) {
      }
    }
    count = count + numberOfPerimeterPointsInCurrentHummock[i];
    println("count = " + count);
    println(" ");
  }
}

void redrawPerimeterLines() {
  count = 0;
  // for every hummock with a perimeter
  for (int i = 0; i < numberOfPerimeters; i ++) {

    stroke(255, 0, 255);
    strokeWeight(4);

    // println("Count = " + count);
    for (int j = 0; j < numberOfPerimeterPointsInCurrentHummock[i]; j ++) {
      if (j < numberOfPerimeterPointsInCurrentHummock[i]) {
        line(pX[j+ startCount], pY[j + startCount], pX[j+startCount+1], pY[j+startCount+1]);
      }
    }
    line(eX[i], eY[i], sX[i], sY[i]);  // close the perimerter from ending x,y to starting x,y
    startCount = startCount + numberOfPerimeterPointsInCurrentHummock[i] + 1;
  }
  startCount = 0;
}


void redrawPerimeterLengths() {
  // lookup the perimiter length from array and reprint at starting point for perimeter

  for (int i = 0; i < numberOfPerimeters; i ++) {
    println("lengthOfEachPerimeter[" + i + "] = "+ lengthOfEachPerimeter[i]);

    f = str(lengthOfEachPerimeter[i]);
    textSize(20);
    fill(255, 0, 255); // text colour
    text(f, sX[i] * textOffset, sY[i] * textOffset);
  }
}

int countMagentaPixels() {
  // http://learningprocessing.com/examples/chp15/example-15-07-PixelArrayImage#

  loadPixels();   // We call loadPixels() on the PImage to read its pixels.

  for (int y = 0; y < height; y++ ) {
    for (int x = 0; x < width; x++ ) {
      int loc = x + y*width;
      // The functions red(), green(), and blue() pull out the three color components from a pixel.
      float r = red(pixels [loc]); 
      float g = green(pixels[loc]);
      float b = blue(pixels[loc]);

      if (r > testColour && b > testColour && g < testColour) {
        // Pixel should be magenta ish
        countOfMagentaPixels ++;
      }

      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, before setting the pixel in the display window.

      // Set the display pixel to the image pixel
      //  pixels[loc] = color(r, g, b);   // no need to re draw the image to the screen in this program
    }
  }
  println(" *** countOfMagentaPixels = " + countOfMagentaPixels);
  return(countOfMagentaPixels);
}


int countYelowPixels() {
  // http://learningprocessing.com/examples/chp15/example-15-07-PixelArrayImage#
  loadPixels();   // We call loadPixels() on the PImage to read its pixels.

  for (int y = 0; y < height; y++ ) {
    for (int x = 0; x < width; x++ ) {
      int loc = x + y*width;
      // The functions red(), green(), and blue() pull out the three color components from a pixel.
      float r = red(pixels [loc]); 
      float g = green(pixels[loc]);
      float b = blue(pixels[loc]);

      if (r == 255 && g == 255 && b ==0) {
        countOfYelowPixels ++;
      }
    }
  }
  println("countOfYelowPixels = " + countOfYelowPixels);
  println("Area = " + countOfYelowPixels / pixelsPerSqMeter);
  return(countOfYelowPixels);
}

void red() {
  // http://learningprocessing.com/examples/chp15/example-15-07-PixelArrayImage#

  loadPixels();   // We call loadPixels() on the PImage to read its pixels.

  for (int y = 0; y < height; y++ ) {
    for (int x = 0; x < width; x++ ) {
      int loc = x + y*width;
      // The functions red(), green(), and blue() pull out the three color components from a pixel.
      float r = red(pixels [loc]); 
      float g = green(pixels[loc]);
      float b = blue(pixels[loc]);
      pixels[loc] = color(r, 0, 0);   // no need to re draw the image to the screen in this program
    }
  }
  updatePixels();
}

boolean checkPixelEast(int x, int y) {
  color c = get(x + 1, y); 
  if (c != #FF00FF) {  // if test point is NOT on a magenta pixel
    collisionEast = false;
    x = x + 1; // move to next pixel East
    if (x == width || x > width) {
      reachedEastBoundary = true;
    } else {
      reachedEastBoundary = false;
    }
  }

  if (reachedEastBoundary == false) {
    if (c == #FF00FF) { // we hit a megenta pixel
      collisionEast = true;
      eastCollisionPoint = x;
      return true;
    }
    checkPixelEast(x, y);  // recursive call keep looking until you hit a boundary
  }
  return false;
} // End East


boolean checkPixelWest(int x, int y) {
  color c = get(x-1, y); // Look West 1 pixel
  if (c != #FF00FF) {  // if test point is NOT on a magenta pixel
    collisionWest = false;
    x = x - 1; // move to next pixel West
    if (x == 0 || x < 0) {
      reachedWestBoundary = true;
    } else {
      reachedWestBoundary = false;
    }
  }

  if (reachedWestBoundary == false) {

    if (c == #FF00FF) { // we hit a megenta pixel
      collisionWest = true;
      westCollisionPoint = x;
      return true;
    }
    checkPixelWest(x, y);
  }
  return false;
} // End West

void area() {
  int x = mouseX;
  int y = mouseY;
  int initialX = x;
  int initialY = y;

  // Check North
  while (get(x, y) != #FF00FF) {
    checkPixelEast(x, y); 
    checkPixelWest(x, y); 
    stroke(255, 255, 0);
    line(eastCollisionPoint, y, westCollisionPoint, y);
    if (y > 0) {
      y = y - 1;
    }
  }

  // Check South
  y = initialY;
  while (get(x, y) != #FF00FF) {
    checkPixelEast(x, y); 
    checkPixelWest(x, y); 
    stroke(255, 255, 0);
    line(eastCollisionPoint, y, westCollisionPoint, y);
    y = y + 1;
  }
}  // end mouse clicked
