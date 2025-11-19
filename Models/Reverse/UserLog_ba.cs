using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class UserLog_ba
{
    public int Id { get; set; }

    public string? Modify_Table { get; set; }

    public int? Modify_Id { get; set; }

    public string? Modify_Action { get; set; }

    public string? Modify_Detail { get; set; }

    public string? Operate_User_Id { get; set; }

    public string? Operate_User_IP { get; set; }

    public DateTime? Operate_Time { get; set; }
}
