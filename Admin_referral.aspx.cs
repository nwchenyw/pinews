using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_referral : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["Authority"] != null)
      {
      if (Request.QueryString["payment"] != null && Session["Pinews_class"].Equals("5"))
        this.Master.Page.Title = "會員付費總覽 | " + Application["Site_Name"];
      else if (Request.QueryString["referral"] != null)
      {
        if (Request.QueryString["referral"].Equals("all"))
          this.Master.Page.Title = "會員引薦總覽 | " + Application["Site_Name"];
        else if (Request.QueryString["referral"].Equals("peraonal"))
          this.Master.Page.Title = "個人引薦管理 | " + Application["Site_Name"];
      }
        if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "引薦獎金")) Response.Redirect("Default.aspx");
        if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "差%獎金"))
        {
          dividends.Visible = true;
          GridView3.Visible = true;
        }
        if (Session["pinews_class"] != null)
        {
          if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "引薦總覽"))
          {
            GridView5.Visible = true;
            GridView4.Visible = true;
            referral_all.Visible = true;
          }
        }
      }
      else Response.Redirect("Default.aspx");

      if (Request.QueryString["referral"] != null)
      {
        if (Request.QueryString["referral"].ToString() == "personal")
        {
          referral_all.Visible = false;
          GridView5.Visible = false;
        }
        else if (Request.QueryString["referral"].ToString() == "all")
        {
          referral.Visible = false;
          referee.Visible = false;
          dividends.Visible = false;
          GridView1.Visible = false;
          GridView2.Visible = false;
          GridView3.Visible = false;
        }
      }
      if (Request.QueryString["payment"] != null)
      {
        if (Session["Pinews_class"].Equals("5"))
        {
          all_payment.Visible = true;
          referral_all.Visible = false;
          referral.Visible = false;
          referee.Visible = false;
          dividends.Visible = false;
          GridView1.Visible = false;
          GridView2.Visible = false;
          GridView3.Visible = false;
          GridView5.Visible = false;
          GridView6.Visible = true;
          GridView7.Visible = true;
        }
      }
      if (!IsPostBack)
        rd_HF.Value = DateTime.Now.ToString("yyy/MM/dd");

      string sql = @"select Format(Min(Referral_Time), 'yyyy/MM/01') as d from Referral where Format(Referral_Time, 'yyyy/MM/01') is not null
