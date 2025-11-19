using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class User_Url
{
    public int Id { get; set; }

    public int? User_Id { get; set; }

    public string? Url { get; set; }
}
