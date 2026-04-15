import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajweed_corrector/services/alphabet_service.dart';
import 'package:tajweed_corrector/data/arabic_letters.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AlphabetService tracks practice and mastery', () async {
    SharedPreferences.setMockInitialValues({});
    final service = AlphabetService();
    final letterId = arabicLetters.first.id;

    await service.markLetterPracticed(letterId);
    await service.markLetterPracticed(letterId);
    await service.markLetterPracticed(letterId);

    await service.recordQuizResult(
      letterId,
      85,
      totalQuestions: 5,
      correctAnswers: 4,
    );

    final progress = await service.getLetterProgress(letterId);
    expect(progress.timesPracticed, 3);
    expect(progress.lastQuizScore, 85);
    expect(progress.isMastered, true);
  });
}

