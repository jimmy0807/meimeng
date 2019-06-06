package ds.security;


import android.util.Log;

import com.born.boss.BNWebViewActivity;
import com.born.boss.MainActivity;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

public class Security extends CordovaPlugin {
    public static final String TAG = "Security";
    private static final String BASE_SALT = "a1f538ec9cf94cf2220b34357ac44f5e7a05rt5a";
    private static final String SALT = "c1f538ec9cf94cf5660b94357ac44f5e7a05817a";
    public static final String ERROR_INVALID_PARAMETERS = "参数格式错误";
    public static final String KEY_DEVICE_MODE = "device_mode";
    public static final String KEY_PLATFORM = "platform";
    public static final String KEY_DEVICE_UUID = "device_uuid";
    public static final String KEY_VERSION = "version";
    public static final String KEY_LATITUDE = "latitude";
    public static final String KEY_LONGITUDE = "longitude";
    public static final String KEY_LOGIN = "login";
    public static final String KEY_UID = "uid";
    public static final String KEY_URL = "url";
    public static final String KEY_DB = "db";
    public static final String KEY_SIGN_DATA = "data";
    public static final String KEY_SIGN_TYPE = "type";
    private static final String ENCODING = "UTF-8";
    private static final int TIME = 40 * 1000;
    public static final String SERVER_URL = "http://we-erp.com/MAST/api/app_init";
    private String _httpUrl = "";
    private String _db = "";
    private String _userSecret = "";

    private String LAUNCH_KEY_URL = "launch_url";
    private String LAUNCH_KEY_DB = "launch_db";
    private String LAUNCH_KEY_CID = "launch_cid";
    private String LAUNCH_KEY_CATEGORY = "launch_category";
    private String LAUNCH_KEY_UID = "launch_uid";
    private String LAUNCH_KEY_MOBILE = "launch_mobile";
    private String LAUNCH_KEY_SID = "launch_sid";
    private String LAUNCH_Browser = "launch_browser";

