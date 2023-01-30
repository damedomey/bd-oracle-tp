package mapping.repository;

import oracle.sql.ARRAY;

import java.sql.*;

public class Pilot extends Person implements SQLData {
    private Blob licence;
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
        licence = stream.readBlob();
        listRefReservations = (ARRAY) stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(id);
        stream.writeString(name);
        stream.writeArray(surname);
        stream.writeInt(telephone);
        stream.writeString(email);
        stream.writeBlob(licence);
        stream.writeArray(listRefReservations);
    }

    public static String findAll() {
        return "SELECT VALUE(po) FROM pilots po";
    }

    public void display(){
        System.out.println("Id : " + id + " Name : " + name);
    }
}
