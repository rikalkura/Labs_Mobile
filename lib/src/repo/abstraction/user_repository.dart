abstract class IUserStorage {
  Future<void> saveUser(Map<String, String> userData);
  Future<Map<String, String>?> getUser();
  Future<void> deleteUser();
  Future<void> updateUser(Map<String, String> updatedData);
}
