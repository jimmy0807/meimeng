package com.born.boss;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.view.View;
import android.webkit.SslErrorHandler;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
public class BNWebViewActivity extends Activity
{
	public static final String WEB_TITLE = "WEB_TITLE";
	public static final String WEB_URL = "WEB_URL";
	public static final String WEB_Right_Title = "WEB_Right_Title";
	
	private TextView titleText;
	private WebView webView;
	private String title;
	private String url;
	private ProgressBar browser_progress;
	private TextView mCloseButton;
	
	static private BNWebViewActivityRightButtonListener mListener;
	IWXAPI wxAPI;

	public interface BNWebViewActivityRightButtonListener
	{
		void didRightButtonPressed(WebView webView);
	}
	
	public static void startAct(Context context, String title, String url)
	{
		Intent intent = new Intent(context, BNWebViewActivity.class);
		if ( url != null && url.length() >=4 && !url.subSequence(0, 4).equals("http") )
		{
			url = "http" + url;
		}
		intent.putExtra(WEB_TITLE, title);
		intent.putExtra(WEB_URL, url);
		context.startActivity(intent);
	}
	
	public static void startAct(Context context, String url)
	{
		Intent intent = new Intent(context, BNWebViewActivity.class);
		if ( url != null && url.length() >=4 && !url.subSequence(0, 4).equals("http") )
		{
			url = "http://" + url;
		}
		intent.putExtra(WEB_URL, url);
		context.startActivity(intent);
	}
	
	public static void startAct(Context context, String url, String rightTitle, BNWebViewActivityRightButtonListener listener)
	{
		Intent intent = new Intent(context, BNWebViewActivity.class);
		if ( url != null && url.length() >=4 && !url.subSequence(0, 4).equals("http") )
		{
			url = "http://" + url;
		}
		intent.putExtra(WEB_URL, url);
		intent.putExtra(WEB_Right_Title, rightTitle);
		mListener = listener;
		context.startActivity(intent);
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.web_view_activity);
		
		initView();
	}
	
	private void initView()
	{
		initData();
		titleText = (TextView)findViewById(R.id.navi_title);
		webView = (WebView)findViewById(R.id.webView);
		mCloseButton = (TextView)findViewById(R.id.navi_close);
		mCloseButton.setVisibility(View.GONE);
		
		browser_progress = (ProgressBar) findViewById(R.id.browser_progress);
		if(!TextUtils.isEmpty(title))
		{
			titleText.setText(title);
		}
		loadWebview(url);
		
		String rightTitle = getIntent().getStringExtra(BNWebViewActivity.WEB_Right_Title);
		if ( rightTitle != null )
		{
			Button rightButton = (Button)findViewById(R.id.navi_right_title);
			rightButton.setText(rightTitle);
			rightButton.setVisibility(View.VISIBLE);
		}
	}
	
	private void initData()
	{
		title = getIntent().getStringExtra(BNWebViewActivity.WEB_TITLE);
		url = getIntent().getStringExtra(BNWebViewActivity.WEB_URL);
	}
	
	@SuppressLint("SetJavaScriptEnabled")
	private void loadWebview(String url)
	{
		webView.setWebChromeClient(new WebChromeClient()
		{
			@Override
			public void onProgressChanged(WebView view, int newProgress)
			{
				super.onProgressChanged(view, newProgress);
				browser_progress.setProgress(newProgress);
			}
			
			@Override
			public void onReceivedTitle(WebView view, String title)
			{
				super.onReceivedTitle(view, title);
				titleText.setText(title);
			}
		});
		
		final Context context = this;
		browser_progress.setIndeterminate(false);
		webView.setWebViewClient(new WebViewClient()
		{
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url)
			{
				if (url.startsWith("http://") || url.startsWith("https://"))
				{
					view.loadUrl(url);
				}
				else
				{
					Intent intent = new Intent();
					intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					intent.setAction(Intent.ACTION_VIEW);
					intent.setData(Uri.parse(url));
					context.startActivity(intent);
				}
				
				return true;
			}
			
			@Override
			public void onPageFinished(WebView view, String url)
			{
				browser_progress.setVisibility(View.GONE);
				super.onPageFinished(view, url);
				new Handler().postDelayed(new Runnable()
				{   
				    public void run()
				    {   
				    	if ( webView.canGoBack() )
				    	{
				    		mCloseButton.setVisibility(View.VISIBLE);
				    	}
				    	else
				    	{
				    		mCloseButton.setVisibility(View.GONE);
				    	}
				    }   
				 }, 300);
			}
			
			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon)
			{
				browser_progress.setVisibility(View.VISIBLE);
				browser_progress.setMax(100);
				browser_progress.setProgress(0);
				super.onPageStarted(view, url, favicon);
			}
			
			@Override
			public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error)
			{
				handler.proceed();
			}
		});
		webView.getSettings().setJavaScriptEnabled(true);
		if (Build.VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN) 
		{
//			/webView.getSettings().setAllowUniversalAccessFromFileURLs(true);
		}
		webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
		webView.requestFocus();
		webView.setScrollBarStyle(WebView.SCROLLBARS_OUTSIDE_OVERLAY);
		
		
		//webView.loadUrl("file:///android_asset/www/app/index.html"); 
			
		webView.loadUrl(url);
	}
	
	public void onBack(View v)
	{
		if ( webView.canGoBack() )
		{
			webView.goBack();
		}
		else
		{
			finish();
		}
	}
	
	public void onClose(View v)
	{
		finish();
	}
	
	public void onNaviRightTitleClick(View v)
	{
		//mListener.didRightButtonPressed(webView);
		new CBCommonActionSheet(this)
				.setFriendListener(new CBCommonActionSheet.ActionSheetListener() {
							public void onClickListener() {
								share(true);
							}
						}).setSessionListener(new CBCommonActionSheet.ActionSheetListener() {
			public void onClickListener() {
				share(false);
			}
		}).showInParentBotton(findViewById(R.id.webview_layout));
	}

	void share(boolean session)
	{
		wxAPI = WXAPIFactory.createWXAPI(webView.getContext(), "wx3e18cef36f359534", true);
		wxAPI.registerApp("wx3e18cef36f359534");

		final SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = String.valueOf(System.currentTimeMillis());
		if ( session )
		{
			req.scene = SendMessageToWX.Req.WXSceneSession;
		}
		else
		{
			req.scene = SendMessageToWX.Req.WXSceneTimeline;
		}


		WXMediaMessage.IMediaObject mediaObject = null;
		WXMediaMessage wxMediaMessage = new WXMediaMessage();
		req.message = wxMediaMessage;

		wxMediaMessage.title = "分享";
		wxMediaMessage.description = "";
		mediaObject = new WXWebpageObject(url);

		wxMediaMessage.mediaObject = mediaObject;

		wxAPI.sendReq(req);
	}
}
