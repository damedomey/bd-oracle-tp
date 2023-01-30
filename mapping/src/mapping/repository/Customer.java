package mapping.repository;

import oracle.sql.ARRAY;

import java.sql.SQLData;
import java.sql.SQLException;
import java.sql.SQLInput;
import java.sql.SQLOutput;

public class Customer extends Person implements SQLData {
    private String sql_type;

    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        sql_type = typeName;
        id = stream.readInt();
        name = stream.readString();
        surname = (ARRAY) stream.readArray();
        telephone = stream.readInt();
        email = stream.readString();
        listRefReservations = (ARRAY) stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(id);
        stream.writeString(name);
        stream.writeArray(surname);
        stream.writeInt(telephone);
        stream.writeString(email);
        stream.writeArray(listRefReservations);
    }

    public static String findAll() {
        return "SELECT VALUE(cu) FROM customers cu";
    }

    public void display(){
        System.out.println("Id : " + id + " Name : " + name);
    }
}
