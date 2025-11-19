using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace PiNewsCore.Models.Reverse;

public partial class RemoteDbContext : DbContext
{
    public RemoteDbContext()
    {
    }

    public RemoteDbContext(DbContextOptions<RemoteDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Advertisement> Advertisements { get; set; }

    public virtual DbSet<Article> Articles { get; set; }

    public virtual DbSet<ArticleDailyStat> ArticleDailyStats { get; set; }

    public virtual DbSet<ArticleStatsView> ArticleStatsViews { get; set; }

    public virtual DbSet<ArticleTotalStat> ArticleTotalStats { get; set; }

    public virtual DbSet<Article_Image> Article_Images { get; set; }

    public virtual DbSet<Article_Rec_Cat> Article_Rec_Cats { get; set; }

    public virtual DbSet<Article_View> Article_Views { get; set; }

    public virtual DbSet<Authority> Authorities { get; set; }

    public virtual DbSet<Authority_Class> Authority_Classes { get; set; }

    public virtual DbSet<Banner> Banners { get; set; }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Class_Authority> Class_Authorities { get; set; }

    public virtual DbSet<Class_Bonu> Class_Bonus { get; set; }

    public virtual DbSet<Class_annual_fee> Class_annual_fees { get; set; }

    public virtual DbSet<Donate_Payment> Donate_Payments { get; set; }

    public virtual DbSet<FB_User_Id> FB_User_Ids { get; set; }

    public virtual DbSet<Image> Images { get; set; }

    public virtual DbSet<Marquee> Marquees { get; set; }

    public virtual DbSet<Member> Members { get; set; }

    public virtual DbSet<Member_Convenience_store_code_payment> Member_Convenience_store_code_payments { get; set; }

    public virtual DbSet<Member_Payment> Member_Payments { get; set; }

    public virtual DbSet<Member_Virtual_account_payment> Member_Virtual_account_payments { get; set; }

    public virtual DbSet<Menu> Menus { get; set; }

    public virtual DbSet<Recommendation> Recommendations { get; set; }

    public virtual DbSet<RecommendationCache> RecommendationCaches { get; set; }

    public virtual DbSet<Referral> Referrals { get; set; }

    public virtual DbSet<Referral_or> Referral_ors { get; set; }

    public virtual DbSet<Staff_Id> Staff_Ids { get; set; }

    public virtual DbSet<UserLog> UserLogs { get; set; }

    public virtual DbSet<UserLogN> UserLogNs { get; set; }

    public virtual DbSet<UserLog_Backup> UserLog_Backups { get; set; }

    public virtual DbSet<UserLog_ba> UserLog_bas { get; set; }

    public virtual DbSet<UserLogbuck2025> UserLogbuck2025s { get; set; }

    public virtual DbSet<User_Authority> User_Authorities { get; set; }

    public virtual DbSet<User_Url> User_Urls { get; set; }

    public virtual DbSet<WebSite_Datum> WebSite_Data { get; set; }

    public virtual DbSet<subscribe_payment> subscribe_payments { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=118.232.49.109;Initial Catalog=Pi news;User ID=sa;Password=!QAZxsw2;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.UseCollation("Chinese_Taiwan_Stroke_CI_AS");

        modelBuilder.Entity<Advertisement>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC07D17F4FC9");

            entity.ToTable("Advertisement");

            entity.Property(e => e.Link).HasMaxLength(500);
            entity.Property(e => e.Remark).HasMaxLength(100);
            entity.Property(e => e.Title).HasMaxLength(100);
            entity.Property(e => e.Type).HasMaxLength(30);
            entity.Property(e => e.Upd_Time).HasColumnType("datetime");
            entity.Property(e => e.video_type).HasMaxLength(10);
            entity.Property(e => e.video_url).HasMaxLength(500);
        });

        modelBuilder.Entity<Article>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC078F7D86F3");

            entity.ToTable("Article");

            entity.HasIndex(e => e.Status, "<Name of Missing Index, sysname,>");

