using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System;
using System.Linq;
using System.Security.Claims;

namespace InventoryV3.Server.Configurations
{
    public class DynamicRoleAuthorizeAttribute : Attribute, IAuthorizationFilter
    {
        private readonly string[] _roles;

        public DynamicRoleAuthorizeAttribute(params string[] roles)
        {
            _roles = roles;
        }

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var user = context.HttpContext.User;

            if (!user.Identity?.IsAuthenticated ?? false)
            {
                Console.WriteLine("User is not authenticated.");
                context.Result = new UnauthorizedResult();
                return;
            }

            var roles = user.Claims.Where(c => c.Type == ClaimTypes.Role).Select(c => c.Value).ToList();
            Console.WriteLine($"User Roles: {string.Join(", ", roles)}");

            if (!_roles.Any(role => roles.Contains(role)))
            {
                Console.WriteLine("User does not have the required role.");
                context.Result = new ForbidResult();
            }
        }

    }
}
