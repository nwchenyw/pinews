using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// InsertReferralDto 的摘要描述
/// </summary>
public class InsertReferralDto
{
    //被推薦人網記名稱
    public string PinwesId { set; get; }
    //被推薦人網記類別
    public string PinwesUserClass { set; get; }
    //推薦人網記ID
    public string IntroducerId { set; get; }
    //推薦人網記類別
    public string IntroducerClass { set; get; }

}
