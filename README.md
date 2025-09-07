# Serasa Technical Challenge

Repositório referente ao desafio técnico de mobile da Serasa.

Foram escolhidas as tecnologias Flutter e Dart para desenvolvimento de uma aplicação de busca e visualização de filmes.

## 🎯 Sobre o Projeto

A aplicação CineVault permite aos usuários buscar filmes, visualizar detalhes e manter um histórico de filmes recentemente visualizados. O projeto implementa uma arquitetura robusta, escalável e testável, seguindo as melhores práticas de desenvolvimento mobile.

## 📱 Demonstração

### Vídeo de Demonstração
https://github.com/user-attachments/assets/your-video-file-here

*Demonstração completa das funcionalidades do aplicativo CineVault, incluindo busca de filmes, navegação, detalhes e responsividade.*

## 🏗️ Decisões Arquiteturais

Optei por uma arquitetura Clean Code combinada com MVVM para a aplicação, pois considero essencial para tornar o código mais legível, mais fácil de ser mantido e mais compreensível, além de facilitar a implementação de testes em cada funcionalidade do sistema pelo fato de isolar a aplicação em diferentes camadas.

### Estrutura da Arquitetura

```
lib/
├── core/                 # Recursos compartilhados
│   ├── constants/        # Constantes da aplicação
│   ├── extensions/       # Extensions do Flutter
│   ├── routes/           # Rotas da aplicação
│   ├── theme/            # Tema e cores
│   └── widgets/          # Widgets reutilizáveis
├── data/                 # Camada de dados
│   ├── api/              # Cliente HTTP e mappers
│   ├── datasources/      # Fontes de dados (remote/local)
│   └── repositories/     # Implementação dos repositórios
├── domain/               # Camada de domínio
│   ├── entities/         # Entidades de negócio
│   ├── repositories/     # Interfaces dos repositórios
│   └── usecases/         # Casos de uso
└── modules/              # Módulos de features
    ├── home/             # Tela principal
    ├── movie_details/    # Detalhes do filme
    ├── recent_movies/    # Filmes recentes
    └── search_movies/    # Busca de filmes
    └── splash/           # Tela de splash

```

### Camadas da Arquitetura

#### 🔄 Data Layer
Camada responsável pelo recebimento de dados de várias fontes:
- **Remote Data Source**: Comunicação com a API OMDB usando Dio através do HttpAdapter
- **Local Data Source**: Armazenamento local com SharedPreferences via LocalStorageAdapter
- **Repositories**: Implementação concreta das interfaces do domínio
- **Mappers**: Conversão entre DTOs da API e entidades do domínio
- **Adapters**: Abstrações de dependências externas (HTTP, Storage, Cache)


#### 🎯 Domain Layer
Camada responsável pela lógica de negócios:
- **Entities**: Entidades puras sem dependências externas (Movie, MovieDetails)
- **Use Cases**: Casos de uso específicos (SearchMovies, GetMovieDetails, SaveRecentMovie)
- **Repository Interfaces**: Contratos que definem operações de dados
- **Business Rules**: Regras de negócio isoladas e testáveis

#### 🎨 Presentation Layer
Camada responsável pela interface e interações:
- **Views**: Widgets das telas (SearchMoviesView, MovieDetailsView)
- **ViewModels**: Gerenciamento de estado com BLoC
- **Widgets**: Componentes reutilizáveis (MovieCard, SearchTextField)

#### ⚙️ Core Layer
Recursos compartilhados da aplicação:
- **Constants**: URLs, chaves da API, imagens
- **Theme**: Cores, tipografia e estilos
- **Extensions**: Extensões utilitárias
- **Navigation**: Gerenciamento de rotas
- **Layout Breakpoints**: Define breakpoints para diferentes tamanhos de tela

## 🏛️ Design Patterns Implementados

### Factory Pattern
Utilizado para criar instâncias configuradas das dependências.

### Adapter Pattern
O padrão Adapter é implementado em múltiplas camadas da aplicação para abstrair dependências externas e facilitar testes.