union all select Format(Max(Referral_Time), 'yyyy/MM/01') as d from Referral where Format(Referral_Time, 'yyyy/MM/01') is not null";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(sql, con))
        {
          con.Open();
          cmd.Parameters.AddWithValue("@uid", Session["User_Id"].ToString());
          using (SqlDataReader reader = cmd.ExecuteReader())
          {
            if (reader.HasRows)
            {
              var i = 0;
              string min = "", max = "";
              while (reader.Read())
              {
                if (i == 0)
                  min = reader["d"].ToString();
                if (i == 1)
                  max = reader["d"].ToString();
                i++;
              };

              uc.FrontEndDebug(this, "referral-date-minmax", string.Format(@"console.log('{0}', '{1}'); $('#date_calendar').calendar({{ type: 'month', minDate: new Date('{0}'), maxDate: new Date('{1}'),text: {{
        days: ['日', '一', '二', '三', '四', '五', '六'],
        months: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
        monthsShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
        today: '今天', now: '現在', am: 'AM', pm: 'PM' }}, onSelect: function (date, mode) {{
  var d = date.toLocaleDateString();
  console.log(d);
  $('#{2}').val(d);
}}, onChange: function () {{
  $('#{2}').val($('#date_calendar').calendar('get date').toLocaleDateString());
}} 
}});", min, max, rd_HF.ClientID));
              if (IsPostBack)
                uc.FrontEndDebug(this, "change currect", string.Format("$('#date_calendar').calendar('set date', '{0}');", rd_HF.Value));
            }
          }
          con.Close();
        }
      }

      uc.FrontEndDebug(this, "auth", string.Format("console.log('{0}');", !Array.Exists(Session["Authority"].ToString().Split(','), m => m == "引薦獎金")));
    }

    protected void GridView1_PreRender(object sender, EventArgs e)
    {
      if (GridView1.Rows.Count > 0)
      {
        //GridView1.HeaderRow.CssClass = "full-width";
        GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
        if (GridView1.ShowFooter)
          GridView1.FooterRow.TableSection = TableRowSection.TableFooter;
      }
    }

    protected void GridView2_PreRender(object sender, EventArgs e)
    {
      if (GridView2.Rows.Count > 0)
      {
        GridView2.HeaderRow.TableSection = TableRowSection.TableHeader;
        if (GridView2.ShowFooter)
          GridView2.FooterRow.TableSection = TableRowSection.TableFooter;
      }
    }

    protected void GridView3_PreRender(object sender, EventArgs e)
    {
      if (GridView3.Rows.Count > 0)
      {
        GridView3.HeaderRow.TableSection = TableRowSection.TableHeader;
        if (GridView3.ShowFooter)
          GridView3.FooterRow.TableSection = TableRowSection.TableFooter;
      }
    }

    protected void GridView1_DataBound(object sender, EventArgs e)
    {
      if (GridView1.Rows.Count > 0)
      {
        double bonus = 0;
        for (var i = 0; i < GridView1.Rows.Count; i++)
        {
          bonus += int.Parse(GridView1.DataKeys[i].Value.ToString());
        }
        GridView1.FooterRow.Cells[4].Text = bonus.ToString();
        if (bonus > 20000)
        {
          double t = Math.Round(bonus * 0.1, 2);
          GridView1.FooterRow.Cells[5].Text = t.ToString();
          bonus -= t;
        }
        else GridView1.FooterRow.Cells[5].Text = "0";

        GridView1.FooterRow.Cells[6].Text = bonus.ToString();
      }
    }

    protected void GridView2_DataBound(object sender, EventArgs e)
    {
      if (GridView1.Rows.Count > 0)
      {
        GridView2.FooterRow.Cells[3].Text = GridView2.Rows.Count.ToString();
      }
    }

    protected void GridView3_DataBound(object sender, EventArgs e)
    {
      if (GridView3.Rows.Count > 0)
      {
        int b = 0;
        int b1 = 0;
        for (var i = 0; i < GridView3.Rows.Count; i++)
        {
          b += int.Parse(GridView3.DataKeys[i].Values["m"].ToString()) * int.Parse(GridView3.DataKeys[i].Values["b"].ToString()) / 100;
          b1 += int.Parse(GridView3.DataKeys[i].Values["m1"].ToString()) * int.Parse(GridView3.DataKeys[i].Values["b1"].ToString()) / 100;
        }
        GridView3.FooterRow.Cells[4].Text = b.ToString();
        GridView3.FooterRow.Cells[6].Text = b1.ToString();
        GridView3.FooterRow.Cells[7].Text = (b + b1).ToString();
      }
    }

    protected void GridView4_PreRender(object sender, EventArgs e)
    {
      if (GridView4.Rows.Count > 0)
        GridView4.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void GridView4_DataBound(object sender, EventArgs e)
    {

    }

    protected void GridView5_PreRender(object sender, EventArgs e)
    {
      if (GridView5.Rows.Count > 0)
      {
        GridView5.HeaderRow.TableSection = TableRowSection.TableHeader;
        if (GridView5.ShowFooter)
          GridView5.FooterRow.TableSection = TableRowSection.TableFooter;
      }
    }

    protected void GridView5_DataBound(object sender, EventArgs e)
    {
      if (GridView5.Rows.Count > 0)
      {
        double mp = 0;
        double ap = 0;
        for (var i = 0; i < GridView5.Rows.Count; i++)
        {
          mp += double.Parse(GridView5.DataKeys[i].Values["mon_bonus"].ToString());
          ap += double.Parse(GridView5.DataKeys[i].Values["all_bonus"].ToString());
        }
        if (GridView5.SelectedIndex != -1)
          GridView5.Rows[GridView5.SelectedIndex].CssClass = "active";
        GridView5.FooterRow.Cells[5].Text = mp.ToString();
        GridView5.FooterRow.Cells[8].Text = ap.ToString();
      }
    }

    protected void referral_date_TB_TextChanged(object sender, EventArgs e)
    {
    }

    protected void referral_date_LB_Click(object sender, EventArgs e)
    {
      DateTime dt;
      if (DateTime.TryParse(rd_HF.Value, out dt))
      {
        uc.FrontEndDebug(this, "val", string.Format("console.log('{0}');", rd_HF.Value));
        SqlDataSource1.DataBind();
        GridView6.DataSourceID = SqlDataSource8.ID;
      }


    }

    protected override void Render(HtmlTextWriter writer)
    {
      foreach (GridViewRow row in this.GridView5.Rows)
      {
        if (row.RowType == DataControlRowType.DataRow)
        {
          if ((row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
          {
            GridView5.CssClass = GridView5.CssClass.Replace("selectable", "");
          }
          else
          {
            for (var i = 0; i < this.GridView5.Columns.Count - 1; i++)
            {
              row.Cells[i].Attributes.Add("onclick", Page.ClientScript.GetPostBackEventReference(this.GridView5, "Select$" + row.RowIndex));
              Page.ClientScript.RegisterForEventValidation(this.GridView5.UniqueID, "Select$" + row.RowIndex);
            }
            row.Cells[this.GridView5.Columns.Count - 1].Attributes.Add("style", "cursor: initial;");
          }
        }
      }

      foreach (GridViewRow row in this.GridView6.Rows)
      {
        if (row.RowType == DataControlRowType.DataRow)
        {
          if ((row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
          {
            GridView6.CssClass = GridView6.CssClass.Replace("selectable", "");
          }
          else
          {
            for (var i = 0; i < this.GridView6.Columns.Count - 1; i++)
            {
              row.Cells[i].Attributes.Add("onclick", Page.ClientScript.GetPostBackEventReference(this.GridView6, "Select$" + row.RowIndex));
              Page.ClientScript.RegisterForEventValidation(this.GridView6.UniqueID, "Select$" + row.RowIndex);
            }
            row.Cells[this.GridView6.Columns.Count - 1].Attributes.Add("style", "cursor: initial;");
          }
        }
      }
      AsyncPostBackTrigger Trigger2 = new AsyncPostBackTrigger();
      Trigger2.ControlID = LinkButton1.UniqueID;
      ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
      ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterAsyncPostBackControl(LinkButton1);

      base.Render(writer);
    }

    protected void GridView5_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.DataRow)
      {

      }
    }

    protected void GridView5_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
      SqlDataSource4.SelectParameters["id"].DefaultValue = GridView5.DataKeys[e.NewSelectedIndex].Values["Introducer_Id"].ToString();

      GridView4.DataBind();
      uc.FrontEndDebug(this, "show modal", "$('#referral_all_detail').modal({inverted: true,allowMultiple: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true}).modal('show');");
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
      GridView5.SelectedIndex = -1;
    }

    protected void GridView6_PreRender(object sender, EventArgs e)
    {
      if (GridView6.Rows.Count > 0)
      {
        GridView6.HeaderRow.TableSection = TableRowSection.TableHeader;
        if (GridView6.ShowFooter)
          GridView6.FooterRow.TableSection = TableRowSection.TableFooter;
      }
    }

    protected void GridView6_DataBound(object sender, EventArgs e)
    {
      if (GridView6.Rows.Count > 0)
      {
        int tmc = 0;
        int tzc = 0;
        int tgc = 0;
        int tjc = 0;
        int tc = 0;
        double tb = 0;
        double tr = 0;
        double dr = 0;
        double tf = 0;
        for (var i = 0; i < GridView6.Rows.Count; i++)
        {
          int mc;
          int zc;
          int gc;
          int jc;
          int c;
          double b;
          double r;
          double d;
          double f;
          if (int.TryParse(GridView6.DataKeys[i].Values["mc"].ToString(), out mc))
            tmc += mc;
          if (int.TryParse(GridView6.DataKeys[i].Values["zc"].ToString(), out zc))
            tzc += zc;
          if (int.TryParse(GridView6.DataKeys[i].Values["gc"].ToString(), out gc))
            tgc += gc;
          if (int.TryParse(GridView6.DataKeys[i].Values["jc"].ToString(), out jc))
            tjc += jc;
          if (int.TryParse(GridView6.DataKeys[i].Values["c"].ToString(), out c))
            tc += c;
          if (double.TryParse(GridView6.DataKeys[i].Values["b"].ToString(), out b))
            tb += b;
          if (double.TryParse(GridView6.DataKeys[i].Values["tr"].ToString(), out r))
            tr += r;
          if (double.TryParse(GridView6.DataKeys[i].Values["dr"].ToString(), out d))
            dr += d;
          if (double.TryParse(GridView6.DataKeys[i].Values["final"].ToString(), out f))
            tf += f;
          //ap += double.Parse(GridView6.DataKeys[i].Values["all_bonus"].ToString());
        }
        if (GridView6.SelectedIndex != -1)
          GridView6.Rows[GridView6.SelectedIndex].CssClass = "active";
        GridView6.FooterRow.Cells[1].Text = tmc.ToString();
        GridView6.FooterRow.Cells[2].Text = tzc.ToString();
        GridView6.FooterRow.Cells[3].Text = tgc.ToString();
        GridView6.FooterRow.Cells[4].Text = tjc.ToString();
        GridView6.FooterRow.Cells[5].Text = tc.ToString();
        GridView6.FooterRow.Cells[6].Text = tb.ToString();
        GridView6.FooterRow.Cells[7].Text = tr.ToString();
        GridView6.FooterRow.Cells[8].Text = dr.ToString();
        GridView6.FooterRow.Cells[9].Text = tf.ToString();
      }
    }

    protected void LinkButton2_Click(object sender, EventArgs e)
    {
      GridView6.SelectedIndex = -1;
    }

    protected void GridView6_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
      uc.FrontEndDebug(this, "show modal", "$('#all_payment_detail').modal({inverted: true,allowMultiple: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true}).modal('show');");
    }

    protected void GridView7_PreRender(object sender, EventArgs e)
    {
      if (GridView7.Rows.Count > 0)
      {
        GridView7.HeaderRow.TableSection = TableRowSection.TableHeader;
        if (GridView7.ShowFooter)
          GridView7.FooterRow.TableSection = TableRowSection.TableFooter;
      }
    }
  }
}