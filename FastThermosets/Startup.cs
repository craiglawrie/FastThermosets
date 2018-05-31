using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(FastThermosets.Startup))]
namespace FastThermosets
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
