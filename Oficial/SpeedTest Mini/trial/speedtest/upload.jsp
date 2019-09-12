<%@ page language="java" import="java.util.Enumeration" %><% 

int base = 0;
String qs = request.getQueryString();
if (qs != null) {
   base += qs.length();
}

String str = "";
for(Enumeration e = request.getHeaderNames();
    e.hasMoreElements() ;) {
    str = (String) e.nextElement();
    base += str.length() + request.getHeader(str).length() + 2;
}

for(Enumeration e = request.getParameterNames();
    e.hasMoreElements() ;) {
    str = (String) e.nextElement();
    base += str.length() + request.getParameter(str).length() + 2;
}


out.print("&size=" + base + "&");
%>
