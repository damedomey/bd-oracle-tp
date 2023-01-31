package mapping.repository;

import oracle.sql.ARRAY;

import java.sql.*;

public class Boat implements SQLData {
    private int id;
    private String name;
    private float surface;
    private String city;
    private int numberOfCabins;
    private int floors;
    private int maxSeats;
    private float price;
    private Ref refCategory;
    private ARRAY listRefReservations;

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
        surface = stream.readFloat();
        city = stream.readString();
        numberOfCabins = stream.readInt();
        floors = stream.readInt();
        maxSeats = stream.readInt();
        price = stream.readFloat();
        refCategory = stream.readRef();
        listRefReservations = (ARRAY) stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(id);
        stream.writeString(name);
        stream.writeFloat(surface);
        stream.writeString(city);
        stream.writeInt(numberOfCabins);
        stream.writeFloat(floors);
        stream.writeInt(maxSeats);
        stream.writeFloat(price);
        stream.writeRef(refCategory);
        stream.writeArray(listRefReservations);
    }

    public static String findAll(){
        return "SELECT VALUE(bo) FROM boats bo";
    }

    public void display() throws SQLException {
        Category category = (Category) refCategory.getObject();
        System.out.println("Id : " + id + " Name : " + name + " City : " + city + " Under category " + category.getName());
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

    public float getSurface() {
        return surface;
    }

    public void setSurface(float surface) {
        this.surface = surface;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public int getNumberOfCabins() {
        return numberOfCabins;
    }

    public void setNumberOfCabins(int numberOfCabins) {
        this.numberOfCabins = numberOfCabins;
    }

    public int getFloors() {
        return floors;
    }

    public void setFloors(int floors) {
        this.floors = floors;
    }

    public int getMaxSeats() {
        return maxSeats;
    }

    public void setMaxSeats(int maxSeats) {
        this.maxSeats = maxSeats;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public Ref getRefCategory() {
        return refCategory;
    }

    public void setRefCategory(Ref refCategory) {
        this.refCategory = refCategory;
    }

    public ARRAY getListRefReservations() {
        return listRefReservations;
    }

    public void setListRefReservations(ARRAY listRefReservations) {
        this.listRefReservations = listRefReservations;
    }
}