            entity.HasIndex(e => e.DateTime, "IX_Article_DateTime");

            entity.HasIndex(e => e.Status, "IX_Article_Status");

            entity.HasIndex(e => new { e.Status, e.DateTime }, "IX_Article_Status_DateTime").IsDescending(false, true);

            entity.HasIndex(e => new { e.Status, e.DateTime }, "IX_Article_Status_DateTime_Optimized")
                .IsDescending(false, true)
                .HasFilter("([Status]=(1))");

            entity.HasIndex(e => e.User_Id, "IX_Article_User_Id");

            entity.HasIndex(e => e.Author_Email, "IX_Author_Email");

            entity.HasIndex(e => e.User_Id, "IX_User_Id");

            entity.Property(e => e.Active_Time).HasColumnType("datetime");
            entity.Property(e => e.Author).HasMaxLength(100);
            entity.Property(e => e.Author_Email).HasMaxLength(100);
            entity.Property(e => e.Category).HasMaxLength(50);
            entity.Property(e => e.DateTime).HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(400);
            entity.Property(e => e.Keyword).HasMaxLength(450);
            entity.Property(e => e.Recommand_Category).HasMaxLength(50);
            entity.Property(e => e.Title).HasMaxLength(500);
            entity.Property(e => e.inActive_Time).HasColumnType("datetime");
        });

        modelBuilder.Entity<ArticleDailyStat>(entity =>
        {
            entity.HasKey(e => new { e.ArticleId, e.StatsDate });

            entity.HasIndex(e => e.StatsDate, "IX_ArticleDailyStats_StatsDate").IsDescending();

            entity.Property(e => e.LastUpdated).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.LikeCount).HasDefaultValue(0);
            entity.Property(e => e.UniqueLikers).HasDefaultValue(0);
            entity.Property(e => e.UniqueViewers).HasDefaultValue(0);
            entity.Property(e => e.ViewCount).HasDefaultValue(0);

            entity.HasOne(d => d.Article).WithMany(p => p.ArticleDailyStats)
                .HasForeignKey(d => d.ArticleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticleDailyStats_Article");
        });

        modelBuilder.Entity<ArticleStatsView>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("ArticleStatsView");

            entity.Property(e => e.Author).HasMaxLength(100);
            entity.Property(e => e.Title).HasMaxLength(500);
            entity.Property(e => e.t).HasMaxLength(4000);
        });

        modelBuilder.Entity<ArticleTotalStat>(entity =>
        {
            entity.HasKey(e => e.ArticleId).HasName("PK__ArticleT__9C6270E8F7DC9137");

            entity.Property(e => e.ArticleId).ValueGeneratedNever();
            entity.Property(e => e.LastMonthLikes).HasDefaultValue(0);
            entity.Property(e => e.LastMonthViews).HasDefaultValue(0);
            entity.Property(e => e.LastUpdated).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.LastWeekLikes).HasDefaultValue(0);
            entity.Property(e => e.LastWeekViews).HasDefaultValue(0);
            entity.Property(e => e.LastYearLikes).HasDefaultValue(0);
            entity.Property(e => e.LastYearViews).HasDefaultValue(0);
            entity.Property(e => e.TotalLikes).HasDefaultValue(0);
            entity.Property(e => e.TotalUniqueLikers).HasDefaultValue(0);
            entity.Property(e => e.TotalUniqueViewers).HasDefaultValue(0);
            entity.Property(e => e.TotalViews).HasDefaultValue(0);

            entity.HasOne(d => d.Article).WithOne(p => p.ArticleTotalStat)
                .HasForeignKey<ArticleTotalStat>(d => d.ArticleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ArticleTotalStats_Article");
        });

        modelBuilder.Entity<Article_Image>(entity =>
        {
            entity.ToTable("Article_Image");
        });

        modelBuilder.Entity<Article_Rec_Cat>(entity =>
        {
            entity.ToTable("Article_Rec_Cat");

            entity.HasIndex(e => new { e.Article_id, e.Rec_cat_id }, "IX_Article_Rec_Cat_ArticleId_RecCatId");

            entity.HasIndex(e => e.Article_id, "IX_Article_Rec_Cat_Article_id");

            entity.HasIndex(e => new { e.Rec_cat_id, e.Article_id }, "IX_Article_Rec_Cat_Optimized");

            entity.HasIndex(e => new { e.Rec_cat_id, e.Article_id }, "IX_Article_Rec_Cat_RecCatId_ArticleId");

            entity.HasIndex(e => e.Rec_cat_id, "IX_Article_Rec_Cat_Rec_cat_id");
        });

        modelBuilder.Entity<Article_View>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Article_View");

            entity.HasIndex(e => e.date, "IX_date");

            entity.Property(e => e.date).HasColumnType("datetime");
            entity.Property(e => e.user).HasDefaultValue(0);
            entity.Property(e => e.visitor).HasDefaultValue(0);
        });

        modelBuilder.Entity<Authority>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Authorit__3214EC07B9BD1051");

            entity.ToTable("Authority");

            entity.Property(e => e.Name).HasMaxLength(20);
        });

        modelBuilder.Entity<Authority_Class>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Authorit__3214EC07E4B1C142");

            entity.ToTable("Authority_Class");

            entity.Property(e => e.Class_Name).HasMaxLength(16);
        });

        modelBuilder.Entity<Banner>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC078E259001");

            entity.ToTable("Banner");

            entity.Property(e => e.Link).HasMaxLength(500);
            entity.Property(e => e.Title).HasMaxLength(1000);
            entity.Property(e => e.Video_type).HasMaxLength(10);
            entity.Property(e => e.Video_url).HasMaxLength(500);
            entity.Property(e => e.active).HasDefaultValue(true);
            entity.Property(e => e.color).HasMaxLength(50);
            entity.Property(e => e.font_name).HasMaxLength(50);
            entity.Property(e => e.font_size).HasMaxLength(5);
            entity.Property(e => e.odr).HasDefaultValue(0);
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC0739996A6D");

            entity.ToTable("City");

            entity.Property(e => e.Id).HasMaxLength(1);
            entity.Property(e => e.Name).HasMaxLength(6);
        });

        modelBuilder.Entity<Class_Authority>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC078C117D0D");

            entity.ToTable("Class_Authority");
        });

        modelBuilder.Entity<Class_Bonu>(entity =>
        {
            entity.HasKey(e => e.Class_Id).HasName("PK__Class_Bo__B09705375A5ACD83");

            entity.Property(e => e.Class_Id).ValueGeneratedNever();
        });

        modelBuilder.Entity<Class_annual_fee>(entity =>
        {
            entity.HasKey(e => e.Class_Id).HasName("PK__Class_an__B09705372F0E5EB4");

            entity.ToTable("Class_annual_fee");

            entity.Property(e => e.Class_Id).ValueGeneratedNever();
        });

        modelBuilder.Entity<Donate_Payment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Donate_P__3214EC070ED92E2B");

            entity.ToTable("Donate_Payment");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.Order_Id).HasMaxLength(20);
            entity.Property(e => e.Pay_Time).HasColumnType("datetime");
            entity.Property(e => e.Sponsor_Name).HasMaxLength(100);
        });

        modelBuilder.Entity<FB_User_Id>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__FB_User___3214EC07A2C748D4");

            entity.ToTable("FB_User_Id");
        });

        modelBuilder.Entity<Image>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC07C4CD72DE");

            entity.ToTable("Image");

            entity.Property(e => e.Content_Type).HasMaxLength(100);
            entity.Property(e => e.File_Name).HasMaxLength(200);
            entity.Property(e => e.Size).HasColumnType("numeric(13, 2)");
            entity.Property(e => e.Upload_Time).HasColumnType("datetime");
        });

        modelBuilder.Entity<Marquee>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Marquee__3214EC0741E14593");

            entity.ToTable("Marquee");

            entity.Property(e => e.Add_Time).HasColumnType("datetime");
            entity.Property(e => e.Link).HasMaxLength(500);
            entity.Property(e => e.Text).HasMaxLength(200);
            entity.Property(e => e.active).HasDefaultValue(true);
            entity.Property(e => e.color).HasMaxLength(50);
            entity.Property(e => e.font_name).HasMaxLength(50);
            entity.Property(e => e.font_size).HasMaxLength(5);
            entity.Property(e => e.font_weight).HasMaxLength(10);
            entity.Property(e => e.odr).HasDefaultValue(0);
        });

        modelBuilder.Entity<Member>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC074F95B56E");

            entity.ToTable("Member");

            entity.HasIndex(e => e.Id, "IX_Member_Id");

            entity.HasIndex(e => e.Id, "IX_Member_Id_UserId");

            entity.HasIndex(e => e.Id, "IX_Member_Optimized");

            entity.HasIndex(e => e.UserId, "IX_Member_UserId");

            entity.HasIndex(e => new { e.Id, e.IsAdmin }, "IX_Member_UserId_IsAdmin");

            entity.Property(e => e.Addr_county).HasMaxLength(8);
            entity.Property(e => e.Addr_district).HasMaxLength(20);
            entity.Property(e => e.Address).HasMaxLength(200);
            entity.Property(e => e.AddressCode).HasMaxLength(3);
            entity.Property(e => e.Bank_branch).HasMaxLength(30);
            entity.Property(e => e.Bank_name).HasMaxLength(30);
            entity.Property(e => e.Bank_username).HasMaxLength(30);
            entity.Property(e => e.Bank_usernum).HasMaxLength(30);
            entity.Property(e => e.Birthday).HasColumnType("datetime");
            entity.Property(e => e.Gender).HasMaxLength(3);
            entity.Property(e => e.Id_card).HasMaxLength(3);
            entity.Property(e => e.Id_number).HasMaxLength(20);
            entity.Property(e => e.Intro).HasMaxLength(200);
            entity.Property(e => e.Job).HasMaxLength(30);
            entity.Property(e => e.Name).HasMaxLength(100);
            entity.Property(e => e.NationalID).HasMaxLength(11);
            entity.Property(e => e.Password).HasMaxLength(100);
            entity.Property(e => e.Phone).HasMaxLength(10);
            entity.Property(e => e.Pinews_class).HasMaxLength(3);
            entity.Property(e => e.Pinews_name).HasMaxLength(20);
            entity.Property(e => e.Pinews_pfr).HasMaxLength(20);
            entity.Property(e => e.Register_Time).HasColumnType("datetime");
            entity.Property(e => e.UserId).HasMaxLength(100);
            entity.Property(e => e.lsat_subscription_time).HasColumnType("datetime");
        });

        modelBuilder.Entity<Member_Convenience_store_code_payment>(entity =>
        {
            entity.HasKey(e => e.id).HasName("PK_Table_1");

            entity.ToTable("Member_Convenience_store_code_payment");

            entity.Property(e => e.Barcode2).HasMaxLength(30);
            entity.Property(e => e.CarrierId1).HasMaxLength(30);
            entity.Property(e => e.CarrierId2).HasMaxLength(30);
            entity.Property(e => e.CarrierType).HasMaxLength(20);
            entity.Property(e => e.Market_ID).HasMaxLength(5);
            entity.Property(e => e.NPOBAN).HasMaxLength(30);
            entity.Property(e => e.OrderID).HasMaxLength(50);
            entity.Property(e => e.PayAmount).HasMaxLength(10);
            entity.Property(e => e.PinCode).HasMaxLength(30);
            entity.Property(e => e.Remark).HasMaxLength(100);
            entity.Property(e => e.Shop_Store_Name).HasMaxLength(100);
            entity.Property(e => e.Uni_num).HasMaxLength(10);
            entity.Property(e => e.e_date).HasMaxLength(10);
            entity.Property(e => e.e_money).HasMaxLength(10);
            entity.Property(e => e.e_orderno).HasMaxLength(50);
            entity.Property(e => e.e_time).HasMaxLength(10);
            entity.Property(e => e.first_strcheck).HasMaxLength(50);
        });

        modelBuilder.Entity<Member_Payment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Member_P__3214EC073458FF60");

            entity.ToTable("Member_Payment");

            entity.Property(e => e.BuyerIdentifier).HasMaxLength(30);
            entity.Property(e => e.Buyer_Mail).HasMaxLength(50);
            entity.Property(e => e.Buyer_Name).HasMaxLength(50);
            entity.Property(e => e.Buyer_Telm).HasMaxLength(50);
            entity.Property(e => e.CarrierId1).HasMaxLength(30);
            entity.Property(e => e.CarrierId2).HasMaxLength(30);
            entity.Property(e => e.CarrierType).HasMaxLength(20);
            entity.Property(e => e.Due_Time).HasColumnType("datetime");
            entity.Property(e => e.NPOBAN).HasMaxLength(30);
            entity.Property(e => e.Order_Id).HasMaxLength(50);
            entity.Property(e => e.Pay_Time).HasColumnType("datetime");
            entity.Property(e => e.Remark).HasMaxLength(100);
        });

        modelBuilder.Entity<Member_Virtual_account_payment>(entity =>
        {
            entity.ToTable("Member_Virtual_account_payment");

            entity.Property(e => e.CarrierId1).HasMaxLength(30);
            entity.Property(e => e.CarrierId2).HasMaxLength(30);
            entity.Property(e => e.CarrierType).HasMaxLength(20);
            entity.Property(e => e.LimitDate).HasMaxLength(20);
            entity.Property(e => e.NPOBAN).HasMaxLength(30);
            entity.Property(e => e.Order_ID).HasMaxLength(50);
            entity.Property(e => e.PayAmount).HasMaxLength(10);
            entity.Property(e => e.Remark).HasMaxLength(400);
            entity.Property(e => e.Uni_num).HasMaxLength(10);
            entity.Property(e => e.e_PayInfo).HasMaxLength(10);
            entity.Property(e => e.e_date).HasMaxLength(10);
            entity.Property(e => e.e_money).HasMaxLength(10);
            entity.Property(e => e.e_orderno).HasMaxLength(50);
            entity.Property(e => e.e_payaccount).HasMaxLength(50);
            entity.Property(e => e.e_time).HasMaxLength(10);
            entity.Property(e => e.first_strcheck).HasMaxLength(50);
        });

        modelBuilder.Entity<Menu>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Menu__3214EC07BE58CB34");

            entity.ToTable("Menu");

            entity.HasIndex(e => e.odr, "IX_Menu_Order");

            entity.Property(e => e.Link).HasMaxLength(100);
            entity.Property(e => e.Name).HasMaxLength(50);
        });

        modelBuilder.Entity<Recommendation>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Recommen__3214EC076B3E1AE0");

            entity.ToTable("Recommendation");

            entity.Property(e => e.Art_Grouping).HasMaxLength(50);
            entity.Property(e => e.Art_Odr_Duration).HasMaxLength(50);
            entity.Property(e => e.Art_Odr_Type).HasMaxLength(50);
            entity.Property(e => e.Category_Name).HasMaxLength(20);
            entity.Property(e => e.font_color).HasMaxLength(50);
            entity.Property(e => e.font_name).HasMaxLength(50);
        });

        modelBuilder.Entity<RecommendationCache>(entity =>
        {
            entity.HasKey(e => new { e.RecCatId, e.OrderType, e.Duration });

            entity.ToTable("RecommendationCache");

            entity.Property(e => e.OrderType).HasMaxLength(20);
            entity.Property(e => e.Duration).HasMaxLength(10);
            entity.Property(e => e.LastUpdated).HasDefaultValueSql("(getdate())");
        });

        modelBuilder.Entity<Referral>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Referral__3214EC0772AED71F");

            entity.ToTable("Referral");

            entity.Property(e => e.Referral_Time).HasColumnType("datetime");
        });

        modelBuilder.Entity<Referral_or>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC0722DDF54F");

            entity.ToTable("Referral_or");

            entity.Property(e => e.Referral_Time).HasColumnType("datetime");
        });

        modelBuilder.Entity<Staff_Id>(entity =>
        {
            entity.HasKey(e => e.User_Id).HasName("PK__Staff_Id__206D917023127897");

            entity.ToTable("Staff_Id");

            entity.Property(e => e.User_Id).ValueGeneratedNever();
            entity.Property(e => e.Staff_Id1)
                .HasMaxLength(10)
                .IsFixedLength()
                .HasColumnName("Staff_Id");
        });

        modelBuilder.Entity<UserLog>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserLog___3214EC070409AD74");

            entity.ToTable("UserLog");

            entity.Property(e => e.Modify_Action).HasMaxLength(20);
            entity.Property(e => e.Modify_Detail).HasMaxLength(1000);
            entity.Property(e => e.Modify_Table).HasMaxLength(50);
            entity.Property(e => e.Operate_Time).HasColumnType("datetime");
            entity.Property(e => e.Operate_User_IP).HasMaxLength(100);
            entity.Property(e => e.Operate_User_Id).HasMaxLength(50);
        });

        modelBuilder.Entity<UserLogN>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserLog__3214EC07D21CE9D2");

            entity.ToTable("UserLogN");

            entity.Property(e => e.Modify_Action).HasMaxLength(20);
            entity.Property(e => e.Modify_Detail).HasMaxLength(1000);
            entity.Property(e => e.Modify_Table).HasMaxLength(50);
            entity.Property(e => e.Operate_Time).HasColumnType("datetime");
            entity.Property(e => e.Operate_User_IP).HasMaxLength(16);
            entity.Property(e => e.Operate_User_Id).HasMaxLength(50);
        });

        modelBuilder.Entity<UserLog_Backup>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserLogb__3214EC0703FF20A6");

            entity.ToTable("UserLog_Backup");

            entity.HasIndex(e => new { e.Modify_Action, e.Modify_Id, e.Operate_Time }, "IX_UserLogBack2025_ModifyAction_ModifyId_OperateTime");

            entity.HasIndex(e => new { e.Modify_Id, e.Modify_Action, e.Operate_Time }, "IX_UserLog_ModifyId_Action_OperateTime").IsDescending(false, false, true);

            entity.HasIndex(e => new { e.Operate_Time, e.Modify_Action }, "IX_UserLog_OperateTime_Action");

            entity.HasIndex(e => new { e.Modify_Action, e.Operate_Time, e.Modify_Id }, "IX_UserLog_Optimized_View_Stats")
                .IsDescending(false, true, false)
                .HasFilter("([Modify_Action] IN ('View', 'like'))");

            entity.Property(e => e.Modify_Action).HasMaxLength(20);
            entity.Property(e => e.Modify_Detail).HasMaxLength(1000);
            entity.Property(e => e.Modify_Table).HasMaxLength(50);
            entity.Property(e => e.Operate_Time).HasColumnType("datetime");
            entity.Property(e => e.Operate_User_IP).HasMaxLength(100);
            entity.Property(e => e.Operate_User_Id).HasMaxLength(50);
        });

        modelBuilder.Entity<UserLog_ba>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserLog___3214EC0743915E5A");

            entity.ToTable("UserLog_ba");

            entity.HasIndex(e => new { e.Modify_Table, e.Modify_Action }, "IX_Modify_Table_Modify_Action_on_ba");

            entity.HasIndex(e => new { e.Modify_Table, e.Modify_Id, e.Modify_Action }, "IX_Modify_Table_Modify_Id_Modify_Action_on_ba");

            entity.HasIndex(e => new { e.Modify_Action, e.Modify_Id, e.Operate_Time }, "IX_UserLog_ModifyAction_ModifyId_OperateTime_on_ba");

            entity.HasIndex(e => new { e.Modify_Action, e.Operate_Time }, "IX_UserLog_ModifyAction_OperateTime_on_ba");

            entity.HasIndex(e => e.Modify_Id, "IX_UserLog_Modify_Id_on_ba");

            entity.HasIndex(e => new { e.Modify_Action, e.Operate_Time, e.Modify_Id }, "IX_UserLog_ba_Action_Time_ModifyId");

            entity.HasIndex(e => new { e.Modify_Id, e.Modify_Action, e.Operate_Time }, "IX_UserLog_ba_ModifyId_Action_OperateTime").IsDescending(false, false, true);

            entity.HasIndex(e => new { e.Operate_Time, e.Modify_Action }, "IX_UserLog_ba_OperateTime_Action").IsDescending(true, false);

            entity.HasIndex(e => new { e.Modify_Action, e.Operate_Time, e.Modify_Id }, "IX_UserLog_ba_Optimized_View_Stats")
                .IsDescending(false, true, false)
                .HasFilter("([Modify_Action] IN ('View', 'like'))");

            entity.Property(e => e.Modify_Action).HasMaxLength(20);
            entity.Property(e => e.Modify_Detail).HasMaxLength(1000);
            entity.Property(e => e.Modify_Table).HasMaxLength(50);
            entity.Property(e => e.Operate_Time).HasColumnType("datetime");
            entity.Property(e => e.Operate_User_IP).HasMaxLength(100);
            entity.Property(e => e.Operate_User_Id).HasMaxLength(50);
        });

        modelBuilder.Entity<UserLogbuck2025>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__UserLog__3214EC07584A0D3A");

            entity.ToTable("UserLogbuck2025");

            entity.HasIndex(e => new { e.Modify_Table, e.Modify_Action }, "IX_Modify_Table_Modify_Action");

            entity.HasIndex(e => new { e.Modify_Table, e.Modify_Id, e.Modify_Action }, "IX_Modify_Table_Modify_Id_Modify_Action");

            entity.HasIndex(e => new { e.Modify_Action, e.Modify_Id, e.Operate_Time }, "IX_UserLog_ModifyAction_ModifyId_OperateTime");

            entity.HasIndex(e => new { e.Modify_Action, e.Operate_Time }, "IX_UserLog_ModifyAction_OperateTime");

            entity.HasIndex(e => e.Modify_Id, "IX_UserLog_Modify_Id");

            entity.HasIndex(e => new { e.Modify_Action, e.Operate_Time, e.Modify_Id }, "IX_UserLog_ba_Action_Time_ModifyId");

            entity.Property(e => e.Modify_Action).HasMaxLength(20);
            entity.Property(e => e.Modify_Detail).HasMaxLength(1000);
            entity.Property(e => e.Modify_Table).HasMaxLength(50);
            entity.Property(e => e.Operate_Time).HasColumnType("datetime");
            entity.Property(e => e.Operate_User_IP).HasMaxLength(100);
            entity.Property(e => e.Operate_User_Id).HasMaxLength(50);
        });

        modelBuilder.Entity<User_Authority>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__User_Aut__3214EC07C17A63DF");

            entity.ToTable("User_Authority");

            entity.Property(e => e.Own_Authority).HasMaxLength(10);
        });

        modelBuilder.Entity<User_Url>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__tmp_ms_x__3214EC07BA1C92C0");

            entity.ToTable("User_Url");

            entity.Property(e => e.Url).HasMaxLength(100);
        });

        modelBuilder.Entity<WebSite_Datum>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__WebSite___3214EC071C1DDE7D");

            entity.Property(e => e.Option).HasMaxLength(50);
        });

        modelBuilder.Entity<subscribe_payment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__subscrib__3214EC07F794F99E");

            entity.ToTable("subscribe_payment");

            entity.Property(e => e.Id).ValueGeneratedNever();
            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.Due_Time).HasColumnType("datetime");
            entity.Property(e => e.Pay_Time).HasColumnType("datetime");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
