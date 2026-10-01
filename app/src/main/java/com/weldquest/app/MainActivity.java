package com.weldquest.app;

import android.app.Activity;
import android.os.Bundle;
import android.graphics.*;
import android.view.*;
import android.widget.*;
import android.content.*;
import java.util.*;

public class MainActivity extends Activity {
    WeldView weldView;
    @Override public void onCreate(Bundle b){
        super.onCreate(b);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,WindowManager.LayoutParams.FLAG_FULLSCREEN);
        showSetup();
    }
    TextView label(String s,int sp){ TextView v=new TextView(this); v.setText(s); v.setTextColor(Color.WHITE); v.setTextSize(sp); v.setPadding(12,8,12,8); return v; }
    public void showSetup(){
        LinearLayout root=new LinearLayout(this); root.setOrientation(LinearLayout.VERTICAL); root.setPadding(34,24,34,24); root.setBackgroundColor(Color.rgb(6,12,18));
        TextView title=label("WELDQUEST",32); title.setTextColor(Color.rgb(255,122,24)); root.addView(title);
        root.addView(label("TIG / WIG TRAINING  •  ALPHA 0.1",15));
        LinearLayout row=new LinearLayout(this); row.setOrientation(LinearLayout.HORIZONTAL);
        LinearLayout controls=new LinearLayout(this); controls.setOrientation(LinearLayout.VERTICAL); controls.setPadding(0,15,25,0);
        Spinner material=new Spinner(this); String[] mats={"1.4404 Edelstahl","S235 Baustahl","AlMg Aluminium","1.4539 / 904L"}; material.setAdapter(new ArrayAdapter<String>(this,android.R.layout.simple_spinner_dropdown_item,mats));
        controls.addView(label("Werkstoff",16)); controls.addView(material);
        TextView tvT=label("Blech-/Wandstärke: 3.0 mm",16); controls.addView(tvT);
        SeekBar thick=new SeekBar(this); thick.setMax(22); thick.setProgress(4); controls.addView(thick);
        Switch auto=new Switch(this); auto.setText("Parameter-Automatik (Training)"); auto.setTextColor(Color.WHITE); auto.setChecked(true); controls.addView(auto);
        TextView tvA=label("Strom: 86 A",16); controls.addView(tvA);
        SeekBar amps=new SeekBar(this); amps.setMax(220); amps.setProgress(66); controls.addView(amps);
        TextView tvG=label("Gas: 8.0 l/min",16); controls.addView(tvG);
        SeekBar gas=new SeekBar(this); gas.setMax(32); gas.setProgress(8); controls.addView(gas);
        TextView safety=label("Automatikwerte sind Simulation — keine WPS / reale Schweißfreigabe.",13); safety.setTextColor(Color.LTGRAY); controls.addView(safety);
        Button go=new Button(this); go.setText("🔥 TRAINING STARTEN"); controls.addView(go);
        TextView preview=label("3D TRAINING BAY\n\nTouch-Steuerung • Lichtbogen • Schweißbad\nNahtauswertung nach dem Training",22); preview.setGravity(Gravity.CENTER); preview.setBackgroundColor(Color.rgb(18,28,36));
        row.addView(controls,new LinearLayout.LayoutParams(0,-1,0.46f)); row.addView(preview,new LinearLayout.LayoutParams(0,-1,0.54f)); root.addView(row,new LinearLayout.LayoutParams(-1,0,1));
        final float[] vals={3f,86f,8f};
        Runnable recalc=()->{ if(auto.isChecked()){ float t=vals[0]; vals[1]=Math.min(180,38+t*16); vals[2]=Math.min(12,Math.max(7,6.5f+t*.45f)); amps.setProgress((int)vals[1]-20); gas.setProgress((int)((vals[2]-4)*2)); } tvA.setText(String.format(Locale.GERMANY,"Strom: %.0f A",vals[1])); tvG.setText(String.format(Locale.GERMANY,"Gas: %.1f l/min",vals[2])); };
        thick.setOnSeekBarChangeListener(new SimpleSeek(){ public void onProgressChanged(SeekBar s,int p,boolean f){vals[0]=1+p*.5f;tvT.setText(String.format(Locale.GERMANY,"Blech-/Wandstärke: %.1f mm",vals[0]));recalc.run();}});
        amps.setOnSeekBarChangeListener(new SimpleSeek(){ public void onProgressChanged(SeekBar s,int p,boolean f){if(!auto.isChecked()){vals[1]=20+p;tvA.setText(String.format(Locale.GERMANY,"Strom: %.0f A",vals[1]));}}});
        gas.setOnSeekBarChangeListener(new SimpleSeek(){ public void onProgressChanged(SeekBar s,int p,boolean f){if(!auto.isChecked()){vals[2]=4+p*.5f;tvG.setText(String.format(Locale.GERMANY,"Gas: %.1f l/min",vals[2]));}}});
        auto.setOnCheckedChangeListener((btt,c)->recalc.run());
        go.setOnClickListener(v->{ weldView=new WeldView(this,mats[material.getSelectedItemPosition()],vals[0],vals[1],vals[2]); setContentView(weldView);});
        setContentView(root); recalc.run();
    }
    abstract static class SimpleSeek implements SeekBar.OnSeekBarChangeListener { public void onStartTrackingTouch(SeekBar s){} public void onStopTrackingTouch(SeekBar s){} }
    class WeldView extends View {
        Paint p=new Paint(3); float x=.13f,y=.55f,lastX=-1; boolean arc=false; ArrayList<Float> bead=new ArrayList<>(); String mat; float thick,amp,gas; long started;
        WeldView(Context c,String m,float t,float a,float g){super(c);mat=m;thick=t;amp=a;gas=g;setBackgroundColor(Color.rgb(3,8,12));started=System.currentTimeMillis();}
        protected void onDraw(Canvas c){super.onDraw(c);float w=getWidth(),h=getHeight();
            Paint grad=new Paint(); grad.setShader(new LinearGradient(0,h*.32f,0,h,Color.rgb(35,43,48),Color.rgb(7,11,14),Shader.TileMode.CLAMP));c.drawRect(0,h*.32f,w,h,grad);
            p.setColor(Color.rgb(85,92,96));c.drawRoundRect(w*.08f,h*.58f,w*.92f,h*.82f,18,18,p);
            p.setColor(Color.rgb(35,39,42));c.drawRect(w*.12f,h*.695f,w*.88f,h*.71f,p);
            if(bead.size()>1){p.setStrokeWidth(15);p.setStrokeCap(Paint.Cap.ROUND);for(int i=1;i<bead.size();i++){float heat=(float)i/bead.size();p.setColor(Color.rgb((int)(115+100*heat),(int)(55+80*heat),25));c.drawLine(bead.get(i-1),h*.703f,bead.get(i),h*.703f,p);}}
            float tx=x*w,ty=y*h;
            p.setStrokeWidth(32);p.setColor(Color.rgb(22,27,31));c.drawLine(tx+80,ty-180,tx+12,ty-18,p);p.setStrokeWidth(12);p.setColor(Color.LTGRAY);c.drawLine(tx+12,ty-18,tx,ty+75,p);
            if(arc){p.setColor(Color.argb(75,100,220,255));c.drawCircle(tx,ty+85,95,p);p.setColor(Color.WHITE);c.drawCircle(tx,ty+85,16,p);p.setColor(Color.rgb(130,225,255));c.drawCircle(tx,ty+85,8,p);}
            p.setColor(Color.WHITE);p.setTextSize(28);c.drawText("WELDQUEST • WIG DC",28,42,p);p.setTextSize(20);c.drawText(String.format(Locale.GERMANY,"%s  •  %.1f mm  •  %.0f A  •  %.1f l/min",mat,thick,amp,gas),28,72,p);
            p.setTextSize(18);c.drawText(arc?"LICHTBOGEN AN — entlang der Fuge führen":"Tippen und halten: Lichtbogen zünden",28,h-32,p);
            p.setColor(Color.rgb(255,122,24));c.drawRoundRect(w-220,18,w-28,72,12,12,p);p.setColor(Color.BLACK);p.setTextSize(19);c.drawText("ZURÜCK",w-165,53,p);
            invalidate();
        }
        public boolean onTouchEvent(android.view.MotionEvent e){float w=getWidth(),h=getHeight();if(e.getAction()==MotionEvent.ACTION_DOWN && e.getX()>w-240 && e.getY()<95){showSetup();return true;}
            if(e.getAction()==MotionEvent.ACTION_DOWN||e.getAction()==MotionEvent.ACTION_MOVE){arc=true;x=Math.max(.1f,Math.min(.9f,e.getX()/w));y=Math.max(.43f,Math.min(.63f,e.getY()/h));if(lastX<0||Math.abs(e.getX()-lastX)>4){bead.add(e.getX());lastX=e.getX();}invalidate();return true;}
            if(e.getAction()==MotionEvent.ACTION_UP||e.getAction()==MotionEvent.ACTION_CANCEL){arc=false;invalidate();return true;}return true;}
    }
}