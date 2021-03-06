package com.example.flutter_sensors;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.sensor.speaker";


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);



        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {

                    if (call.method.equals(("genTone"))) {
                        final Map<String,Object> argument=call.arguments();

                        int duration = (int) argument.get("duration");
                        int sampleRate = (int) argument.get("sampleRate");
                        double freq1 = (double)argument.get("freq1");
                        double freq2 = (double)argument.get("freq2");
                        int numSample = duration * sampleRate;
                        double sample[] = new double[numSample];
                        byte[] generatedSnd = new byte[2 * numSample];
                        double instfreq = 0, numerator;
                        for (int i = 0; i < numSample; i++) {
                            numerator = (double) (i) / (double) numSample;
                            instfreq = freq1 + (numerator * (freq2 - freq1));
                            if ((i % 1000) == 0) {
                                Log.e("Current Freq:", String.format("Freq is: %f at loop %d of %d", instfreq, i, numSample));
                            }
                            sample[i] = Math.sin(2 * Math.PI * i / (sampleRate / instfreq));

                        }
                        int idx = 0;
                        for (final double dVal : sample) {
                            final short val = (short) ((dVal * 32767));
                            generatedSnd[idx++] = (byte) (val & 0x00ff);
                            generatedSnd[idx++] = (byte) ((val & 0xff00) >>> 8);
                        }
                        Map<String,Object> audioTrackDetails=new HashMap<>();
                        audioTrackDetails.put("generatedSnd",generatedSnd);
                        audioTrackDetails.put("sampleRate",sampleRate);
                        result.success(audioTrackDetails);

                    }
                    if(call.method.equals("playTone")){
                        final Map<String,Object> argument=call.arguments();
                        System.out.println(argument.entrySet());
                        byte[] generatedSnd=(byte[])argument.get("generatedSnd");
                        int sampleRate=(Integer)argument.get("sampleRate");
                        AudioTrack audioTrack;
                        audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC,sampleRate,
                                AudioFormat.CHANNEL_CONFIGURATION_MONO,
                                AudioFormat.ENCODING_PCM_16BIT,
                                generatedSnd.length,
                                AudioTrack.MODE_STATIC);
                        audioTrack.write(generatedSnd, 0, generatedSnd.length);
                        audioTrack.play();
                    }
                });
    }

}