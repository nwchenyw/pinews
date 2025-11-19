using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Member
{
    public int Id { get; set; }

    public string? UserId { get; set; }

    public string? Password { get; set; }

    public string? Pinews_name { get; set; }

    public string? Pinews_class { get; set; }

    public string? Pinews_pfr { get; set; }

    public string? Name { get; set; }

    public string? Gender { get; set; }

    public string? Id_number { get; set; }

    public string? Id_card { get; set; }

    public DateTime? Birthday { get; set; }

    public string? Phone { get; set; }

    public string? Job { get; set; }

    public string? Bank_name { get; set; }

    public string? Bank_branch { get; set; }

    public string? Bank_username { get; set; }

    public string? Bank_usernum { get; set; }

    public string? Addr_county { get; set; }

    public string? Addr_district { get; set; }

    public string? AddressCode { get; set; }

    public string? Address { get; set; }

    public string? NationalID { get; set; }

    public bool? IsAdmin { get; set; }

    public bool? Certification { get; set; }

    public int? Member_Img_Id { get; set; }

    public int? Idcard_photo_fid { get; set; }

    public int? Idcard_photo_nid { get; set; }

    public DateTime? Register_Time { get; set; }

    public string? Intro { get; set; }

    public int subscription_count { get; set; }

    public DateTime? lsat_subscription_time { get; set; }
}
