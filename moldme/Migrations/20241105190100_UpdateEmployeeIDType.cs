using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace moldme.Migrations
{
    /// <inheritdoc />
    public partial class UpdateEmployeeIDType : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "EmployeeID",
                table: "Employees",
                type: "nvarchar(56)",
                maxLength: 56,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(6)",
                oldMaxLength: 6);

            migrationBuilder.AlterColumn<string>(
                name: "EmployeesEmployeeId",
                table: "EmployeeProject",
                type: "nvarchar(56)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(6)");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "EmployeeID",
                table: "Employees",
                type: "nvarchar(6)",
                maxLength: 6,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(56)",
                oldMaxLength: 56);

            migrationBuilder.AlterColumn<string>(
                name: "EmployeesEmployeeId",
                table: "EmployeeProject",
                type: "nvarchar(6)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(56)");
        }
    }
}
