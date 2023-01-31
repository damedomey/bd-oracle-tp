package mapping.repository;

import oracle.sql.ARRAY;

import java.io.IOError;
import java.io.IOException;
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

    public void displayBoatsInCategory() throws SQLException, IOException {
        Ref [] refs = (Ref[]) this.getListRefBoats().getArray();
        System.out.println("Liste des bateaux dans la catégorie " + name);

        for (Ref refBoat: refs) {
            Boat boat = (Boat) refBoat.getObject();
            boat.display();
        }

        System.out.println("-------------");
    }

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

    public ARRAY getListRefBoats() {
        return listRefBoats;
    }

    public void setListRefBoats(ARRAY listRefBoats) {
        this.listRefBoats = listRefBoats;
    }
}
