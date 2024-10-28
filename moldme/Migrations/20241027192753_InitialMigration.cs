using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace moldme.Migrations
{
    /// <inheritdoc />
    public partial class InitialMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Companies",
                columns: table => new
                {
                    CompanyID = table.Column<string>(type: "nvarchar(6)", maxLength: 6, nullable: false),
                    Name = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    TaxId = table.Column<int>(type: "int", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    Contact = table.Column<int>(type: "int", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    Sector = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    subscriptionPlan = table.Column<int>(type: "int", maxLength: 20, nullable: false),
                    Password = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Companies", x => x.CompanyID);
                });

            migrationBuilder.CreateTable(
                name: "Payments",
                columns: table => new
                {
                    PaymentID = table.Column<string>(type: "nvarchar(6)", maxLength: 6, nullable: false),
                    Value = table.Column<float>(type: "real", nullable: false),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Plan = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Payments", x => x.PaymentID);
                });

            migrationBuilder.CreateTable(
                name: "Tasks",
                columns: table => new
                {
                    TaskId = table.Column<int>(type: "int", maxLength: 6, nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TitleName = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    FilePath = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tasks", x => x.TaskId);
                });

            migrationBuilder.CreateTable(
                name: "Employees",
                columns: table => new
                {
                    StaffID = table.Column<string>(type: "nvarchar(6)", maxLength: 6, nullable: false),
                    Name = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    Profession = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    NIF = table.Column<int>(type: "int", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    Contact = table.Column<int>(type: "int", nullable: true),
                    Password = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    CompanyID = table.Column<string>(type: "nvarchar(6)", maxLength: 6, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Employees", x => x.StaffID);
                    table.ForeignKey(
                        name: "FK_Employees_Companies_CompanyID",
                        column: x => x.CompanyID,
                        principalTable: "Companies",
                        principalColumn: "CompanyID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Projects",
                columns: table => new
                {
                    ProjectId = table.Column<string>(type: "nvarchar(6)", maxLength: 6, nullable: false),
                    Name = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    Budget = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CompanyId = table.Column<string>(type: "nvarchar(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Projects", x => x.ProjectId);
                    table.ForeignKey(
                        name: "FK_Projects_Companies_CompanyId",
                        column: x => x.CompanyId,
                        principalTable: "Companies",
                        principalColumn: "CompanyID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reviews",
                columns: table => new
                {
                    ReviewID = table.Column<string>(type: "nvarchar(6)", maxLength: 6, nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                    Stars = table.Column<int>(type: "int", nullable: false),
                    StaffID = table.Column<string>(type: "nvarchar(6)", nullable: true),
                    ReviewedStaffID = table.Column<string>(type: "nvarchar(6)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reviews", x => x.ReviewID);
                    table.ForeignKey(
                        name: "FK_Reviews_Employees_ReviewedStaffID",
                        column: x => x.ReviewedStaffID,
                        principalTable: "Employees",
                        principalColumn: "StaffID");
                    table.ForeignKey(
                        name: "FK_Reviews_Employees_StaffID",
                        column: x => x.StaffID,
                        principalTable: "Employees",
                        principalColumn: "StaffID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Employees_CompanyID",
                table: "Employees",
                column: "CompanyID");

            migrationBuilder.CreateIndex(
                name: "IX_Projects_CompanyId",
                table: "Projects",
                column: "CompanyId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_ReviewedStaffID",
                table: "Reviews",
                column: "ReviewedStaffID");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_StaffID",
                table: "Reviews",
                column: "StaffID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Payments");

            migrationBuilder.DropTable(
                name: "Projects");

            migrationBuilder.DropTable(
                name: "Reviews");

            migrationBuilder.DropTable(
                name: "Tasks");

            migrationBuilder.DropTable(
                name: "Employees");

            migrationBuilder.DropTable(
                name: "Companies");
        }
    }
}
