

package com.queryx.database.controllers;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/database")
@CrossOrigin(origins = "http://localhost:5173")
public class DatabaseController {

    private final JdbcTemplate jdbc;

    public DatabaseController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping
    public Map<String, Object> getCompleteDatabase() {

        Map<String, Object> result = new LinkedHashMap<>();

        result.put("users", jdbc.queryForList("SELECT * FROM users"));
        result.put("customers", jdbc.queryForList("SELECT * FROM customers"));
        result.put("warehouses", jdbc.queryForList("SELECT * FROM warehouses"));
        result.put("orders", jdbc.queryForList("SELECT * FROM orders"));
        result.put("shipments", jdbc.queryForList("SELECT * FROM shipments"));
        result.put("tracking_events", jdbc.queryForList("SELECT * FROM tracking_events"));
        result.put("complaints", jdbc.queryForList("SELECT * FROM complaints"));
        result.put("regional_events", jdbc.queryForList("SELECT * FROM regional_events"));
        result.put("investigations", jdbc.queryForList("SELECT * FROM investigations"));
        result.put("investigation_events", jdbc.queryForList("SELECT * FROM investigation_events"));
        result.put("responses", jdbc.queryForList("SELECT * FROM responses"));

        return result;
    }
}

