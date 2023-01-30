package mapping.repository;

import oracle.sql.ARRAY;

import java.sql.*;

public class Category implements SQLData {
    private int id;
    private String name;
    private ARRAY listRefBoats;
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
        listRefBoats = (ARRAY) stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(id);
        stream.writeString(name);
        stream.writeArray(listRefBoats);
    }

    public static String findAll() {
        return "SELECT VALUE(ca) FROM categories ca";
    }

    public void display(){
        System.out.println("Id : " + id + " Name : " + name);
    }
}
