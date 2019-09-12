<Head>
  <script language=CS runat=server>
    void Page_Load(object sender, System.EventArgs e) 
    {
	<%--
	Copyright 2007 Ookla
	Calculates the size of an HTTP POST
	--%>
	int size = 0;
	size += Request.ServerVariables["ALL_RAW"].Length;
	size += Request.ServerVariables["QUERY_STRING"].Length;
	size += Request.TotalBytes;
	string reply = string.Format("size={0}", size.ToString());
	Response.Buffer = false;
	Response.AddHeader("Content-Length", reply.Length.ToString());
	Response.Write(reply);
	Response.End();
    }
  </script>
</Head>
