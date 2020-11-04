#define TREESIZE 20
#define TREEWIDTH 255

void print_t(struct node *);
int _print_t(struct node *, int, int, int, char s[TREESIZE][TREEWIDTH]);

int _print_t(struct node *tree, int is_left, int offset, int depth, char s[TREESIZE][TREEWIDTH]){
    char b[TREESIZE];
    int width = 5;

    if (!tree) return 0;

		printf("(%s)", tree->value);
    sprintf(b, "(%s)", tree->value);

    int left  = _print_t(tree->left,  1, offset,                depth + 1, s);
    int right = _print_t(tree->right, 0, offset + left + width, depth + 1, s);

    for (int i = 0; i < width; i++)
        s[2 * depth][offset + left + i] = b[i];

    if (depth && is_left) {

        for (int i = 0; i < width + right; i++)
            s[2 * depth - 1][offset + left + width/2 + i] = '-';

        s[2 * depth - 1][offset + left + width/2] = '+';
        s[2 * depth - 1][offset + left + width + right + width/2] = '+';

    } else if (depth && !is_left) {

        for (int i = 0; i < left + width; i++)
            s[2 * depth - 1][offset - width/2 + i] = '-';

        s[2 * depth - 1][offset + left + width/2] = '+';
        s[2 * depth - 1][offset - width/2 - 1] = '+';
    }

    return left + width + right;
}

void print_t(struct node *tree){
    char s[TREESIZE][TREEWIDTH];
    for (int i = 0; i < TREESIZE; i++)
        sprintf(s[i], "%80s", " ");

    _print_t(tree, 0, 0, 0, s);

    for (int i = 0; i < TREESIZE; i++)
        printf("%s\n", s[i]);
}