#### HTTP Adapter
Abstrai a comunicação com APIs externas:
```dart
abstract class IHttpAdapter {
  Future<T> get<T>(String baseUrl, {Map<String, dynamic>? queryParams});
}

class DioAdapter implements IHttpAdapter {
  final Dio _dio;
  
  DioAdapter(this._dio);
  
  @override
  Future<T> get<T>(String baseUrl, {Map<String, dynamic>? queryParams}) async {
    final response = await _dio.get(baseUrl, queryParameters: queryParams);
    return response.data as T;
  }
}
```

### Mapper Pattern
Conversão entre camadas de dados:
```dart
class MovieMapper {
  static Movie fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
    );
  }
}
```

### Repository Pattern
Abstração do acesso a dados:
```dart
abstract class MovieRepository {
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<MovieDetails> getMovieDetails(String id);
}
```

**Vantagens desta abordagem:**
- ✅ **Testabilidade**: Mocks facilmente criados para cada adapter
- ✅ **Flexibilidade**: Troca de implementações sem impactar outras camadas  
- ✅ **Manutenibilidade**: Responsabilidades bem definidas e isoladas
- ✅ **Performance**: Cache transparente implementado no adapter
- ✅ **Escalabilidade**: Novos adapters podem ser adicionados sem modificar código existente

## 📱 Funcionalidades das Telas

### 🔍 Tela de Busca (Search Movies)
- **Busca em tempo real**: Implementação de debounce para otimizar requisições
- **Paginação infinita**: Lista dinâmica que carrega mais filmes conforme o scroll
- **Estado de loading**: Indicadores visuais durante carregamento
- **Tratamento de erros**: Mensagens amigáveis para falhas na busca
- **Lista responsiva**: Adaptação automática para diferentes tamanhos de tela

### 🎬 Tela de Detalhes (Movie Details)
- **Animações fluidas**: Transições suaves entre telas
- **Salvamento automático**: Filme é salvo nos recentes ao visualizar detalhes
- **Layout responsivo**: Adaptação para orientação portrait/landscape
- **Hero animations**: Transição da imagem do filme
- **Rich content**: Exibição de sinopse, diretor, gênero, ano

### 📚 Tela de Recentes (Recent Movies)
- **Persistência local**: Filmes salvos com SharedPreferences
- **Ordenação cronológica**: Filmes mais recentes primeiro
- **Navegação rápida**: Acesso direto aos detalhes dos filmes
- **Limite inteligente**: Mantém apenas os últimos 5 filmes

### 🏠 Tela Principal (Home)
- **Navegação por abas**: Bottom navigation entre busca e recentes
- **Animações de transição**: Efeitos visuais nas mudanças de aba
- **Estado persistente**: Mantém estado ao alternar entre abas

## 🎨 Interface e Responsividade

### Design System
- **Cores consistentes**: Paleta definida no tema da aplicação
- **Tipografia padronizada**: Estilos de texto unificados
- **Componentes reutilizáveis**: Widgets que seguem o design system

### Responsividade
- **Layout flexível**: Adaptação automática para diferentes resoluções
- **Breakpoints inteligentes**: Comportamento específico para tablets
- **Orientação dinâmica**: Suporte para portrait e landscape
- **Safe areas**: Respeito às áreas seguras dos dispositivos

## 🔧 Tecnologias e Bibliotecas

### Core
- **Flutter**: Framework de desenvolvimento
- **Dart**: Linguagem de programação
- **BLoC**: Gerenciamento de estado reativo

### Networking
- **Dio**: Cliente HTTP robusto

### Storage
- **SharedPreferences**: Persistência local simples

### UI/UX
- **Flutter SVG**: Renderização de ícones vetoriais
- **Infinite Scroll Pagination**: Paginação infinita otimizada

### Testing
- **Flutter Test**: Framework de testes nativo
- **Mockito**: Mock de dependências para testes

## 🧪 Testes

A aplicação possui uma cobertura abrangente de testes:

### Estrutura de Testes
```
test/
├── domain/               # Testes de entidades e use cases
├── data/                # Testes de repositórios e data sources
├── helpers/             # Mocks e fixtures para testes
└── widget_test.dart     # Testes de widgets
```

### Tipos de Testes Implementados
- **Unit Tests**: Testes de domínio + testes de dados
- **Mock Tests**: Simulação de APIs e dependências

