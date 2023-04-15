<?php

class Access {
// ``

    // Connection information.
    private $connection;

    // SQL querey information.
    private $querey;

    // Connected to the database server.
    private $connected = false;

    // Errors.
    private $error;

    // Hostname or IP address of the database server.
    private $host = "localhost";

    // Port to access the database server.
    private $port = 8888;

    // Name of the database.
    private $database = "facebook";

    // Username.
    private $username = "root";

    // Password.
    private $password = "root"; // This is a random password!

    // Database charset.
    private $charset = "UTF8";

    private $output;

    // PDO options.
    private $options = [
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_PERSISTENT => true
    ];

    /**
    *
    * Connect.
    *
    * Creates connection to the database server.
    *
    **/

    public function connect() {

        if ($this->connected === true) {

            return true;

        } else {

            try {

                $this->connection = new PDO("mysql:host={$this->host};port={$this->port};dbname={$this->database};charset={$this->charset}", $this->username, $this->password, $this->options);

                $this->connected = true;

                // $this->$output = 'Connesso correttamente';
                // echo($this->$output);

            } catch (PDOException $e) {

                // $this->error = $e->getMessage();
                // echo($this->error);
                return null;

            }

        }

    }

    /**
    *
    * Query the Database.
    *
    * Used for SELECT, INSERT, UPDATE and DELETE statements.
    *
    **/

    public function query($query, $parameters = [], $expectSingleResult = false) {

        if ($this->connected === true) {

            if (is_string($query) && $query !== "" && is_array($parameters) && is_bool($expectSingleResult)) {

                try {

                    // Prepare querey.
                    $this->querey = $this->connection->prepare($query);

                    // Bind parameters to querey.
                    foreach ($parameters as $placeholder => $value) {

                        // Parameter type.
                        if (is_string($value)) {

                            // Parameter is a string.
                            $type = PDO::PARAM_STR;

                        } elseif (is_int($value)) {

                            // Parameter is a integer.
                            $type = PDO::PARAM_INT;

                        } elseif (is_bool($value)) {

                            // Parameter is a boolean.
                            $type = PDO::PARAM_BOOL;

                        } else {

                            // Parameter is NULL.
                            $type = PDO::PARAM_NULL;

                        }

                        // Bind parameter.
                        $this->querey->bindValue($placeholder, $value, $type);

                    }

                    // Execute SQL querey.
                    $this->querey->execute();

                    // Get Result of SQL querey.
                    if ($expectSingleResult === true) {

                        $results = $this->querey->fetch(PDO::FETCH_ASSOC);

                    } else {

                        $results = $this->querey->fetchAll(PDO::FETCH_ASSOC);

                    }

                    // Return results of SQL querey.
                    return $results;

                } catch (PDOException $e) {

                    // $this->error = $e->getMessage();
                    // echo($this->error);
                }

            } else {

                // $this->error = "Invalid Querey or Paramaters";
                // echo($this->error);
                return null;

            }

        } else {

            // $this->error = "Not Connected to Database Server";
            // echo($this->error);
            return null;

        }

    }

    /**
    *
    * Select users by email (and other info in dictionary)
    * 
    **/

    public function selectUser($email) {

        if ($this->connected === TRUE) {
            $parameters = [':email' => $email];
            $query = "SELECT * FROM `users` WHERE `email` = :email";
            return $this->query($query, $parameters, TRUE);

        } else {
            // $this->error = "C'è stato un errore nella selezione dell'utente";
            // echo($this->error);
            return null;
        }
    }

    /**
    *
    * Insert new user into DB
    * 
    **/

    public function insertUser($email, $firstname, $lastname, $password, $salt ,$birthday, $gender, $cover, $user, $bio) {

        if ($this->connected === TRUE) {
            $parameters = [':email' => $email, 
                ':firstname' => $firstname, 
                ':lastname' => $lastname,
                ':passwordd' => $password,
                ':salt' => $salt,
                ':birthday' => $birthday,
                ':gender' => $gender,
                ':cover' => $cover,
                ':ava' => $user,
                ':bio' => $bio
            ];
            $query = "INSERT INTO users (`email`, `firstName`, `lastName`, `password`, `salt` ,`birthday`, `gender`, `cover`, `user`, `bio`) VALUES (:email, :firstname, :lastname, :passwordd, :salt, :birthday, :gender, :cover, :ava, :bio)";
            // $this->output = "Utente inserito correttamente";
            // echo($this->output);
            return $this->query($query, $parameters, FALSE);
        } else {
            // $this->error = "C'è stato un errore nell'inserimento dell'utente";
            // echo($this->error);
            return null;
        }

    }


    /**
    *
    * Update userProfile images into DB
    * 
    **/

    function updateImagePath($type, $path, $id) {
        if ($this->connected == TRUE) {
            
            $parameters = [
                ":paths" => $path,
                ":id" => $id
            ];


            if ($type == 'cover') {
                $query = "UPDATE `users` SET `cover` = :paths WHERE `id` = :id";
            } else {
                $query = "UPDATE `users` SET `user` = :paths WHERE `id` = :id";
            }

            return $this->query($query, $parameters, FALSE);

        } else {
            return null;
        }
    }


    /**
    *
    * Update Bio into DB
    * 
    **/

    function updateBio($id, $bio) {
        if ($this->connected == TRUE) {
            
            $parameters = [
                ":paths" => $bio,
                ":id" => $id
            ];


            $query = "UPDATE `users` SET `bio` = :paths WHERE `id` = :id";

            return $this->query($query, $parameters, FALSE);

        } else {
            return null;
        }
    }


    function uploadPost($user_id, $text, $picture) {

        if ($this->connected == TRUE) {

            $parameters = [
                ":userid" => $user_id,
                ":textt" => $text,
                ":picture" => $picture
            ];

            $query = "INSERT INTO posts (`user_id`, `text`, `picture`) VALUES (:userid, :textt, :picture)";

            return $this->query($query, $parameters, FALSE);

        } else {
            return null;
        }


    }


    /**
    *
    * Select users by ID (and other info in dictionary)
    * 
    **/

    public function selectUserID($id) {

        if ($this->connected === TRUE) {
            $parameters = [':id' => $id];
            $query = "SELECT * FROM `users` WHERE `id` = :id";
            return $this->query($query, $parameters, TRUE);

        } else {
            return null;
        }
    }


    public function updateUser($email, $firstname, $lastname, $birthday, $gender, $id) {


        if ($this->connected == TRUE) {
            $parameters = [
                ":email" => $email,
                ":firstname" => $firstname,
                ":lastname" => $lastname,
                ":birthday" => $birthday,
                ":gender" => $gender,
                ":id" => $id
            ];
    
    
            $query = "UPDATE `users` SET `email` = :email , `firstName` = :firstname , `lastName` = :lastname , `birthday` = :birthday , `gender` = :gender WHERE `id` = :id";
    
            return $this->query($query, $parameters, FALSE);
        } else {
            return null;
        }
    }


    public function updatePassword($id, $password, $salt) {

        if ($this->connected == TRUE) {
            $parameters = [
                ":passwordd" => $password,
                ":salt" => $salt,
                ":id" => $id
            ];
    
    
            $query = "UPDATE `users` SET `password` = :passwordd , `salt` = :salt  WHERE `id` = :id";
    
            return $this->query($query, $parameters, FALSE);
        } else {
            return null;
        }

    }


    /**
    *
    * Close the current connection to the database server.
    *
    **/

    public function close() {

        $this->connection = null;
        // $this->output = 'Connessione terminata';
        // echo($this->output);
    }

}

