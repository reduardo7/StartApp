package com.surfernetwork.startapp;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.ComponentName;
import android.content.pm.PackageManager;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.net.Uri;
import android.os.SystemClock;
import android.util.Log;
import android.widget.Toast;

public class StartApp extends CordovaPlugin {
    public static final String NATIVE_ACTION_STRING="startApp";
    private String appurl=null;
    @Override
    public boolean execute(String action, JSONArray data, final CallbackContext callbackContext) throws JSONException  {
        Log.d("StartApp", "Hello, this is a native function called from PhoneGap/Cordova!");
        //only perform the action if it is the one that should be invoked

        try {
            if (NATIVE_ACTION_STRING.equals(action)) {

                if (data.length() != 1) {
                    callbackContext.error("error");

                    return false;
                }

                //final String component = data.getString(0);
                final String strjson = data.getString(0);
                final JSONObject arg_object = new JSONObject(strjson);
                Log.i("StartApp","strjson="+strjson);

                final String resultType=arg_object.has("result")?arg_object.getString("result"):null;
                final String appid=arg_object.has("appid")?arg_object.getString("appid"):null;
                final String apptype=arg_object.has("apptype")?arg_object.getString("apptype"):null;
                final String urlscheme=arg_object.has("urlscheme")?arg_object.getString("urlscheme"):null;
                appurl=arg_object.has("appurl")?arg_object.getString("appurl"):null;

                Log.d("StartApp","result="+resultType);
                Log.d("StartApp","appid="+appid);
                Log.d("StartApp","apptype="+apptype);
                Log.d("StartApp","urlscheme="+urlscheme);
                Log.d("StartApp","appurl="+appurl);

                cordova.getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        //loadApp(component);

                        if(apptype.equals("facebook"))
                        {
                            Log.d("StartApp"," call facebook");
                            openFacebook(appid,apptype);
                        }
                        else if(apptype.equals("twitter"))
                        {
                            Log.d("StartApp"," call twitter");
                            openTwitter(appid,apptype);
                        }
                        else if(apptype.equals("youtube"))
                        {
                            Log.d("StartApp"," call youtube");
                            openYoutube(appid,apptype);
                        }
                        else if(apptype.equals("instagram"))
                        {
                            Log.d("StartApp"," call instagram");
                            openInstagram(appid,apptype);
                        }
                        else if(apptype.equals("snapchat"))
                        {
                            Log.d("StartApp"," call snapchat");
                            openSnapchat(appid,apptype);
                        }
                        else if(apptype.equals("website"))
                        {
                            Log.d("StartApp"," call website");
                            openWeb(appid,apptype);
                        }
                        callbackContext.success();

                    }
                });

                return true;
            }
            callbackContext.error("error");
            return true;

        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("error");
            return true;
        }

    }

    void loadApp(String component) {
        Intent intent=new Intent(Intent.ACTION_MAIN);
        PackageManager manager=this.cordova.getActivity().getApplicationContext().getPackageManager();
        intent=manager.getLaunchIntentForPackage(component);
        intent.addCategory(Intent.CATEGORY_LAUNCHER);

        this.cordova.getActivity().getApplicationContext().startActivity(intent);
    }

    public void openFacebook(String appid, String apptype) {
        Intent i = null;

        try {
            Log.d("StartApp", "In try");

            String fbappurl="fb://facewebmodal/f?href="+appurl;

            i = new Intent(Intent.ACTION_VIEW, Uri.parse(fbappurl));
        } catch (Exception e) {
            Log.d("StartApp","In exception");
            e.getMessage();
            e.printStackTrace();
           i = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));
        }

        checkIfAppExists(i, apptype);

    }

    //Twitter

    public void openTwitter(String appid, String apptype){
        Intent i = null;
        Log.d("StartApp","In openTwitterPage");

        try {
            Log.d("StartApp","openTwitterPage In try");
            i = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));

        }catch (Exception e) {
            Log.d("StartApp", "openTwitterPage In exception");
            i = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));
        }

        checkIfAppExists(i, apptype);
    }

    //Youtube

    public void openYoutube(String appid, String apptype){
        Intent i = null;
        Log.d("StartApp","In openYoutube");

        try {
            Log.d("StartApp","openYoutube In try");
            this.cordova.getActivity().getApplicationContext().getPackageManager().getPackageInfo(appid, 0);

           Log.d("StartApp","openYoutube url : "+appurl);

            i=new Intent(Intent.ACTION_VIEW);
            i.setData(Uri.parse(appurl));
            //i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }catch (Exception e) {
            Log.d("StartApp", "openYoutube In exception");

            // try to use other intent
            i = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));
        }

        checkIfAppExists(i, apptype);
    }

    //Instagram

    public void openInstagram(String appid, String apptype){
        Intent i = null;
        Log.d("StartApp","In openInstagram");

        try {
            Log.d("StartApp", "openInstagram In try");
            this.cordova.getActivity().getApplicationContext().getPackageManager().getPackageInfo(appid, 0);

            Log.d("StartApp","openInstagram url : "+appurl);
           String instaurl = appurl;
           //remove spaces
            instaurl=instaurl.trim();

            String instauser=null;

            if (instaurl.toLowerCase().contains("www.")) {
                instauser = instaurl.replace(instaurl.substring(0, 25), "");
            }
                else{
                instauser = instaurl.replace(instaurl.substring(0, 21), "");
            }

            Log.d("StartApp","instauser="+instauser);
            i = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.instagram.com/_u/"+instauser));

        }catch (Exception e) {
            Log.d("StartApp","openInstagram In exception");

            // try to use other intent
            i = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));
        }

        checkIfAppExists(i, apptype);
    }
        //Snapchat
    public void openSnapchat(String appid, String apptype){
        Intent i = null;
        Log.d("StartApp","In openSnapchat");

        try {
            Log.d("StartApp","openSnapchat In try");
            this.cordova.getActivity().getApplicationContext().getPackageManager().getPackageInfo(appid, 0);

            Log.d("StartApp","openSnapchat url : "+appurl);

            i=new Intent(Intent.ACTION_VIEW);
            i.setData(Uri.parse(appurl));
            //i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }catch (Exception e) {
            Log.d("StartApp", "openSnapchat In exception");

            // try to use other intent
            i = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));
        }

        checkIfAppExists(i, apptype);
    }
    //Web

    public void openWeb(String appid, String apptype){
        Intent i = null;
        Log.d("StartApp","In openWeb");

        try {
            Log.d("StartApp","openWeb In try");
            i = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));

        }catch (Exception e) {
            Log.d("StartApp","openWeb In exception");
            i = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));
        }

        this.cordova.getActivity().startActivity(i);
    }

    // method to check whether an app exists or not
    public void checkIfAppExists(Intent appIntent, String appName){
        Log.d("StartApp","In checkIfAppExists");

        try{
            Log.d("StartApp","In checkIfAppExists try");
            appIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (appIntent.resolveActivity(this.cordova.getActivity().getApplicationContext().getPackageManager()) != null) {
                Log.d("StartApp", " App found checkIfAppExists");

                // start the activity if the app exists in the system

            } else {
                Log.d("StartApp"," App not found checkIfAppExists");
                // tell the user the app does not exist
                //Toast.makeText(this.cordova.getActivity().getApplicationContext(), appName + " app does not exist!", Toast.LENGTH_LONG).show();
                appIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(appurl));
            }
            this.cordova.getActivity().startActivity(appIntent);
        }
        catch (Exception e) {
            Log.d("StartApp","In checkIfAppExists exception");
            e.getMessage();
            e.printStackTrace();

        }
    }

}
