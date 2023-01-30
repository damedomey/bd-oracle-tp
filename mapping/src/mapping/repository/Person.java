package mapping.repository;

import oracle.sql.ARRAY;

abstract class Person {
    protected int id;
    protected String name;
    protected ARRAY surname;
    protected int telephone;
    protected String email;
    protected ARRAY listRefReservations;

}
