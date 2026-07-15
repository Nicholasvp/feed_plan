// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'FeedPlan';

  @override
  String get homeTitle => 'Meus Projetos';

  @override
  String get newProject => 'Novo Projeto';

  @override
  String get editProject => 'Editar Projeto';

  @override
  String get deleteProject => 'Excluir';

  @override
  String get deleteProjectConfirm =>
      'Tem certeza que deseja excluir este projeto?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get noProjects => 'Nenhum projeto ainda. Crie o primeiro!';

  @override
  String get createProfile => 'Criar Perfil';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get profileName => 'Nome';

  @override
  String get profileBio => 'Bio';

  @override
  String get profileAvatar => 'Foto do Perfil';

  @override
  String get addPhoto => 'Adicionar Foto';

  @override
  String get addVideo => 'Adicionar Vídeo';

  @override
  String get addMedia => 'Adicionar Mídia';

  @override
  String get reorder => 'Reordenar';

  @override
  String get crop => 'Cortar';

  @override
  String get trim => 'Aparar';

  @override
  String get aspectRatio => 'Proporção';

  @override
  String get square => 'Quadrado (1:1)';

  @override
  String get portrait => 'Retrato (4:5)';

  @override
  String get story => 'Story (9:16)';

  @override
  String get landscape => 'Paisagem (16:9)';

  @override
  String get gridPreview => 'Prévia do Grid';

  @override
  String get export => 'Exportar';

  @override
  String get exporting => 'Exportando...';

  @override
  String get exportSuccess => 'Carrossel exportado com sucesso!';

  @override
  String get exportPath => 'Salvo na galeria';

  @override
  String get openGallery => 'Abrir Galeria';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próximo';

  @override
  String get done => 'Pronto';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglês';

  @override
  String get portuguese => 'Português';

  @override
  String get settings => 'Configurações';

  @override
  String get warningNoMedia => 'Adicione ao menos uma mídia para exportar.';

  @override
  String get carouselEditor => 'Editor de Carrossel';

  @override
  String get slide => 'Slide';

  @override
  String get slideOf => 'de';

  @override
  String get importGrid => 'Importar do grid';

  @override
  String get startFromScratch => 'Começar do zero';

  @override
  String get postInGrid => 'Post no grid';

  @override
  String get newPost => 'Novo Post';

  @override
  String get emptyGrid =>
      'Seu grid está vazio. Adicione posts para ver a prévia.';

  @override
  String selectedCount(int count) {
    return '$count selecionado(s)';
  }

  @override
  String deleteItemCount(int count) {
    return 'Excluir $count item';
  }

  @override
  String deleteItemCountConfirm(int count) {
    return 'Tem certeza que deseja excluir $count item?';
  }

  @override
  String get delete => 'Excluir';

  @override
  String get errorLogs => 'Logs de Erro';

  @override
  String get noPostsYet => 'Nenhum post ainda';

  @override
  String get tapToCreateCarousel =>
      'Toque em + para criar seu primeiro carrossel';

  @override
  String errorSavingImage(String error) {
    return 'Erro ao salvar imagem: $error';
  }

  @override
  String get premiumFeature => 'Recurso Premium';

  @override
  String premiumLimitReached(String feature) {
    return 'Você atingiu o limite gratuito para $feature. Assine o Premium para desbloquear acesso ilimitado.';
  }

  @override
  String get notNow => 'Agora não';

  @override
  String get upgrade => 'Assinar';

  @override
  String get premium => 'Premium';

  @override
  String get tapToChangePhoto => 'Toque para mudar a foto';

  @override
  String get name => 'Nome';

  @override
  String get bio => 'Bio';

  @override
  String get followers => 'Seguidores';

  @override
  String get following => 'Seguindo';

  @override
  String get deleteCarousel => 'Excluir carrossel';

  @override
  String get addPagesAndPhotos =>
      'Adicione páginas e fotos para montar seu carrossel';

  @override
  String get addFirstPage => 'Adicionar Primeira Página';

  @override
  String get addImageToCurrentPage => 'Adicionar imagem à página atual';

  @override
  String get addPage => 'Adicionar página';

  @override
  String get applyGridLayout => 'Aplicar layout de grid';

  @override
  String get exportPagesToGallery => 'Exportar páginas para galeria';

  @override
  String get centerImage => 'Centralizar imagem';

  @override
  String get deleteSelectedImage => 'Excluir imagem selecionada';

  @override
  String get exportingPages => 'Exportando páginas';

  @override
  String savingPagesToGallery(int count) {
    return 'Salvando $count página na galeria...';
  }

  @override
  String get allPagesSaved => 'Todas as páginas salvas na galeria!';

  @override
  String pagesSavedOf(int saved, int total) {
    return '$saved de $total páginas salvas na galeria.';
  }

  @override
  String exportFailed(String error) {
    return 'Falha na exportação: $error';
  }

  @override
  String get pageCreatedTapAgain =>
      'Página criada. Toque em + novamente para adicionar imagem.';

  @override
  String errorAddingImage(String error) {
    return 'Erro ao adicionar imagem: $error';
  }

  @override
  String get deleteCarouselConfirm => 'Excluir carrossel?';

  @override
  String get actionCannotBeUndone => 'Esta ação não pode ser desfeita.';

  @override
  String get tapToAdd => 'Toque para adicionar';

  @override
  String get chooseGridLayout => 'Escolha um layout de grid';

  @override
  String get viewCarousel => 'Visualizar Carrossel';

  @override
  String get noPagesInCarousel => 'Nenhuma página neste carrossel';

  @override
  String get goBack => 'Voltar';

  @override
  String get readyToExport => 'Pronto para exportar';

  @override
  String get exportComingSoon => 'Funcionalidade de exportação em breve!';

  @override
  String get saveToGallery => 'Salvar na Galeria';

  @override
  String get noLogsFound => 'Nenhum log encontrado.';

  @override
  String get copyLogs => 'Copiar logs';

  @override
  String get logsCopied => 'Logs copiados para a área de transferência';

  @override
  String get clearLogs => 'Limpar logs';

  @override
  String get clearLogsConfirm => 'Limpar logs?';

  @override
  String get clearLogsMessage => 'Isso excluirá todos os logs salvos.';

  @override
  String get refresh => 'Atualizar';

  @override
  String get enterInstagramUsername => 'Digite um username do Instagram';

  @override
  String get dailyLimitReached =>
      'Limite diário atingido. Assine o Premium para buscar mais.';

  @override
  String errorFetchingPosts(String error) {
    return 'Erro ao buscar posts: $error';
  }

  @override
  String get posts => 'posts';

  @override
  String get instagramUsername => 'Username do Instagram';
}
