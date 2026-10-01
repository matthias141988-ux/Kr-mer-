package com.weldquest.app;

import android.app.*; import android.os.*; import android.graphics.*; import android.graphics.drawable.*; import android.view.*; import android.widget.*; import android.content.*; import java.util.*;

public class MainActivity extends Activity {
 int orange=Color.rgb(255,126,20), panel=Color.argb(225,9,17,24); SimView sim;
 @Override public void onCreate(Bundle b){super.onCreate(b);getWindow().setFlags(1024,1024);showMenu();}
 TextView txt(String s,int z){TextView v=new TextView(this);v.setText(s);v.setTextColor(Color.WHITE);v.setTextSize(z);v.setPadding(16,10,16,10);return v;}
 GradientDrawable bg(int c,int r){GradientDrawable d=new GradientDrawable();d.setColor(c);d.setCornerRadius(r);d.setStroke(1,Color.rgb(55,73,86));return d;}
 public void showMenu(){
  LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setPadding(24,14,24,18);root.setBackgroundColor(Color.rgb(4,9,13));
  LinearLayout top=new LinearLayout(this); TextView logo=txt("WELD",30); logo.setTypeface(null,1); TextView q=txt("QUEST",30);q.setTextColor(orange);q.setTypeface(null,1);top.addView(logo);top.addView(q);top.addView(txt("   WIG     MIG/MAG     E-Hand     UP     Orbital     Rohr     Behälter     Prüfung",16));root.addView(top);
  TextView sub=txt("SCHWEISSEN LERNEN. KÖNNEN. BEHERRSCHEN.",12);sub.setTextColor(Color.LTGRAY);root.addView(sub);
  LinearLayout body=new LinearLayout(this);
  LinearLayout left=new LinearLayout(this);left.setOrientation(LinearLayout.VERTICAL);left.setPadding(12,12,12,12);left.setBackground(bg(panel,14));
  left.addView(txt("TRAINING EINRICHTEN",19));
  String[] labels={"Material","Werkstückstärke","Nahtart","Position","Zusatzwerkstoff"};
  String[][] opts={{"Edelstahl (1.4301)","Edelstahl (1.4404)","S235","1.4539 / 904L","AlMg"},{"2,0 mm","1,0 mm","1,5 mm","3,0 mm","4,0 mm","6,0 mm"},{"Stumpfnaht (I-Naht)","Kehlnaht","V-Naht"},{"PA (Wannenlage)","PB","PC","PF"},{"ER308L (1,6 mm)","ER316L","1.4539 passend","Ohne Zusatz"}};
  for(int i=0;i<labels.length;i++){left.addView(txt(labels[i],14));Spinner s=new Spinner(this);s.setAdapter(new ArrayAdapter<String>(this,android.R.layout.simple_spinner_dropdown_item,opts[i]));left.addView(s);}
  Switch auto=new Switch(this);auto.setText("Parameter-Automatik");auto.setTextColor(Color.WHITE);auto.setChecked(true);left.addView(auto);
  Button go=new Button(this);go.setText("🔥  WIG-TRAINING STARTEN");go.setTextSize(16);left.addView(go);
  TextView safe=txt("TRAININGSSIMULATION • KEINE WPS / REALE SCHWEISSFREIGABE",11);safe.setTextColor(Color.LTGRAY);left.addView(safe);
  Preview pv=new Preview(this); body.addView(left,new LinearLayout.LayoutParams(0,-1,.34f));body.addView(pv,new LinearLayout.LayoutParams(0,-1,.66f));root.addView(body,new LinearLayout.LayoutParams(-1,0,1));
  go.setOnClickListener(v->{sim=new SimView(this);setContentView(sim);});
  setContentView(root);
 }
 class Preview extends View {Paint p=new Paint(3);Preview(Context c){super(c);}protected void onDraw(Canvas c){super.onDraw(c);float w=getWidth(),h=getHeight();Paint g=new Paint();g.setShader(new LinearGradient(0,0,0,h,Color.rgb(30,43,52),Color.rgb(5,10,14),Shader.TileMode.CLAMP));c.drawRect(8,8,w-8,h-8,g);p.setColor(Color.rgb(80,91,98));c.drawRect(w*.10f,h*.58f,w*.9f,h*.78f,p);p.setColor(Color.rgb(255,95,20));p.setStrokeWidth(13);c.drawLine(w*.25f,h*.68f,w*.72f,h*.68f,p);p.setColor(Color.rgb(180,230,255));c.drawCircle(w*.72f,h*.68f,52,p);p.setColor(Color.WHITE);c.drawCircle(w*.72f,h*.68f,18,p);p.setColor(Color.rgb(25,31,35));p.setStrokeWidth(45);c.drawLine(w*.86f,h*.28f,w*.73f,h*.62f,p);p.setTextSize(25);p.setColor(Color.WHITE);c.drawText("DEINE WERKSTATT",32,48,p);p.setTextSize(17);p.setColor(Color.LTGRAY);c.drawText("WIG • Lichtbogen • Schweißbad • Nahtanalyse",32,78,p);}}
 class SimView extends View {
  Paint p=new Paint(3);ArrayList<Float> xs=new ArrayList<>(),ys=new ArrayList<>();boolean arc=false;float tx=.70f,ty=.59f,last=-99;long start=System.currentTimeMillis();float amp=85,gas=8,speed=0;int score=92;
  SimView(Context c){super(c);setBackgroundColor(Color.rgb(3,7,10));}
  protected void onDraw(Canvas c){super.onDraw(c);float w=getWidth(),h=getHeight();
   Paint wall=new Paint();wall.setShader(new LinearGradient(0,0,0,h,Color.rgb(35,42,45),Color.rgb(5,8,10),Shader.TileMode.CLAMP));c.drawRect(0,0,w,h,wall);
   // workshop
   p.setColor(Color.rgb(20,27,31));for(int i=0;i<6;i++)c.drawRect(i*w/6f,h*.18f,i*w/6f+8,h*.57f,p);
   p.setColor(Color.rgb(32,49,60));c.drawRect(w*.32f,h*.27f,w*.48f,h*.55f,p);c.drawRect(w*.78f,h*.26f,w*.91f,h*.55f,p);
   p.setColor(Color.rgb(74,82,85));c.drawRect(w*.06f,h*.60f,w*.94f,h*.89f,p);
   p.setColor(Color.rgb(110,116,117));c.drawRect(w*.12f,h*.65f,w*.84f,h*.82f,p);
   // seam and bead
   p.setStrokeCap(Paint.Cap.ROUND);p.setStrokeWidth(5);p.setColor(Color.rgb(42,45,47));c.drawLine(w*.18f,h*.735f,w*.80f,h*.735f,p);
   if(xs.size()>1){for(int i=1;i<xs.size();i++){float q=(float)i/xs.size();p.setStrokeWidth(15);p.setColor(Color.rgb((int)(125+100*q),(int)(65+75*q),(int)(35+20*q)));c.drawLine(xs.get(i-1),ys.get(i-1),xs.get(i),ys.get(i),p);p.setStrokeWidth(3);p.setColor(Color.rgb(240,195,130));c.drawLine(xs.get(i-1),ys.get(i-1)-2,xs.get(i),ys.get(i)-2,p);}}
   float x=tx*w,y=ty*h;
   // filler left hand
   p.setStrokeWidth(10);p.setColor(Color.rgb(170,174,175));c.drawLine(x-330,y+95,x-15,y+118,p);p.setStrokeWidth(55);p.setColor(Color.rgb(23,25,26));c.drawLine(x-430,y+130,x-315,y+95,p);
   // torch right
   p.setStrokeWidth(60);p.setColor(Color.rgb(20,23,25));c.drawLine(x+210,y-250,x+38,y+80,p);p.setStrokeWidth(34);p.setColor(Color.rgb(190,100,210));c.drawLine(x+45,y+60,x+10,y+112,p);
   if(arc){p.setColor(Color.argb(60,100,190,255));c.drawCircle(x,y+126,100,p);p.setColor(Color.rgb(255,105,15));c.drawCircle(x,y+126,42,p);p.setColor(Color.WHITE);c.drawCircle(x,y+126,19,p);}
   // HUD panels
   panel(c,15,90,300,400,"Material\nEdelstahl (1.4301)\n\nWerkstückstärke\n2,0 mm\n\nNahtart\nStumpfnaht (I-Naht)\n\nPosition\nPA (Wannenlage)\n\nZusatz\nER308L (1,6 mm)");
   panel(c,w-315,90,w-15,360,"Schweißstrom (A)        85\n━━━━━━━━━━\nGasfluss (l/min)          8\n━━━━━━━━━━\nPuls (Hz)                    0\n\n[ Automatik ]   MANUELL");
   panel(c,w-315,380,w-15,h-90,"DEINE NAHT • ECHTZEIT\n\n✓ Einbrandtiefe      0,9 mm\n✓ Nahtbreite           4,1 mm\n✓ Nahtüberhöhung   0,6 mm\n✓ Gleichmäßigkeit   "+score+" %\n\nQUERSCHNITT\n       ▾\n    \u25E2██\u25E3");
   panel(c,330,90,720,230,"ZIEL: Gleichmäßige WIG-Naht\n○ konstante Geschwindigkeit\n○ Brennerwinkel 10–15°\n○ Abstand 2–4 mm\n○ gleichmäßige Nahtbreite");
   panel(c,20,h-155,240,h-20,"BRENNERWINKEL\n10–15°\n\nABSTAND  2–4 mm");
   panel(c,w*.36f,h-115,w*.72f,h-20,String.format(Locale.GERMANY,"Geschwindigkeit  %.0f cm/min     Zeit  %02d:%02d     Nahtlänge %.1f cm",speed,(System.currentTimeMillis()-start)/60000,(System.currentTimeMillis()-start)/1000%60,xs.size()*.04));
   p.setColor(Color.WHITE);p.setTextSize(24);c.drawText("WELD",20,45,p);p.setColor(orange);c.drawText("QUEST",90,45,p);p.setTextSize(16);p.setColor(Color.LTGRAY);c.drawText("WIG   MIG/MAG   E-Hand   UP   Orbital   Rohr   Behälter   Prüfung",210,43,p);
   p.setColor(orange);c.drawRoundRect(w-150,18,w-18,65,10,10,p);p.setColor(Color.BLACK);p.setTextSize(17);c.drawText("BEENDEN",w-130,49,p);
   invalidate();
  }
  void panel(Canvas c,float l,float t,float r,float b,String s){p.setColor(Color.argb(220,5,13,19));c.drawRoundRect(l,t,r,b,12,12,p);p.setStyle(Paint.Style.STROKE);p.setStrokeWidth(2);p.setColor(Color.rgb(55,76,89));c.drawRoundRect(l,t,r,b,12,12,p);p.setStyle(Paint.Style.FILL);p.setTextSize(16);p.setColor(Color.WHITE);float yy=t+28;for(String line:s.split("\n")){c.drawText(line,l+15,yy,p);yy+=24;}}
  public boolean onTouchEvent(MotionEvent e){float w=getWidth(),h=getHeight();if(e.getAction()==0&&e.getX()>w-170&&e.getY()<80){showMenu();return true;}if(e.getAction()==0||e.getAction()==2){arc=true;float nx=Math.max(.22f,Math.min(.77f,e.getX()/w));float ny=Math.max(.55f,Math.min(.64f,e.getY()/h));if(last>-90){speed=Math.min(30,Math.abs(nx-last)*300);}tx=nx;ty=ny;if(last<0||Math.abs(nx-last)>.003){xs.add(tx*w);ys.add(h*.735f);last=nx;}return true;}if(e.getAction()==1){arc=false;return true;}return true;}
 }
}