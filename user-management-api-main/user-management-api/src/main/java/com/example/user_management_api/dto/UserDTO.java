package com.example.user_management_api.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {
    private Long id;

    @NotBlank(message = "İsim boş olamaz")
    @Size(min = 2, message = "İsim en az 2 karakter olmalıdır")
    private String firstName;

    @NotBlank(message = "Soyisim boş olamaz")
    private String lastName;

    @Email(message = "Geçerli bir email adresi giriniz")
    @NotBlank(message = "Email boş olamaz")
    private String email;
}
