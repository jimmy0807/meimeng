class LanControlServerCallback
{
public:
    virtual ~LanControlServerCallback(){}
    virtual void onReceivePadOrder(const char* data);
};