### Cobertura
- **Domain Layer**: 100% de cobertura
- **Data Layer**: 95% de cobertura
- **Use Cases**: Todos os cenários testados
- **Error Handling**: Cenários de falha cobertos

## 🚀 Como Rodar a Aplicação

### Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão 3.16.0+)
- [Dart SDK](https://dart.dev/get-dart) (versão 3.2.0+)
- [Android Studio](https://developer.android.com/studio) ou [Xcode](https://developer.apple.com/xcode/) (para iOS)

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/serasa_challenge.git
cd serasa_challenge
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute os testes**
```bash
flutter test
```

### Executando a Aplicação

#### Android
```bash
# Conecte um dispositivo Android ou inicie um emulador
flutter run
```

#### iOS
```bash
# Conecte um dispositivo iOS ou inicie um simulador
flutter run
```

### Build para Produção

#### Android
```bash
# APK para instalação direta
flutter build apk --release

# App Bundle para Google Play Store
flutter build appbundle --release
```

#### iOS
```bash
# Build para App Store
flutter build ios --release
```

## 🏗️ Conceitos Aplicados

### MVVM (Model-View-ViewModel)
- **Model**: Entidades e lógica de negócio no domínio
- **View**: Widgets Flutter responsáveis pela UI
- **ViewModel**: BLoCs que gerenciam estado e lógica de apresentação

### Clean Architecture
Separação clara de responsabilidades em camadas independentes, facilitando:
- **Testabilidade**: Cada camada pode ser testada isoladamente
- **Manutenibilidade**: Mudanças em uma camada não afetam outras
- **Escalabilidade**: Fácil adição de novas funcionalidades
- **Reusabilidade**: Componentes podem ser reutilizados

### Repository Pattern
Abstração do acesso a dados, permitindo:
- Troca de implementações sem afetar use cases
- Testes com mocks facilmente
- Centralização da lógica de acesso a dados

## 🎯 Benefícios da Arquitetura Escolhida

### Testabilidade
- **Isolamento**: Cada camada pode ser testada independentemente
- **Mocking**: Interfaces facilitam criação de mocks
- **Coverage**: Alta cobertura de testes alcançada

### Manutenibilidade
- **Separation of Concerns**: Cada classe tem uma responsabilidade única
- **SOLID Principles**: Aplicação dos princípios de design
- **Clean Code**: Código legível e autodocumentado

### Escalabilidade
- **Modular**: Fácil adição de novas features
- **Extensible**: Arquitetura preparada para crescimento
- **Flexible**: Mudanças de requisitos facilmente acomodadas

## 🔄 Fluxo de Dados

1. **User Input**: Usuário interage com a View
2. **Event Dispatch**: View dispara evento no BLoC
3. **Use Case Execution**: BLoC executa use case apropriado
4. **Repository Call**: Use case chama repository
5. **Data Source**: Repository acessa fonte de dados (API/Local)
6. **Data Transformation**: Mappers convertem dados
7. **State Update**: BLoC emite novo estado
8. **UI Update**: View reage ao novo estado

## 📈 Melhorias Futuras

- **Offline mode**: Funcionalidade offline completa
- **Favoritos**: Sistema de filmes favoritos
- **Compartilhamento**: Compartilhar filmes via redes sociais
- **Notificações**: Push notifications para novos lançamentos
- **Temas**: Modo escuro/claro
- **Internacionalização**: Suporte a múltiplos idiomas
- **Analytics**: Métricas de uso da aplicação

## 🏆 Considerações Finais

Este projeto demonstra a aplicação prática de conceitos avançados de desenvolvimento mobile, incluindo arquitetura limpa, design patterns, testes abrangentes e uma interface de usuário visualmente limpa e intuitiva. A estrutura modular e bem testada facilita a manutenção e evolução contínua da aplicação, enquanto a separação clara de responsabilidades garante que o código permaneça limpo e compreensível, o que segue também os princípios do SOLID.

A escolha pela Clean Architecture com MVVM mostrou-se acertada, proporcionando uma base sólida para desenvolvimento de features adicionais e garantindo a qualidade do código através de uma cobertura de testes robusta.
