package mapping.repository;

import oracle.sql.ARRAY;

abstract class Person {
    protected int id;
    protected String name;
    protected ARRAY surname;
    protected int telephone;
    protected String email;
    protected ARRAY listRefReservations;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ARRAY getSurname() {
        return surname;
    }

    public void setSurname(ARRAY surname) {
        this.surname = surname;
    }

    public int getTelephone() {
        return telephone;
    }

    public void setTelephone(int telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public ARRAY getListRefReservations() {
        return listRefReservations;
    }

    public void setListRefReservations(ARRAY listRefReservations) {
        this.listRefReservations = listRefReservations;
    }
}
