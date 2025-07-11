import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/models/errors/failures.dart';
import '../../../../common/models/usecase/usecase.dart';
import '../repositories/daily_report_repository.dart';

class UploadDailyReportImage
    implements UseCase<String, UploadDailyReportImageParams> {
  final DailyReportRepository repository;

  UploadDailyReportImage(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadDailyReportImageParams params) {
    return repository.uploadDailyReportImage(params.reportId, params.imagePath);
  }
}

class UploadDailyReportImageParams extends Equatable {
  final String reportId;
  final String imagePath;

  const UploadDailyReportImageParams({
    required this.reportId,
    required this.imagePath,
  });

  @override
  List<Object> get props => [reportId, imagePath];
}