    private boolean hasFetchUserInfo = false;

    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext)
            throws JSONException {

        Log.e(TAG, _userSecret);
        if (action.equals("sign")) {
            this.sign(args,1, callbackContext);
            return true;
        } else if (action.equals("deviceRegister")) {
            this.deviceRegister(args, callbackContext);
            return true;
        } else if (action.equals("signCommon")) {
            this.signCommon(args,0, callbackContext);
            return true;
        } else if (action.equals("deviceInit")) {
            this.deviceInit(args, callbackContext);
            return true;
        }
        else if (action.equals("launch")) {
            this.launch(args, callbackContext);
            return true;
        }

        return false;
    }


    /**
     * 请求签名
     *
     * @param args
     * @param callbackContext
     * @return
     */
    protected boolean sign(CordovaArgs args, Integer type, final CallbackContext callbackContext) {
        final JSONObject params;
        try {
            params = args.getJSONObject(0);
            SortedMap<Object, Object> parameters = new TreeMap<Object, Object>();
            Iterator<String> it = params.keys();
            while (it.hasNext()) {
                String key = (String) it.next();
                String u = params.get(key).toString();
                parameters.put(key, u);
            }
            StringBuffer sb = new StringBuffer();
            Set es = parameters.entrySet();//所有参与传参的参数按照accsii排序（升序）
            Iterator pit = es.iterator();
            while (pit.hasNext()) {
                Map.Entry entry = (Map.Entry) pit.next();
                String k = (String) entry.getKey();
                Object v = entry.getValue();
                if (null != v && !"".equals(v)
                        && !"sign".equals(k) && !"key".equals(k)) {
                    if(sb.toString().length()>0){
                        sb.append("&"+k + "=" + v);
                    }else{
                        sb.append(k + "=" + v);
                    }
                }
            }
            String signData = sb.toString();

            if (signData == null || signData.length() <= 0) {
                callbackContext.error(ERROR_INVALID_PARAMETERS);
            }

            String sign = "";
            sign = md5(signData + _userSecret);

            params.put("sign", sign);
            callbackContext.success(params);


        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            callbackContext.error(ERROR_INVALID_PARAMETERS);
            return true;
        }
        return true;
    }



    /**
     * 请求签名
     *
     * @param args
     * @param callbackContext
     * @return
     */
    protected boolean signCommon(CordovaArgs args, Integer type, final CallbackContext callbackContext) {
        final JSONObject params;
        try {
            params = args.getJSONObject(0);
            SortedMap<Object, Object> parameters = new TreeMap<Object, Object>();
            Iterator<String> it = params.keys();
            while (it.hasNext()) {
                String key = (String) it.next();
                String u = params.get(key).toString();
                parameters.put(key, u);
            }
            StringBuffer sb = new StringBuffer();
            Set es = parameters.entrySet();//所有参与传参的参数按照accsii排序（升序）
            Iterator pit = es.iterator();
            while (pit.hasNext()) {
                Map.Entry entry = (Map.Entry) pit.next();
                String k = (String) entry.getKey();
                Object v = entry.getValue();
                if (null != v && !"".equals(v)
                        && !"sign".equals(k) && !"key".equals(k)) {

                    if(sb.toString().length()>0){
                        sb.append("&"+k + "=" + v);
                    }else{
                        sb.append(k + "=" + v);
                    }
                }
            }
            String signData = sb.toString();

            if (signData == null || signData.length() <= 0) {
                callbackContext.error(ERROR_INVALID_PARAMETERS);
            }
            String sign = "";
            sign = md5(signData + SALT);

            params.put("sign", sign);
            callbackContext.success(params);


        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            callbackContext.error(ERROR_INVALID_PARAMETERS);
            return true;
        }
        return true;
    }


    protected boolean deviceInit(CordovaArgs args, final CallbackContext callbackContext) {
        final JSONObject params;
        try {
            params = args.getJSONObject(0);

            String device_mode = params.getString(KEY_DEVICE_MODE);
            String platform = params.getString(KEY_PLATFORM);
            String device_uuid = params.getString(KEY_DEVICE_UUID);
            String version = params.getString(KEY_VERSION);
            String latitude = params.getString(KEY_LATITUDE);
            String longitude = params.getString(KEY_LONGITUDE);
            String login = params.getString(KEY_LOGIN);

            String data = "device_mode=" + device_mode +
                    "&device_uuid=" + device_uuid +
                    "&latitude=" + latitude +
                    "&login=" + login +
                    "&longitude=" + longitude +
                    "&platform=" + platform +
                    "&version=" + version;
            String sign = md5(data + BASE_SALT);

            String sendData = "<xml><platform>" + platform + "</platform>" +
                    "<longitude>" + longitude + "</longitude>" +
                    "<device_uuid>" + device_uuid + "</device_uuid>" +
                    "<latitude>" + latitude + "</latitude>" +
                    "<device_mode>" + device_mode + "</device_mode>" +
                    "<version>" + version + "</version>" +
                    "<login>" + login + "</login>" +
                    "<sign>" + sign + "</sign>" +
                    "</xml>";

            JSONObject response = sendPostRequest(SERVER_URL, sendData);
            if (response == null) {
                callbackContext.error(ERROR_INVALID_PARAMETERS);
            } else {
                int errcode = response.getInt("errcode");
                if (errcode == 0) {
                    JSONObject rdata = response.getJSONObject("data");

                    String url = rdata.getString("url");
                    String db = rdata.getString("db");

                    this._httpUrl = url;
                    this._db = db;
                    callbackContext.success(rdata);
                } else {
                    String errmsg = response.getString("errmsg");
                    callbackContext.error(errmsg);
                }
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            callbackContext.error(ERROR_INVALID_PARAMETERS);
            return true;
        }
        return true;
    }

    protected boolean deviceRegister(CordovaArgs args, final CallbackContext callbackContext) {
        final JSONObject params;
        try {
            params = args.getJSONObject(0);

            String device_mode = params.getString(KEY_DEVICE_MODE);
            String platform = params.getString(KEY_PLATFORM);
            String device_uuid = params.getString(KEY_DEVICE_UUID);
            String version = params.getString(KEY_VERSION);
            String latitude = params.getString(KEY_LATITUDE);
            String longitude = params.getString(KEY_LONGITUDE);
            String login = params.getString(KEY_LOGIN);
            String uid = params.getString(KEY_UID);
            String url = params.getString(KEY_URL);
            String db = params.getString(KEY_DB);
            if (url != null && url.length() > 0) {
                this._httpUrl = url;
            }
            if (db != null && db.length() > 0) {
                this._db = db;
            }

            String data = "device_mode=" + device_mode +
                    "&device_uuid=" + device_uuid +
                    "&latitude=" + latitude +
                    "&login=" + login +
                    "&longitude=" + longitude +
                    "&platform=" + platform +
                    "&uid=" + uid +
                    "&version=" + version;
            String sign = md5(data + SALT);

            String sendData = "<xml><platform>" + platform + "</platform>" +
                    "<longitude>" + longitude + "</longitude>" +
                    "<device_uuid>" + device_uuid + "</device_uuid>" +
                    "<latitude>" + latitude + "</latitude>" +
                    "<device_mode>" + device_mode + "</device_mode>" +
                    "<version>" + version + "</version>" +
                    "<login>" + login + "</login>" +
                    "<uid>" + uid + "</uid>" +
                    "<sign>" + sign + "</sign>" +
                    "</xml>";


            String apiUrl = this._httpUrl + "/" + this._db + "/ds/device";
            JSONObject response = sendPostRequest(apiUrl, sendData);
            if (response == null) {
                callbackContext.error(ERROR_INVALID_PARAMETERS);
            } else {
                int errcode = response.getInt("errcode");
                if (errcode == 0) {
                    JSONObject rdata = response.getJSONObject("data");
                    String secret = rdata.getString("secret");
                    int id = rdata.getInt("id");
                    _userSecret = secret;
                    callbackContext.success(id);
                } else {
                    String errmsg = response.getString("errmsg");
                    callbackContext.error(errmsg);
                }
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            callbackContext.error(ERROR_INVALID_PARAMETERS);
            return true;
        }
        return true;
    }

    /**
     * 发送请求
     *
     * @param service 服务地址
     * @param data    数据
     */
    private JSONObject sendPostRequest(String service, String data) {
        HttpURLConnection conn = null;
        InputStream input = null;
        StringBuffer sBuffer = new StringBuffer();
        String line = null;
        BufferedReader bReader = null;
        try {
            URL url = new URL(service);
            conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(TIME);
            conn.setReadTimeout(TIME);
            conn.setDoInput(true);
            conn.setDoOutput(true);
            conn.setUseCaches(false);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Connection", "close");
            conn.setRequestProperty("Charset", ENCODING);
            conn.setRequestProperty("Content-Length", String.valueOf(data.length()));
            conn.setRequestProperty("Content-Type", "text/*;charset=utf-8");
            DataOutputStream outStream = new DataOutputStream(conn.getOutputStream());
            outStream.write(data.getBytes());
            outStream.flush();
            outStream.close();
            if (conn == null) {
                return null;
            }
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                input = conn.getInputStream();
                if (input != null) {
                    bReader = new BufferedReader(new InputStreamReader(input));
                    while ((line = bReader.readLine()) != null) {
                        sBuffer.append(line);
                    }
                    return new JSONObject(sBuffer.toString());
                }
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
        }
        return null;
    }

    /**
     * MD5加密
     *
     * @param string
     * @return
     */
    public static String md5(String string) {
        byte[] hash;
        try {
            hash = MessageDigest.getInstance("MD5").digest(string.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Huh, MD5 should be supported?", e);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("Huh, UTF-8 should be supported?", e);
        }
        StringBuilder hex = new StringBuilder(hash.length * 2);
        for (byte b : hash) {
            if ((b & 0xFF) < 0x10) hex.append("0");
            hex.append(Integer.toHexString(b & 0xFF));
        }
        return hex.toString();
    }

    protected boolean launch(CordovaArgs args, final CallbackContext callbackContext) {
        final JSONObject params;
        try {
            params = args.getJSONObject(0);

            String launchUrl = params.getString(LAUNCH_KEY_URL);
            String launchDb = params.getString(LAUNCH_KEY_DB);
            String launchCid = params.getString(LAUNCH_KEY_CID);
            String launchCategory = params.getString(LAUNCH_KEY_CATEGORY);
            String launchUid = params.getString(LAUNCH_KEY_UID);
            String launchMobile = params.getString(LAUNCH_KEY_MOBILE);
            final String launchSid = params.getString(LAUNCH_KEY_SID);

            callbackContext.success("");

            if (launchCategory.equals("browser")) {
                final String url = params.getString(LAUNCH_Browser);

                ((MainActivity) cordova.getActivity()).getHandler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        BNWebViewActivity.startAct(cordova.getActivity(),url);
                        //HistoryActivity.startAct(cordova.getActivity());
                    }
                }, 0);
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            callbackContext.error(ERROR_INVALID_PARAMETERS);
            return true;
        }
        return true;
    }
}

