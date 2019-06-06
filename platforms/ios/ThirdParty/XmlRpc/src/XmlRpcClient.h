
#ifndef _XMLRPCCLIENT_H_
#define _XMLRPCCLIENT_H_

#if defined(_MSC_VER)
# pragma warning(disable:4786)    // identifier was truncated in debug info
#endif


#ifndef MAKEDEPEND
# include <string>
#endif

namespace XmlRpc
{
  class XmlRpcValue;
  class XmlRpcClient {
  public:
    static const char REQUEST_BEGIN[];
    static const char REQUEST_END_METHODNAME[];
    static const char PARAMS_TAG[];
    static const char PARAMS_ETAG[];
    static const char PARAM_TAG[];
    static const char PARAM_ETAG[];
    static const char REQUEST_END[];
      
    static const char METHODRESPONSE_TAG[];
    static const char FAULT_TAG[];

  };
}

#endif
