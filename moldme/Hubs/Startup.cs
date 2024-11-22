using Microsoft.AspNetCore.SignalR;
using moldme.data;

namespace moldme.hubs
{
    /// <summary>
    /// Hub for managing chat messages.
    /// </summary>
    public class ChatHub : Hub
    {
        /// <summary>
        /// Sends a message to all connected clients.
        /// </summary>
        /// <param name="userId">The ID of the user sending the message.</param>
        /// <param name="message">The message content.</param>
        /// <returns>A task that represents the asynchronous operation.</returns>
        public async Task SendMessage(string userId, string message)
        {
            await Clients.All.SendAsync("ReceiveMessage", userId, message);
        }
    }
    /// <summary>
    /// Configures services and the app's request pipeline.
    /// </summary>
    public class Startup
    {
        /// <summary>
        /// Configures the services for the application.
        /// </summary>
        /// <param name="services">The service collection to configure.</param>
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            services.AddDbContext<ApplicationDbContext>();
            services.AddSignalR();
        }

        /// <summary>
        /// Configures the application pipeline.
        /// </summary>
        /// <param name="app">The application builder to configure.</param>
        /// <param name="env">The hosting environment.</param>
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRouting();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapHub<ChatHub>("api/chathub");
            });
        }
    }
}