using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Demo
{
    public partial class student : System.Web.UI.Page
    {
        public SqlConnection con;
        public SqlCommand cmd;
        public SqlDataAdapter da;
        public DataSet ds;
        public DataTable dt;
        string strcon = "Data Source=.\\SQLEXPRESS;Initial Catalog=Student; Integrated Security=True";

        //string strcon = ConfigurationSettings.AppSettings["AppDatabaseName"];

        protected void Page_Load(object sender, EventArgs e)
        {
            Connection_Data();
            if (!IsPostBack)
            {
                Student_Bind();
                BindGridview();
            }
        }

        private void Connection_Data()
        {
            con = new SqlConnection(strcon);
            cmd = new SqlCommand();
            cmd.Connection = con;
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            dt = new DataTable();
        }

        protected void btnInsertNew_Click(object sender, EventArgs e)
        {
            //Insert new records
            ddlStudent.SelectedIndex = 0;
            ClearAll();
            txtName.Focus();
            lblmsg.Text = "";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            con.Open();
            if (ddlStudent.SelectedIndex == 0)
            {
                //Insert data into database
                cmd.CommandText = "student_insert";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("Name", txtName.Text);
                cmd.Parameters.AddWithValue("Course", txtCourse.Text);
                cmd.Parameters.AddWithValue("Semester", ddlSemester.SelectedItem.Value);
                cmd.Parameters.AddWithValue("University", txtUniversity.Text);
                cmd.Parameters.AddWithValue("EmailAddress", txtEmailAddress.Text);
                cmd.Parameters.AddWithValue("Password", txtPassword.Text);
                cmd.ExecuteNonQuery();
                lblmsg.Text = "Student details inserted successfully";
                con.Close();
            }
            else
            {
                //Update student details
                cmd.CommandText = "student_update";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("Student_Id", Convert.ToInt32(ddlStudent.SelectedItem.Value));
                cmd.Parameters.AddWithValue("Name", txtName.Text);
                cmd.Parameters.AddWithValue("Course", txtCourse.Text);
                cmd.Parameters.AddWithValue("Semester", ddlSemester.SelectedItem.Value.ToString());
                cmd.Parameters.AddWithValue("University", txtUniversity.Text);
                cmd.Parameters.AddWithValue("EmailAddress", txtEmailAddress.Text);
                cmd.Parameters.AddWithValue("Password", txtPassword.Text);
                cmd.ExecuteNonQuery();
                lblmsg.Text = "Student details updated successfully";
                con.Close();
            }
            Student_Bind();
            BindGridview();
            ClearAll();
        }

        protected void bntDelete_Click(object sender, EventArgs e)
        {
            //Delete student details
            con.Open();
            if (ddlStudent.SelectedIndex != 0)
            {
                cmd.CommandText = "student_delete";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("Student_Id", Convert.ToInt32(ddlStudent.SelectedItem.Value));
                cmd.ExecuteNonQuery();
                lblmsg.Text = "Student details deleted successfully";
                con.Close();
                Student_Bind();
                BindGridview();
                ClearAll();
            }
        }

        protected void btngridDelete_Click(object sender, EventArgs e)
        {
            try
            {
                //3,4,
                string Ids = getIds(gvDetails, "lblId");
                if(Ids!="")
                { 
                string[] splitedid = Ids.Split(',');
                foreach (string id in splitedid)
                {
                    con.Open();
                    cmd.CommandText = "student_delete";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("Student_Id", Convert.ToInt32(id));
                    cmd.ExecuteNonQuery();
                    lblmsg.Text = "Student details deleted successfully";
                    con.Close();
                    Student_Bind();
                    BindGridview();
                    ClearAll();
                }
                }
                else
                {
                    lblmsg.Text = "Please select student from list.";
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                //HandleExceptions.ExceptionLogging(ex, "", true);
            }
        }

        public string getIds(GridView gv1, string ID)
        {
            string s = "";
            foreach (GridViewRow x in gv1.Rows)
            {
                CheckBox c1 = (CheckBox)x.FindControl("cb_select");
                if (c1.Checked == true)
                {
                    Label l1 = (Label)x.FindControl(ID);
                    s += l1.Text + ", ";

                }

            }
            s = s.TrimEnd(',');
            return s;
        }

        protected void ddlStudent_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Load student details in input fields
            if (ddlStudent.SelectedIndex > 0)
            {
                con.Open();
                cmd.CommandText = "select_student_by_name";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("Student_Id", Convert.ToInt32(ddlStudent.SelectedItem.Value));
                da.Fill(dt);
                con.Close();
                foreach (DataRow row in dt.Rows)
                {
                    txtName.Text = row["Name"].ToString();
                    txtCourse.Text = row["Course"].ToString();
                    ddlSemester.SelectedValue = row["Semester"].ToString();
                    txtUniversity.Text = row["University"].ToString();
                    txtEmailAddress.Text = row["EmailAddress"].ToString();
                    txtPassword.Attributes.Add("value", row["Password"].ToString());
                }
                dt.Clear();
            }
            else
            {
                ClearAll();
            }
        }

        private void Student_Bind()
        {
            //Bind Student dropdownlist
            Connection_Data();
            con.Open();
            cmd.CommandText = "select_student";
            cmd.CommandType = CommandType.StoredProcedure;
            da.Fill(dt);
            con.Close();
            if (dt.Rows.Count > 0)
            {
                ddlStudent.DataValueField = "Student_Id";
                ddlStudent.DataTextField = "Name";
                ddlStudent.DataSource = dt;
                ddlStudent.DataBind();
            }
            ddlStudent.Items.Insert(0, "Select Student");
            dt.Clear();
        }

        private void ClearAll()
        {
            txtName.Text = "";
            txtCourse.Text = "";
            txtUniversity.Text = "";
            txtPassword.Text = "";
            txtEmailAddress.Text = "";
            ddlSemester.SelectedIndex = 0;
            txtPassword.Attributes.Add("value", "");
        }

        protected void BindGridview()
        {
            DataSet ds = new DataSet();
            con.Open();
            cmd.CommandText = "select_student";
            cmd.CommandType = CommandType.StoredProcedure;
            da.Fill(ds);
            con.Close();
            gvDetails.DataSource = ds;
            gvDetails.DataBind();
        }
        protected void gvDetails_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDetails.PageIndex = e.NewPageIndex;
            BindGridview();
        }



    }
}
