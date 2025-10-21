import 'package:clickcut_mobile/features/select/apresentation/controllers/select_business_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  
		@override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SelectBusinessController>().fetchBusinesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SelectBusinessController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _buildBody(controller),
        ),
      ),
    );
  }

  Widget _buildBody(SelectBusinessController controller) {
    switch (controller.state) {
      case SelectBusinessState.loading:
      case SelectBusinessState.idle:
        return const Center(child: CircularProgressIndicator());

      case SelectBusinessState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Erro ao buscar negócios: ${controller.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchBusinesses(),
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        );

      case SelectBusinessState.success:
        if (controller.businesses.isEmpty) {
          return const Center(child: Text('Nenhum negócio encontrado.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70.0, bottom: 40.0),
              child: Text(
                "Qual negócio deseja acessar?", // Título
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: controller.businesses.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 colunas
                  childAspectRatio: 0.8, // Proporção (largura / altura)
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final business = controller.businesses[index];
                  return GestureDetector(
                    onTap: () {
                      controller.selectBusiness(context, business);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Imagem ou Placeholder
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  // Cor de fundo caso a imagem falhe
                                  color: Colors.grey.shade800,
                                  child: business.logoUrl != null
                                      ? Image.network(
                                          business.logoUrl!,
                                          fit: BoxFit.cover,
                                          // Feedback de loading
                                          loadingBuilder:
                                              (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                          // Feedback de erro
                                          errorBuilder:
                                              (context, error, stack) {
                                            return const Icon(Icons.business,
                                                size: 60,
                                                color: Colors.white70);
                                          },
                                        )
                                      : const Icon(Icons.business,
                                          size: 60, color: Colors.white70),
                                ),
                              ),

                              // Ícone de Cadeado
                              if (business.hasPassword)
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.lock,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Nome do Negócio
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            business.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1, // Evita quebra de linha
                            overflow: TextOverflow.ellipsis, // Adiciona "..."
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      // ### FIM DA UI ESTILO NETFLIX ###
    }
  }
}
