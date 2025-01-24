import controlP5.*;
import processing.pdf.*;

ControlP5 cp5;


int waveType = 0;
int waveAmplitude = 100; 
float waveFrequency = 0.02;
float waveThickness = 2; 
int numWaves = 2; 
float marginPercentage = 0.1;

boolean isMoving = false; 
float movementSpeed = 0.05; 
float movementOffset = 0;


int backgroundColor = #ff5c00;  
int strokeColor = #2323ff;  
int controlBackgroundColor = #000000; 



void setup() {
  
  size(800, 500);  
 
  cp5 = new ControlP5(this);


  cp5.addSlider("waveType")
     .setPosition(20, 20) 
     .setSize(200, 20) 
     .setRange(0, 3) 
     .setValue(0) 
     .setNumberOfTickMarks(4) 
     .setSliderMode(Slider.FLEXIBLE);



  cp5.addKnob("waveThickness")
     .setPosition(20, 60) 
     .setSize(50, 50) 
     .setRange(10, 50) 
     .setValue(25) 
     .setCaptionLabel("Grosor"); 

  cp5.addSlider("numWaves")
     .setPosition(20, 120) 
     .setSize(200, 20) 
     .setRange(1, 10) 
     .setValue(2) 
     .setNumberOfTickMarks(10) 
     .setSliderMode(Slider.FLEXIBLE); 
  
  cp5.addKnob("movementSpeed")
     .setPosition(20, 160) 
     .setSize(50, 50) 
     .setRange(0.01, 0.50) 
     .setValue(0.2) 
     .setCaptionLabel("Speed");

  cp5.addSlider("marginPercentage")
     .setPosition(20, 220) 
     .setSize(200, 20) 
     .setRange(0, 0.49) 
     .setValue(0.25) 
     .setSliderMode(Slider.FLEXIBLE) 
     .setNumberOfTickMarks(0); 

  cp5.addSlider("waveAmplitude")
     .setPosition(20, 260) 
     .setSize(200, 20) 
     .setRange(50, 200) 
     .setValue(100) 
     .setSliderMode(Slider.FLEXIBLE); 

  cp5.addButton("changeColors")
     .setPosition(20, 300)
     .setSize(200, 40)
     .setLabel("Invert Colors")
     .onClick(new CallbackListener() {
       public void controlEvent(CallbackEvent event) {
         
         if (backgroundColor == #ff5c00) {
           backgroundColor = #2323ff;  
           strokeColor = #ff5c00;  
         } else {
           backgroundColor = #ff5c00; 
           strokeColor = #2323ff;  
         }
       }
     });

  cp5.addButton("exportPDF")
     .setPosition(20, 360)
     .setSize(200, 40)
     .setLabel("Export to PDF")
     .onClick(new CallbackListener() {
       public void controlEvent(CallbackEvent event) {
         String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
         String fileName = "wave_visualization_" + timestamp + ".pdf";
         PGraphics pdf = createGraphics(500, 500, PDF, fileName);
         beginRecord(pdf);
         pdf.pushMatrix();
         pdf.translate(-300, 0); 
         drawWaves();
         pdf.popMatrix();
  
         
         endRecord();
         println("Archivo exportado: " + fileName);
       }
     });
   
}

  void draw() {
    drawWaves();
  
    fill(controlBackgroundColor);  
    noStroke();
    rect(0, 0, 300, height);  
  }
  
 
  void drawWaves() {
    background(backgroundColor); 
    stroke(strokeColor);  
    strokeWeight(waveThickness); 
    noFill();
  
    // Calcular la frecuencia de la onda según el número de ondas
    float adjustedFrequency = TWO_PI * numWaves / (width - 300);  // Ajustar la frecuencia para el nuevo rango
  
    // Calcular los márgenes (basado en el porcentaje)
    float margin = (width - 300) * marginPercentage;
    float startX = 300 + margin; // El inicio de la onda después del margen
    float endX = width - margin; // El final de la onda antes del margen derecho
  
    // Si las ondas deben moverse, ajustar el desplazamiento
    if (isMoving) {
      movementOffset += movementSpeed; // Desplazar la onda solo si isMoving es true
    }
  
    // Dibujar la onda seleccionada como una serie de líneas
    float prevX = startX;
    float prevY = height / 2;
  
    for (float x = startX + 1; x < endX; x++) {
      float y = height / 2;
      float t = (x - 300) * adjustedFrequency + (isMoving ? movementOffset : 0); // Usar el offset y ajustar el cálculo para la nueva posición de X
  
      // Calcular la forma de la onda
      if (waveType == 0) {
        y += sin(t) * waveAmplitude; // Onda sinusoidal
      } else if (waveType == 1) {
        // Onda cuadrada que comienza en la parte superior
        y += (sin(t) > 0 ? waveAmplitude : -waveAmplitude); // Onda cuadrada
      } else if (waveType == 2) {
        // Onda triangular
        float triangleWave = abs((t % TWO_PI) - PI) - (PI / 2);
        y += triangleWave * (waveAmplitude / (PI / 2)); // Onda triangular
      } else if (waveType == 3) {
        // Onda de dientes de sierra
        float sawtoothWave = (t % TWO_PI) / TWO_PI - 0.5;
        y += sawtoothWave * 2 * waveAmplitude; // Dientes de sierra
      }
  
      // Evitar la línea vertical al principio de la onda
      if (x > startX + 1) {
        // Dibujar una línea entre el punto anterior y el actual
        line(prevX, prevY, x, y);
      }
      prevX = x;
      prevY = y;
    }
  }
 
 
 
 
 
  void keyPressed() {
    if (key == ' ') {
      isMoving = !isMoving;
    }
  }
