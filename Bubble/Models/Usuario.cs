using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace Bubble.Models;

public class Usuario
{
    public int Id { get; set; }
    public string Nombre { get; set; }
    public string Email { get; set; }
    public string Contrasena { get; set; }
    public string Rol { get; set; }
    public DateTime FechaCreacion { get; set; } = DateTime.Now;
    public bool Activo { get; set; } = true; // Propiedad opcional
}
public class LoginRequest
{
    [Required]
    [EmailAddress]
    public string Email { get; set; } = null!;

    [Required]
    public string Password { get; set; } = null!;
}

public class RegisterRequest
{
    [Required]
    [EmailAddress]
    public string Email { get; set; } = null!;

    [Required]
    [MinLength(6)]
    public string Password { get; set; } = null!;

    [Required]
    public string Nombre { get; set; } = null!;

    public string Rol { get; set; } = "Cliente";
}

public class LoginResponse
{
    public string Token { get; set; } = null!;
    public string Email { get; set; } = null!;
    public string Nombre { get; set; } = null!;
    public string Rol { get; set; } = null!;
    public DateTime Expiracion { get; set; }
}