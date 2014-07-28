
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

float x0, y0, x1, y1, a_x0, a_y0, a_x1, a_y1, yell_x, yell_y, y_xL, y_yL, y_x, y_y;
double yellow_x[], yellow_xL[];
double yellow_y[], yellow_yL[];
double jYellow_x[], jYellow_xL[];
char charColor[];
int outWidth = 2560;
int outHeight = 1600;

float rightHandJoint0, rightHandJoint1, leftHandJoint0, leftHandJoint1;
float sqrtL[], isLengthEqualL[], sqrtR[], isLengthEqualR[];
boolean first = true;
boolean touchEvent = false;
boolean noZero = false;

//centroid
float area, sumArea;
float centroidFrac;

boolean animate = false;
boolean record = false;
boolean template2 = false;
boolean template1 = true;
boolean template3 = false;
//face
int yellowFaceSize = 300;

//hands
int whiteSkeletonXincr = 150;

int whiteRightHandJointX = 150+whiteSkeletonXincr;
int whiteRightHandJointY = 304;
int whiteLeftHandJointX = whiteRightHandJointX-110;
int whiteLeftHandJointY = 304;
int animatingFaceX = 700;
int animatingFaceY = 720/2;
int whiteSkeletonX = 100+whiteSkeletonXincr;
int whiteSkeletonY = 720/2;

int yellowJointX;
int jointYellow_x, jointYellow_xL;

int handLength = 250;

int jLx; // joint Left hand
int eLx; // end left hand
int jRx; // joint right hand
int eRx; // end right hand

int itt;
int bufferArea = 75;

float xTouc;
float yTouc;

color[] animColor = {
  color(255, 255, 0)/*yellow*/, color(125, 193, 255)/*pink*/, color(184, 20, 103)/*blue*/
};

public class xandy
{
  public double x;
  public double y;
}

//-----------------------------------------------------------------------------------------

