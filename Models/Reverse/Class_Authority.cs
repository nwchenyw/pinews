using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Class_Authority
{
    public int Id { get; set; }

    public int? Auth_Class_Id { get; set; }

    public int? Auth_Id { get; set; }
}
