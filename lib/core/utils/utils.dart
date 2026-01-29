class Utils {
  static void safePrintJwt(String jwt) {
    const int chunkSize = 800;

    for (int i = 0; i < jwt.length; i += chunkSize) {
      int end = i + chunkSize;
      if (end > jwt.length) {
        end = jwt.length;
      }

      print("jwt :${jwt.substring(i, end)}");
    }
  }
}
