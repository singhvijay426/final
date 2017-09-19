<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="studentAjax.aspx.cs" Inherits="Demo.studentAjax" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>jQuery Gridview Crud Operations Example</title>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.8.2.js"></script>
    <script type="text/javascript">

        var prodid = 0, opstatus = '';

        $(function () {
            BindGridview();
            $('#btndelete').hide();
        });

        function BindGridview() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "studentAjax.aspx/BindGridview",
                data: "{}",
                dataType: "json",
                success: function (data) {
                    var result = data.d;
                    for (var i = 0; i < result.length; i++) {
                       
                        $("#gvDetails").append('<tr><td>' + result[i].productid + '</td><td>' + result[i].productname + '</td><td>' + result[i].price + '</td><td><img src=images/edit.jpg width=20px height=20px onclick=updatedata(' + result[i].productid + ',"' + result[i].productname + '","' + result[i].price + '") > <img src=images/delete.png width=20px height=20px onclick=deleterecords(' + result[i].productid + ')> </td></tr>');
                    }
                },
                error: function (data) {
                    var r = data.responseText;
                    var errorMessage = r.Message;
                    alert(errorMessage);
                }
            });
        }

        function deleterecords(productid) {
            insertupdatedata(productid, '', '', 'DELETE')
        }

        function insertupdatedata(productid, productname, price, status) {
            if (prodid != 0 && opstatus == 'UPDATE')
                productid = prodid;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "studentAjax.aspx/crudoperations",
                data: "{'productid':'" + productid + "','productname':'" + productname + "','price':'" + price + "','status':'" + status + "'}",
                dataType: "json",
                success: function (data) {
                    if (data.d == 'true')
                        $('#btnInsert').show();
                    $('#btndelete').hide();
                        window.location.reload();
                },
                error: function (data) {
                    var r = data.responseText;
                    var errorMessage = r.Message;
                    alert(errorMessage);
                }
            });
        }

        function updatedata(productid, productname, price) {
            debugger;
            $('#btnInsert').hide();
            $('#btndelete').show();
            prodid = productid;
            $('#ProId').val(productid);
            $('#txtProduct').val(productname);
            $('#txtPrice').val(price);
            opstatus = 'UPDATE';
          
        }

    </script>
    <style type="text/css">
        .GridviewDiv {
            font-size: 100%;
            font-family: 'Lucida Grande', 'Lucida Sans Unicode', Verdana, Arial, Helevetica, sans-serif;
            color: #303933;
        }

        .headerstyle {
            color: #FFFFFF;
            border-right-color: #abb079;
            border-bottom-color: #abb079;
            background-color: #df5015;
            padding: 0.5em 0.5em 0.5em 0.5em;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <table>
            <tr>
                <td>Product Name:</td>
                <td>
                    <span class="hide" id="ProId"></span>
                    <input type="text" id="txtProduct" /></td>
            </tr>
            <tr>
                <td>Price:</td>
                <td>
                    <input type="text" id="txtPrice" /></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input type="button" id="btnInsert" value="Insert" onclick="insertupdatedata('0',$('#txtProduct').val(),$('#txtPrice').val(),'INSERT')" />
                      <input type="button" id="btndelete" value="UPDATE" onclick="insertupdatedata($('#ProId').val(), $('#txtProduct').val(), $('#txtPrice').val(), 'UPDATE')" />
                </td>
            </tr>
        </table>
        <br />
        <div class="GridviewDiv">
            <asp:GridView runat="server" ID="gvDetails">
                <HeaderStyle CssClass="headerstyle" />
            </asp:GridView>
        </div>
    </form>
</body>
</html>
