package com.queryx.database.controllers;

import com.queryx.database.repositories.CustomerRepository;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/customers")
@CrossOrigin(origins = "http://localhost:5173")
public class CustomerController {

    private final CustomerRepository customerRepository;

    public CustomerController(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    @GetMapping
    public List<Map<String, Object>> getAllCustomers() {
        return customerRepository.findAll().stream()
            .map(customer -> {
                Map<String, Object> data = new LinkedHashMap<>();
                data.put("id", customer.getId());
                data.put("customerNumber", customer.getCustomerNumber());
                data.put("name", customer.getName());
                data.put("email", customer.getEmail());
                data.put("phone", customer.getPhone());
                data.put("address", customer.getAddress());
                return data;
            })
            .toList();
    }
}