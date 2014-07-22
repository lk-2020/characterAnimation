
/*
 *
 * androidMultiTouch.pde
 * Shows the basic use of MultiTouch Events
 *
 */

//-----------------------------------------------------------------------------------------
// IMPORTS
import android.view.MotionEvent;
//-----------------------------------------------------------------------------------------
// VARIABLES

static int tempp;
int TouchEvents;
float xTouch[], playX;
float yTouch[], playY;
int currentPointerId = 0;
boolean printFPS;

int it=0, iter=0;

float x0, y0, x1, y1, a_x0, a_y0, a_x1, a_y1, yell_x, yell_y, y_x, y_y;
double yellow_x[];
double yellow_y[];
int outWidth = 2560;
int outHeight = 1600;

float rightHandJoint0, rightHandJoint1, leftHandJoint0, leftHandJoint1;
boolean first = true;
boolean touchEvent = false;
boolean noZero = false;

//centroid
float area, sumArea;
float centroidFrac;

boolean animate = false;
boolean record = false;

//face
int yellowFaceSize = 300;

//hands
int whiteSkeletonXincr = 150;

int whiteRightHandJointX = 150+whiteSkeletonXincr;
int whiteRightHandJointY = 304;
int whiteLeftHandJointX = whiteRightHandJointX-110;
int whiteLeftHandJointY = 304;
int yellowFaceX = 700;
int yellowFaceY = 720/2;
int whiteSkeletonX = 100+whiteSkeletonXincr;
int whiteSkeletonY = 720/2;


public class xandy
{
  public double x;
  public double y;
}

//-----------------------------------------------------------------------------------------

void setup() {
  //size(displayWidth, displayHeight);
  size(1280, 720);
  orientation(LANDSCAPE);
  background(0);
  fill(0, 0, 244);
  //rect(100, 100, 100, 100);
  stroke(255);
  rectMode(CENTER);
  //ellipseMode(CORNERS);

  // Initialize Multitouch x y arrays
  xTouch = new float [10];
  yTouch = new float [10]; // Don't use more than ten fingers!
  yellow_x = new double[100000];
  yellow_y = new double[100000];
}

//-----------------------------------------------------------------------------------------

void draw() {
  if (animate == false)
  {
    iter=0;// variable to store the actions
    background(0);

    if (record == true)
      drawRecordButton_afterClicked();
    if (record == false)
      drawRecordButton_unClicked();


    drawYellowChar();
    drawWhiteChar();
    drawWhiteSkeleton();
    drawBlueCirclesOnTouch();
    ifTouchEventIs2();


    if (((xTouch[0]!=0)&&(yTouch[0]!=0))&&(touchEvent==true)) 
    {
        strokeWeight(25);
        stroke(255, 255, 0);
        line(yellowFaceX-whiteSkeletonXincr+yellowFaceSize, whiteRightHandJointY-15, yell_x, yell_y);// yellow right hand
        line(yellowFaceX-whiteSkeletonXincr, whiteLeftHandJointY-15, yell_x, yell_y);// yellow left hand
    }

    noStroke();
    fill(0, 255, 180);
    rect(900, 100, 100, 50, 15);//PLAY BUTTON

    textSize(20);
    fill(255);
    text("RECORD", 875-122, 105);

    if ((xTouch[0]<950-120)&&(xTouch[0]>850-120)&&(yTouch[0]>75)&&(yTouch[0]<125))
    {
      record = true;
    }

    textSize(20);
    fill(255);
    text("PLAY", 875, 105);
    // if play clicked
    playX = xTouch[0];
    playY = yTouch[0];
    if ((playX<950)&&(playX>850)&&(playY>75)&&(playY<125))
    {
      playX = 0.0;
      playY = 0.0;
      animate = true;
      xTouch[0] = 0.0;
      yTouch[0] = 0.0;
      println("xTouch[0] " + xTouch[0]);
      println("yTouch[0] " + yTouch[0]);
    }
  }

  else if (animate == true)
  {
    record = false;
    if (it != 0)
    {
      background(255);
      iter++;
      if (!((yellow_x[iter] == 0.0)||(yellow_y[iter] == 0.0)))
      {
        noZero = true;
      }

      if (noZero == true)
      {
        if (yellow_x[iter] != 0.0)
          y_x=(int)yellow_x[iter];

        if (yellow_y[iter] != 0.0)
          y_y=(int)yellow_y[iter];

        drawYellowChar();

        strokeWeight(25);
        stroke(255, 255, 0);
        line(whiteRightHandJointX+yellowFaceX-whiteSkeletonXincr, whiteRightHandJointY-15, y_x, y_y);// yellow hand
      }
      if (iter == it)
      {
        animate = false;
        it = 0;
      }
    }
    else if (it == 0)
    {
      animate = false;
    }
  }
}



