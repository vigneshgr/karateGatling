package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;


public class DataGenerator {

    public static String getRandomEmail() {
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
        return email;
    }

    public static String getRandomUserName() {
        Faker faker = new Faker();
        String username = faker.name().username();
        return username;
    }

    public static JSONObject getRandomArticleValues() {
        Faker faker = new Faker();
        String title = faker.name().username();
        String description = faker.name().username();
        String body = faker.name().username();
        JSONObject json1 = new JSONObject();
        json1.put("title", title);
        json1.put("description", description);
        json1.put("body", body);
        System.out.println(json1);
        return json1;
    }
}