using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Referral_or
{
    public int Id { get; set; }

    public int? User_Id { get; set; }

    public int? User_Class { get; set; }

    public int? Introducer_Id { get; set; }

    public int? Introducer_Class { get; set; }

    public DateTime? Referral_Time { get; set; }
}