//-------------------------------------------------------------------------------
void drawRecordButton_unClicked()
{
  noStroke();
  fill(0, 255, 180);
  rect(900-110, 100, 100, 50, 15);// REOCRD BUTTON
}


void drawRecordButton_afterClicked()
{
  noStroke();
  fill(255, 0, 0);
  rect(900-110, 100, 100, 50, 15);// REOCRD BUTTON
}


void drawYellowChar()
{
  noStroke();
  fill(255, 255, 0);
  rect(yellowFaceX, yellowFaceY, 300, 300, 15);// yellow face

  fill(0); 
  ellipse(yellowFaceX-75, yellowFaceY+25, 30, 40);//eye left
  ellipse(yellowFaceX+75, yellowFaceY+25, 30, 40);//eye right

  //mouth
  noFill();
  strokeWeight(5);
  stroke(0);
  arc(yellowFaceX-75+75, yellowFaceY+25+25, 75, 75, 0, PI, OPEN);
}


void drawWhiteChar()
{
  //white left body
  noFill();
  stroke(255);
  rect(whiteSkeletonX, whiteSkeletonY, 160, 160, 15);
}

void drawWhiteSkeleton()
{
  strokeWeight(5);
  stroke(0, 180, 255, 180);
  noFill();

  if ((xTouch[0]==0)&&(yTouch[0]==0)) 
  {
    strokeWeight(25);
    stroke(255);
    line(whiteRightHandJointX, whiteRightHandJointY, 300+100, 200); //white hand skeleton

    fill(255, 255, 255);
    noStroke();
    rect(whiteSkeletonX, whiteSkeletonY, 160, 160, 15); //white left skeleton
  }
}

void drawBlueCirclesOnTouch()
{
  if ((xTouch[0]!=0)&&(yTouch[0]!=0)) 
  {
    for (int i = 0; i < xTouch.length; i++) {
      ellipse(xTouch[i], yTouch[i], 150, 150);
    }
  }
}


