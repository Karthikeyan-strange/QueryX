package com.queryx.database.entities;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "customers")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "customer_number", nullable = false, unique = true, length = 50)
    private String customerNumber;

    @Column(nullable = false, length = 200)
    private String name;

    @Column(nullable = false, unique = true, length = 320)
    private String email;

    @Column(length = 50)
    private String phone;

    private String address;

    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;

    public UUID getId() { return id; }

    public String getCustomerNumber() { return customerNumber; }
    public void setCustomerNumber(String v) { customerNumber = v; }

    public String getName() { return name; }
    public void setName(String v) { name = v; }

    public String getEmail() { return email; }
    public void setEmail(String v) { email = v; }

    public String getPhone() { return phone; }
    public void setPhone(String v) { phone = v; }

    public String getAddress() { return address; }
    public void setAddress(String v) { address = v; }
}