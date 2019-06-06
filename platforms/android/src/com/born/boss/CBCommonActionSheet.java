package com.born.boss;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.PopupWindow;
import android.widget.TextView;

public class CBCommonActionSheet extends PopupWindow
{
	private Button m_popu_ok; 
    private Button m_popu_cancel;  
    private TextView m_title;
    
    private View m_popupView;

    private Context m_context;
    
    private ActionSheetListener m_sessionBtnListener;
    private ActionSheetListener m_friendBtnListener;
    
    public interface ActionSheetListener
    {
    	void onClickListener();
    }
    
	public CBCommonActionSheet(Context context)
    {  
        super(context);
        m_context = context;
        
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        m_popupView = inflater.inflate(R.layout.delete_card_popupwindow, null);
        
        m_title = (TextView) m_popupView.findViewById(R.id.popup_title);
        
        m_popu_ok = (Button) m_popupView.findViewById(R.id.btn_ok);
        m_popu_ok.setOnClickListener(new OnClickListener()
        {
			public void onClick(View v)
			{
				if ( m_sessionBtnListener != null )
				{
					m_sessionBtnListener.onClickListener();
				}
				
				dismiss();
			}
		});

		Button friendBtn = (Button)m_popupView.findViewById(R.id.popup_title);
		friendBtn.setOnClickListener(new OnClickListener()
		{
			public void onClick(View v)
			{
				if ( m_friendBtnListener != null )
				{
					m_friendBtnListener.onClickListener();
				}

				dismiss();
			}
		});

        m_popu_cancel = (Button) m_popupView.findViewById(R.id.btn_cancel);
        m_popu_cancel.setOnClickListener(new OnClickListener()
        {
			public void onClick(View v)
			{
//				if ( m_cancelBtnListener != null )
//				{
//					m_cancelBtnListener.onClickListener();
//				}
				
				dismiss();
			}
		});
        
        this.setContentView(m_popupView);  
        this.setWidth(LayoutParams.MATCH_PARENT);  
        this.setHeight(LayoutParams.WRAP_CONTENT);  
        this.setFocusable(true);
        ColorDrawable drawable = new ColorDrawable(0x80000000);
        this.setBackgroundDrawable(drawable);
        this.setAnimationStyle(R.style.dialog_nodim);
        this.setOutsideTouchable(true);
        m_popupView.setOnTouchListener(new OnTouchListener()
        {
			public boolean onTouch(View v, MotionEvent event)
			{
				int height = m_popupView.findViewById(R.id.delete_layout).getTop();
				int y = (int) event.getY();
				if (event.getAction() == MotionEvent.ACTION_UP)
				{
					if (y < height)
					{
						dismiss();
					}
				}
				return true;
			}
		});
    }
    
	public CBCommonActionSheet setTitle(String title)
	{
		m_title.setText(title);
		return this;
	}
	
	public CBCommonActionSheet setFriendListener(ActionSheetListener listener)
	{
		m_friendBtnListener = listener;
		return this;
	}
	
	public CBCommonActionSheet setSessionListener(ActionSheetListener listener)
	{
		m_sessionBtnListener = listener;

		return this;
	}

    public void showInParentBotton(View parent)
    {
    	this.showAtLocation(parent, Gravity.BOTTOM, 0, 0);
    }
}
