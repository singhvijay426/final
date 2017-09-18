<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="student.aspx.cs" Inherits="Demo.student" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Demo</title>
    <style type="text/css">
        .DetailsRequired {
            font-size: 15px;
            color: red;
        }

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

        <asp:ScriptManager runat="server"></asp:ScriptManager>

        <div style="font-family: Aharoni; font-size: 30px; text-align: center; margin: 30px;">
            <asp:Label ID="lblHead" runat="server" Text="Demo"></asp:Label>
        </div>
        <hr />
        <br />

        <br />
        <center>
            <div style="font-size: 25px; text-align: left; border: 2px solid black; width: 700px; padding: 30px;">
                <div style="text-align: center;">
                    Select Student For Update :
                <asp:DropDownList ID="ddlStudent" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlStudent_SelectedIndexChanged">
                </asp:DropDownList>
                    &nbsp; &nbsp; &nbsp;
                <asp:Button ID="btnInsertNew" runat="server" Text="Refresh" Width="150px" Font-Size="22px"
                    OnClick="btnInsertNew_Click" />
                </div>
                <br />
                <hr />
                <table cellspacing="10px" cellpadding="5px">
                   
                    <tr>
                        <td>Name :<font style="color: red">*</font>
                        </td>
                        <td>
                            <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtName"
                                Display="Dynamic" CssClass="DetailsRequired" ValidationGroup="login" ErrorMessage="Name required!"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>Email Address :<font style="color: red">*</font>
                        </td>
                        <td>
                            <asp:TextBox ID="txtEmailAddress" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvtxtEmail" runat="server" ControlToValidate="txtEmailAddress"
                                Display="Dynamic" CssClass="DetailsRequired" ValidationGroup="login" ErrorMessage="Email address required!"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revtxtEmail" runat="server" ControlToValidate="txtEmailAddress"
                                ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic"
                                ValidationGroup="login" CssClass="DetailsRequired" ErrorMessage="Sorry this email address is not recognized."></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>Password :<font style="color: red">*</font>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvtxtPassword" runat="server" ControlToValidate="txtPassword"
                                Display="Dynamic" CssClass="DetailsRequired" ValidationGroup="login" ErrorMessage="Password required!"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>Course :
                        </td>
                        <td>
                            <asp:TextBox ID="txtCourse" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Semester :
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlSemester" runat="server" Style="height: 20px; width: 180px;">
                                <asp:ListItem Value="first">First</asp:ListItem>
                                <asp:ListItem Value="second">Second</asp:ListItem>
                                <asp:ListItem Value="third">Third</asp:ListItem>
                                <asp:ListItem Value="fourth">Fourth</asp:ListItem>
                                <asp:ListItem Value="fifth">Fifth</asp:ListItem>
                                <asp:ListItem Value="sixth">Sixth</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>University :
                        </td>
                        <td>
                            <asp:TextBox ID="txtUniversity" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <hr />
                <div style="text-align: center; padding: 10px;">
                    <asp:Button ID="btnSave" runat="server" Text="Save/Update" Width="150px" Font-Size="22px"
                        OnClick="btnSave_Click" ValidationGroup="login" />&nbsp; &nbsp; &nbsp;
          
                    <asp:Button ID="btnDelete" runat="server" Text="Delete From Dropdown" Width="250px" Font-Size="22px"
                        OnClick="bntDelete_Click" /><br />
                    <br />
                    <asp:Button ID="btngridDelete" runat="server" Text="Delete From Grid" Width="250px" Font-Size="22px" OnClick="btngridDelete_Click" />
                </div>
                 <br />
                            <asp:Label ID="lblmsg" runat="server" Style="color: red;"></asp:Label>
                      
            </div>

            <br />
            <br />

            <asp:GridView runat="server" ID="gvDetails" AllowPaging="true" PageSize="10" AutoGenerateColumns="false" Width="700px" OnPageIndexChanging="gvDetails_PageIndexChanging">
                <HeaderStyle CssClass="headerstyle" />
                <Columns>
                    <asp:TemplateField HeaderText="Select">
                        <HeaderTemplate>
                            Select
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="cb_select" runat="server" CssClass="cbSelect" /><%#Container.DataItemIndex+1 %>
                            <asp:Label ID="lblId" runat="server" Visible="false" Text='<%# Eval("Student_Id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Name" HeaderText="Name" />
                    <asp:BoundField DataField="Course" HeaderText="Course" />
                    <asp:BoundField DataField="Semester" HeaderText="Semester" />
                    <asp:BoundField DataField="University" HeaderText="University" />
                    <asp:BoundField DataField="EmailAddress" HeaderText="EmailAddress" />
                    <asp:BoundField DataField="Password" HeaderText="Password" />
                </Columns>
            </asp:GridView>
            <br />

        </center>


    </form>

</body>
</html>



