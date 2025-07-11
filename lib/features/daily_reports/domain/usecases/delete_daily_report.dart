import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/models/errors/failures.dart';
import '../../../../common/models/usecase/usecase.dart';
import '../repositories/daily_report_repository.dart';

class DeleteDailyReport implements UseCase<void, DeleteDailyReportParams> {
  final DailyReportRepository repository;

  DeleteDailyReport(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteDailyReportParams params) {
    return repository.deleteDailyReport(params.reportId);
  }
}

class DeleteDailyReportParams extends Equatable {
  final String reportId;

  const DeleteDailyReportParams(this.reportId);

  @override
  List<Object> get props => [reportId];
}
