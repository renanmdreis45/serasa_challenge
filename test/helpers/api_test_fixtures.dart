import 'package:serasa_challenge/data/api/response/http_response.dart';

class ApiTestFixtures {
  static Map<String, dynamic> get successfulSearchResponse => {
    'Response': 'True',
    'Search': [
      {
        'imdbID': 'tt0111161',
        'Title': 'The Shawshank Redemption',
        'Director': 'Frank Darabont',
        'Year': '1994',
        'Poster': 'https://example.com/poster1.jpg',
      },
      {
        'imdbID': 'tt0068646',
        'Title': 'The Godfather',
        'Director': 'Francis Ford Coppola',
        'Year': '1972',
        'Poster': 'https://example.com/poster2.jpg',
      },
    ],
  };

  static Map<String, dynamic> get emptySearchResponse => {
    'Response': 'False',
    'Error': 'Movie not found!',
  };

  static Map<String, dynamic> get movieDetailsResponse => {
    'imdbID': 'tt0111161',
    'Title': 'The Shawshank Redemption',
    'Director': 'Frank Darabont',
    'Year': '1994',
    'Genre': 'Drama',
    'Plot':
        'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
    'Poster': 'https://example.com/poster1.jpg',
    'Response': 'True',
  };

  static Map<String, dynamic> get movieNotFoundResponse => {
    'Response': 'False',
    'Error': 'Incorrect IMDb ID.',
  };

  static HttpResponse<Map<String, dynamic>> get successfulSearchHttpResponse =>
      HttpResponse(data: successfulSearchResponse, statusCode: 200);

  static HttpResponse<Map<String, dynamic>> get emptySearchHttpResponse =>
      HttpResponse(data: emptySearchResponse, statusCode: 200);

  static HttpResponse<Map<String, dynamic>> get movieDetailsHttpResponse =>
      HttpResponse(data: movieDetailsResponse, statusCode: 200);

  static HttpResponse<Map<String, dynamic>> get movieNotFoundHttpResponse =>
      HttpResponse(data: movieNotFoundResponse, statusCode: 200);

  static HttpResponse<Map<String, dynamic>> get networkErrorHttpResponse =>
      HttpResponse(data: null, statusCode: 500);

  static HttpResponse<Map<String, dynamic>> get unauthorizedHttpResponse =>
      HttpResponse(data: {'Error': 'Invalid API key!'}, statusCode: 401);

  static List<Map<String, dynamic>> get localMoviesJsonList => [
    {
      'imdbID': 'tt0111161',
      'Title': 'The Shawshank Redemption',
      'Director': 'Frank Darabont',
      'Year': 1994,
      'Poster': 'https://example.com/poster1.jpg',
    },
    {
      'imdbID': 'tt0068646',
      'Title': 'The Godfather',
      'Director': 'Francis Ford Coppola',
      'Year': 1972,
      'Poster': 'https://example.com/poster2.jpg',
    },
  ];

  static String get localMoviesJsonString =>
      '[{"imdbID":"tt0111161","Title":"The Shawshank Redemption","Director":"Frank Darabont","Year":1994,"Poster":"https://example.com/poster1.jpg"},{"imdbID":"tt0068646","Title":"The Godfather","Director":"Francis Ford Coppola","Year":1972,"Poster":"https://example.com/poster2.jpg"}]';
}
