package main

import (
	"database/sql"
	"fmt"
	"github.com/gofiber/fiber/v2"
	_ "github.com/lib/pq"
	"log"
)

// Database instance
var db *sql.DB

// Database settings
const (
	host     = "localhost"
	port     = 5432 // Default port
	user     = "postgres"
	password = "password"
	dbname   = "deez_notes"
)

type Role int

const (
	Admin Role = iota
	Reader
	Writer
)

// User struct
type User struct {
	ID       string `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
	Role     Role   `json:"role"`
}

// Users struct
type Users struct {
	Users []User `json:"users"`
}

// Connect function
func Connect() error {
	var err error
	db, err = sql.Open("postgres", fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbname))
	if err != nil {
		return err
	}
	if err = db.Ping(); err != nil {
		return err
	}
	return nil
}

func main() {
	// Connect with database
	if err := Connect(); err != nil {
		log.Fatal(err)
	}

	// Create a Fiber app
	app := fiber.New()

	// Get all records from postgreSQL
	app.Get("/user", func(c *fiber.Ctx) error {
		// Select all User(s) from database
		rows, err := db.Query("SELECT id, username, email, role FROM users order by id")
		if err != nil {
			return c.Status(500).SendString(err.Error())
		}
		defer rows.Close()
		result := Users{}

		for rows.Next() {
			user := User{}
			if err := rows.Scan(&user.ID, &user.Username, &user.Email, &user.Role); err != nil {
				return err // Exit if we get an error
			}

			// Append User to Users
			result.Users = append(result.Users, user)
		}
		// Return Users in JSON format
		return c.JSON(result)
	})

	// Add record into postgreSQL
	app.Post("/user", func(c *fiber.Ctx) error {
		// New User struct
		u := new(User)

		// Parse body into struct
		if err := c.BodyParser(u); err != nil {
			return c.Status(400).SendString(err.Error())
		}

		// Insert User into database
		res, err := db.Query("INSERT INTO users (username, email, role)VALUES ($1, $2, $3)", u.Username, u.Email, u.Role)
		if err != nil {
			return err
		}

		// Print result
		log.Println(res)

		// Return User in JSON format
		return c.JSON(u)
	})

	// Update record into postgreSQL
	app.Put("/user", func(c *fiber.Ctx) error {
		// New User struct
		u := new(User)

		// Parse body into struct
		if err := c.BodyParser(u); err != nil {
			return c.Status(400).SendString(err.Error())
		}

		// Update User into database
		res, err := db.Query("UPDATE users SET username=$1,email=$2,role=$3 WHERE id=$5", u.Username, u.Email, u.Role, u.ID)
		if err != nil {
			return err
		}

		// Print result
		log.Println(res)

		// Return User in JSON format
		return c.Status(201).JSON(u)
	})

	// Delete record from postgreSQL
	app.Delete("/user", func(c *fiber.Ctx) error {
		// New User struct
		u := new(User)

		// Parse body into struct
		if err := c.BodyParser(u); err != nil {
			return c.Status(400).SendString(err.Error())
		}

		// Delete User from database
		res, err := db.Query("DELETE FROM users WHERE id = $1", u.ID)
		if err != nil {
			return err
		}

		// Print result
		log.Println(res)

		// Return User in JSON format
		return c.JSON("Deleted")
	})

	log.Fatal(app.Listen(":3000"))
}