void setup() {
  //size(displayWidth, displayHeight);
  size(1280, 720);
  //size(2560,1600);
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
  yellow_xL = new double[100000];
  yellow_y = new double[100000];
  yellow_yL = new double[100000];
  jYellow_x = new double[100000];
  jYellow_xL = new double[100000];
  charColor = new char[100000];

  sqrtL = new float[4]; 
  isLengthEqualL = new float[4];
  sqrtR = new float[4];
  isLengthEqualR = new float[4];
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

    template1Button();
    template2Button();
    template3Button();

    drawAnimatingChar();
    drawWhiteChar();
    drawWhiteSkeleton();
    //drawBlueCirclesOnTouch();
    if (TouchEvents == 2)
      ifTouchEventIs2();
    if (TouchEvents == 4)
      ifTouchEventIs4();
    recordButton();
    stopButton();
    playButton();
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
        drawAnimatedChar(iter);
        if ((yellow_x[iter] != 0.0)&&(yellow_y[iter] != 0.0))
        {
          y_x=(int)yellow_x[iter];
          jointYellow_x = (int)jYellow_x[iter];
          y_y=(int)yellow_y[iter];
          jointYellow_x = (int)jYellow_x[iter];
          whatsAnimatedHandColor(iter, (int)yellow_x[iter], (int)yellow_y[iter], (int)jYellow_x[iter]);
        }
        if ((yellow_xL[iter] != 0.0)&&(yellow_yL[iter] != 0.0))
        {
          y_xL=(int)yellow_xL[iter];
          jointYellow_xL = (int)jYellow_xL[iter];
          y_yL=(int)yellow_yL[iter];
          jointYellow_xL = (int)jYellow_xL[iter];
          whatsAnimatedHandColor(iter, (int)yellow_xL[iter], (int)yellow_yL[iter], (int)jYellow_xL[iter]);
        }
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

void ifTouchEventIs2()
{
  rightHandJoint0 = sqrt(pow(xTouch[0]-(whiteRightHandJointX), 2) + pow(yTouch[0]-(whiteRightHandJointY), 2));
  rightHandJoint1 = sqrt(pow(xTouch[1]-(whiteRightHandJointX), 2) + pow(yTouch[1]-(whiteRightHandJointY), 2));
  leftHandJoint0 = sqrt(pow(xTouch[0]-(whiteLeftHandJointX), 2) + pow(yTouch[0]-(whiteLeftHandJointY), 2));
  leftHandJoint1 = sqrt(pow(xTouch[1]-(whiteLeftHandJointX), 2) + pow(yTouch[1]-(whiteLeftHandJointY), 2));

  strokeWeight(5);
  stroke(255, 255, 255);
  if ((rightHandJoint1<bufferArea)) // right joint id touchId[1]
  {
    redHighlight();
    touchEvent = true;
    line(whiteRightHandJointX, whiteRightHandJointY, xTouch[0], yTouch[0]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
    yellow_x[it] = (xTouch[0]-whiteRightHandJointX)+(animatingFaceX+whiteSkeletonXincr);
    yellow_y[it] = yTouch[0]-15;
    jYellow_x[it] = animatingFaceX-whiteSkeletonXincr+yellowFaceSize;
    ifTouchEventIs2_colorCheck(it);
    if (record == true)
    {
      it++;
    }
  }
  else if ((rightHandJoint0<bufferArea)) // right joint id touchId[0]
  {
    redHighlight();
    line(whiteRightHandJointX, whiteRightHandJointY, xTouch[1], yTouch[1]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
    touchEvent = true;
    yellow_x[it] = (xTouch[1]-whiteRightHandJointX)+(animatingFaceX+whiteSkeletonXincr);
    //x1 = xTouch[1]+animatingFaceX-whiteSkeletonXincr;
    yellow_y[it] = yTouch[1]-15;
    jYellow_x[it] = animatingFaceX-whiteSkeletonXincr+yellowFaceSize;
    ifTouchEventIs2_colorCheck(it);
    if (record == true)
    {
      it++;
    }
  }

  if ((leftHandJoint1<bufferArea)) // right joint id touchId[1]
  {
    redHighlight();
    touchEvent = true;
    line(whiteLeftHandJointX, whiteLeftHandJointY, xTouch[0], yTouch[0]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
    yellow_x[it] = (animatingFaceX-whiteSkeletonXincr) - (whiteLeftHandJointX - xTouch[0]);
    yellow_y[it] = yTouch[0]-15;
    jYellow_x[it] = animatingFaceX-whiteSkeletonXincr;
    ifTouchEventIs2_colorCheck(it);
    if (record == true)
    {
      it++;
    }
  }
  else if ((leftHandJoint0<bufferArea)) // right joint id touchId[0]
  {
    redHighlight();
    line(whiteLeftHandJointX, whiteLeftHandJointY, xTouch[1], yTouch[1]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
    touchEvent = true;
    yellow_x[it] = (animatingFaceX-whiteSkeletonXincr) - (whiteLeftHandJointX - xTouch[1]);
    yellow_y[it] = yTouch[1]-15;
    jYellow_x[it] = animatingFaceX-whiteSkeletonXincr;
    ifTouchEventIs2_colorCheck(it);
    if (record == true)
    {
      it++;
    }
  }
}

void ifTouchEventIs4()
{
  int i, j;
  //check for right joint
  for (i=0;i<4;i++)
  {
    sqrtR[i] = sqrt(pow(xTouch[i]-(whiteRightHandJointX), 2) + pow(yTouch[i]-(whiteRightHandJointY), 2));
    if (sqrtR[i] < bufferArea)// check for right joint --- touchid[i] is the right joint
    { 
      redHighlight();
      jRx = i;
      for (j=0;j<4;j++)
      {
        if (j != jRx)
        {
          if (xTouch[j] > whiteSkeletonX)
            eRx = j;//RECORD j
        }
      }
      strokeWeight(5);
      stroke(255, 255, 255);
      touchEvent = true;
      //line(xTouch[jRx], yTouch[jRx], xTouch[eRx], yTouch[eRx]); //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
      line (whiteRightHandJointX, whiteRightHandJointY, xTouch[eRx], yTouch[eRx]);
      yell_x = (xTouch[eRx]-whiteRightHandJointX)+(animatingFaceX+whiteSkeletonXincr);
      yell_y = yTouch[eRx]-15;
      yellowJointX = animatingFaceX-whiteSkeletonXincr+yellowFaceSize;

      yellow_x[it] = yell_x; //END POINTS OF HAND X
      yellow_y[it] = yell_y; //END POINTS OF HAND Y
      jYellow_x[it] = yellowJointX;
      if (template1 == true)
      {
        charColor[it] = 'y';
        stroke(animColor[0]);
      }
      if (template2 == true)
      {
        charColor[it] = 'p';
        stroke(animColor[1]);
      }
      if (template3 == true)
      {
        charColor[it] = 'b';
        stroke(animColor[2]);
      }

      strokeWeight(25);
      line(yellowJointX, whiteRightHandJointY-15, yell_x, yell_y);// yellow hand -- right
    }
  }


  for (i=0;i<4;i++)
  {
    if ((i != jRx) && (i != eRx))
    {
      sqrtL[i] = sqrt(pow(xTouch[i]-(whiteLeftHandJointX), 2) + pow(yTouch[i]-(whiteLeftHandJointY), 2));
      if (sqrtL[i] < bufferArea)// check for right joint --- touchid[i] is the right joint
      { 
        //redHighlight();
        jLx = i;
        for (j=0;j<4;j++)
        {
          if ((j != jRx) && (j != eRx) && (j != jLx))
          {
            if (xTouch[j] < whiteSkeletonX)
              eLx = j;//RECORD j
          }
        }
        strokeWeight(5);
        stroke(255, 255, 255);
        touchEvent = true;
        //line(xTouch[jLx], yTouch[jLx], xTouch[eLx], yTouch[eLx]);
        line (whiteLeftHandJointX, whiteLeftHandJointY, xTouch[eLx], yTouch[eLx]);
        yell_x = (animatingFaceX-whiteSkeletonXincr) - (whiteLeftHandJointX - xTouch[eLx]);
        yell_y = yTouch[eLx]-15;
        yellowJointX = animatingFaceX-whiteSkeletonXincr;

        yellow_xL[it] = yell_x;
        yellow_yL[it] = yell_y;
        jYellow_xL[it] = yellowJointX;

        if (template1 == true)
        {
          charColor[it] = 'y';
          stroke(animColor[0]);
        }
        if (template2 == true)
        {
          charColor[it] = 'p';
          stroke(animColor[1]);
        }
        if (template3 == true)
        {
          charColor[it] = 'b';
          stroke(animColor[2]);
        }
        if (record == true)
        {
          it++;
        }
        strokeWeight(25);
        line(yellowJointX, whiteRightHandJointY-15, yell_x, yell_y);// yellow hand -- left
      }
    }
  }
}

void redHighlight()
{
  stroke(255, 0, 0);
  noFill();
  rect(whiteSkeletonX, whiteSkeletonY, 167+50, 167+50, 15);//white left skeleton highlighted in red to show the correct placement
}


void recordButton()
{
  textSize(20);
  fill(255);
  text("RECORD", 875-122, 105);
  if ((xTouch[0]<950-120)&&(xTouch[0]>850-120)&&(yTouch[0]>75)&&(yTouch[0]<125))
  {
    record = true;
  }
}

void stopButton()
{
  noStroke();
  fill(0, 255, 180);
  rect(900, 100, 100, 50, 15);//STOP BUTTON
  textSize(20);
  fill(255);
  text("STOP", 900-20, 105);
  if ((xTouch[0]<950)&&(xTouch[0]>850)&&(yTouch[0]>75)&&(yTouch[0]<125))
  {
    record = false;
  }
}

void template1Button()
{
  if (template1 ==  true)
  {
    strokeWeight(5);
    stroke(255, 0, 0);
  }
  else
    noStroke();
  fill(animColor[0]);
  rect(1000, 600, 100, 100, 15);
  if ((xTouch[0]<1050)&&(xTouch[0]>950)&&(yTouch[0]<650)&&(yTouch[0]>550))
  {
    template1 = true;
    template2 = false;
    template3 = false;
  }
  else
    noStroke();
}

void template2Button()
{
  if (template2 ==  true)
  {
    strokeWeight(5);
    stroke(255, 0, 0);
  }
  else
    noStroke();
  fill(animColor[1]);
  rect(1200, 600, 100, 100, 15);
  if ((xTouch[0]<1250)&&(xTouch[0]>1150)&&(yTouch[0]<650)&&(yTouch[0]>550))
  {
    template2 = true;
    template1 = false;
    template3 = false;
  }
  else
    noStroke();
}

void template3Button()
{
  if (template3 ==  true)
  {
    strokeWeight(5);
    stroke(255, 0, 0);
  }
  else
    noStroke();
  //fill(232, 44, 12);
  fill(animColor[2]);
  rect(1100, 600, 100, 100, 15);
  if ((xTouch[0]<1150)&&(xTouch[0]>1050)&&(yTouch[0]<650)&&(yTouch[0]>550))
  {
    template3 = true;
    template1 = false;
    template2 = false;
  }
  else
    noStroke();
}

void playButton()
{
  noStroke();
  fill(0, 255, 180);
  rect(900+130, 100, 100, 50, 15);//PLAY BUTTON
  textSize(20);
  fill(255);
  text("PLAY", 875+122+10, 105);
  // if play clicked
  playX = xTouch[0];
  playY = yTouch[0];
  if ((playX<950+130)&&(playX>850+130)&&(playY>75)&&(playY<125))
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

void drawAnimatingChar()
{
  noStroke();
  if (template1 == true)
    fill(animColor[0]);
  if (template2 == true)
    fill(animColor[1]);
  if (template3 == true)
    fill(animColor[2]);
  rect(animatingFaceX, animatingFaceY, 300, 300, 15);// animating face

  fill(0); 
  ellipse(animatingFaceX-75, animatingFaceY+25, 30, 40);//eye left
  ellipse(animatingFaceX+75, animatingFaceY+25, 30, 40);//eye right

  //mouth
  noFill();
  strokeWeight(5);
  stroke(0);
  arc(animatingFaceX-75+75, animatingFaceY+25+25, 75, 75, 0, PI, OPEN);
}

void drawAnimatedChar(int iter)
{
  noStroke();
  if (charColor[iter] == 'y')
    fill(animColor[0]);
  if (charColor[iter] == 'p')
    fill(animColor[1]);
  if (charColor[iter] == 'b')
    fill(animColor[2]);
  rect(animatingFaceX, animatingFaceY, 300, 300, 15);// animating face

  fill(0); 
  ellipse(animatingFaceX-75, animatingFaceY+25, 30, 40);//eye left
  ellipse(animatingFaceX+75, animatingFaceY+25, 30, 40);//eye right

  //mouth
  noFill();
  strokeWeight(5);
  stroke(0);
  arc(animatingFaceX-75+75, animatingFaceY+25+25, 75, 75, 0, PI, OPEN);
}



void drawWhiteChar() //white left body
{
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


//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent event) {
  xandy centroid =  new xandy();
  xandy centroidInter =  new xandy();
  // Number of places on the screen being touched:
  TouchEvents = event.getPointerCount();
  //println("TouchEvents  "+TouchEvents);
  // If no action is happening, listen for new events else 
  for (int i = 0; i < TouchEvents; i++) {
    int pointerId = event.getPointerId(i);

    xTouch[pointerId] = event.getX(i); 
    yTouch[pointerId] = event.getY(i);
    float siz = event.getSize(i);
    //println("pointerId  "+pointerId);
  }

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

void whatsAnimatedHandColor(int iter, float yxx, float yyy, int join)
{
  if (charColor[iter] == 'y')
    stroke(animColor[0]);
  if (charColor[iter] == 'p')
    stroke(animColor[1]);
  if (charColor[iter] == 'b')
    stroke(animColor[2]);
  strokeWeight(25);
  line(join, whiteRightHandJointY-15, yxx, yyy);
}

void whatsAnimatedColor(int iter)
{
  if (charColor[iter] == 'y')
    fill(animColor[0]);
  if (charColor[iter] == 'p')
    fill(animColor[1]);
  if (charColor[iter] == 'b')
    fill(animColor[2]);
}

void whatsAnimatingColor()
{
  if (template1 == true)
    fill(animColor[0]);
  if (template2 == true)
    fill(animColor[1]);
  if (template3 == true)
    fill(animColor[2]);
}

void ifTouchEventIs2_colorCheck(int itIncr) {
  strokeWeight(25);
  if (template1 == true)
  {
    charColor[itIncr] = 'y';
    stroke(animColor[0]);
  }
  if (template2 == true)
  {
    charColor[itIncr] = 'p';
    stroke(animColor[1]);
  }
  if (template3 == true)
  {
    charColor[itIncr] = 'b';
    stroke(animColor[2]);
  }
  line((int)jYellow_x[itIncr], whiteRightHandJointY-15, (float)yellow_x[itIncr], (float)yellow_y[itIncr]);// hand
}

