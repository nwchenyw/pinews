using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Web;

/// <summary>
/// RegisterInsertMemberDto 的摘要描述
/// </summary>
public class RegisterInsertMemberDto
{
    //Email
    public string Acc { set; get; }
    //網際名稱
    public string PinwesName { set; get; }
    //密碼
    public string Pass { set; get; }
    //介紹人
    public string PlatformReferrer { set; get; }
    //手機
    public string Tel { set; get; }
    //縣市
    public string County { set; get; }
    //網際類別
    public string PinewClass { set; get; }
    //網際類別
    public string UserName { set; get; }
    
}
