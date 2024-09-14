Table table;
String[] year;
int[] insgesamt;
int[] hochs;
int[] fachs;
int[] nichtde;
int lineWeight = 3;
int margin = 48;
float pointGap;
float tension;
color[] palette = {color(23, 225, 0), color(239, 31, 193), color(0, 216, 224), color(255, 255, 0)};
int selectedValueIndex = -1;

void setup() {
  size(1000, 600);
  background(0);
  table = loadTable("Hochschulen.csv", "header");
  int rowCount = table.getRowCount();
  year = new String[rowCount];
  insgesamt = new int[rowCount];
  hochs = new int[rowCount];
  fachs = new int[rowCount];
  nichtde = new int[rowCount];
  textFont(createFont("Georgia", 18));

  for (int i = 0; i < rowCount; i++) {
    TableRow row = table.getRow(i);
    year[i] = row.getString("Wintersemester");
    insgesamt[i] = row.getInt("Studierende insgesamt");
    hochs[i] = row.getInt("im 1. Hochschulsemester");
    fachs[i] = row.getInt("im 1. Fachsemester");
    nichtde[i] = row.getInt("nichtdeutsche Studierende");
  }
  pointGap = (width -  2*margin) / (year.length - 1.0);
}

void drawBezier(int[] values, color c) {
  beginShape();
  noStroke();
  fill(c, 150);
  for (int i = 0; i < values.length; i++) {
    float posX = i * pointGap + margin;
    float posY = height - margin - map(values[i], 0, max(insgesamt), 0, height - margin * 2);

    // mouse over the line
    if (mouseX >= posX - 5 && mouseX <= posX + 15 && mouseY >= posY - 15 && mouseY <= posY + 5) {
      selectedValueIndex = i;
      fill(c);
      textSize(16);
      text(values[i], posX, posY - 20);
    }

    if (i > 0) {
      float c1 = (i - 1) * pointGap + margin + tension;
      float c2 = height - margin - map(values[i - 1], 0, max(insgesamt), 0, height - margin * 2);
      float c3 = posX - tension;
      float c4 = posY;
      bezierVertex(c1, c2, c3, c4, posX, posY);
    } else {
      vertex(posX, posY);
    }
  }
  noFill();
  stroke(c);
  endShape();

}

void draw() {
  background(0);
  textSize(20);
  fill(255);
  textAlign(CENTER);
  text("Studierende an den Hochschulen in Hessen seit dem Wintersemester 1975", width/2, 40);
  
  noStroke();
  fill(255, 50);
  rect(50, 100, 210, 125); 

  tension = mouseX / 70;
  strokeWeight(lineWeight);
  noFill();
  
  // studierende insgesamt line
  drawBezier(insgesamt, palette[0]);
  fill(palette[0]);
  rect(60, height - 487, 5, 5);
  textSize(14);  
  text("Studierende insgesamt", width / 2 - 350, height - 480);
  
  // hochs line
  drawBezier(hochs, palette[1]);
  fill(palette[1]);
  rect(60, height - 457, 5, 5);
  textSize(14);
  text("im 1. Hochschulsemester", width / 2 - 343, height - 450);
  
  // fachs line
  drawBezier(fachs, palette[2]);
  fill(palette[2]);
  rect(60, height - 427, 5, 5);
  textSize(14);
  text("im 1. Fachsemester", width / 2 - 361, height - 420);
  
  // nichtde line
  drawBezier(nichtde, palette[3]);
  fill(palette[3]);
  rect(60, height - 397, 5, 5);
  textSize(14);
  text("nichtdeutsche Studierende", width / 2 - 336, height - 390);
  
  stroke(255);
  strokeWeight(1);
  line(20,height-48,width-20,height-50);
  fill(255);

  int startYear = 1975;
  int endYear = 2023;
  int yearCount = 8; 
  int interval = (endYear - startYear) / yearCount;
  
  for (int i = 0; i <= yearCount; i++) {
    int year = startYear + i * interval;
    float posX = margin + i*112 + interval;
    line(posX, height - 40, posX, height - 55);
    text(Integer.toString(year), posX, height-25);
  }
}
void mousePressed() {
  selectedValueIndex = -1;
}
