package com.example.user_management_api.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.user_management_api.model.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // JpaRepository sayesinde save, findById, findAll, delete gibi metodlar hazır gelir.
}