void ifTouchEventIs2()
{
  if (TouchEvents == 2)
  {

    rightHandJoint0 = sqrt(pow(xTouch[0]-(whiteRightHandJointX), 2) + pow(yTouch[0]-(whiteRightHandJointY), 2));
    rightHandJoint1 = sqrt(pow(xTouch[1]-(whiteRightHandJointX), 2) + pow(yTouch[1]-(whiteRightHandJointY), 2));
    
    leftHandJoint0 = sqrt(pow(xTouch[0]-(whiteLeftHandJointX), 2) + pow(yTouch[0]-(whiteLeftHandJointY), 2));
    leftHandJoint1 = sqrt(pow(xTouch[1]-(whiteLeftHandJointX), 2) + pow(yTouch[1]-(whiteLeftHandJointY), 2));

    strokeWeight(5);
    stroke(255, 255, 255);
    if ((rightHandJoint1<25)) // right joint id touchId[1]
    {
      stroke(255, 0, 0);
      noFill();
      rect(whiteSkeletonX, whiteSkeletonY, 167, 167, 15);//white left skeleton highlighted in red to show the correct placement
      touchEvent = true;
      line(whiteRightHandJointX,whiteRightHandJointY, xTouch[0], yTouch[0]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
      x0 = (xTouch[0]-whiteRightHandJointX)+(yellowFaceX+whiteSkeletonXincr);
      y0 = yTouch[0]-15;
      yellow_x[it] = x0;
      yellow_y[it] = y0;
      yell_x=x0;
      yell_y=y0;
      if (record == true)
      {
        it++;
      }
    }
    else if ((rightHandJoint0<25)) // right joint id touchId[0]
    {
      stroke(255, 0, 0);
      noFill();
      rect(whiteSkeletonX, whiteSkeletonY, 167, 167, 15);//white left skeleton highlighted in red to show the correct placement
      line(whiteRightHandJointX, whiteRightHandJointY, xTouch[1], yTouch[1]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
      touchEvent = true;
      x1 = (xTouch[1]-whiteRightHandJointX)+(yellowFaceX+whiteSkeletonXincr);
      //x1 = xTouch[1]+yellowFaceX-whiteSkeletonXincr;
      y1 = yTouch[1]-15;
      yellow_x[it] = x1;
      yellow_y[it] = y1;
      yell_x=x1;
      yell_y=y1;
      if (record == true)
      {
        it++;
      }
    }
    
    if ((leftHandJoint1<25)) // right joint id touchId[1]
    {
      stroke(255, 0, 0);
      noFill();
      rect(whiteSkeletonX, whiteSkeletonY, 167, 167, 15);//white left skeleton highlighted in red to show the correct placement
      touchEvent = true;
      line(whiteLeftHandJointX,whiteLeftHandJointY, xTouch[0], yTouch[0]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
      x0 = (yellowFaceX-whiteSkeletonXincr) - (whiteLeftHandJointX - xTouch[0]);
      y0 = yTouch[0]-15;
      yellow_x[it] = x0;
      yellow_y[it] = y0;
      yell_x=x0;
      yell_y=y0;
      if (record == true)
      {
        it++;
      }
    }
    else if ((leftHandJoint0<25)) // right joint id touchId[0]
    {
      stroke(255, 0, 0);
      noFill();
      rect(whiteSkeletonX, whiteSkeletonY, 167, 167, 15);//white left skeleton highlighted in red to show the correct placement
      line(whiteLeftHandJointX, whiteLeftHandJointY, xTouch[1], yTouch[1]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
      touchEvent = true;
      x1 = (yellowFaceX-whiteSkeletonXincr) - (whiteLeftHandJointX - xTouch[1]);
      y1 = yTouch[1]-15;
      yellow_x[it] = x1;
      yellow_y[it] = y1;
      yell_x=x1;
      yell_y=y1;
      if (record == true)
      {
        it++;
      }
    }
    
  }
}


//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent event) {
  xandy centroid =  new xandy();
  xandy centroidInter =  new xandy();
  // Number of places on the screen being touched:
  TouchEvents = event.getPointerCount();
  println("TouchEvents  "+TouchEvents);
  // If no action is happening, listen for new events else 
  for (int i = 0; i < TouchEvents; i++) {
    int pointerId = event.getPointerId(i);
    xTouch[pointerId] = event.getX(i); 
    yTouch[pointerId] = event.getY(i);
    float siz = event.getSize(i);
    println("pointerId  "+pointerId);

    //centroid of the points
    sumArea = 0;

    centroid.x = 0;
    centroid.y = 0;

    for (int j = 0; j < TouchEvents; j++) {
      area = (xTouch[j] * yTouch[j+1]) - (xTouch[j+1] * yTouch[j]);
      centroidInter.x = (xTouch[j] + xTouch[j+1])*(xTouch[j] + xTouch[j+1])* area;
      centroidInter.y = (yTouch[j] + yTouch[j+1])*(yTouch[j] + yTouch[j+1])* area;

      centroid.x += centroidInter.x;
      centroid.y += centroidInter.y;
      sumArea += area;
    }
    sumArea = sumArea*0.5;
    centroidFrac = 1.0 / (6 * sumArea); 
    centroid.x *= centroidFrac;
    centroid.y *= centroidFrac;
  }

  //  println(centroid.x);
  //  println(centroid.y);
  //  println(xTouch[0]);
  //  println(yTouch[0]);
  //  println(xTouch[1]);
  //  println(yTouch[1]);

  // ACTION_DOWN 
  if (event.getActionMasked() == 0 ) {
    print("Initial action detected. (ACTION_DOWN)");
    print("Action index: " +str(event.getActionIndex()));
  } 
  // ACTION_UP 
  else if (event.getActionMasked() == 1) {
    print("ACTION_UP");
    print("Action index: " +str(event.getActionIndex()));
  }
  //  ACTION_POINTER_DOWN 
  else if (event.getActionMasked() == 5) {
    print("Secondary pointer detected: ACTION_POINTER_DOWN");
    print("Action index: " +str(event.getActionIndex()));
  }
  // ACTION_POINTER_UP 
  else if (event.getActionMasked() == 6) {
    print("ACTION_POINTER_UP");
    print("Action index: " +str(event.getActionIndex()));
  }
  // 
  else if (event.getActionMasked() == 4) {
  }

  // If you want the variables for motionX/motionY, mouseX/mouseY etc.
  // to work properly, you'll need to call super.surfaceTouchEvent().
  return super.surfaceTouchEvent(event);
}


//if (TouchEvents == 2)
//  {
//    if (first == true)
//    {
//      squareRoot2 = sqrt(pow(xTouch[0]-xTouch[1], 2) + pow(yTouch[0]-yTouch[1], 2));
//      first = false;
//    }
//    println(squareRoot2);
//
//    squareRoot2_ = sqrt(pow(xTouch[0]-xTouch[1], 2) + pow(yTouch[0]-yTouch[1], 2));
//    if ((squareRoot2_ < squareRoot2+10)&&(squareRoot2_ > squareRoot2-10))
//    {
//      fill(255);
//      textSize(102);
//      text("Object 1", xTouch[1], yTouch[1]);
//    }
//  }
//  if (TouchEvents == 4)
//  {
//    fill(255);
//    textSize(102);
//    text("Donkey", xTouch[3], yTouch[3]);
//  }

