using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class User_Authority
{
    public int Id { get; set; }

    public int User_Id { get; set; }

    public int Authority_Id { get; set; }

    public string? Own_Authority { get; set; }
}
