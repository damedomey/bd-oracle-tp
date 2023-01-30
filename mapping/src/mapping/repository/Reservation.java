package mapping.repository;

import oracle.sql.ARRAY;

import java.sql.*;

public class Reservation implements SQLData  {
    private int id;
    private Date requestDatetime;
    private Date startDate;
    private Date endDate;
    private int groupSize;
    private String stateOfReservation;
    private ARRAY listRefBoats;
    private ARRAY listRefPilots;
    private ARRAY listRefCustomers;

    private String sql_type;

    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        sql_type = typeName;
        id = stream.readInt();
        requestDatetime = stream.readDate();
        startDate = stream.readDate();
        endDate = stream.readDate();
        groupSize = stream.readInt();
        stateOfReservation = stream.readString();
        listRefBoats = (ARRAY) stream.readArray();
        listRefPilots = (ARRAY) stream.readArray();
        listRefCustomers = (ARRAY) stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(id);
        stream.writeDate(requestDatetime);
        stream.writeDate(startDate);
        stream.writeDate(endDate);
        stream.writeInt(groupSize);
        stream.writeString(stateOfReservation);
        stream.writeArray(listRefBoats);
        stream.writeArray(listRefPilots);
        stream.writeArray(listRefCustomers);
    }

    public static String findAll() {
        return "SELECT VALUE(re) FROM reservations re";
    }

    public void display(){
        System.out.println("Id : " + id + " group size : " + groupSize);
    }
}
