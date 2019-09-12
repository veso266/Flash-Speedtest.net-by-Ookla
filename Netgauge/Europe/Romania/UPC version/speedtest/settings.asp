<%@LANGUAGE="VBSCRIPT"%>
<%
Response.ContentType="text/xml"
Dim xml
Set fs=Server.CreateObject("Scripting.FileSystemObject")
Set f=fs.OpenTextFile(Server.MapPath("settings.xml"),1)
xml = f.ReadAll
f.close
xml = Replace(xml, "%CLIENT_IP%", Request.ServerVariables("REMOTE_ADDR"))
Response.Write xml
Set f=Nothing
Set fs=Nothing
Set xml=Nothing
%>
