using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;

namespace Demo
{
    public partial class studentAjax : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindColumnToGridview();
            }
        }
        private void BindColumnToGridview()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ProductId");
            dt.Columns.Add("ProductName");
            dt.Columns.Add("Price");
            dt.Columns.Add("Edit");
            dt.Rows.Add();
            gvDetails.DataSource = dt;
            gvDetails.DataBind();
            gvDetails.Rows[0].Visible = false;
        }
        [WebMethod]
        public static ProductDetails[] BindGridview()
        {
            DataTable dt = new DataTable();
            List<ProductDetails> details = new List<ProductDetails>();
            using (SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS;Initial Catalog=Student; Integrated Security=True"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("crudoperations", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@status", "SELECT");
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                con.Close();
                foreach (DataRow dtrow in dt.Rows)
                {
                    ProductDetails product = new ProductDetails();
                    product.productid = dtrow["productid"].ToString();
                    product.productname = dtrow["productname"].ToString();
                    product.price = dtrow["price"].ToString();
                    details.Add(product);
                }
            }
            return details.ToArray();
        }
        public class ProductDetails
        {
            public string productid { get; set; }
            public string productname { get; set; }
            public string price { get; set; }
        }
        [WebMethod]
        public static string crudoperations(string status, string productname, string price, int productid)
        {
            string msg = "false";
            using (SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS;Initial Catalog=Student; Integrated Security=True"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("crudoperations", con);
                cmd.CommandType = CommandType.StoredProcedure;
                if (status == "INSERT")
                {
                    cmd.Parameters.AddWithValue("@status", status);
                    cmd.Parameters.AddWithValue("@productname", productname);
                    cmd.Parameters.AddWithValue("@price", price);
                }
                else if (status == "UPDATE")
                {

                    cmd.Parameters.AddWithValue("@status", status);
                    cmd.Parameters.AddWithValue("@productname", productname);
                    cmd.Parameters.AddWithValue("@price", price);
                    cmd.Parameters.AddWithValue("@productid", productid);
                }
                else if (status == "DELETE")
                {
                    cmd.Parameters.AddWithValue("@status", status);
                    cmd.Parameters.AddWithValue("@productid", productid);
                }
                cmd.ExecuteNonQuery();
                msg = "true";
            }
            return msg;
        }

    }
}
