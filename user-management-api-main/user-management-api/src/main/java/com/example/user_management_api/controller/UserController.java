package com.example.user_management_api.controller;

// Gerekli Spring ve Validation Importları
import com.example.user_management_api.dto.UserDTO;
import com.example.user_management_api.service.UserService;
import jakarta.validation.Valid; 
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    // Constructor Injection (Bağımlılık Enjeksiyonu)
    public UserController(UserService userService) {
        this.userService = userService;
    }

    // Listeleme (Pagination & Sorting)
    @GetMapping
    public Page<UserDTO> getAllUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String direction
    ) {
        Sort sort = direction.equalsIgnoreCase("desc") ? Sort.by(sortBy).descending() : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);
        return userService.getAllUsers(pageable);
    }

    // Kayıt Ekleme
    @PostMapping
    public UserDTO createUser(@Valid @RequestBody UserDTO userDto) {
        return userService.createUser(userDto);
    }

    // Güncelleme
    @PutMapping("/{id}")
    public UserDTO updateUser(@PathVariable Long id, @Valid @RequestBody UserDTO userDto) {
        return userService.updateUser(id, userDto);
    }

    // Silme
    @DeleteMapping("/{id}")
    public String deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return "Kullanıcı başarıyla silindi.";
    }
}